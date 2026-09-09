# 📊 SIEM / SOC

> Centralizar logs, correlacionar eventos e responder a incidentes. Coração do SOC.

---

## 🚀 Passo a Passo

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
