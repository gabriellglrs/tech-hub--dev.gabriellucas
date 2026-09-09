# 🚨 IDS / IPS — Detecção e Prevenção de Intrusão

> Monitorar tráfego e detectar ataques em tempo real. IDS só alerta, IPS bloqueia.

---

## 🚀 Passo a Passo

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

## Comparativo

| Ferramenta | Tipo | Regras | Performance |
|:---|:---|:---|:---|
| **Suricata** | IDS/IPS | Emerging Threats, ET Open | Multi-thread, alta |
| **Snort** | IDS/IPS | Talos, Community | Single-thread |
| **Zeek** | NSM | Scripts Zeek | Alta, foco em logs |

## Fluxo típico

```
1. Espelhar tráfego (port mirror / TAP) → IDS
2. IDS compara com assinaturas + anomalia
3. Alerta vai para SIEM (ver 04-siem-soc.md)
4. Se IPS → bloqueia IP/porta automaticamente
```

## Exemplo de regra Suricata

```bash
# /etc/suricata/rules/local.rules
alert http any any -> any any (msg:"Tentativa SQLi"; http.uri; content:"union select"; nocase; sid:1000002; rev:1; classtype:web-application-attack;)
```
