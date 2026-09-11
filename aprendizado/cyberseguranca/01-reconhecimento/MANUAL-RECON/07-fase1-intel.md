## FASE 1 — Inteligência Passiva

**Tempo estimado:** 30-60 minutos
**Objetivo:** Descobrir O QUE existe sem gerar NENHUM tráfego para o alvo. Tudo via fontes públicas.
**Por quê:** Se o alvo tem IDS/IPS, ele NÃO vai detectar esta fase. É 100% segura.

---

### Passo 1.1 — Informações do Domínio (WHOIS e DNS)

**O que você vai fazer:** Consultar banco de dados públicos para descobrir quem registrou o domínio, quais IPs pertencem a ele, e quais servidores de DNS ele usa.

**Passo 1.1.1 — WHOIS**

```bash
whois evilcorp.com > 01-intel/whois.txt
```

**✅ Output esperado (exemplo real):**
```
   Domain Name: EVILCORP.COM
   Registry Domain ID: 1234567890_DOMAIN_COM-VRSN
   Registrar WHOIS WHO IS: WHOIS AKAMAI-LOS ANGELES
   Updated Date: 2024-01-15T12:00:00Z
   Creation Date: 2010-03-22T15:30:00Z
   Registrar Registration Expiration Date: 2025-03-22T15:30:00Z
   Registrant Organization: EvilCorp Inc.
   Registrant State/Province: California
   Registrant Country: US
   Name Server: NS1.AWSDNS.COM
   Name Server: NS2.AWSDNS.ORG
   DNSSEC: unsigned
```

**O que procurar no output:**
- **Registrant Organization:** Nome da empresa dona do domínio
- **Range de IPs:** Geralmente aparece como CIDR (ex: `192.168.0.0/24`) — anote, você vai escanear esses IPs depois
- **Name Servers:** Podem revelar infraestrutura (ex: `ns1.awsdns.com` = usa AWS)
- **Email de contato:** Pode ser usado para OSINT de pessoas
- **Data de criação:** Domínios muito novos podem ter configs padrão

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `whois: command not found` | Ferramenta não instalada | `sudo apt install whois` |
| Output vazio | Domínio privado ou proteção WHOIS | Acesse https://who.is e busque manualmente |
| Timeout | DNS lento | Use `whois -h whois.verisign-grs.com evilcorp.com` |
| Acesso bloqueado | IP banido pelo registry | Use `proxychains4 whois evilcorp.com` |

**Passo 1.1.2 — Records DNS**

```bash
dig evilcorp.com ANY > 01-intel/dns-records.txt
```

**✅ Output esperado (exemplo real):**
```
;; ANSWER SECTION:
evilcorp.com.        300    IN    A    104.21.33.15
evilcorp.com.        300    IN    A    172.67.188.22
evilcorp.com.        300    IN    MX    10 mail.evilcorp.com.
evilcorp.com.        300    IN    NS    ns1.awsdns.com.
evilcorp.com.        300    IN    NS    ns2.awsdns.org.
evilcorp.com.        300    IN    TXT   "v=spf1 include:_spf.google.com ~all"
evilcorp.com.        300    IN    TXT   "google-site-verification=abc123"
```

**O que procurar:**
- **A record:** IP do domínio principal → `104.21.33.15` (Cloudflare)
- **AAAA record:** IPv6 (se existir)
- **MX record:** Servidor de email → `mail.evilcorp.com` (pode revelar infraestrutura)
- **NS record:** Nameservers → `ns1.awsdns.com` (AWS Route 53)
- **TXT record:** SPF, DMARC, informações de verificação

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `dig: command not found` | Ferramenta não instalada | `sudo apt install dnsutils` |
| `;; no servers could be reached` | DNS bloqueando | Use `nslookup evilcorp.com 8.8.8.8` |
| Output vazio | Domínio não existe | Verifique ortografia do domínio |
| APENAS SOA record | DNS privado | Use `host evilcorp.com` como alternativa |

**Passo 1.1.3 — Reverse DNS (dos IPs encontrados)**

```bash
# Descobrir o IP do domínio primeiro
dig +short evilcorp.com
# Output esperado: 104.21.33.15

# Agora fazer reverse DNS
dig -x 104.21.33.15 > 01-intel/reverse-dns.txt
```

**✅ Output esperado (exemplo real):**
```
;; ANSWER SECTION:
15.33.21.104.in-addr.arpa. 300 IN PTR 104-21-33-15.cloudflare.net.
```

**O que procurar:** Hostnames associados ao IP. Se o IP pertence a um range grande, pode haver outros hostnames. O hostname `cloudflare.net` confirma que o site usa Cloudflare CDN.

---

### Passo 1.2 — Enumeração de Subdomínios Passiva

**O que você vai fazer:** Usar ferramentas que consultam 40+ fontes públicas (Google, VirusTotal, crt.sh, etc) para encontrar TODOS os subdomínios conhecidos. Nenhuma dessas ferramentas toca no alvo.

**Passo 1.2.1 — Subfinder (mais rápido)**

```bash
subfinder -d evilcorp.com -silent > 01-intel/subfinder.txt
```

**✅ Output esperado (exemplo real):**
```
admin.evilcorp.com
mail.evilcorp.com
staging.evilcorp.com
dev.evilcorp.com
api.evilcorp.com
www.evilcorp.com
vpn.evilcorp.com
portal.evilcorp.com
```

**O que procurar:** Lista de subdomínios. Cada linha é um subdomínio diferente.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Domínio muito novo/privado | Use `-all` para mais fontes: `subfinder -d evilcorp.com -all -silent` |
| Timeout | API limitando | Use `subfinder -d evilcorp.com -timeout 15 -silent` |
| `command not found` | Não instalado | `sudo apt install subfinder` ou `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` |

**Passo 1.2.2 — Amass passivo (mais profundo)**

```bash
amass enum -passive -d evilcorp.com -o 01-intel/amass.txt
```

**✅ Output esperado (exemplo real):**
```
www.evilcorp.com
admin.evilcorp.com
mail.evilcorp.com
dev.evilcorp.com
staging.evilcorp.com
api.evilcorp.com
internal.evilcorp.com
test.evilcorp.com
jenkins.evilcorp.com
gitlab.evilcorp.com
grafana.evilcorp.com
```

**Diferença do Subfinder:** Amass usa mais fontes e gera mais resultados, mas é mais lento. Geralmente encontra 20-50% mais subdomínios que o Subfinder.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Internet bloqueando APIs | Verifique conectividade: `curl -s https://google.com` |
| Muito lento (>10 min) | Normal do Amass | Espere ou cancele com Ctrl+C e use resultados do Subfinder |
| `command not found` | Não instalado | `sudo apt install amass` |

**Passo 1.2.3 — crt.sh (Certificate Transparency)**

```bash
curl -s "https://crt.sh/?q=evilcorp.com&output=json" | jq -r '.[].name_value' | sort -u > 01-intel/crtsh.txt
```

**✅ Output esperado (exemplo real):**
```
*.evilcorp.com
evilcorp.com
admin.evilcorp.com
api.evilcorp.com
dev.evilcorp.com
mail.evilcorp.com
staging.evilcorp.com
www.evilcorp.com
```

**O que procurar:** Subdomínios que apareceram em certificados SSL. Esses subdomínios podem não existir mais no DNS, mas existiram algum dia. O `*.evilcorp.com` significa que há um certificado wildcard.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `jq: command not found` | jq não instalado | `sudo apt install jq` |
| Output vazio | crt.sh retornou erro | Acesse https://crt.sh manualmente e busque pelo domínio |
| Timeout | crt.sh sobrecarregado | Tente novamente em 5 minutos |
| JSON malformado | API mudou | Use `curl -s "https://crt.sh/?q=evilcorp.com" | grep -oE '[a-z0-9.-]+\.evilcorp\.com' | sort -u > 01-intel/crtsh.txt` |

**Passo 1.2.4 — theHarvester (emails + subdomínios)**

```bash
theHarvester -d evilcorp.com -b all -f 01-intel/theharvester.html
```

**✅ Output esperado (exemplo real):**
```
*******************************************************************
*  _   _                                            _             *
* | |_| |__   ___    /\  /\__ _ _ ____   _____  ___| |_ ___ _ __ *
* | __|  _ \ / _ \  / /_/ / _` | '__\ \ / / _ \/ __| __/ _ \ '__|*
* | |_| | | |  __/ / __  / (_| | |   \ V /  __/\__ \ ||  __/ |   *
*  \__|_| |_|\___/ \/ /_/ \__,_|_|    \_/ \___||___/\__\___|_|   *
*                                                                 *
* theHarvester 4.x                                                *
*******************************************************************

[*] Searching 0 results...

Emails found:
-----------------
admin@evilcorp.com
info@evilcorp.com
jose.silva@evilcorp.com
maria.santos@evilcorp.com

Hosts found:
-----------------
www.evilcorp.com [104.21.33.15]
admin.evilcorp.com [104.21.33.16]
mail.evilcorp.com [192.168.1.50]
```

**O que procurar:**
- **Emails:** Podem ser usados para ataques de phishing ou brute force
- **Subdomínios:** Confirma o que já encontrou + novos
- **IPs:** Confirma ranges do WHOIS

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muito pouco output | Fontes limitando requests | Reduza fontes: `-b google,bing,crtsh` |
| `Connection refused` | IP banido | Use `proxychains4 theHarvester -d evilcorp.com -b google` |
| `command not found` | Não instalado | `sudo apt install theharvester` |

**Passo 1.2.5 — Combinar e deduplicar**

```bash
cat 01-intel/subfinder.txt 01-intel/amass.txt 01-intel/crtsh.txt 01-intel/theharvester.txt | grep -i "evilcorp.com" | sort -u > 01-intel/subdominios-todos.txt
```

**✅ Output esperado (exemplo real — subdomínios combinados):**
```
admin.evilcorp.com
api.evilcorp.com
dev.evilcorp.com
gitlab.evilcorp.com
grafana.evilcorp.com
internal.evilcorp.com
jenkins.evilcorp.com
mail.evilcorp.com
portal.evilcorp.com
staging.evilcorp.com
test.evilcorp.com
vpn.evilcorp.com
www.evilcorp.com
```

**Verificar quantos encontrou:**
```bash
wc -l 01-intel/subdominios-todos.txt
```

**O que é um bom número:**
- 10-30 subdomínios = domínio pequeno/médio (normal)
- 30-100 subdomínios = empresa grande (normal)
- 100+ subdomínios = empresa muito grande ou com muitos serviços
- 0 subdomínios = domínio muito novo, privado, ou erro no comando

---

### Passo 1.3 — OSINT Organizacional

**O que você vai fazer:** Usar fontes públicas para descobrir informações sobre a organização que podem ajudar no ataque.

**Passo 1.3.1 — Google Dorking (no navegador)**

Abra o Firefox/Chrome e busque:

| Busca | O que encontra |
|-------|----------------|
| `site:evilcorp.com filetype:pdf` | PDFs expostos (docs internos) |
| `site:evilcorp.com inurl:admin` | Painéis de administração |
| `site:evilcorp.com intitle:"index of"` | Diretórios abertos |
| `site:evilcorp.com filetype:sql` | SQL dumps expostos |
| `site:evilcorp.com inurl:login` | Páginas de login |
| `"evilcorp.com" password` | Senhas vazadas |
| `"evilcorp.com" "confidential"` | Docs confidenciais |

**✅ Output esperado no navegador:**
```
site:evilcorp.com filetype:pdf

1. https://evilcorp.com/docs/rede-interna-2024.pdf
2. https://evilcorp.com/docs/relatorio-financeiro.pdf
3. https://staging.evilcorp.com/docs/configuracoes-api.pdf
```

**O que procurar:** PDFs de rede interna, configs de API, dados de staging = tesouro.

**Salve os resultados:** Copie os URLs encontrados e cole em `01-intel/google-dorks.txt`

**Passo 1.3.2 — Shodan (se tiver API key)**

```bash
# Instalar e configurar (primeira vez)
pip3 install shodan
shodan init SUA_API_KEY

# Buscar
shodan search "org:EvilCorp" --filename 01-intel/shodan.json
```

**✅ Output esperado (exemplo de 1 resultado):**
```json
{
  "ip_str": "104.21.33.15",
  "port": 443,
  "org": "EvilCorp Inc.",
  "product": "cloudflare",
  "version": "nginx",
  "vulns": ["CVE-2023-44487"],
  "hostnames": ["www.evilcorp.com", "admin.evilcorp.com"]
}
```

**O que procurar:** IPs, serviços expostos, vulnerabilidades conhecidas, headers interessantes.

**❌ Se não tiver API key:**
| Alternativa | Como |
|-------------|------|
| Shodan web | Acesse https://www.shodan.io e busque por `org:EvilCorp` |
| Censys | Acesse https://search.censys.io e busque o mesmo |
| ZoomEye | Acesse https://www.zoomeye.org |

**Passo 1.3.3 — Wayback Machine (URLs históricas)**

```bash
# Instalar waybackurls (primeira vez)
go install github.com/tomnomnom/waybackurls@latest

# Usar
echo "evilcorp.com" | waybackurls > 01-intel/wayback.txt
```

**✅ Output esperado (exemplo real):**
```
https://evilcorp.com/
https://evilcorp.com/admin/
https://evilcorp.com/admin/login.php
https://evilcorp.com/api/v1/users
https://evilcorp.com/api/v2/documents
https://evilcorp.com/config.php
https://evilcorp.com/debug/
https://evilcorp.com/old-site/
https://evilcorp.com/wordpress/
https://evilcorp.com/wp-admin/
https://evilcorp.com/wp-content/uploads/2023/backup.sql
https://evilcorp.com/robots.txt
https://evilcorp.com/sitemap.xml
```

**O que procurar:**
- `/admin/` → Painéis de administração
- `/api/` → Endpoints de API
- `/config.php` → Arquivo de configuração
- `/debug/` → Página de debug (pode ter infos sensíveis)
- `/old-site/` → Site antigo (pode ter menos segurança)
- `/wp-admin/` → WordPress admin
- `.sql` dumps → Backup de banco exposto

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `waybackurls: command not found` | Não instalado | `go install github.com/tomnomnom/waybackurls@latest` |
| Go não instalado | Não tem Go | `sudo apt install golang` |
| Output vazio | Domínio não tem histórico | Acesse https://web.archive.org e busque manualmente |
| Muito lento | Wayback retornando muito | Use gau (ver próximo passo) |

**Passo 1.3.4 — URLs de múltiplas fontes**

```bash
# Instalar gau (primeira vez)
go install github.com/lc/gau/v2/cmd/gau@latest

# Usar
echo "evilcorp.com" | gau > 01-intel/gau.txt

# Combinar com wayback
cat 01-intel/wayback.txt 01-intel/gau.txt | sort -u > 01-intel/todas-urls.txt
```

**✅ Output esperado de `wc -l 01-intel/todas-urls.txt`:**
```
2847 01-intel/todas-urls.txt
```
(2847 URLs únicas encontradas — é um número bom para uma empresa média)

---

### Checklist da Fase 1

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | WHOIS completo | `01-intel/whois.txt` | [ ] |
| 2 | Records DNS | `01-intel/dns-records.txt` | [ ] |
| 3 | ASN/BGP Mapping | `01-intel/asns.txt`, `01-intel/cidrs.txt` | [ ] |
| 4 | Reverse DNS | `01-intel/reverse-dns.txt` | [ ] |
| 5 | Subdomínios (combinados) | `01-intel/subdominios-todos.txt` | [ ] |
| 6 | Emails encontrados | `01-intel/theharvester.html` | [ ] |
| 7 | GitHub/GitLab OSINT | `01-intel/github-repos.txt` | [ ] |
| 8 | Google Dorks | `01-intel/google-dorks.txt` | [ ] |
| 9 | URLs históricas | `01-intel/todas-urls.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 1:

```
01-intel/
├── whois.txt              ← dados do WHOIS (empresa, IPs, nameservers)
├── dns-records.txt        ← records DNS (A, MX, NS, TXT)
├── asns.txt               ← ASNs da organização
├── cidrs.txt              ← ranges de IP (prefixos CIDR)
├── reverse-dns.txt        ← reverse DNS dos IPs
├── subdominios-todos.txt  ← TODOS os subdomínios combinados (merge dos 4)
├── subfinder.txt          ← subdomínios do Subfinder
├── amass.txt              ← subdomínios do Amass
├── crtsh.txt              ← subdomínios do crt.sh
├── theharvester.txt       ← subdomínios + emails do theHarvester
├── github-repos.txt       ← repositórios públicos da organização
├── github-files.txt       ← arquivos em repositórios (possíveis secrets)
├── google-dorks.txt       ← URLs encontradas no Google
├── wayback.txt            ← URLs do Wayback Machine
├── gau.txt                ← URLs do gau
├── todas-urls.txt         ← MERGE de wayback + gau (URLs históricas combinadas)
└── shodan.json            ← (se tiver API key) resultados do Shodan
```

### ✅ Sinal de sucesso:
- Você tem pelo menos **10 subdomínios** em `subdominios-todos.txt`
- Você tem pelo menos **100+ URLs** em `todas-urls.txt`
- Você sabe o **range de IPs** do alvo (do WHOIS/DNS)
- Você sabe **quais nameservers** o alvo usa

### ❌ Se falhou:
- Revise os erros na tabela "Se der errado" de cada passo
- Avance para Fase 2 mesmo assim — talvez com menos dados
- O mínimo para avançar: ter `subdominios-todos.txt` com pelo menos 3 subdomínios

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 1 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `subdominios-todos.txt` | Fase 2 | Validar quais subdomínios estão vivos |
| `todas-urls.txt` | Fase 4 | Encontrar endpoints antigos, parâmetros |
| `whois.txt` | Fase 2 | Saber quais IPs escanear |
| `dns-records.txt` | Fase 3 | Saber tecnologias DNS usadas |
| `google-dorks.txt` | Fase 4 | URLs sensíveis já encontradas |

**Se completou tudo → Avance para Fase 2**

---
