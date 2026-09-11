## FASE 3 — Fingerprinting

**Tempo estimado:** 20-40 minutos
**Objetivo:** Saber EXATAMENTE o que o alvo usa — CMS, frameworks, servidores, linguagens, libs.
**Por quê:** Saber que o alvo usa WordPress 5.7 com PHP 7.4 te permite buscar CVEs específicas. É como saber a marca da fechadura antes de escolher a picareta.

---

### Passo 3.1 — Fingerprinting Web

**Passo 3.1.1 — WhatWeb no domínio principal**

```bash
whatweb -a 3 -v evilcorp.com > 03-fingerprint/whatweb-principal.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com [200 OK] Apache[2.4.41], Country[US][US], HTML5, HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)], IP[104.21.33.15], PHP[7.4.3], Title[EvilCorp - Leading the Future], Ubuntu[18.04], X-Powered-By[PHP/7.4.3]
```

**O que procurar no output:**
- `[Apache/2.4.41]` → Servidor web e versão
- `[PHP/7.4.3]` → Linguagem e versão
- `[Ubuntu 18.04]` → Sistema operacional (PODE TER CVEs do SO)
- `[Title]` → Nome do site
- `[HTML5]` → Tecnologia frontend

**Passo 3.1.2 — WhatWeb em todos os subdomínios vivos**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | whatweb -a 3 -i - > 03-fingerprint/whatweb-todos.txt
```

**✅ Output esperado (exemplo):**
```
http://admin.evilcorp.com [403 Forbidden] Apache[2.4.41]
http://api.evilcorp.com [200 OK] JSON, RESTAPI
http://dev.evilcorp.com [200 OK] Apache[2.4.41], PHP[7.4.3], WordPress[5.7]
http://mail.evilcorp.com [200 OK] Roundcube[1.6.0]
http://staging.evilcorp.com [200 OK] Apache[2.4.41], PHP[8.1.0]
http://www.evilcorp.com [200 OK] Apache[2.4.41], PHP[7.4.3], WordPress[6.4]
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| WAF bloqueando | Cloudflare/WAF detectando WhatWeb | Mude User-Agent: `whatweb -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"` |
| Muito lento | Agressividade alta | Reduza: `-a 2` |
| Output vazio | WAF bloqueando todas as respostas | Use httpx tech detect (próximo passo) |

**Passo 3.1.3 — httpx tech detect em massa (alternativa mais rápida)**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | httpx -tech-detect -title -status-code -web-server -silent > 03-fingerprint/httpx-tech.txt
```

**✅ Output esperado (exemplo real):**
```
http://admin.evilcorp.com [403] [Admin Panel] [Apache/2.4.41]
http://api.evilcorp.com [200] [EvilCorp API] [nginx/1.24.0]
http://dev.evilcorp.com [200] [Dev Server] [Apache/2.4.41] [PHP/7.4.3, WordPress/5.7]
http://mail.evilcorp.com [200] [Roundcube Webmail] [Apache/2.4.41]
http://www.evilcorp.com [200] [EvilCorp] [Apache/2.4.41] [PHP/7.4.3, WordPress/6.4]
```

---

### Passo 3.2 — Detecção de WAF

**Por quê:** Se o alvo tem WAF, seus scans podem ser bloqueados ou banir seu IP. Precisa saber ANTES de escanear.

**Passo 3.2.1 — Wafw00f no domínio principal**

```bash
wafw00f -v evilcorp.com > 03-fingerprint/waf-principal.txt
```

**✅ Output esperado (exemplo real — COM WAF):**
```
                 ______
                /     _\
               / /\_/\ \   wafw00f - v2.2.1
              / __   _ \   https://github.com EnableSecurity/wafw00f
             / /\/\  \ \  @_EnableSecurity

 [*] Checking http://evilcorp.com
 [+] The site http://evilcorp.com is behind Cloudflare (Cloudflare Inc.)
```

**✅ Output esperado (exemplo real — SEM WAF):**
```
 [~] Checking http://evilcorp.com
 [-] No WAF detected by the generic detection
```

**O que fazer com essa informação:**
- **Sem WAF:** Escaneie normalmente, menos restrições
- **Com Cloudflare:** Geralmente bloqueia scans. Use `-T3` e menos threads
- **Com AWS WAF:** Pode bloquear por IP. Use ProxyChains
- **WAF diferente em cada sub:** Foque nos subdomínios SEM WAF primeiro

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `command not found` | Não instalado | `sudo apt install wafw00f` |
| Output "No WAF" mas bloqueando | WAF não detectado genericamente | Use `wafw00f -a` para testar todos os detectores |
| Timeout | WAF bloqueando wafw00f | Use `proxychains4 wafw00f -v evilcorp.com` |

**Passo 3.2.2 — Wafw00f em todos os subdomínios**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | wafw00f -i - -o 03-fingerprint/waf-todos.json -f json
```

---

### Passo 3.3 — Buscar CVEs para versões encontradas

**O que você vai fazer:** Usar as versões encontradas nas fases anteriores para buscar vulnerabilidades conhecidas.

```bash
# Buscar CVEs para Apache 2.4.41
searchsploit apache 2.4.41

# Buscar CVEs para WordPress 5.7
searchsploit wordpress 5.7

# Buscar CVEs para PHP 7.4
searchsploit php 7.4.3

# Buscar CVEs para jQuery 3.3.1
searchsploit jquery 3.3.1
```

**✅ Output esperado (exemplo real — Apache 2.4.41):**
```
------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                       |  Path
------------------------------------------------------------------------------------- ---------------------------------
Apache 2.4.41 - 'mod_remoteip' Request Smuggling                                    | linux/webapps/49039.txt
Apache 2.4.41 - HTTP/2 Request Smuggling                                            | linux/dos/47897.py
Apache HTTP Server 2.4.41 - 'mod_cgid' RCE                                         | linux/remote/48884.py
------------------------------------------------------------------------------------- ---------------------------------
```

**O que procurar:** Vulnerabilidades com CVE que têm exploit público. Anote os números de CVE.

**❌ Se searchsploit não encontrar nada:**
| Alternativa | Como |
|-------------|------|
| Nmap NSE | `nmap --script vuln -p 80,443 evilcorp.com` |
| Nuclei | `nuclei -u http://evilcorp.com -severity critical,high` |
| Manual | Pesquise no Google: "Apache 2.4.41 CVE" |

---

### Checklist da Fase 3

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | WhatWeb principal | `03-fingerprint/whatweb-principal.txt` | [ ] |
| 2 | WhatWeb todos os subs | `03-fingerprint/whatweb-todos.txt` | [ ] |
| 3 | httpx tech detect | `03-fingerprint/httpx-tech.txt` | [ ] |
| 4 | WAF principal | `03-fingerprint/waf-principal.txt` | [ ] |
| 5 | WAF todos os subs | `03-fingerprint/waf-todos.json` | [ ] |
| 6 | CVEs buscadas | Anotadas no relatório | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 3:

```
03-fingerprint/
├── whatweb-principal.txt    ← tecnologias do domínio principal
├── whatweb-todos.txt        ← tecnologias de TODOS os subdomínios vivos
├── httpx-tech.txt           ← tecnologias via httpx (confirmação)
├── waf-principal.txt        ← WAF do domínio principal
├── waf-todos.json           ← WAF de todos os subdomínios
└── cves-encontradas.txt     ← lista de CVEs que você buscou (se/searchsploit)
```

### ✅ Sinal de sucesso:
- Você sabe o **CMS** que o alvo usa (WordPress, Joomla, Drupal, ou nenhum)
- Você sabe o **servidor web** e versão (Apache, Nginx, IIS)
- Você sabe o **WAF** (Cloudflare, AWS WAF, ou nenhum)
- Você buscou **CVEs** para as versões encontradas
- Você tem uma tabela mental: `versão | vulnerabilidade可能性`

### ❌ Se falhou:
- Se WhatWeb não detectou nada: use `httpx -tech-detect` (já deve ter na Fase 2)
- Se Wafw00f não detectou WAF: provavelmente NÃO tem WAF (bom para você)
- O mínimo para avançar: ter pelo menos a versão do servidor web

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 3 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `whatweb-principal.txt` | Fase 4, 5 | Saber se é WordPress para usar WPScan |
| `waf-todos.json` | Fase 4, 5 | Evitar subdomínios com WAF |
| `cves-encontradas.txt` | Fase 5 | Buscar vulnerabilidades específicas |
| `httpx-tech.txt` | Fase 5 | Confirmar versões para Nuclei |

**Se completou tudo → Avance para Fase 4**

---
