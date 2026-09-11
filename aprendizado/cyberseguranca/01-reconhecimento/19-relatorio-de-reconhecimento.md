# 📝 19. Relatório de Reconhecimento — Documentando Descobertas

> Um scan sem relatório é como uma investigação sem prova. Saiba como documentar cada descoberta para uso futuro, apresentação ao cliente, ou como evidência.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 30min | ⭐⭐ Intermediário | `markdown, nano` |

</div>

---

## 🎓 Por que isso importa?

Em pentest profissional, o relatório é o **único entregável** que o cliente vê. Um bom relatório:

- **Justifica o valor** do teste
- **Prioriza riscos** para a organização
- **Evidencia o trabalho** feito
- **Permite replicação** dos achados
- **Protege legalmente** o pentester

Mesmo em CTFs e Bug Bounty, documentar facilita:
- Não re-fazer trabalho já feito
- Compartilhar achados com a comunidade
- Construir portfólio

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Markdown | Sim | Qualquer editor de texto |
| Ferramentas de recon | Sim | Arquivos 01-18 deste módulo |

---

## 🎯 Quando Usar Relatórios

- **Sempre.** Cada scan deve gerar algum tipo de documentação
- Antes de reportar bug em Bug Bounty
- Para entregar ao cliente em pentest
- Para seu próprio portfólio/histórico

---

## 📐 Estrutura de um Relatório de Reconhecimento

### Seção 1: Cabeçalho

```markdown
# Relatório de Reconhecimento
## Alvo: evilcorp.com
## Data: 2026-09-10
## Autor: Seu Nome
## Classificação: CONFIDENCIAL
```

### Seção 2: Escopo

```markdown
## Escopo
- **Domínio principal:** evilcorp.com
- **Subdomínios descobertos:** 47
- **Alcance:** Apenas passive recon + active web scanning
- **Exclusões:** Sem exploração, sem brute force de senhas
- **Autorização:** Contrato #12345 assinado em DD/MM/AAAA
```

### Seção 3: Resumo Executivo

```markdown
## Resumo Executivo

O reconhecimento revelou:
- 47 subdomínios ativos
- 12 servidores web com versões desatualizadas
- 3 plugins WordPress vulneráveis
- 2 buckets S3 com acesso anônimo
- 1 WAF Cloudflare (com bypass possível via subdomínio staging)

**Risco geral: ALTO** — Múltiplos vetores de entrada identificados.
```

### Seção 4: Metodologia

```markdown
## Metodologia

| Fase | Ferramentas | Resultados |
|------|------------|------------|
| DNS Enum | Subfinder, Amass | 47 subdomínios |
| Fingerprinting | WhatWeb, httpx | 12 servidores web |
| Port Scan | Nmap, Masscan | 156 ports abertos |
| Discovery | Gobuster, ffuf | 234 caminhos encontrados |
| WAF Detection | Wafw00f | Cloudflare detectado |
| Web Vulns | Nikto, WPScan | 8 vulnerabilidades |
| Cloud | aws CLI | 2 buckets S3 |
| Certificados | crt.sh | 15 subdomínios extras |
```

### Seção 5: Descobertas Detalhadas

```markdown
## Descobertas

### D1: Subdomínios Descobertos (47)

| # | Subdomínio | IP | Status | Observações |
|---|-----------|-----|--------|-------------|
| 1 | admin.evilcorp.com | 192.168.1.10 | 200 OK | Painel admin (WordPress) |
| 2 | staging.evilcorp.com | 192.168.1.11 | 200 OK | Sem autenticação! |
| 3 | api.evilcorp.com | 192.168.1.12 | 200 OK | API REST exposta |
| 4 | dev.evilcorp.com | 192.168.1.13 | 302 | Redirect para login |
| 5 | mail.evilcorp.com | 192.168.1.14 | 200 OK | Webmail Roundcube |
| ... | ... | ... | ... | ... |

### D2: Vulnerabilidades Web

| # | Severidade | Host | Vulnerabilidade | CVE |
|---|-----------|------|----------------|-----|
| 1 | CRÍTICA | staging.evilcorp.com | Admin panel sem autenticação | - |
| 2 | ALTA | admin.evilcorp.com | WordPress 5.7 (insecure) | CVE-2021-XXXXX |
| 3 | ALTA | admin.evilcorp.com | Plugin vuln (Contact Form 7) | CVE-2024-XXXXX |
| 4 | MÉDIA | api.evilcorp.com | API versionamento exposto | - |
| 5 | MÉDIA | dev.evilcorp.com | Debug mode ativado | - |

### D3: Cloud Storage

| # | Bucket | Tipo | Status | Conteúdo |
|---|--------|------|--------|----------|
| 1 | evilcorp-backups | S3 | Acessível (200) | SQL dumps, configs |
| 2 | evilcorp-assets | S3 | Listável (200) | Imagens, PDFs |
```

### Seção 6: Fluxo de Reconhecimento

```markdown
## Fluxo de Reconhecimento Executado

```
1. DNS Enumeration
   Subfinder + Amass → 47 subdomínios
          ↓
2. Fingerprinting
   WhatWeb + httpx → 12 servidores web identificados
          ↓
3. Port Scanning
   Nmap -sV → 156 ports abertos
          ↓
4. Content Discovery
   Gobuster + ffuf → 234 caminhos
          ↓
5. WAF Detection
   Wafw00f → Cloudflare (bypass via staging)
          ↓
6. Vulnerability Scanning
   Nikto + WPScan → 8 vulnerabilidades
          ↓
7. Cloud Enumeration
   aws CLI → 2 buckets S3
```
```

### Seção 7: Recomendações

```markdown
## Recomendações

| # | Prioridade | Recomendação |
|---|-----------|-------------|
| 1 | URGENTE | Remover acesso anônimo ao bucket S3 evilcorp-backups |
| 2 | URGENTE | Proteger staging.evilcorp.com com autenticação |
| 3 | ALTA | Atualizar WordPress de 5.7 para versão mais recente |
| 4 | ALTA | Atualizar plugin Contact Form 7 |
| 5 | MÉDIA | Desativar debug mode em dev.evilcorp.com |
| 6 | MÉDIA | Implementar versionamento de API com autenticação |
```

### Seção 8: Ferramentas Utilizadas

```markdown
## Ferramentas Utilizadas

| Ferramenta | Versão | Uso |
|-----------|--------|-----|
| Subfinder | 2.6.x | Subdomain enumeration |
| Amass | 4.x | Deep subdomain enum |
| WhatWeb | 0.6.4 | Web fingerprinting |
| httpx | 1.x | HTTP probing |
| Nmap | 7.95 | Port scanning |
| Gobuster | 3.8 | Directory discovery |
| ffuf | 2.1 | Fuzzing |
| Wafw00f | 2.4.2 | WAF detection |
| Nikto | 2.5 | Web vulnerability scan |
| WPScan | 3.x | WordPress scan |
| aws CLI | 2.x | Cloud enumeration |
```

### Seção 9: Anexos

```markdown
## Anexos

- Anexo A: Lista completa de subdomínios (arquivo anexo)
- Anexo B: Resultado completo do Nmap
- Anexo C: Resultado do WhatWeb
- Anexo D: Logs dos scans
```

---

## 📄 Template Markdown Pronto

```markdown
# RELATÓRIO DE RECONHECIMENTO

| Campo | Valor |
|-------|-------|
| **Alvo** | [DOMÍNIO] |
| **Data** | [DATA] |
| **Autor** | [NOME] |
| **Classificação** | CONFIDENCIAL |

---

## 1. Resumo Executivo

[2-3 parágrafos com os achados mais importantes]

## 2. Escopo

- **Alcance:** [descrever]
- **Exclusões:** [descrever]
- **Autorização:** [referência]

## 3. Metodologia

| Fase | Ferramentas | Resultados |
|------|------------|------------|
| DNS | ... | ... |

## 4. Descobertas

### 4.1 [Categoria]
[tabela com achados]

## 5. Recomendações

| # | Prioridade | Recomendação |
|---|-----------|-------------|
| 1 | ... | ... |

## 6. Ferramentas

| Ferramenta | Versão | Uso |
|-----------|--------|-----|

## 7. Anexos

- [lista]
```

---

## 🛠️ Dicas de Escrita

### Seja Específico

**Ruim:** "Encontrei vulnerabilidades."
**Bom:** "Encontrei 3 plugins WordPress com CVEs conhecidas: Contact Form 7 (CVE-2024-1234), Yoast SEO (CVE-2024-5678), e Elementor (CVE-2024-9012)."

### Priorize por Risco

**CRÍTICA** → Acesso direto, dados expostos, autenticação bypass
**ALTA** → Configurações incorretas, versões vulns
**MÉDIA** → Informação exposta, configurações subótimas
**BAIXA** → Melhorias de segurança, hardening

### Inuaia Evidências

```markdown
**Evidência:**
```bash
# Comando executado
wpscan --url http://admin.evilcorp.com -e vp

# Output
[!] plugin-name: 1.0 - SQL Injection (CVE-2024-1234)
```
```

### Não Inuaia Dados Sensíveis

Nunca colube senhas, tokens, ou dados PII no relatório. Use placeholder:

```markdown
**Bucket acessível:** s3://evilcorp-backups
**Status:** 200 OK (acesso anônimo confirmado)
**Conteúdo identificado:** backup_2026-01.sql (50MB)
```

---

## 📊 Ferramentas Úteis para Relatórios

| Ferramenta | Uso | Output |
|-----------|-----|--------|
| `markdown` | Escrever relatório | .md |
| `pandoc` | Converter para PDF/DOCX | .pdf, .docx |
| `csvtool` | Organizar tabelas | .csv |
| `sqlite3` | Banco de dados de achados | .db |
| `git` | Versionar relatório | .git |

**Converter Markdown para PDF:**
```bash
# Instalar pandoc
sudo apt install pandoc texlive-xetex

# Converter
pandoc relatorio.md -o relatorio.pdf
```

---

## ⚠️ Erros Comuns

| Erro | Solução |
|------|---------|
| Relatório genérico demais | Seja específico: versões, CVEs, IPs |
| Sem evidências | Sempre inclua comandos e outputs |
| Sem priorização | Use CRÍTICA/ALTA/MÉDIA/BAIXA |
| Dados sensíveis no relatório | Use placeholders |
| Relatório sem estrutura | Siga o template acima |

---

## 🎯 Cheat Sheet Rápido

```bash
# Criar relatório
nano relatorio-evilcorp-2026.md

# Converter para PDF
pandoc relatorio-evilcorp-2026.md -o relatorio-evilcorp-2026.pdf

# Versionar
git add relatorio-evilcorp-2026.md
git commit -m "Add recon report for evilcorp.com"
```

---

## 📚 Referências

- [OWASP Reporting Structure](https://owasp.org/www-project-web-security-testing-guide/latest/5-Reporting/01-Reporting_Structure)
- [PTES Reporting Guidelines](http://www.pentest-standard.org/index.php/Reporting)
- [SANS Writing a Penetration Testing Report](https://www.sans.org/white-papers/33343)
- [Template de Relatório (GitHub)](https://github.com/Amahdavi-cybersecurity/pen-testing-report-template)

---

**Este é o último arquivo do módulo!**

**Anterior:** [18. OPSEC e Anonimato](18-opsec-e-anonimato.md)

---

## 🎉 Parabéns!

Você completou o módulo de Reconhecimento! Agora você tem ferramentas para:

1. **DNS Enum** → Subfinder, Amass, dig, dnsrecon
2. **OSINT** → theHarvester, Sherlock, Maltego, Recon-ng
3. **Fingerprinting** → WhatWeb, Wappalyzer, httpx
4. **Port Scanning** → Nmap, Masscan
5. **Content Discovery** → Gobuster, ffuf
6. **WAF Detection** → Wafw00f
7. **Web Scanning** → Nikto, WPScan
8. **Banner Grabbing** → Netcat/Ncat, curl
9. **Subdomain Takeover** → Subzy, Nuclei
10. **Cloud Enum** → aws CLI, cloud_enum
11. **OPSEC** → ProxyChains, Tor
12. **Relatório** → Documentação profissional

**Próximo módulo:** [02 - Web Applications](../02-web-aplicacoes/README.md)
