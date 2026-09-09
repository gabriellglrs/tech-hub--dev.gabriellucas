# 🛡️ Blue Team / Defesa

> Defesa, monitoramento e hardening. O outro lado da cibersegurança: impedir, detectar e responder.

---

## 📂 O que tem nesta pasta?

| Arquivo | Tema | Ferramentas |
|:---|:---|:---|
| [01-hardening.md](01-hardening.md) | Hardening de Sistema e Serviços | `lynis, openSCAP, CIS-CAT, UFW hardening, sysctl` |
| [02-firewall.md](02-firewall.md) | Firewall e Filtragem de Rede | `ufw, iptables, nftables, firewalld` |
| [03-ids-ips.md](03-ids-ips.md) | Detecção e Prevenção de Intrusão | `snort, suricata, zeek` |
| [04-siem-soc.md](04-siem-soc.md) | SIEM e Operação SOC | `wazuh, elastic stack, splunk, graylog` |
| [05-waf-defensivo.md](05-waf-defensivo.md) | WAF Defensivo | `modsecurity, naxsi, cloudflare WAF, fail2ban` |

---

## 🚀 Fluxo Blue Team típico

```
1. Hardening       → fechar portas, atualizar, CIS Benchmark
        ↓
2. Firewall        → bloquear tudo, liberar só necessário (default deny)
        ↓
3. IDS/IPS         → detectar tentativas de intrusão em tempo real
        ↓
4. WAF             → proteger aplicação web contra OWASP Top 10
        ↓
5. SIEM/SOC        → centralizar logs, alertar e responder
```

> Todos os guias seguem o mesmo padrão dos guias `offensive/` : Passo a Passo + Flags + Exemplos práticos.
