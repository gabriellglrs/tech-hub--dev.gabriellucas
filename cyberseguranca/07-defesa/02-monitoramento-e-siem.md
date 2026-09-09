# 🚨 IDS/IPS & SIEM — Monitoramento e Detecção

> Monitorar tráfego e detectar ataques em tempo real. IDS só alerta, IPS bloqueia. SIEM centraliza logs, correlaciona eventos e responde a incidentes.

---

## Instalação das Ferramentas

```bash
sudo apt install -y suricata snort zeek
sudo suricata-update
# Wazuh SIEM (agent):
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
sudo bash wazuh-install.sh -a
```

---

## 🚀 IDS/IPS — Detecção e Prevenção de Intrusão

### Suricata (IDS/IPS mais moderno)
```bash
sudo apt install -y suricata
sudo suricata-update
sudo systemctl enable --now suricata
# Regras em /etc/suricata/rules/
# Logs em /var/log/suricata/eve.json

# Testar detecção
curl http://testmynids.org/uid/index.html
# Deve gerar alerta UID

# Ver alertas
tail -f /var/log/suricata/fast.log | grep -i alert
```

### Snort 3
```bash
sudo apt install -y snort
sudo snort -c /etc/snort/snort.conf -i eth0 -A console
# Regra custom: alert icmp any any -> any any (msg:"ICMP detectado"; sid:1000001;)
```

### Zeek (ex-Bro) — Análise comportamental
```bash
sudo apt install -y zeek
sudo zeek -i eth0
# Logs: conn.log, http.log, dns.log em /var/log/zeek/
```

---

## Comparativo IDS/IPS

| Ferramenta | Tipo | Regras | Performance |
|:---|:---|:---|:---|
| **Suricata** | IDS/IPS | Emerging Threats, ET Open | Multi-thread, alta |
| **Snort** | IDS/IPS | Talos, Community | Single-thread |
| **Zeek** | NSM | Scripts Zeek | Alta, foco em logs |

### Fluxo típico

```
1. Espelhar tráfego (port mirror / TAP) → IDS
2. IDS compara com assinaturas + anomalia
3. Alerta vai para SIEM
4. Se IPS → bloqueia IP/porta automaticamente
```

### Exemplo de regra Suricata

```bash
# /etc/suricata/rules/local.rules
alert http any any -> any any (msg:"Tentativa SQLi"; http.uri; content:"union select"; nocase; sid:1000002; rev:1; classtype:web-application-attack;)
```

---

## 📊 SIEM / SOC — Centralização e Correlação

### Wazuh (SIEM open-source, fork do OSSEC)
```bash
# Instalação all-in-one (via script oficial)
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
sudo bash wazuh-install.sh -a

# Acesse https://SEU_IP com admin/admin
# Agentes:
sudo WAZUH_MANAGER='MANAGER_IP' apt install -y wazuh-agent
sudo systemctl enable --now wazuh-agent
```

### Elastic Stack (ELK)
```bash
sudo apt install -y elasticsearch kibana logstash
# Filebeat para enviar logs:
sudo apt install -y filebeat
sudo filebeat modules enable suricata system
sudo systemctl enable --now filebeat
```

### Graylog
```bash
# Alternativa ao ELK, mais simples
# Requer MongoDB + OpenSearch
docker run -d --name graylog -p 9000:9000 -p 12201:12201 graylog/graylog
```

---

## O que monitorar

| Log | Fonte | Por que |
|:---|:---|:---|
| `auth.log` | Linux | Brute force SSH |
| `suricata eve.json` | IDS | Tentativas de exploit |
| `apache/nginx access.log` | Web | OWASP attacks |
| `windows event log` | AD | Movimentação lateral |
| `firewall log` | UFW/iptables | Port scan |

## Exemplo de correlação (Wazuh)

```xml
<!-- /var/ossec/etc/rules/local_rules.xml -->
<rule id="100200" level="10">
  <if_sid>550</if_sid>
  <match>authentication failed</match>
  <description>Múltiplas falhas de login SSH</description>
  <group>authentication_failures,</group>
</rule>
```

## SOC — Fluxo

```
1. Coleta (agents + syslog + IDS)
2. Normalização (parsing)
3. Correlação (regras)
4. Alerta → Ticket (TheHive, Shuffle)
5. Resposta (isolamento, bloqueio, forense)
```

## Lab Prático

1. **TryHackMe — Suricata** — Configure regras de detecção, analise logs `eve.json` e identifique tráfego malicioso com Suricata.
   - https://tryhackme.com/room/suricata
2. **TryHackMe — Wazuh** — Implemente um SIEM com Wazuh, crie regras customizadas e monitore agentes em tempo real.
   - https://tryhackme.com/room/wazuh
3. **TryHackMe — Snort** — Escreva regras de detecção, analise PCAPs e configure modos IPS com Snort.
   - https://tryhackme.com/room/snort
