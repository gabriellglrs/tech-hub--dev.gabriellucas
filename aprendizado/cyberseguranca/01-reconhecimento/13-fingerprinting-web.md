# 🔍 13. Fingerprinting Web — Identificando Tecnologias do Alvo

> Antes de atacar, você precisa saber O QUE está atacando. Fingerprinting revela CMS, servidores, frameworks, linguagens e até versões específicas.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 40min | ⭐⭐ Intermediário | `whatweb, wappalyzer, httpx` |

</div>

---

## 🎓 Por que isso importa?

Imagine entrar em uma casa sem saber se a porta é de madeira ou aço. Fingerprinting é como olhar a fechadura antes de escolher a picareta. Saber que o site roda WordPress 5.7 com jQuery 3.3.1 e PHP 7.4 te dá:

- **CVEs conhecidas** para cada componente
- **Vetores de ataque** específicos (plugins WordPress vulns, jQuery XSS)
- **Priorização** — atacar o elo mais fraco

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP básico | Sim | Módulo 02 |
| O que é CMS | Sim | Conhecimento geral |
| cURL | Sim | Arquivo 12 deste módulo |

---

## 🎯 Quando usar Fingerprinting

- Sempre como **primeiro passo** em qualquer alvo web
- Antes de qualquer scan de vulnerabilidades
- Para descobrir versões exatas e buscar CVEs
- Para identificar frameworks customizados

---

## 🛠️ Ferramentas de Fingerprinting

### 1. WhatWeb — O Fingerprinting via CLI

WhatWeb é a ferramenta padrão de fingerprinting do Kali. Ele envia requests HTTP e analisa as respostas contra um banco de 1.800+ fingerprints.

#### Instalação

```bash
# Pre-installed no Kali. Verificar versão:
whatweb --version

# Se não estiver instalado:
sudo apt update && sudo apt install whatweb
```

#### Flags Principais

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-a` | Nível de agressividade (1-3) | `whatweb -a 3` |
| `-v` | Output verboso (mostra cada match) | `whatweb -v` |
| `-i` | Ler alvos de arquivo | `whatweb -i targets.txt` |
| `--color` | Output colorido | `whatweb --color` |
| `-o` | Salvar output em arquivo | `whatweb -o result.txt` |
| `-f` | Formato do output (json, csv, html) | `whatweb -f json` |
| `--no-errors` | Suprimir erros | `whatweb --no-errors` |
| `-U` | Custom User-Agent | `whatweb -U "Mozilla/5.0"` |

#### Exemplos Práticos

**Scan básico — o que o site usa?**
```bash
whatweb http://testphp.vulnweb.com
```

**Output esperado:**
```
http://testphp.vulnweb.com [200 OK] Apache[2.4.41], Bootstrap[4.3.1],
Country[RESERVED][ZZ], HTML5, HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)],
IP[192.168.50.20], JQuery[3.3.1], PHP[7.4.3], WordPress[5.7],
X-Powered-By[PHP/7.4.3]
```

**Scan agressivo — pegar TUDO (mais lento, mais ruidoso):**
```bash
whatweb -a 3 -v http://testphp.vulnweb.com
```

**Output verboso mostrando evidências:**
```
http://testphp.vulnweb.com [200 OK] Apache[2.4.41],
  Country[RESERVED][ZZ],
  HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)],
  IP[192.168.50.20],
  JQuery[3.3.1][from jQuery CDN: code.jquery.com],
  PHP[7.4.3][X-Powered-By: PHP/7.4.3],
  WordPress[5.7][Meta generator: WordPress 5.7]
```

**Scan de múltiplos alvos:**
```bash
# De arquivo
whatweb -i alvos.txt -o resultado.json -f json

# De uma lista na command line
whatweb http://site1.com http://site2.com http://site3.com
```

**Salvar em formato HTML para relatório:**
```bash
whatweb -a 3 --color http://target.com -o relatorio.html -f html
```

#### O que procurar no output

| Componente Detectado | O que fazer |
|---------------------|-------------|
| `WordPress[5.7]` | Buscar CVEs do WordPress 5.7, enumerar plugins com WPScan |
| `JQuery[1.9.1]` | Versões antigas do jQuery têm XSS (CVE-2020-11022, CVE-2020-11023) |
| `PHP[7.2]` | PHP 7.2 já ficou sem suporte — verificar versões vulneráveis |
| `Apache[2.4.49]` | Apache 2.4.49 tem path traversal (CVE-2021-41773) |
| `X-Powered-By` | Expõe tecnologia e versão — alvo fácil para buscas de CVE |
| `wp-login.php` | WordPress com login acessível — brute force possível |

---

### 2. Wappalyzer — Fingerprinting via Browser

Wappalyzer é uma extensão de browser que faz a mesma coisa que WhatWeb, mas de forma visual e interativa.

#### Instalação

```
1. Abra Firefox/Chrome
2. Vá nas extensões/add-ons
3. Busque por "Wappalyzer"
4. Instale a extensão oficial
```

**Não precisa de CLI** — é clicar no ícone da extensão e ver as tecnologias.

#### O que Wappalyzer detecta

- CMS (WordPress, Joomla, Drupal)
- Frameworks (Laravel, Django, React, Angular)
- Servidores web (Apache, Nginx, IIS)
- Linguagens (PHP, Python, Node.js, Java)
- Analytics (Google Analytics, Hotjar)
- CDN (Cloudflare, Akamai, Fastly)
- Fontes de pagamento (Stripe, PayPal)
- JavaScript libs (jQuery, Bootstrap, Vue.js)

#### Comparação: WhatWeb vs Wappalyzer

| Aspecto | WhatWeb | Wappalyzer |
|---------|---------|------------|
| **Interface** | CLI (terminal) | Browser extension |
| **Velocidade** | Rápido (múltiplos alvos) | Lento (1 por vez) |
| **Automação** | Sim (scripts, pipelines) | Não (manual) |
| **Versões** | Detecta versões | Detecta versões |
| **Profundidade** | 1.800+ plugins | Mais categorias |
| **Uso em pentest** | Preferido (padrão OSCP) | Complementar |

**Recomendação:** Use WhatWeb como ferramenta principal e Wappalyzer para validação visual.

---

### 3. httpx — Fingerprinting em Massa

O httpx (já coberto no arquivo 02) também faz fingerprinting quando combinado com as flags certas.

```bash
# Fingerprinting de lista de subdomínios
cat subdominios.txt | httpx -title -tech-detect -status-code -web-server -follow-redirects -o httpx-fingerprint.json -json
```

**Output esperado:**
```json
{
  "url": "https://admin.evilcorp.com",
  "title": "Admin Panel - EvilCorp",
  "tech-detect": ["Apache/2.4.41", "PHP/7.4.3", "WordPress 5.7", "jQuery 3.3.1"],
  "status_code": 200,
  "webserver": "Apache",
  "final_url": "https://admin.evilcorp.com/wp-admin/"
}
```

**Pipeline completo de fingerprinting:**
```bash
# 1. Enumerar subdomínios
subfinder -d evilcorp.com -silent > subs.txt

# 2. Fingerprinting em massa
cat subs.txt | httpx -title -tech-detect -status-code -web-server -silent > fingerprint.txt

# 3. Filtrar apenas WordPress
cat fingerprint.txt | grep -i "wordpress"
```

---

## 🔗 Pipeline de Fingerprinting Recomendado

```
1. WhatWeb (target principal)
       ↓
2. Wappalyzer (validação visual)
       ↓
3. httpx (massa — todos os subdomínios)
       ↓
4. Buscar CVEs para cada componente encontrado
       ↓
5. WPScan (se WordPress detectado)
```

---

## ⚠️ Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| WhatWeb não detecta nada | Site bloqueia User-Agent | Use `-U "Mozilla/5.0"` |
| Output muito verboso | Usou `-v` sem necessidade | Remova `-v` para output limpo |
| Wappalyzer não mostra nada | Extensão desabilitada | Verifique no ícone do browser |
| httpx não retorna tech | Falta `-tech-detect` | Adicione a flag `-tech-detect` |
| WordPress não detectado | Protegido por WAF | Use WPScan com `--force` |

---

## 🎯 Cheat Sheet Rápido

```bash
# Scan básico do WhatWeb
whatweb http://target.com

# Scan agressivo com tudo
whatweb -a 3 -v http://target.com

# Múltiplos alvos
whatweb -i targets.txt -o result.json -f json

# Fingerprinting em massa via httpx
cat subs.txt | httpx -title -tech-detect -status-code -web-server

# Detectar WordPress especificamente
whatweb http://target.com | grep -i wordpress

# Buscar CVEs para versão encontrada
searchsploit apache 2.4.41
searchsploit wordpress 5.7
searchsploit jquery 3.3.1
```

---

## 📚 Referências

- [WhatWeb GitHub](https://github.com/urbanadventurer/WhatWeb)
- [WhatWeb Wiki](https://github.com/urbanadventurer/WhatWeb/wiki)
- [OWASP Fingerprinting Guide](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/01-Information_Gathering/08-Fingerprint_Web_Application_Framework)
- [Wappalyzer](https://www.wappalyzer.com/)
- [httpx - ProjectDiscovery](https://github.com/projectdiscovery/httpx)

---

**Próximo:** [14. Discovery de Conteúdo](14-discovery-de-conteudo.md) — Gobuster e ffuf para encontrar diretórios, arquivos e endpoints ocultos

**Anterior:** [12. CORS e APIs](12-cors-e-api.md)
