# 🛡️ 16. Detecção de WAF e Scanners Web — Antes de Atacar, Conheça as Defesas

> Se o alvo tem WAF (Web Application Firewall), seus scans serão bloqueados. Precisa detectar e contornar antes de qualquer teste.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 40min | ⭐⭐ Intermediário | `wafw00f, nikto, wpscan` |

</div>

---

## 🎓 Por que isso importa?

Um WAF (Web Application Firewall) é como um segurança na porta. Ele bloqueia:
- SQL Injection
- XSS
- Directory brute force
- Robots maliciosos

Se você mandar scan sem saber do WAF, vai receber 403 ou ser banido. Detecção primeiro, ataque depois.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP básico | Sim | Módulo 02 |
| O que é WAF | Sim | Este arquivo explica |
| Fingerprinting | Sim | Arquivo 13 |

---

## 🛠️ Wafw00f — Detecção de WAF

Wafw00f detecta mais de 150 WAFs diferentes analisando respostas HTTP.

### Instalação

```bash
# Pre-installed no Kali
wafw00f --version

# Se não estiver:
sudo apt update && sudo apt install wafw00f
# ou
pip3 install wafw00f
```

### Flags Principais

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-v` | Verboso | `wafw00f -v` |
| `-a` | Encontrar TODOS os WAFs (não parar no primeiro) | `wafw00f -a` |
| `-r` | Não seguir redirecionamentos 3xx | `wafw00f -r` |
| `-t` | Testar um WAF específico | `wafw00f -t "Cloudflare"` |
| `-l` | Listar todos os WAFs suportados | `wafw00f -l` |
| `-o` | Output em arquivo | `wafw00f -o result.json` |
| `-f` | Formato (json, csv, text) | `wafw00f -f json` |
| `-i` | Ler targets de arquivo | `wafw00f -i urls.txt` |
| `-p` | Usar proxy | `wafw00f -p http://127.0.0.1:8080` |
| `-H` | Headers customizados | `wafw00f -H headers.txt` |
| `-T` | Timeout | `wafw00f -T 30` |
| `--no-colors` | Sem cores no output | `wafw00f --no-colors` |

### Exemplos Práticos

**Detecção básica:**
```bash
wafw00f http://example.com
```

**Output esperado (com WAF):**
```
    (  /  )        / | \                  . |__|
     \(_)_))      /  |  \                   |__|

                ~ WAFW00F : v2.4.2 ~
    ~ Sniffing Web Application Firewalls since 2009 ~

[*] Checking http://example.com
[+] The site http://example.com is behind Cloudflare (Cloudflare Inc.) WAF.
[~] Number of requests: 2
```

**Output esperado (sem WAF):**
```
[*] Checking http://example.com
[-] No WAF detected by the generic detection
[~] Number of requests: 2
```

**Encontrar TODOS os WAFs (não parar no primeiro):**
```bash
wafw00f -a -v http://example.com
```

**Output esperado:**
```
[*] Checking http://example.com
[+] The site http://example.com is behind Cloudflare (Cloudflare Inc.) WAF.
[+] The site http://example.com is behind ModSecurity (Trustwave) WAF.
[~] Number of requests: 15
```

**Testar WAF específico:**
```bash
wafw00f http://example.com -t "Cloudflare"
```

**Listar todos os WAFs suportados:**
```bash
wafw00f -l
```

**Output esperado (parcial):**
```
[+] Can test for these WAFs:
WAF Name                        Manufacturer
------                          ------------
9egeek                          9egeek
AirCDN                          AirCDN
AkamaiGhost                     Akamai
Amazon AWS WAF                  Amazon
Artisantech                     Artisantech
...
Cloudflare                      Cloudflare Inc.
...
ModSecurity                     Trustwave
...
```

**Múltiplos alvos de arquivo:**
```bash
wafw00f -i urls.txt -o resultado.json -f json
```

**Com proxy (Burp Suite):**
```bash
wafw00f http://example.com -p http://127.0.0.1:8080
```

---

## 🛠️ Nikto — Scanner de Vulnerabilidades Web

Nikto verifica configurações incorretas, arquivos padrão inseguros, versões desatualizadas e mais de 6.700 checks.

### Instalação

```bash
# Pre-installed no Kali
nikto -Version

# Se não estiver:
sudo apt update && sudo apt install nikto
```

### Flags Principais

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-h` | Host alvo | `-h http://target.com` |
| `-p` | Porta(s) | `-p 80,443,8080` |
| `-ssl` | Forçar SSL | `-ssl` |
| `-o` | Output file | `-o resultado.html` |
| `-Format` | Formato (txt, htm, csv, xml) | `-Format htm` |
| `-Tuning` | Tipo de teste (0-9,a-c) | `-Tuning 123` |
| `-evasion` | Técnica de evasão (1-8,A,B) | `-evasion 1` |
| `-Cgidirs` | Diretórios CGI | `-Cgidirs all` |
| `-Display` | O que mostrar | `-Display V` |
| `-useproxy` | Usar proxy | `-useproxy http://proxy:8080` |
| `-timeout` | Timeout por request | `-timeout 10` |
| `-vhost` | Virtual host | `-vhost admin.target.com` |
| `-root` | Prepend path | `-root /app` |
| `-noslash` | Remover trailing slash | `-noslash` |
| `-no404` | Não tentar adivinhar 404 | `-no404` |
| `-update` | Atualizar databases | `-update` |
| `-dbcheck` | Verificar databases | `-dbcheck` |

### Exemplos Práticos

**Scan básico:**
```bash
nikto -h http://target.com
```

**Output esperado:**
```
- Nikto v2.5.0
---------------------------------------------------------------------------
+ Target IP:     192.168.1.100
+ Target Hostname:   target.com
+ Target Port:   80
+ Start Time:    2026-09-10 10:30:00
---------------------------------------------------------------------------
+ Server: Apache/2.4.41 (Ubuntu)
+ /: The anti-clickjacking X-Frame-Options header is not present. See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
+ /: Uncommon header 'x-powered-by' found, with contents: PHP/7.4.3
+ /admin/: Admin directory found.
+ /robots.txt: Robots file found. 57 paths disallowed.
+ /phpinfo.php: PHP info file found.
+ /backup/: Directory indexing found.
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7915 requests: 0 error(s) and 12 item(s) reported on remote host
---------------------------------------------------------------------------
+ End Time:      2026-09-10 10:35:23
---------------------------------------------------------------------------
```

**Scan em porta específica:**
```bash
nikto -h http://target.com -p 8080
```

**Scan SSL (HTTPS):**
```bash
nikto -h https://target.com -ssl
```

**Scan com evasão (para bypass de WAF):**
```bash
nikto -h http://target.com -evasion 1
```

**Evasões disponíveis:**
```
1 — Random URI encoding (non-UTF8)
2 — Directory self-reference (/./)
3 — Premature URL ending
4 — Prepend long random string
5 — Fake parameter
6 — TAB as request spacer
7 — Change case of URL
8 — Use Windows directory separator (\)
```

**Scan com output HTML:**
```bash
nikto -h http://target.com -o relatorio.html -Format htm
```

**Scan através de proxy:**
```bash
nikto -h http://target.com -useproxy http://127.0.0.1:8080
```

**Scan de virtual host:**
```bash
nikto -h 192.168.1.100 -vhost admin.target.com
```

**Scan de um único request (stealth):**
```bash
nikto -h http://target.com -Single
```

---

## 🛠️ WPScan — Scanner WordPress

WPScan é a ferramenta definitiva para alvos WordPress.

### Instalação

```bash
# Pre-installed no Kali
wpscan --version

# Se não estiver:
sudo apt update && sudo apt install wpscan
```

### Flags Principais

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `--url` | URL do WordPress | `--url http://target.com` |
| `-e` | O que enumerar | `-e vp,vt,u` |
| `--enumerate` | Alias para -e | `--enumerate vp` |
| `--api-token` | Token da API WPScan | `--api-token TOKEN` |
| `--plugins-detection` | Modo de detecção (passive/mixed/aggressive) | `--plugins-detection mixed` |
| `--stealthy` | Modo stealth | `--stealthy` |
| `--passwords` | Wordlist para brute force | `--passwords rockyou.txt` |
| `--password-attack` | Tipo de ataque | `--password-attack wp-login` |
| `--proxy` | Proxy | `--proxy http://127.0.0.1:8080` |
| `--cookie-string` | Cookies | `--cookie-string "session=abc"` |
| `--force` | Forçar scan mesmo sem WP detectado | `--force` |
| `--wp-content-dir` | Diretório wp-content customizado | `--wp-content-dir custom` |
| `-o` | Output file | `-o resultado.txt` |
| `-v` | Verboso | `-v` |
| `--no-banner` | Sem banner | `--no-banner` |

### Opções de Enumeração (-e)

| Opção | Descrição |
|-------|-----------|
| `vp` | Plugins vulneráveis |
| `ap` | Todos os plugins |
| `p` | Plugins populares |
| `vt` | Themes vulneráveis |
| `at` | Todos os themes |
| `t` | Themes populares |
| `tt` | TimThumbs |
| `cb` | Config backups |
| `dbe` | Database exports |
| `u` | User IDs (ex: u1-5) |
| `m` | Media IDs |

**Default (sem -e):** vp,vt,tt,cb,dbe,u,m

### Exemplos Práticos

**Enumerar plugins vulneráveis (mais comum):**
```bash
wpscan --url http://target.com -e vp
```

**Output esperado:**
```
[+] WordPress version 5.7 identified (Insecure, released 2021-03-09)
 | Found By: Rss Generator (Aggressive Detection)
 |  https://target.com/feed/
 |  https://target.com/comments/feed/
[i] The iThemes Security plugin does not seem to be installed.

[+] wp-login.php
 | Found By: Direct Access (Aggressive Detection)

[+] Enumerating plugins (passive mode)
[+] Plugins found: 15

[+] plugin-name
 | Location: http://target.com/wp-content/plugins/plugin-name/
 | Latest Version: 1.0
 | Readme: http://target.com/wp-content/plugins/plugin-name/readme.txt
 | [!] Vulnerabilities:
 |   - SQL Injection (CVE-2024-XXXXX)
```

**Enumerar usernames:**
```bash
wpscan --url http://target.com -e u
```

**Enumerar todos os plugins:**
```bash
wpscan --url http://target.com -e ap --plugins-detection mixed
```

**Enumerar com API token (vulnerabilidades detalhadas):**
```bash
wpscan --url http://target.com -e vp --api-token SEU_TOKEN
```

**Obter token:** https://wpscan.com/profile (plano gratuito: 25 requests/dia)

**Brute force de senha:**
```bash
wpscan --url http://target.com -e u --passwords /usr/share/wordlists/rockyou.txt
```

**Modo stealth (menos detecção):**
```bash
wpscan --url http://target.com --stealthy -e vp
```

**Com proxy:**
```bash
wpscan --url http://target.com --proxy http://127.0.0.1:8080 -e vp
```

**Scan completo com tudo:**
```bash
wpscan --url http://target.com -e ap,at,u,tt,cb,dbe --plugins-detection mixed --api-token TOKEN
```

---

## 🔗 Pipeline de Detecção

```
1. wafw00f (detectar WAF)
       ↓
   [Se tem WAF → usar técnica de evasão]
       ↓
2. nikto (scan geral de vulnerabilidades)
       ↓
3. WPScan (se WordPress detectado)
       ↓
4. Analisar resultados → priorizar exploração
```

---

## ⚠️ Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| wafw00f: "No WAF detected" | WAF não está na database ou sem WAF | Use `wafw00f -a` para testar todos |
| nikto: muitos falsos positivos | Nikto é genérico | Cruzar com outros scanners |
| nikto: scan muito lento | Muitos checks | Use `-Tuning` para limitar tipos |
| WPScan: "not WordPress" | Tem WAF bloqueando | Use `--force` ou `--stealthy` |
| WPScan: sem vulnerabilidades | Falta API token | Obtenha token em wpscan.com |
| WPScan: plugins não encontrados | Detecção passiva limitada | Use `--plugins-detection mixed` |

---

## 🎯 Cheat Sheet Rápido

```bash
# === WAFW00F ===
wafw00f http://target.com                    # Detectar WAF
wafw00f -a -v http://target.com              # Todos os WAFs
wafw00f -l                                    # Listar WAFs suportados
wafw00f -i urls.txt -o result.json           # Múltiplos alvos

# === NIKTO ===
nikto -h http://target.com                   # Scan básico
nikto -h http://target.com -p 8080           # Porta específica
nikto -h https://target.com -ssl             # HTTPS
nikto -h http://target.com -evasion 1        # Com evasão
nikto -h http://target.com -o report.html -Format htm  # Output HTML

# === WPSCAN ===
wpscan --url http://target.com -e vp         # Plugins vulneráveis
wpscan --url http://target.com -e u          # Enumerar users
wpscan --url http://target.com -e vp --api-token TOKEN  # Com API
wpscan --url http://target.com --stealthy    # Modo stealth
wpscan --url http://target.com -e u --passwords rockyou.txt  # Brute force
```

---

## 📚 Referências

- [Wafw00f GitHub](https://github.com/EnableSecurity/wafw00f)
- [Wafw00f Kali](https://www.kali.org/tools/wafw00f)
- [Nikto GitHub](https://github.com/sullo/nikto)
- [Nikto Kali](https://www.kali.org/tools/nikto)
- [WPScan GitHub](https://github.com/wpscanteam/wpscan)
- [WPScan Kali](https://www.kali.org/tools/wpscan)
- [WPScan API](https://wpscan.com/)

---

**Próximo:** [17. Banner Grabbing e Servidores](17-banner-grabbing-e-servidores.md) — Netcat/Ncat para identificar serviços

**Anterior:** [15. Subdomain Enum Avançado](15-subdomain-enum-avancado.md)
