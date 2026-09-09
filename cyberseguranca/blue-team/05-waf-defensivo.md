# 🧱 WAF Defensivo

> Proteger aplicação web na camada 7 contra OWASP Top 10: SQLi, XSS, LFI, RCE.

---

## 🚀 Passo a Passo

### ModSecurity + Nginx
```bash
sudo apt install -y libmodsecurity3 modsecurity-crs
sudo nano /etc/nginx/modsec/main.conf
# SecRuleEngine On
# Include /usr/share/modsecurity-crs/crs-setup.conf

# Testar bloqueio
curl "http://localhost/?id=1%20union%20select"
# Deve retornar 403

# Logs
tail -f /var/log/modsec_audit.log
```

### NAXSI (Nginx Anti XSS/SQLi)
```bash
sudo apt install -y libnginx-mod-naxsi
# Regras em /etc/nginx/naxsi_core.rules
```

### Cloudflare / Imperva (WAF gerenciado)
- Ativar `OWASP Core Rule Set`
- Modo `Block` para SQLi/XSS, `Challenge` para bots
- Rate limiting: 100 req/min por IP

### Fail2Ban (WAF leve + brute force)
```bash
sudo apt install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable --now fail2ban
# Bloqueia IP após 5 falhas SSH:
# [sshd] enabled = true, maxretry = 5, bantime = 3600
sudo fail2ban-client status sshd
```

---

## Comparativo

| WAF | Tipo | Grátis? | Performance |
|:---|:---|:---|:---|
| **ModSecurity** | Open-source, on-prem | ✅ | Média |
| **NAXSI** | Nginx, leve | ✅ | Alta |
| **Cloudflare** | Cloud | Parcial | Alta (CDN) |
| **Fail2Ban** | Host, log-based | ✅ | Leve |

## Teste de WAF (verificar se bloqueia)

```bash
# wafw00f para detectar (offensive)
wafw00f http://seusite.com

# Testar bypass defensivo
curl -H "X-Originating-IP: 127.0.0.1" "http://localhost/?id=1' OR '1'='1"
```
