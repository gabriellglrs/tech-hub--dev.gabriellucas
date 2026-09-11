# 🔌 17. Banner Grabbing e Servidores — Identificando o que está rodando

> Conectar a um port aberto e pegar a "baneira" do serviço revela versão exata, sistema operacional e até configurações internas.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 35min | ⭐⭐ Intermediário | `ncat, curl, nmap` |

</div>

---

## 🎓 Por que isso importa?

Quando você conecta em um port, muitos serviços enviam uma "banner" — uma string que identifica o programa e a versão:

```
SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
220 mail.evilcorp.com ESMTP Postfix (Ubuntu)
HTTP/1.1 200 OK\nServer: nginx/1.19.0
```

Com essa informação você pode:
- Buscar CVEs específicas para essa versão
- Identificar o sistema operacional
- Saber exatamente qual software está rodando
- Encontrar configurações incorretas

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| O que é uma porta TCP | Sim | Arquivo 01 |
| HTTP básico | Sim | Módulo 02 |
| SSH básico | Sim | Conhecimento geral |

---

## 🎯 Quando usar Banner Grabbing

- Depois de descobrir portas abertas com Nmap
- Para identificar versões exatas de serviços
- Para buscar CVEs específicas
- Para detectar serviços não padrão em ports incomuns

---

## 🛠️ Netcat/Ncat — A Faca Suíça da Rede

Netcat é a ferramenta mais versátil para conexões de rede baixo nível. O Nmap Project mantém o Ncat, uma versão moderna.

### Instalação

```bash
# Netcat (pre-installed no Kali)
nc --version

# Ncat (parte do Nmap, pre-installed)
ncat --version

# Se não estiver:
sudo apt update && sudo apt install netcat-openbsd
```

### Flags Principais (ncat/nc)

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-v` | Verboso | `ncat -v` |
| `-n` | Sem DNS lookup | `ncat -n` |
| `-z` | Zero-I/O (scan sem dados) | `ncat -z` |
| `-l` | Listen (modo servidor) | `ncat -l 4444` |
| `-p` | Porta | `ncat -p 4444` |
| `-u` | UDP (default é TCP) | `ncat -u` |
| `-w` | Timeout em segundos | `ncat -w 3` |
| `-k` | Manter conexão aberta | `ncat -k -l 4444` |
| `-C` | Enviar CRLF | `ncat -C` |
| `-q` | EOF + delay antes de fechar | `ncat -q 1` |
| `-e` | Executar comando (perigoso!) | `ncat -e /bin/sh` |

### Exemplos Práticos

**1. Banner Grabbing — Conectar e pegar banner:**

**SSH:**
```bash
ncat -v target.com 22
```

**Output esperado:**
```
SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
```

**SMTP:**
```bash
ncat -v target.com 25
```

**Output esperado:**
```
220 mail.evilcorp.com ESMTP Postfix (Ubuntu)
```

**FTP:**
```bash
ncat -v target.com 21
```

**Output esperado:**
```
220 (vsFTPd 3.0.5)
```

**HTTP (request manual):**
```bash
ncat -C target.com 80
```

**Digite (e pressione Enter duas vezes):**
```
GET / HTTP/1.0
Host: target.com

```

**Output esperado:**
```
HTTP/1.1 200 OK
Server: nginx/1.19.0
Date: Wed, 10 Sep 2026 12:00:00 GMT
Content-Type: text/html; charset=UTF-8
X-Powered-By: PHP/7.4.3
...
```

**2. Port Scan rápido:**
```bash
# TCP scan de ports 21-100
ncat -zv target.com 21-100

# Output esperado:
# Ncat: Connected to 192.168.1.100:21.
# Ncat: Connected to 192.168.1.100:22.
# Ncat: Connected to 192.168.1.100:80.
# Ncat: DONE.
```

**3. UDP Scan:**
```bash
ncat -zvu target.com 53 111 161
```

**4. Verificar porta específica:**
```bash
ncat -zv target.com 443
```

**5. Banner grabbing de múltiplos ports:**
```bash
for port in 21 22 25 80 443; do
    echo "=== Port $port ===" | nc -zv -w 2 target.com $port 2>&1
done
```

**6. Servidor simples (para testes):**
```bash
# Máquina A (escutar):
ncat -l -p 4444

# Máquina B (conectar):
ncat -v machineA 4444
```

---

## 🛠️ curl — HTTP Banner Grabbing

O curl é mais HTTP-específico e revela headers completos.

### Exemplos Práticos

**Headers HTTP completos:**
```bash
curl -I http://target.com
```

**Output esperado:**
```
HTTP/1.1 200 OK
Server: nginx/1.19.0
Date: Wed, 10 Sep 2026 12:00:00 GMT
Content-Type: text/html; charset=UTF-8
X-Powered-By: PHP/7.4.3
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Strict-Transport-Security: max-age=31536000
```

**Verbose (mostra TLS, redirect, tudo):**
```bash
curl -vI https://target.com 2>&1 | grep -E "(< |> |SSL|TLS|subject|issuer)"
```

**Output esperado:**
```
> GET / HTTP/1.1
> Host: target.com
> User-Agent: curl/7.88.1
>
< HTTP/1.1 200 OK
< Server: nginx/1.19.0
< X-Powered-By: PHP/7.4.3
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* Server certificate:
*   subject: CN=target.com
*   issuer: C=US; O=Let's Encrypt; CN=R3
```

**Detectar tecnologias via headers:**
```bash
curl -sI http://target.com | grep -i "server\|x-powered-by\|x-aspnet"
```

---

## 🛠️ Nmap Scripts para Banner Grabbing

O Nmap tem NSE scripts específicos para banner grabbing.

```bash
# Service version detection
nmap -sV target.com

# HTTP server header
nmap --script http-server-header target.com

# SSH host key
nmap --script ssh-hostkey target.com

# SSL/TLS certificate info
nmap --script ssl-cert target.com

# FTP banner
nmap --script ftp-banner target.com

# SMB info
nmap --script smb-os-discovery target.com

# MySQL banner
nmap --script mysql-banner target.com

# Todos os banners de serviços
nmap -sV --script=banner target.com
```

---

## 📊 Tabela de Banners Comuns

| Serviço | Porta | Banner Exemplo | O que revela |
|---------|-------|----------------|--------------|
| SSH | 22 | `SSH-2.0-OpenSSH_8.9p1` | Versão OpenSSH |
| FTP | 21 | `220 (vsFTPd 3.0.5)` | Versão vsFTPd |
| SMTP | 25 | `220 mail.domain.com ESMTP Postfix` | Software + hostname |
| HTTP | 80 | `Server: nginx/1.19.0` | Web server + versão |
| MySQL | 3306 | `5.7.42-0ubuntu0.18.04.1` | Versão MySQL |
| SMB | 445 | Windows 10 Pro Build 19041 | SO + versão |
| RDP | 3389 | `Microsoft Remote Desktop Protocol` | Versão Windows |

---

## 🔗 Pipeline de Banner Grabbing

```
1. Nmap -sV (scan de versões em todos os ports)
       ↓
2. ncat (banner manual de ports específicos)
       ↓
3. curl -I (headers HTTP detalhados)
       ↓
4. Buscar CVEs para cada versão encontrada
```

---

## ⚠️ Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| Sem banner | Servício não envia banner | Use `nmap -sV` que faz probing |
| Timeout | Firewall bloqueando | Use `-w 3` para timeout maior |
| Output binário | Alguns serviços enviam bytes | Use `ncat -v` para ver ASCII |
| "Connection refused" | Porta fechada | Verifique com `nmap` primeiro |
| Banner genérica | Servício oculta versão | Use NSE scripts do Nmap |

---

## 🎯 Cheat Sheet Rápido

```bash
# === NETCAT/NCAT ===
ncat -v target.com 22                     # Banner SSH
ncat -v target.com 25                     # Banner SMTP
ncat -v target.com 21                     # Banner FTP
ncat -zv target.com 21-100                # Port scan
ncat -C target.com 80                     # HTTP request manual

# === CURL ===
curl -I http://target.com                 # Headers HTTP
curl -sI http://target.com | grep -i server  # Só o servidor
curl -vI https://target.com 2>&1 | grep SSL  # Info TLS

# === NMAP ===
nmap -sV target.com                       # Service version
nmap --script http-server-header target.com  # HTTP header
nmap --script ssh-hostkey target.com      # SSH info
nmap --script ssl-cert target.com         # SSL cert
nmap -sV --script=banner target.com       # Todos os banners

# === COMBINADO ===
nmap -sV target.com | grep -E "open|service"
```

---

## 📚 Referências

- [Netcat Kali](https://www.kali.org/tools/netcat)
- [Ncat Users Guide](https://nmap.org/ncat/guide/)
- [Nmap NSE Scripts](https://nmap.org/book/nse-usage.html)
- [OWASP Banner Grabbing](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/01-Information_Gathering/02-Fingerprint_Web_Server)

---

**Próximo:** [18. OPSEC e Anonimato](18-opsec-e-anonimato.md) — ProxyChains, Tor e boas práticas de anonimato

**Anterior:** [16. Detecção de WAF](16-deteccao-waf.md)
