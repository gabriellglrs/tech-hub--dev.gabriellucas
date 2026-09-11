# 🔍 Google Dorking

> Operadores avançados do Google para encontrar informações expostas — sem tocar no alvo.

---

## 📚 O que é Google Dorking?

**Google Dorking** (ou Google Hacking) é usar **operadores especiais** no Google para encontrar informações que não deveriam estar públicas — senhas, arquivos de configuração, painéis administrativos, erros de servidores. É como ter um raio-x do Google.

### Por que isso é importante?

- **100% passivo** — você não toca no alvo (só usa o Google)
- **Encontra coisas que ferramentas não encontram** — o Google indexa TUDO
- **Usado por profissionais** — OSCP, bug bounty, OSINT
- **Revela erros humanos** — gente que esqueceu arquivos sensíveis expostos

### Como funciona na prática?

```
Busca normal:  empresa.com
                → Resultados genéricos

Google Dork:   site:empresa.com filetype:pdf
                → Só PDFs do site da empresa

Google Dork:   site:empresa.com inurl:admin
                → Páginas com "admin" na URL

Google Dork:   site:empresa.com intitle:"index of"
                → Diretórios abertos no servidor
```

### O que você vai descobrir?

| Tipo de informação | Dork | Como usar |
|:---|:---|:---|
| Arquivos expostos | `filetype:pdf`, `filetype:xlsx` | Encontrar documentos internos |
| Painéis admin | `inurl:admin`, `inurl:login` | Encontrar portas de entrada |
| Diretórios abertos | `intitle:"index of"` | Acessar arquivos sem autenticação |
| Erros de servidor | `intext:"error"`, `intext:"warning"` | Encontrar falhas de configuração |
| Emails | `"@empresa.com"` | Coletar endereços para phishing |

---

## 🚀 Passo a Passo — Como fazer Google Dorking

Vamos aprender a usar o Google como ferramenta de reconhecimento.

### Passo 1: Operadores básicos

```bash
# Esses operadores funcionam direto no Google (não precisa de terminal)

# site: → Só resultados de um site específico
site:empresa.com

# filetype: → Só um tipo de arquivo
site:empresa.com filetype:pdf
site:empresa.com filetype:xlsx
site:empresa.com filetype:doc
site:empresa.com filetype:sql
site:empresa.com filetype:log

# inurl: → Texto deve estar na URL
site:empresa.com inurl:admin
site:empresa.com inurl:login
site:empresa.com inurl:upload

# intitle: → Texto deve estar no título
site:empresa.com intitle:"index of"
site:empresa.com intitle:"login"

# intext: → Texto deve estar no conteúdo
site:empresa.com intext:"password"
site:empresa.com intext:"error"
```

### Passo 2: Dorks para informações sensíveis

```bash
# Senhas e credenciais expostas
site:empresa.com filetype:env
site:empresa.com filetype:conf
site:empresa.com filetype:log "password"
site:empresa.com inurl:config intext:password

# Arquivos de banco de dados
site:empresa.com filetype:sql
site:empresa.com filetype:db
site:empresa.com filetype:bak

# Arquivos de configuração
site:empresa.com filetype:yml
site:empresa.com filetype:xml "password"
site:empresa.com filetype:ini

# Backups
site:empresa.com filetype:bak
site:empresa.com filetype:old
site:empresa.com filetype:backup
```

### Passo 3: Dorks para descobrir estrutura

```bash
# Diretórios abertos
site:empresa.com intitle:"index of"
site:empresa.com intitle:"index of" "parent directory"

# Subdomínios
site:*.empresa.com -www

# Tecnologias
site:empresa.com inurl:wp-admin    # WordPress
site:empresa.com inurl:phpmyadmin  # phpMyAdmin
site:empresa.com inurl:cpanel       # cPanel

# Areas internas
site:empresa.com inurl:portal
site:empresa.com inurl:intranet
site:empresa.com inurl:vpn
```

### Passo 4: Dorks para emails e pessoas

```bash
# Emails
"@empresa.com"
site:empresa.com "@empresa.com"

# Redes sociais
site:linkedin.com "empresa.com"
site:facebook.com "empresa.com"

# Documentos com nomes
site:empresa.com filetype:pdf "autor"
site:empresa.com filetype:pdf "confidencial"
```

### Resumo da ordem — Por que essa sequência?

```
PASSO 1: site: → Restringir ao alvo
├── POR QUE: Primeiro, delimite o escopo
├── O QUE PROCURAR: O site da empresa
├── QUANDO AVANÇAR: Quando souber o domínio exato
└── SE DER ERRADO: Se não retornar nada, tente sem "site:"

        ↓

PASSO 2: filetype: → Procurar arquivos expostos
├── POR QUE: Arquivos sensíveis são encontrados assim
├── O QUE PROCURAR: .sql, .env, .bak, .log, .conf
├── QUANDO AVANÇAR: Quando encontrar arquivos interessantes
└── SE DER ERRADO: Se não achar, tente outros formatos (.log, .txt)

        ↓

PASSO 3: inurl: e intitle: → Encontrar painéis e diretórios
├── POR QUE: Painéis admin são pontos de entrada
├── O QUE PROCURAR: /admin, /login, "index of"
├── QUANDO AVANÇAR: Quando encontrar URLs acessíveis
└── SE DER ERRADO: Se bloquear, pode ser WAF — tente outro dork

        ↓

PASSO 4: intext: → Procurar erros e credenciais
├── POR QUE: Erros revelam informações internas
├── O QUE PROCURAR: "password", "error", "warning"
├── QUANDO AVANÇAR: Quando tiver informações suficientes
└── SE DER ERRADO: Se muito resultado, adicione mais filtros
```

**Dica:** Salve seus dorks favoritos em um arquivo para reutilizar.

---

## Tool Card: Google Dorks Essenciais

### 🎯 Quando usar Google Dorking
Sempre no início do reconhecimento. Use quando:
- Precisar encontrar **arquivos sensíveis** expostos no Google
- Precisar descobrir **painéis administrativos** e áreas internas
- Precisar coletar **emails** de funcionários
- Quiser uma técnica **100% passiva** (não toca no alvo)

### 🛠️ Como o Google Dorking te ajuda
- **Arquivos** → PDFs, planilhas, backups com dados sensíveis
- **Painéis** → /admin, /login, phpMyAdmin, cPanel
- **Erros** → Mensagens de erro que revelam configurações
- **Estrutura** → Diretórios abertos, subdomínios, tecnologias

### ➡️ Depois de usar Google Dorking — Próximos passos
1. **Arquivos encontrados?** → Baixe e analise (podem ter senhas!)
2. **Painéis encontrados?** → Teste brute force com Hydra (Módulo 3)
3. **Emails encontrados?** → Use para phishing ou brute force
4. **Diretórios abertos?** → Navegue e procure por dados sensíveis
5. **Documente tudo** → Salve os URLs encontrados para referência futura

---

## Referências de Dorks

### Listas prontas
- [Google Hacking Database](https://www.exploit-db.com/google-hacking-database)
- [Pentest-Tools Google Dorks](https://pentest-tools.com/google-hacking)
- [SANS Google Dorks](https://www.sans.org/)

### Dorks por cenário

| Cenário | Dork |
|:--------|:-----|
| WordPress | `site:empresa.com inurl:wp-admin OR inurl:wp-login` |
| phpMyAdmin | `site:empresa.com inurl:phpmyadmin` |
| Backup exposto | `site:empresa.com filetype:bak OR filetype:old OR filetype:backup` |
| SQL dump | `site:empresa.com filetype:sql "dump"` |
| Configuração | `site:empresa.com filetype:yml OR filetype:xml "password"` |
| Erros | `site:empresa.com intext:"warning" OR intext:"error"` |
| Diretório aberto | `site:empresa.com intitle:"index of" "parent directory"` |

---

## Lab Prático

### Exercício 1: Google Dorks Básicos
- **Objetivo:** Encontre 5 arquivos expostos no site da empresa usando dorks
- **Dorks para testar:** `site:target.com filetype:pdf`, `site:target.com inurl:admin`
- **Tempo estimado:** 20 minutos

### Exercício 2: Encontrar Painéis Admin
- **Objetivo:** Descubra painéis administrativos escondidos
- **Dorks para testar:** `site:target.com inurl:login`, `site:target.com intitle:"admin"`
- **Tempo estimado:** 15 minutos

### Exercício 3: Coletar Emails
- **Objetivo:** Reúna uma lista de emails da empresa
- **Dorks para testar:** `"@target.com"`, `site:target.com "@target.com"`
- **Tempo estimado:** 10 minutos

### Exercício 4: Google Dorks no TryHackMe
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/googledorking
- **O que vai praticar:** Dorks avançados, enumeração de arquivos, descoberta de informações
- **Tempo estimado:** 30 minutos

### Dica de Estudo
> Crie um "kit de dorks" personalizado. Salve os dorks que mais funcionam em um arquivo. Com o tempo, você vai memorizar os mais úteis.
