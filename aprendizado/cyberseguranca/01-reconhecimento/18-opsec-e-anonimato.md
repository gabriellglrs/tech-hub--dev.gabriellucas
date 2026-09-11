# 🕵️ 18. OPSEC e Anonimato — Proteja sua Identidade durante Reconhecimento

> Se o alvo descobrir que está sendo mapeado, pode mudar configs, ativar defesas, ou até processar você. Anonimato não é opcional em pentest real.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 35min | ⭐⭐ Intermediário | `proxychains, tor, curl` |

</div>

---

## 🎓 Por que isso importa?

Sem anonimato, todo scan que você faz fica logado no servidor alvo:
- Seu IP real aparece nos logs
- O admin pode ver que está sendo mapeado
- Em pentest autorizado, isso pode quebrar sigilo
- Em Bug Bounty, outros hunters podem ver seus scans

**OPSEC (Operations Security)** é a prática de proteger suas operações de serem detectadas ou rastreadas.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Proxy e VPN | Sim | Este arquivo explica |
| Tor básico | Sim | Este arquivo explica |
| Linux básico | Sim | Módulo 00 |

---

## 🎯 Quando usar OPSEC

- Pentest autorizado (sigilo é requisito contratual)
- Bug Bounty (outros hunters não devem ver seus scans)
- Pesquisa acadêmica
- Qualquer operação onde seu IP não deve ser associado a você

---

## 🛠️ Tor — A Rede Anônima

Tor roteia seu tráfego através de 3 nós aleatórios no mundo, escondendo seu IP real.

### Instalação

```bash
# Instalar Tor
sudo apt update && sudo apt install tor

# Iniciar o serviço
sudo systemctl start tor

# Verificar status
sudo systemctl status tor

# Tor abre SOCKS5 na porta 9050 (padrão)
# Proxy: socks5://127.0.0.1:9050
```

### Configuração para Reconhecimento

Edite `/etc/tor/torrc` para habilitar DNS eTransPort:

```bash
# Adicionar ao final do torrc:
AutomapHostsOnResolve 1
DNSPort 53530
TransPort 9040
```

Reiniciar Tor:
```bash
sudo systemctl restart tor
```

### Verificar se Tor está funcionando

```bash
# Testar via curl
curl --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip

# Output esperado:
# {"IsTor":true,"IP":"109.70.100.58"}
```

---

## 🛠️ ProxyChains — Forçar Qualquer App a Usar Proxy

ProxyChains intercepta chamadas de rede de qualquer programa e roteia através de proxies (Tor, SOCKS, HTTP).

### Instalação

```bash
# Pre-installed no Kali
proxychains4 --version

# Se não estiver:
sudo apt update && sudo apt install proxychains4
```

### Configuração

Edite `/etc/proxychains4.conf`:

```bash
# 1. Tipo de chain (descomente UM):
# dynamic_chain    ← Melhor anonimato (pula proxies mortos)
# strict_chain     ← Ordem fixa (mais rápido)
# random_chain     ← Aleatório

# 2. Habilitar proxy DNS (IMPORTANTE!):
proxy_dns

# 3. No final, configure o proxy:
[ProxyList]
socks5 127.0.0.1 9050    # Tor (padrão)
```

**Configuração recomendada para reconhecimento:**
```bash
dynamic_chain
proxy_dns
[ProxyList]
socks5 127.0.0.1 9050
```

### Uso Básico

A regra é simples: **adicione `proxychains4` antes de qualquer comando**.

```bash
# Funciona com QUALQUER ferramenta
proxychains4 nmap -sT -Pn target.com
proxychains4 curl http://target.com
proxychains4 whois target.com
proxychains4 dig @target.com
proxychains4 ssh user@target.com
proxychains4 nikto -h http://target.com
proxychains4 wafw00f http://target.com
```

### Exemplos Práticos

**Verificar seu IP (antes e depois):**
```bash
# IP real
curl -s https://api.ipify.org
# Output: 200.100.50.25 (seu IP)

# IP via Tor
proxychains4 curl -s https://api.ipify.org 2>/dev/null
# Output: 109.70.100.58 (IP do Tor)
```

**Scan anônimo com Nmap:**
```bash
proxychains4 nmap -sT -Pn -p 80,443 target.com
```

**Nota:** Nmap SYN scan (`-sS`) NÃO funciona com proxychains. Use TCP connect (`-sT`).

**Whois anônimo:**
```bash
proxychains4 whois target.com
```

**Navegador anônimo:**
```bash
proxychains4 firefox https://target.com
```

**DNS lookup anônimo:**
```bash
proxychains4 dig target.com
```

**Nikto anônimo:**
```bash
proxychains4 nikto -h http://target.com
```

---

## ⚠️ Cuidados Importantes

### O que NÃO funciona via ProxyChains/Tor

| Ferramenta | Funciona? | Motivo |
|------------|-----------|--------|
| `nmap -sS` (SYN) | Não | Precisa de raw sockets |
| `nmap -sT` (TCP connect) | Sim | Usa conexão normal |
| `nmap -sU` (UDP) | Não | Tor não suporta UDP |
| `curl` | Sim | HTTP funciona via SOCKS |
| `nikto` | Sim | HTTP funciona |
| `wafw00f` | Sim | HTTP funciona |
| `ffuf` | Sim | HTTP funciona |
| `gobuster` | Sim | HTTP funciona |
| `hydra` | Não (lento) | Muitas conexões |
| `sqlmap` | Sim | HTTP funciona |

### DNS Leak

Mesmo com ProxyChains, alguns programas podem "vazar" DNS:

```bash
# Verificar se há DNS leak
proxychains4 curl -s https://dnsleaktest.com

# Ou usar torsocks (mais confiável)
torsocks curl -s https://api.ipify.org
```

### Performance

Tor é LENTO por causa dos 3 saltos. Scan completo de Nmap via Tor pode levar HORAS.

**Dicas:**
- Use Tor apenas para reconhecimento passivo
- Para scan ativo, considere VPN
- Reduza threads (`-t 10`) ao usar proxychains

---

## 🛠️ VPN — Alternativa ao Tor

VPNs são mais rápidas que Tor e ainda escondem seu IP.

### Opções de VPN para Pentest

| VPN | Custo | Velocidade | Anonimato | Recomendação |
|-----|-------|-----------|-----------|--------------|
| **ProtonVPN** | Gratuito | ⭐⭐⭐ | ⭐⭐⭐ | **Melhor opção gratuita** |
| **Mullvad** | €5/mês | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | **Melhor para OPSEC** |
| **IVPN** | $6/mês | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | **Bom para pentest** |
| **NordVPN** | $3/mês | ⭐⭐⭐⭐ | ⭐⭐ | Mais popular |

### Instalação ProtonVPN (gratuito)

```bash
# Instalar
sudo apt install protonvpn

# Conectar
protonvpn-cli connect

# Desconectar
protonvpn-cli disconnect
```

### Combinando VPN + Tor

Para máxima anonimidade:
```
Seu PC → VPN → Tor → Alvo
```

---

## 🛠️ Outras Técnicas de OPSEC

### 1. Alterar User-Agent

```bash
# Para não parecer um scanner
curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" http://target.com

# WhatWeb sem fingerprint do WhatWeb
whatweb -U "Mozilla/5.0" http://target.com
```

### 2. Rate Limiting

```bash
# Gobuster com delay
gobuster dir -u http://target.com -w wordlist.txt --delay 0.2

# Nmap com timing conservador
nmap -T2 -sT -Pn target.com

# ffuf com delay
ffuf -u http://target.com/FUZZ -w wordlist.txt -p 0.1
```

### 3. Horário de Operação

- Scaneie durante horário comercial (mais tráfego, menos suspeita)
- Evite meia-noite (padrão de bots)
- Distribua scans ao longo do dia

### 4. Logs e Rastros

```bash
# Limpar histórico do bash
history -c && history -w

# Usar /tmp para arquivos temporários
cd /tmp && mkdir recon_$$ && cd recon_$$

# Ao final, deletar tudo
rm -rf /tmp/recon_*
```

---

## 🔗 Pipeline OPSEC Recomendado

```
1. Iniciar Tor
   sudo systemctl start tor
       ↓
2. Verificar IP Tor
   proxychains4 curl -s https://api.ipify.org
       ↓
3. Scan passivo (DNS, WHOIS, certificados)
   proxychains4 whois target.com
   proxychains4 dig target.com
       ↓
4. Scan ativo (com rate limiting)
   proxychains4 nmap -sT -Pn -T2 target.com
       ↓
5. Web scanning
   proxychains4 whatweb http://target.com
   proxychains4 nikto -h http://target.com
       ↓
6. Limpar rastros
   history -c && rm -rf /tmp/recon_*
```

---

## ⚠️ Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| "DNS resolution failed" | Tor não configurado para DNS | Habilite `proxy_dns` no proxychains4.conf |
| Scan extremamente lento | Tor tem 3 saltos | Use VPN ou Tor apenas para passivo |
| "Connection refused" | Tor não está rodando | `sudo systemctl start tor` |
| IP real aparece | Programa não usa proxychains | Coloque `proxychains4` antes do comando |
| "LD_PRELOAD" error | sudo ignora LD_PRELOAD | Use `proxychains4` sem `sudo` ou use `torsocks` |

---

## 🎯 Cheat Sheet Rápido

```bash
# === SETUP ===
sudo systemctl start tor                    # Iniciar Tor
sudo systemctl status tor                   # Verificar status

# === VERIFICAR ANONIMATO ===
curl -s https://api.ipify.org                # IP real
proxychains4 curl -s https://api.ipify.org   # IP via Tor
torsocks curl -s https://api.ipify.org       # Alternativa

# === SCANS ANÔNIMOS ===
proxychains4 nmap -sT -Pn target.com
proxychains4 curl -I http://target.com
proxychains4 whois target.com
proxychains4 nikto -h http://target.com
proxychains4 whatweb http://target.com
proxychains4 wafw00f http://target.com

# === PROTEÇÃO ===
history -c && history -w                     # Limpar bash history
rm -rf /tmp/recon_*                          # Limpar arquivos
```

---

## 📚 Referências

- [Tor Project](https://www.torproject.org/)
- [ProxyChains GitHub](https://github.com/rofl0r/proxychains-ng)
- [ProxyChains Kali](https://www.kali.org/tools/proxychains4)
- [ProtonVPN](https://protonvpn.com/)
- [OWASP Testing Guide - Testing for Information Leakage](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/01-Information_Gathering)

---

**Próximo:** [19. Relatório de Reconhecimento](19-relatorio-de-reconhecimento.md) — Como documentar suas descobertas

**Anterior:** [17. Banner Grabbing](17-banner-grabbing-e-servidores.md)
