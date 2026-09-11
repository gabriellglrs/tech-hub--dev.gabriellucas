## FASE 6 — Análise e Validação

**Tempo estimado:** 30-60 minutos
**Objetivo:** Confirmar cada achado, eliminar falsos positivos, organizar tudo por severidade.
**Por quê:** Scanner gera muitos falsos positivos. Você precisa CONFIRMAR cada achado antes de reportar. Um falso positivo no relatório destrói sua credibilidade.

---

### Passo 6.1 — Validação Manual

Para CADA achado das fases anteriores, faça o seguinte:

| Tipo de Achado | Como Validar | Comando de Validação |
|----------------|-------------|---------------------|
| Subdomínio vivo | Acessar no navegador | `curl -I http://sub.evilcorp.com` |
| Diretório encontrado | Acessar no navegador | `curl -I http://evilcorp.com/admin` |
| Versão de serviço | Ler banner | `ncat -v evilcorp.com 22` |
| WAF detectado | Verificar headers | `curl -I http://evilcorp.com` |
| Vulnerabilidade Nikto | Acessar caminho | `curl -I http://evilcorp.com/phpmyadmin` |
| Vulnerabilidade Nuclei | Seguir instruções do output | N/A |
| WordPress vuln | Verificar versão | `curl -s http://evilcorp.com | grep "generator"` |
| S3 Bucket | Tentar listar | `aws s3 ls s3://bucket --no-sign-request` |
| CNAME takeover | Confirmar erro | `curl -I http://docs.evilcorp.com` |

**✅ Output esperado de validação de um 403 (exemplo real):**
```bash
# Admin retorna 403 — é vulnerabilidade?
curl -I http://evilcorp.com/admin
# Resposta: HTTP/1.1 403 Forbidden

# Testar com X-Forwarded-For (bypass)
curl -H "X-Forwarded-For: 127.0.0.1" http://evilcorp.com/admin
# Resposta: HTTP/1.1 403 Forbidden (não funcionou)

# Testar com POST
curl -X POST http://evilcorp.com/admin
# Resposta: HTTP/1.1 403 Forbidden (não funcionou)

# CONCLUSÃO: 403 é proteção real. NÃO é vulnerabilidade.
```

**Crie um arquivo de validação:**
```bash
echo "# Validação de Achados - $(date)" > 06-validacao/validacao.md
echo "" >> 06-validacao/validacao.md
echo "## Achados Confirmados" >> 06-validacao/validacao.md
echo "- [ ] Achado 1: [descrever]" >> 06-validacao/validacao.md
echo "- [ ] Achado 2: [descrever]" >> 06-validacao/validacao.md
```

---

### Passo 6.2 — Eliminar Falsos Positivos

**Regras para eliminar falsos positivos:**

| Regra | Exemplo | É vulnerabilidade? |
|-------|---------|:---:|
| Status 403 | `/admin` retorna 403 | ❌ Não (proteção normal) |
| Nikto genérico | `/icons/README` existe | ❌ Não (arquivo padrão Apache) |
| Nuclei "info" | Header ausente | ❌ Não (configuração padrão) |
| Versão antiga sem CVE | Apache 2.4.41 sem CVE público | ❌ Não |
| CNAME para serviço externo | `blog.evilcorp.com` → WordPress.com | ❌ Não (serviço reclamado) |
| `.env` exposto | `http://evilcorp.com/.env` retorna 200 | ✅ SIM ⭐⭐⭐ |
| `config.bak` exposto | Acessível sem auth | ✅ SIM ⭐⭐⭐ |
| Plugin WordPress vulnerável | `wp-file-manager` versão antiga | ✅ SIM ⭐⭐ |
| Subzy VULNERABLE | Subdomínio não reclamado | ✅ SIM ⭐⭐⭐ |
| S3 Bucket listável | `aws s3 ls` retorna conteúdo | ✅ SIM ⭐⭐⭐ |
| mysql exposto à internet | Porta 3306 aberta externamente | ✅ SIM ⭐⭐ |

**❌ Se um achado NÃO for vulnerabilidade, REMOVA do relatório.**

---

### Passo 6.3 — Organizar por Severidade

```bash
cat > 06-validacao/resumo-severidade.md << 'EOF'
# Resumo de Severidade

## CRÍTICO
- S3 Bucket "evilcorp-backup" listável com dumps de banco
- Subdomain Takeover em docs.evilcorp.com
- .env exposto com credenciais AWS

## ALTO
- wp-file-manager plugin vulnerable (CVE-2020-25213)
- MySQL 3306 exposto à internet
- wp-config.php.bak acessível

## MÉDIO
- Headers de segurança ausentes (X-Frame-Options, CSP)
- PHP 7.4.3 com versão desatualizada
- Cookie PHPSESSID sem httponly

## BAIXO
- Apache 2.4.41 com versão desatualizada
- phpinfo.php exposto

## INFORMATIVO
- WordPress 5.7 detectado
- Certificado Let's Encrypt
- Uso de Cloudflare CDN
EOF
```

---

### Checklist da Fase 6

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Todos os achados validados | `06-validacao/validacao.md` | [ ] |
| 2 | Falsos positivos eliminados | Revisado | [ ] |
| 3 | Achados organizados por severidade | `06-validacao/resumo-severidade.md` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 6:

```
06-validacao/
├── validacao.md              ← lista de cada achado com status (confirmado/eliminado)
└── resumo-severidade.md      ← vulnerabilidades organizadas por severidade
```

### ✅ Sinal de sucesso:
- Cada vulnerabilidade em `resumo-severidade.md` tem: **nome, URL, evidência, impacto**
- Você **confirmou manualmente** cada achado (com curl, ncat, navegador)
- Você **eliminou falsos positivos** (Nikto genérico, 403, etc)
- Sabe exatamente o que vai escrever no relatório

### ❌ Se falhou:
- Se não encontrou NENHUMA vulnerabilidade: documente "Alvo sem vulnerabilidades encontradas" no relatório
- Foque em vulnerabilidades de **configuração** que sempre existem:
  - Headers ausentes
  - Versões antigas
  - Serviços expostos

**Se completou tudo → Avance para Fase 7**

---
