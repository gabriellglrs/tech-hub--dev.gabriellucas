## FASE 7 — Relatório

**Tempo estimado:** 60-120 minutos
**Objetivo:** Documentar TUDO de forma que outra pessoa possa replicar e entender.
**Por quê:** O relatório é o ÚNICO entregável que o cliente/equipe vê. Se não está no relatório, não aconteceu.

---

### Passo 7.1 — Criar Estrutura do Relatório

```bash
cat > 07-relatorio/relatorio-recon.md << 'EOF'
# Relatório de Reconhecimento

| Campo | Valor |
|-------|-------|
| **Alvo** | evilcorp.com |
| **Data** | 10/09/2026 |
| **Autor** | [SEU NOME] |
| **Classificação** | CONFIDENCIAL |

---

## 1. Resumo Executivo

Durante o reconhecimento de evilcorp.com, foram identificadas 3 vulnerabilidades
de severidade crítica, 3 de severidade alta, e 3 de severidade média.
As principais descobertas incluem:

- **CRÍTICO:** S3 Bucket "evilcorp-backup" listável com dumps de banco de dados
- **CRÍTICO:** Subdomain Takeover em docs.evilcorp.com (CNAME para S3 não reclamado)
- **CRÍTICO:** Arquivo .env exposto com credenciais AWS
- **ALTO:** Plugin WordPress "wp-file-manager" vulnerable (CVE-2020-25213)
- **ALTO:** MySQL porta 3306 exposto à internet
- **ALTO:** wp-config.php.bak acessível sem autenticação

## 2. Escopo

- **Alcance:** *.evilcorp.com, IPs 104.21.33.0/24, 192.168.1.0/24
- **Exclusões:** Nenhum

## 3. Metodologia

| Fase | Ferramentas | Resultados |
|------|------------|------------|
| 1 - Inteligência Passiva | Subfinder, Amass, crt.sh, theHarvester | 47 subdomínios encontrados |
| 2 - Enumeração Ativa | httpx, Nmap, ncat | 12 subdomínios vivos, 8 ports abertos |
| 3 - Fingerprinting | WhatWeb, wafw00f, searchsploit | WordPress 5.7, Apache 2.4.41, sem WAF |
| 4 - Discovery | Gobuster, ffuf, Wayback | 15 diretórios, 342 URLs com parâmetros |
| 5 - Vulns | Nikto, Nuclei, WPScan, Subzy | 9 vulnerabilidades encontradas |
| 6 - Validação | Manual (curl, ncat) | 9 confirmadas, 0 falsos positivos |

## 4. Descobertas

### 4.1 Subdomínios (47 encontrados, 12 ativos)

| Subdomínio | Status | IP |
|------------|--------|-----|
| www.evilcorp.com | 200 OK | 104.21.33.15 |
| admin.evilcorp.com | 403 Forbidden | 104.21.33.16 |
| api.evilcorp.com | 200 OK | 104.21.33.17 |
| docs.evilcorp.com | 200 OK | (S3) |
| staging.evilcorp.com | 200 OK | 192.168.1.20 |

### 4.2 Ports e Serviços

| IP | Port | Serviço | Versão |
|----|------|---------|--------|
| 104.21.33.15 | 22 | SSH | OpenSSH 8.9p1 |
| 104.21.33.15 | 80 | HTTP | Apache 2.4.41 |
| 104.21.33.15 | 443 | HTTPS | Apache 2.4.41 |
| 104.21.33.15 | 3306 | MySQL | MySQL 5.7.42 |

### 4.3 Vulnerabilidades Web

#### [CRÍTICO] .env Expost
- **URL:** http://evilcorp.com/.env
- **Evidência:** Retorna variáveis de ambiente com AWS_ACCESS_KEY
- **Comando:** `curl -s http://evilcorp.com/.env`
- **Impacto:** Credenciais AWS expostas podem permitir acesso à infraestrutura cloud

#### [ALTO] wp-file-manager Vulnerável
- **Plugin:** wp-file-manager 6.9
- **CVE:** CVE-2020-25213
- **Evidência:** WPScan detectou versão vulnerável
- **Impacto:** Upload de arquivos arbitrários (RCE)

### 4.4 Subdomain Takeover

| Subdomínio | CNAME | Status |
|------------|-------|--------|
| docs.evilcorp.com | evilcorp.s3.amazonaws.com | VULNERABLE (NoSuchBucket) |
| staging.evilcorp.com | evilcorp-staging.herokuapp.com | VULNERABLE (Heroku Error Page) |

## 5. Recomendações

| # | Severidade | Recomendação |
|---|-----------|-------------|
| 1 | CRÍTICO | Remover .env da web imediatamente |
| 2 | CRÍTICO | Revogar credenciais AWS expostas |
| 3 | CRÍTICO | Reclamar/restringir subdomínio docs.evilcorp.com |
| 4 | ALTO | Atualizar plugin wp-file-manager para versão corrigida |
| 5 | ALTO | Restringir acesso MySQL à rede interna |
| 6 | ALTO | Remover wp-config.php.bak |
| 7 | MÉDIO | Adicionar headers de segurança (X-Frame-Options, CSP) |
| 8 | MÉDIO | Atualizar PHP para versão suportada |
| 9 | MÉDIO | Adicionar flags httponly e secure nos cookies |

## 6. Ferramentas Utilizadas

Subfinder, Amass, crt.sh, theHarvester, httpx, Nmap, ncat, WhatWeb, wafw00f,
searchsploit, Gobuster, ffuf, Waybackurls, Nikto, Nuclei, WPScan, Subzy, AWS CLI

## 7. Anexos

- Arquivos de output de cada ferramenta (01-intel/ a 05-vulns/)
EOF
```

---

### Checklist da Fase 7

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Relatório completo | `07-relatorio/relatorio-recon.md` | [ ] |
| 2 | Resumo executivo escrito | Seção 1 preenchida | [ ] |
| 3 | Todas as descobertas documentadas | Seção 4 preenchida | [ ] |
| 4 | Recomendações listadas | Seção 5 preenchida | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 7:

```
07-relatorio/
└── relatorio-recon.md    ← relatório completo e profissional
```

### ✅ Sinal de sucesso:
- O relatório tem **Resumo Executivo** que qualquer pessoa entende
- Cada vulnerabilidade tem: **nome, URL, evidência (comando+output), impacto, severidade**
- As **Recomendações** são específicas e acionáveis
- Outra pessoa consegue **replicar** o que você fez

**✅ Parabéns! Você completou o reconhecimento!**

---
