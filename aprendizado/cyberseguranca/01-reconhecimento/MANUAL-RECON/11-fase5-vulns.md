## FASE 5 — Scan de Vulnerabilidades

**Tempo estimado:** 60-120 minutos
**Objetivo:** Identificar vulnerabilidades conhecidas e configurações incorretas nos serviços e aplicações web encontrados.
**Por quê:** Agora que você sabe O QUE o alvo usa (Fase 3) e ONDE estão os pontos de entrada (Fase 4), pode buscar vulnerabilidades específicas.

---

### Passo 5.1 — Web Vulnerability Scan

**Passo 5.1.1 — Nikto**

```bash
nikto -h http://evilcorp.com -o 05-vulns/nikto.html -Format htm
```

**✅ Output esperado (exemplo real):**
```
- Nikto v2.x
---------------------------------------------------------------------------
+ Target IP:     104.21.33.15
+ Target Hostname: evilcorp.com
+ Target Port: 80
+ Start Time:   2026-09-10 14:30:00

+ Server: Apache/2.4.41 (Ubuntu)
+ OSVDB-3233: /icons/README: Apache default file found.
+ OSVDB-3268: /docs/: Directory indexing found.
+ OSVDB-3092: /admin/: This might be interesting...
+ OSVDB-3092: /backup/: This might be interesting...
+ OSVDB-3092: /config/: This might be interesting...
+ OSVDB-3092: /uploads/: This might be interesting...
+ OSVDB-3268: /icons/: Directory indexing found.
+ Cookie PHPSESSID created without the httponly flag
+ Cookie PHPSESSID created without the secure flag
+ /admin/: Admin login page/section found.
+ OSVDB-3092: /phpmyadmin/: phpMyAdmin is free database admin tool.

+ End Time: 2026-09-10 14:35:00
+ 15 items checked - 10 interesting findings
---------------------------------------------------------------------------
```

**O que procurar:**
- `/admin/` → Painel administrativo ⭐
- `/backup/` → Backups expostos ⭐
- `/config/` → Configurações ⭐
- `/phpmyadmin/` → phpMyAdmin (banco de dados web) ⭐⭐
- `Cookie PHPSESSID created without httponly flag` → Falta de segurança ⭐
- `Cookie PHPSESSID created without secure flag` → Falta de segurança ⭐

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muitos falsos positivos | Nikto é genérico | SEMPRE confirme manualmente cada achado |
| WAF bloqueando | Rate limiting | Use `-evasion 1` para bypass básico |
| Muito lento | Scan completo | Limite a 10 minutos: `-maxtime 600` |
| Output vazio | Site retorna 404 para tudo | Use `-Format txt` para ver mais detalhes |

**Passo 5.1.2 — Nuclei**

```bash
nuclei -u http://evilcorp.com -severity medium,high,critical -o 05-vulns/nuclei.txt
```

**✅ Output esperado (exemplo real):**
```
                     __     _
   ____  __  _______/ /__  (_)
  / __ \/ / / / ___/ / _ \/ /
 / / / / /_/ / /__/ /  __/ /
/_/ /_/\__,_/\___/_/\___/_/  v3.x

[2026-09-10 14:40:00] [critical] [apache-server-config] http://evilcorp.com
[2026-09-10 14:40:01] [high] [x-powered-by-header] http://evilcorp.com
[2026-09-10 14:40:02] [medium] [missing-strict-transport-security] http://evilcorp.com
[2026-09-10 14:40:03] [high] [phpinfo-exposure] http://evilcorp.com/phpinfo.php
[2026-09-10 14:40:04] [critical] [env-exposure] http://evilcorp.com/.env
[2026-09-10 14:40:05] [medium] [backup-file-disclosure] http://evilcorp.com/config.bak
```

**Explicação:**
- `-severity medium,high,critical`: Mostrar apenas médio, alto e crítico (ignorar low/info)
- Primeiro rode: `nuclei -update-templates` para atualizar templates

**O que procurar:**
- `[critical]` → VULNERABILIDADE GRAVE — confirmar e reportar
- `[high]` → VULNERABILIDADE ALTA — confirmar e reportar
- `[medium]` → VULNERABILIDADE MÉDIA — reportar se confirmada

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Sem resultados | Templates desatualizados | `nuclei -update-templates` |
| Muitos falsos positivos | Templates genéricos | Confirme cada achado manualmente |
| WAF bloqueando | Muitos requests | Use ProxyChains ou `-rl 50` (50 requests/s) |
| Muito lento | Scan completo | Limite: `-severity critical,high` |

**Passo 5.1.3 — Nmap NSE vuln**

```bash
nmap --script vuln -p [PORTAS-ABERTAS] -iL 02-enum/ips.txt -oN 05-vulns/nmap-vuln.txt
```

**✅ Output esperado (exemplo real):**
```
PORT    STATE SERVICE
443/tcp open  https

ssl-poodle:
  VULNERABLE:
  SSLv3 POODLE vulnerability
  State: VULNERABLE
  Risk factor: High
  CVE: CVE-2014-3566

http-shellshock:
  VULNERABLE:
  Shellshock vulnerability
  State: VULNERABLE
  CVE: CVE-2014-6271
```

---

### Passo 5.2 — WordPress (se aplicável)

Se o WhatWeb detectou WordPress na Fase 3, execute esta fase.

**Passo 5.2.1 — WPScan**

```bash
wpscan --url http://evilcorp.com -e vp,vt,u --plugins-detection mixed --no-banner -o 05-vulns/wpscan.txt
```

**✅ Output esperado (exemplo real):**
```
[+] URL: http://evilcorp.com/
[+] Started: Thu Sep 10 14:45:00 2026

Interesting Finding(s):

[+] Headers
 | Interesting Entry: X-Powered-By: PHP/7.4.3

[+] WordPress version: 5.7
 | Found By: Rss Generator (Passive Detection)
 | [!] https://wordpress.org/news/2021/03/wordpress-5-7-1-security-and-maintenance-release/

[+] WordPress theme: twentytwentyone
 | Found By: Css Style(s) In Passive Detection
 | Version: 1.3 (80% confidence)

[+] Enumerating All Plugins (via Passive Methods)
[+] Plugins Found:
 | wp-file-manager
 | Found By:被动检测
 | Version: 6.9 (100% confidence)
 | [!] https://wpscan.com/plugin/12345

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
[+] Config Backups Found:
 | wp-config.php.bak
 | Found By: Aggressive Detection
 | Path: http://evilcorp.com/wp-config.php.bak

[+] Enumerating Users (via Aggressive Methods)
 | Username: admin
 | Username: jose.silva
```

**O que procurar:**
- `WordPress version: 5.7` → Versão antiga, pode ter CVEs
- `wp-file-manager: 6.9` → Plugin COM VULNERABILIDADE CONHECIDA ⭐⭐
- `wp-config.php.bak` → Backup da configuração exposto ⭐⭐⭐
- `Username: admin` → Username padrão ⭐

---

### Passo 5.3 — Cloud Storage

**Passo 5.3.1 — S3 Buckets**

```bash
# Tentar listar bucket com o nome do domínio
aws s3 ls s3://evilcorp --no-sign-request 2>&1 > 05-vulns/s3-test.txt

# Testar variações do nome
for name in evilcorp evil-corp evilcorp-prod evilcorp-backup; do
    echo "=== Testing s3://$name ===" >> 05-vulns/s3-test.txt
    aws s3 ls s3://$name --no-sign-request 2>&1 >> 05-vulns/s3-test.txt
done
```

**✅ Output esperado (exemplo real — bucket exposto):**
```
=== Testing s3://evilcorp ===
                           PRE backups/
                           PRE documents/
                           PRE images/
                           PRE uploads/

=== Testing s3://evil-corp ===
A client error (NoSuchBucket) occurred when calling the ListObjectsV2 operation

=== Testing s3://evilcorp-backup ===
                           PRE database-dumps/
                           PRE configs/
```

**⚠️ Se encontrar um bucket listável → CRÍTICO. Anote como vulnerabilidade grave.**

---

### Passo 5.4 — Subdomain Takeover

**O que você vai fazer:** Verificar se algum subdomínio aponta (CNAME) para um serviço externo que NÃO foi reclamado. Se sim, você pode "tomar" esse subdomínio.

**Passo 5.4.1 — Verificar CNAMEs**

```bash
cat 02-enum/resolvidos.txt | while read sub; do
    cname=$(dig +short "$sub" CNAME | head -1)
    if [ ! -z "$cname" ]; then
        echo "$sub -> $cname" >> 05-vulns/cnames.txt
    fi
done
```

**✅ Output esperado (exemplo real):**
```
docs.evilcorp.com -> evilcorp.s3.amazonaws.com
staging.evilcorp.com -> evilcorp-staging.herokuapp.com
blog.evilcorp.com -> evilcorp.wordpress.com
```

**Passo 5.4.2 — Subzy scan**

```bash
# Instalar (primeira vez)
go install github.com/LukaSusic/subzy@latest

# Rodar
subzy run --targets 02-enum/resolvidos.txt --concurrency 50 > 05-vulns/subzy.txt
```

**✅ Output esperado (exemplo real):**
```
[NOT VULNERABLE]  evilcorp.com
[NOT VULNERABLE]  www.evilcorp.com
[VULNERABLE]      docs.evilcorp.com  → evilcorp.s3.amazonaws.com (NoSuchBucket)
[NOT VULNERABLE]  mail.evilcorp.com
[VULNERABLE]      staging.evilcorp.com → evilcorp-staging.herokuapp.com (Heroku Error Page)
[NOT VULNERABLE]  api.evilcorp.com
```

**⚠️ Se encontrar `VULNERABLE` → CRÍTICO. Você pode assumir controle desse subdomínio.**

---

### Checklist da Fase 5

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Nikto | `05-vulns/nikto.html` | [ ] |
| 2 | Nuclei | `05-vulns/nuclei.txt` | [ ] |
| 3 | Nmap NSE vuln | `05-vulns/nmap-vuln.txt` | [ ] |
| 4 | WPScan (se WP) | `05-vulns/wpscan.txt` | [ ] |
| 5 | S3 Buckets | `05-vulns/s3-test.txt` | [ ] |
| 6 | Subdomain Takeover | `05-vulns/subzy.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 5:

```
05-vulns/
├── nikto.html               ← scan de vulnerabilidades web (HTML legível)
├── nuclei.txt               ← vulnerabilidades encontradas por template
├── nmap-vuln.txt            ← vulnerabilidades via scripts NSE do Nmap
├── wpscan.txt               ← (se WordPress) vulnerabilidades do WP
├── s3-test.txt              ← teste de S3 buckets expostos
├── subzy.txt                ← teste de subdomain takeover
├── cnames.txt               ← CNAMEs dos subdomínios
└── searchsploit-results.txt ← resultados do searchsploit para CVEs
```

### ✅ Sinal de sucesso:
- Você encontrou pelo menos **2-3 vulnerabilidades** que pode CONFIRMAR
- Cada vulnerabilidade tem: **nome, URL alvo, evidência, severidade**
- Você separou **falsos positivos** de vulnerabilidades reais
- Você sabe qual vulnerabilidade é CRÍTICA, ALTA, MÉDIA, BAIXA

### ❌ Se falhou:
- Se NENHUM scanner encontrou nada: o alvo pode ser bem protegido
- Foque em vulnerabilidades de **configuração** que você já encontrou:
  - Headers de segurança ausentes (Fase 2.3.2)
  - Versões antigas (Fase 2.2.2)
  - Serviços expostos à internet (MySQL, Redis)
- O mínimo para avançar: ter pelo menos 1 achado que pode confirmar

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 5 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `nuclei.txt` | Fase 6 | Validar cada achado do Nuclei |
| `nikto.html` | Fase 6 | Validar achados do Nikto |
| `wpscan.txt` | Fase 6 | Validar plugins vulneráveis |
| `subzy.txt` | Fase 7 | Documentar takeover no relatório |

**Se completou tudo → Avance para Fase 6**

---
