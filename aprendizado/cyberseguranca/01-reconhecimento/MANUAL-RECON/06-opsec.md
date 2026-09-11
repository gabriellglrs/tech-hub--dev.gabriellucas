## OPSEC — Não Deixar Rastros

> **OPSEC (Operations Security)** é garantir que o alvo NÃO saiba que você está escaneando ele. Se o alvo perceber, pode mudar configs, bloquear seu IP, ou até processar você.

### O que o alvo pode ver de você?

| O que você faz | O que o alvo vê | Risco |
|----------------|-----------------|-------|
| `nmap -sT -p- alvo.com` | Seu IP real nos logs | ⚠️ ALTO |
| `nmap -sS -p- alvo.com` | SYN packets do seu IP | ⚠️ MÉDIO |
| `gobuster dir -u alvo.com` | Seu IP fazendo requests | ⚠️ MÉDIO |
| `subfinder -d alvo.com` | NADA (passivo) | ✅ BAIXO |
| `theHarvester -d alvo.com` | NADA (passivo) | ✅ BAIXO |
| `curl http://alvo.com` | 1 request no log | ✅ BAIXO |

### Regras de OPSEC:

**1. Use VPN para TODOS os scans ativos**
```bash
# ANTES de qualquer scan ativo
nordvpn connect
curl -s https://ifconfig.me  # confirme que o IP mudou
```

**2. Limpe seus logs depois**
```bash
# Limpar histórico do bash
history -c
history -w

# Limpar logs do sistema (se tiver root)
sudo truncate -s 0 /var/log/syslog
sudo truncate -s 0 /var/log/auth.log
```

**3. Use User-Agent falso**
```bash
# Em vez de:
whatweb http://evilcorp.com

# Use:
whatweb -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" http://evilcorp.com

# Em Nmap:
nmap -sV -A -Pn --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" evilcorp.com
```

**4. Não escaneie tudo de uma vez**
```bash
# RUIM — escaneia tudo rápido e é bloqueado
nmap -sT -Pn -p- -T5 --min-rate 10000 evilcorp.com

# BOM — escaneia devagar e discretamente
nmap -sT -Pn -p 21,22,25,80,443,3306,8080 -T2 --max-rate 100 evilcorp.com
```

**5. Adicione delay entre requests**
```bash
# Gobuster com delay
gobuster dir -u http://evilcorp.com -w common.txt -t 10 --delay 0.5s

# ffuf com delay
ffuf -u http://evilcorp.com/FUZZ -w common.txt -p 0.5
```

**6. Saiba quando PARAR**

| Sinal | O que fazer |
|-------|-------------|
| Scan retornando 0 resultados | Pare. Pode estar bloqueado. Espere 30min e mude de IP |
| Respostas HTTP vindo muito rápido | Pare. Pode ser WAF retornando respostas falsas |
| IP banido (VPN desconectou) | Reconecte VPN (novo IP) e continue |
| ISP bloqueou acesso | Desconecte VPN, reconecte, mude de IP |
| Mais de 1 hora no mesmo scan | Pare. Revise se está no caminho certo |

**7. Nunca escaneie sem autorização**
- **CTF/Bootrooms:** Autorizado (HackTheBox, TryHackMe)
- **Alvo próprio:** Autorizado
- **Alvo de terceiros:** ILEGAL sem autorização por escrito
- **Bug bounty:** Autorizado se estiver no escopo do programa

### Checklist de OPSEC:

| # | Item | ☑ |
|---|------|:---:|
| 1 | VPN conectada e IP verificado | [ ] |
| 2 | User-Agent configurado nos scanners | [ ] |
| 3 | Delay entre requests configurado | [ ] |
| 4 | Logs do bash limpos | [ ] |
| 5 | Autorização confirmada (CTF/próprio) | [ ] |

---
