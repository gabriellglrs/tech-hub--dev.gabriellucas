## FASE 4 — Discovery de Conteúdo

**Tempo estimado:** 60-120 minutos
**Objetivo:** Encontrar diretórios, arquivos, endpoints e parâmetros ocultos no site.
**Por quê:** Todo site tem portas dos trás — /admin, /backup, /config, /api. Esses caminhos não aparecem no menu, mas existem.

---

### Passo 4.1 — Directory/File Discovery

**Passo 4.1.1 — Gobuster (scan rápido inicial)**

```bash
gobuster dir -u http://evilcorp.com -w /usr/share/wordlists/dirb/common.txt -t 50 -b 404,403 -o 04-discovery/gobuster-basico.txt
```

**✅ Output esperado (exemplo real):**
```
===============================================================
Gobuster v3.x
===============================================================
[+] Url:                     http://evilcorp.com
[+] Threads:                 50
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Status codes:            404,403
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/admin                [Status: 301] [Size: 315] [--> http://evilcorp.com/admin/]
/api                  [Status: 301] [Size: 313] [--> http://evilcorp.com/api/]
/backup               [Status: 403] [Size: 277]
/config               [Status: 403] [Size: 277]
/css                  [Status: 301] [Size: 313] [--> http://evilcorp.com/css/]
/docs                 [Status: 301] [Size: 314] [--> http://evilcorp.com/docs/]
/images               [Status: 301] [Size: 316] [--> http://evilcorp.com/images/]
/js                   [Status: 301] [Size: 310] [--> http://evilcorp.com/js/]
/login                [Status: 200] [Size: 1845]
/robots.txt           [Status: 200] [Size: 134]
/sitemap.xml          [Status: 200] [Size: 5671]
/uploads              [Status: 403] [Size: 277]
===============================================================
Finished
===============================================================
```

**O que procurar:**
- `/admin` → Painel administrativo ⭐
- `/backup` → Backups expostos ⭐
- `/config` → Configurações ⭐
- `/docs` → Documentação exposta ⭐
- `/uploads` → Uploads de arquivo
- `/api` → API REST
- `/robots.txt` → Pode revelar caminhos ocultos
- `/sitemap.xml` → Mapa do site

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muitos falsos positivos | Status codes variados | Adicione: `-b 404,403,400,500` |
| Muito lento | Wordlist grande | Diminua threads: `-t 20` |
| WAF bloqueando | Rate limiting | Adicione delay: `--delay 0.2` |
| Output vazio | Site retorna tudo 404 | Teste manualmente: `curl -I http://evilcorp.com/` |

**Passo 4.1.2 — ffuf com extensões (encontrar arquivos)**

```bash
ffuf -u http://evilcorp.com/FUZZ -w /usr/share/wordlists/dirb/common.txt -e .php,.bak,.txt,.zip,.sql,.env,.old -fc 404,403 -o 04-discovery/ffuf-extensoes.json -of json
```

**✅ Output esperado (exemplo real):**
```
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0
________________________________________________

[Method: GET]     http://evilcorp.com/FUZZ
[Status: 200]     [Size: 234]     [Words: 15]     [Lines: 12]
[Duration: 45ms]

admin.php           [Status: 200] [Size: 234]
config.php          [Status: 200] [Size: 0]
config.bak          [Status: 200] [Size: 1247]
database.sql        [Status: 200] [Size: 45678]
.env                [Status: 200] [Size: 345]
phpinfo.php         [Status: 200] [Size: 67890]
robots.txt          [Status: 200] [Size: 134]
sitemap.xml         [Status: 200] [Size: 5671]
test.php            [Status: 200] [Size: 456]
backup.zip          [Status: 200] [Size: 234567]
```

**O que procurar:**
- `admin.php` → Painel admin ⭐
- `config.php` → Configuração com senhas ⭐
- `config.bak` → Backup da configuração ⭐⭐
- `database.sql` → Dump do banco de dados ⭐⭐⭐
- `.env` → Variáveis de ambiente (API keys) ⭐⭐⭐
- `phpinfo.php` → Informações do PHP
- `backup.zip` → Backup do site ⭐⭐
- `test.php` → Página de teste (pode ter vulnerabilidades)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muitos resultados | Wordlist muito genérica | Use wordlist menor ou mais específica |
| WAF bloqueando | Muitos requests | Adicione delay: `-p 0.1` ou use ProxyChains |
| Tudo 404 | Site é SPA (Single Page App) | Tente endpoints de API: `/api/v1/`, `/api/v2/` |
| `command not found` | ffuf não instalado | `sudo apt install ffuf` |

**Passo 4.1.3 — Scan recursivo (subdiretórios)**

Se encontrou diretórios interessantes na Fase 4.1.1, escaneie dentro deles:

```bash
ffuf -u http://evilcorp.com/admin/FUZZ -w /usr/share/wordlists/dirb/common.txt -recursion -recursion-depth 2 -fc 404 -o 04-discovery/ffuf-recursive.json -of json
```

---

### Passo 4.2 — Virtual Host Discovery

**O que você vai fazer:** Descobrir subdomínios internos que não estão no DNS público mas existem no servidor.

**Passo 4.2.1 — Descobrir o tamanho da resposta padrão**

Primeiro, descubra qual é o tamanho da resposta para um host que NÃO existe:

```bash
ffuf -u http://192.168.1.100 -H "Host: FUZZ.naoexiste.com" -w /usr/share/wordlists/dirb/common.txt -mc all -fs 0 -o /dev/null -of json -s
```

**✅ Output esperado (exemplo):**
```
[INFO] Filter: -fs 0 (response size 0)
... after scanning ...
[fs: 2345]   ← ANOTE ESTE NÚMERO. É o tamanho da resposta padrão.
```

**Passo 4.2.2 — Fuzzing de vhosts**

```bash
ffuf -u http://192.168.1.100 -H "Host: FUZZ.evilcorp.com" -w /usr/share/wordlists/dirb/common.txt -fs 2345 -mc 200,301,302 -o 04-discovery/vhosts.json -of json
```

**✅ Output esperado (exemplo real):**
```
admin.evilcorp.com    [Status: 200] [Size: 567]
dev.evilcorp.com      [Status: 302] [Size: 0]
internal.evilcorp.com [Status: 200] [Size: 890]
staging.evilcorp.com  [Status: 200] [Size: 456]
```

**O que procurar:**
- `admin.evilcorp.com` → Painel admin interno ⭐
- `staging.evilcorp.com` → Ambiente de staging (geralmente menos seguro) ⭐
- `dev.evilcorp.com` → Ambiente de desenvolvimento ⭐
- `internal.evilcorp.com` → Rede interna ⭐⭐

---

### Passo 4.3 — Descoberta de Parâmetros

**O que você vai fazer:** Descobrir parâmetros de URL que podem ser vulneráveis a SQLi, XSS, IDOR.

**Passo 4.3.1 — URLs com parâmetros (do Wayback/Gau)**

```bash
# Filtrar URLs que têm parâmetros (=)
cat 01-intel/todas-urls.txt | grep "=" | sort -u > 04-discovery/urls-com-parametros.txt

# Ver quantas encontrou
wc -l 04-discovery/urls-com-parametros.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com/page?id=5
http://evilcorp.com/search?q=test&type=all
http://evilcorp.com/api/users?id=123&format=json
http://evilcorp.com/download?file=document.pdf
http://evilcorp.com/login?redirect=/admin
http://evilcorp.com/news?page=2&sort=date
```

**O que procurar:** URLs como `page.php?id=5`, `search.php?q=test`, `api/users?id=123`

**❌ Se encontrou 0 URLs:** Use gau/waybackurls da Fase 1.3.3/1.3.4.

---

### Passo 4.4 — JavaScript Analysis

**O que você vai fazer:** Analisar arquivos JavaScript do site para encontrar endpoints de API, chaves expostas, e configurações internas.

**Passo 4.4.1 — Coletar todos os arquivos JS**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | katana -jc -d 3 -silent | grep "\.js$" | sort -u > 04-discovery/js-files.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com/js/app.js
http://evilcorp.com/js/config.js
http://evilcorp.com/js/api.js
http://admin.evilcorp.com/js/admin.js
http://api.evilcorp.com/js/swagger.js
```

**❌ Se katana não estiver instalado:**
```bash
go install github.com/projectdiscovery/katana/cmd/katana@latest
```

**Alternativa sem katana:**
```bash
# Usar waybackurls + grep
echo "evilcorp.com" | waybackurls | grep "\.js$" | sort -u > 04-discovery/js-files.txt
```

**Passo 4.4.2 — Extrair endpoints dos JS**

```bash
# Instalar LinkFinder (primeira vez)
git clone https://github.com/GerbenJavado/LinkFinder.git /opt/linkfinder
pip3 install -r /opt/linkfinder/requirements.txt

# Rodar em cada arquivo JS
while IFS= read -r js; do
    python3 /opt/linkfinder/LinkFinder.py -i "$js" -o cli
done < 04-discovery/js-files.txt > 04-discovery/js-endpoints.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com/api/v1/users
http://evilcorp.com/api/v1/documents
http://evilcorp.com/api/v2/admin
http://evilcorp.com/api/auth/login
http://evilcorp.com/api/auth/register
http://evilcorp.com/uploads/
http://evilcorp.com/admin/api/settings
```

**Passo 4.4.3 — Buscar secrets nos JS**

```bash
grep -iE "(api.?key|token|secret|password|auth|firebase|aws|github)" 04-discovery/js-files.txt > 04-discovery/js-secrets.txt
```

**✅ Output esperado (exemplo real — se encontrar secrets):**
```
// config.js
const API_KEY = "sk-1234567890abcdef";
const FIREBASE_CONFIG = {
  apiKey: "AIzaSyD1234567890",
  authDomain: "evilcorp.firebaseapp.com"
};
const AWS_ACCESS_KEY = "AKIA1234567890ABCDEF";
```

**⚠️ Se encontrar isso → GRANDE ACHADO. Anote como severidade CRÍTICA.**

---

### Checklist da Fase 4

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Diretórios (Gobuster) | `04-discovery/gobuster-basico.txt` | [ ] |
| 2 | Arquivos com extensões (ffuf) | `04-discovery/ffuf-extensoes.json` | [ ] |
| 3 | Virtual hosts | `04-discovery/vhosts.json` | [ ] |
| 4 | URLs com parâmetros | `04-discovery/urls-com-parametros.txt` | [ ] |
| 5 | Arquivos JS | `04-discovery/js-files.txt` | [ ] |
| 6 | Endpoints em JS | `04-discovery/js-endpoints.txt` | [ ] |
| 7 | Secrets em JS | `04-discovery/js-secrets.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 4:

```
04-discovery/
├── gobuster-basico.txt       ← diretórios encontrados (admin, api, backup, etc)
├── ffuf-extensoes.json       ← arquivos com extensões (.php, .bak, .sql, .env)
├── ffuf-recursive.json       ← scan recursivo dentro de diretórios encontrados
├── vhosts.json               ← virtual hosts descobertos (admin, staging, internal)
├── urls-com-parametros.txt   ← URLs com ?parametro=valor (candidatas a SQLi, XSS)
├── parametros.json           ← parâmetros descobertos via brute force
├── js-files.txt              ← todos os arquivos JavaScript encontrados
├── js-endpoints.txt          ← endpoints extraídos dos JS ( /api/users, /api/admin )
├── js-secrets.txt            ← secrets/chaves encontradas nos JS
├── google-dorks.txt          ← cópia da Fase 1 (URLs sensíveis)
└── todas-urls.txt            ← cópia da Fase 1 (URLs históricas)
```

### ✅ Sinal de sucesso:
- Você encontrou pelo menos **5 diretórios** em `gobuster-basico.txt`
- Você tem **URLs com parâmetros** em `urls-com-parametros.txt`
- Você identificou pelo menos **1 virtual host** interno (ex: staging, dev, internal)
- Você encontrou **arquivos sensíveis** em `ffuf-extensoes.json` (ex: config.php, .env)

### ❌ Se falhou:
- Se Gobuster não encontrou nada: o site pode ser SPA — tente endpoints de API
- Se ffuf não encontrou arquivos: tente extensões diferentes
- O mínimo para avançar: ter `gobuster-basico.txt` com pelo menos 3 diretórios

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 4 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `gobuster-basico.txt` | Fase 5 | Nikto vai varrer esses diretórios |
| `ffuf-extensoes.json` | Fase 5 | Arquivos sensíveis são alvos de vulnerabilidade |
| `urls-com-parametros.txt` | Fase 5 | Candidatos a SQLi, XSS |
| `js-endpoints.txt` | Fase 5 | Endpoints de API para Nuclei testar |
| `js-secrets.txt` | Fase 5, 7 | Secrets são vulnerabilidades CRÍTICAS |

**Se completou tudo → Avance para Fase 5**

---
