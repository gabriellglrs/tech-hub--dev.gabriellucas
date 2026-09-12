# Fase 12: Geração de Relatório

**Tempo estimado:** 30-45 minutos
**Objetivo:** Documentar TODAS as vulnerabilidades confirmadas em formato profissional para apresentação ao cliente ou equipe de desenvolvimento.
**Por quê:** O relatório é o ÚNICO entregável que o cliente vê. Um relatório ruim pode fazer o cliente ignorar vulnerabilidades críticas. Um relatório bom gera ação imediata.

---

### Passo 12.1 — Criar Estrutura do Relatório

**O que você vai fazer:** Criar o arquivo de relatório com a estrutura padrão.

```bash
cat > relatorio/final/RELATORIO-SEGURANCA.md << 'ENDOFFILE'
# Relatório de Teste de Segurança Web

## Informações Gerais
- **Alvo:** https://target.com
- **Data do teste:** 2026-09-12
- **Tester:** [Seu Nome]
- **Escopo:** Aplicação web completa (target.com e subdomínios)
- **Ferramentas:** Burp Suite Community, SQLMap, Nuclei, Hydra, ffuf
- **Metodologia:** OWASP Testing Guide v4.2

## Resumo Executivo
[Podem ser preenchidos depois — ver Passo 10.2]

## Vulnerabilidades Encontradas
[Podem ser preenchidos depois — ver Passo 10.3]

## Detalhamento de Vulnerabilidades
[Podem ser preenchidos depois — ver Passo 10.4]

## Recomendações
[Podem ser preenchidos depois — ver Passo 10.5]

## Anexos
[Podem ser preenchidos depois — ver Passo 10.6]
ENDOFFILE
```

---

### Passo 12.2 — Preencher Resumo Executivo

**O que você vai fazer:** Escrever um resumo para executivos que não entendem de técnica.

```markdown
## Resumo Executivo

O teste de segurança revelou **X vulnerabilidades** na aplicação web, incluindo
**X vulnerabilidades de severidade crítica e alta**. As principais vulnerabilidades
encontradas permitem:

1. **Execução remota de comandos** via Command Injection e SQL Injection
2. **Acesso não autorizado** via bypass de autenticação e IDOR
3. **Exposição de dados sensíveis** via SSRF e XXE
4. **Manipulação de transações** via race conditions

**Risco geral da aplicação: ALTO**

Recomendação: correção imediata das vulnerabilidades críticas e altas antes
de qualquer novo deploy em produção.
```

---

### Passo 12.3 — Criar Tabela de Vulnerabilidades

```markdown
## Vulnerabilidades Encontradas

| # | Vulnerabilidade | Severidade | Endpoint | Status |
|---|-----------------|------------|----------|--------|
| 1 | SQL Injection | Crítica | GET /api/users?id= | Confirmado |
| 2 | Command Injection | Crítica | GET /api/ping?host= | Confirmado |
| 3 | SSRF | Alta | GET /api/fetch?url= | Confirmado |
| 4 | XSS Reflected | Média | GET /search?q= | Confirmado |
| 5 | IDOR | Média | GET /api/orders/{id} | Confirmado |
| 6 | Clickjacking | Baixa | GET / | Confirmado |
```

---

### Passo 12.4 — Detalhar Cada Vulnerabilidade

Para cada vulnerabilidade da Fase 11, crie uma seção completa:

```markdown
### 1. SQL Injection (Crítica)

**CVSS:** 8.6 (High)
**Endpoint:** GET /api/users?id=
**Parâmetro:** id

**Descrição:**
O parâmetro `id` aceita input do usuário sem sanitização, permitindo injeção
de código SQL. Um atacante pode manipular queries para ler, modificar ou
deletar dados do banco de dados.

**Payload Utilizado:**
```
1' OR '1'='1--
```

**Evidência:**
- Request original: `GET /api/users?id=1` → retorna 1 usuário
- Request com payload: retorna 50+ usuários com dados sensíveis
- SQLMap confirmou: MySQL 5.7, database `targetdb`
- UNION SELECT permitiu extrair tabela `users` completa

**Impacto:**
- Leitura de dados sensíveis (usuários, senhas hashes, emails)
- Possível execução de comandos no servidor de banco de dados
- Bypass de autenticação
- Potencial takeover completo do banco de dados

**Recomendação:**
- Usar prepared statements/parameterized queries
- Implementar validação de entrada (whitelist de caracteres)
- Aplicar princípio do menor privilege no banco de dados
- Implementar WAF com regras de SQLi

**Referências:**
- OWASP: https://owasp.org/www-community/attacks/SQL_Injection
- CWE-89: https://cwe.mitre.org/data/definitions/89.html
- CVSS Calculator: https://www.first.org/cvss/calculator/3.1
```

---

### Passo 12.5 — Escrever Recomendações

```markdown
## Recomendações

### Corretivas (Imediato — próxima sprint)
1. Corrigir SQL Injection em `/api/users?id=` com prepared statements
2. Corrigir XSS em `/search?q=` com sanitização de output
3. Implementar CSRF tokens em todas as ações state-changing
4. Corrigir SSRF com whitelist de URLs permitidas

### Preventivas (Curto prazo — 1-3 meses)
1. Implementar WAF (Web Application Firewall)
2. Adicionar headers de segurança (CSP, X-Frame-Options, HSTS)
3. Implementar rate limiting em endpoints de login
4. Conduct security code review em endpoints críticos

### Detectivas (Médio prazo — 3-6 meses)
1. Implementar logging de segurança (SIEM)
2. Configurar monitoramento de intrusão
3. Realizar testes de segurança periódicos (trimestrais)
4. Implementar bug bounty program
```

---

### Passo 12.6 — Adicionar Anexos

```markdown
## Anexos

### Anexo A: Screenshots de Evidência
- `evidence-sqli.png` — SQL Injection retornando múltiplos usuários
- `evidence-xss.png` — XSS alert funcionando
- `evidence-ssrf.png` — SSRF acessando cloud metadata

### Anexo B: Logs de Requisições
- `request-response-sqli.txt` — Request/Response completo da SQLi
- `request-response-xss.txt` — Request/Response completo do XSS
- `request-response-ssrf.txt` — Request/Response completo do SSRF

### Anexo C: Ferramentas Utilizadas
- Burp Suite Community 2025.x
- SQLMap 1.8.x
- Nuclei 3.x
- Hydra 9.x
- ffuf 2.x

### Anexo D: Metodologia
- OWASP Testing Guide v4.2
- PTES (Penetration Testing Execution Standard)
- NIST SP 800-115
```

---

### Passo 12.7 — Salvar Relatório Final

```bash
mkdir -p relatorio/final

# Copiar evidências
cp relatorio/evidencias.md relatorio/final/ 2>/dev/null
cp relatorio/*.txt relatorio/final/ 2>/dev/null
cp relatorio/*.png relatorio/final/ 2>/dev/null

# Verificar estrutura
ls -la relatorio/final/
```

---

## Checklist do Relatório

| # | Item | Status | ☑ |
|---|------|--------|:---:|
| 1 | Informações gerais preenchidas | — | [ ] |
| 2 | Resumo executivo escrito (sem jargão técnico) | — | [ ] |
| 3 | Tabela de vulnerabilidades criada | — | [ ] |
| 4 | Cada vulnerabilidade detalhada | — | [ ] |
| 5 | Recomendações claras e acionáveis | — | [ ] |
| 6 | Anexos incluídos | — | [ ] |
| 7 | Relatório revisado e formatado | — | [ ] |

### ✅ Sinal de sucesso:
- Relatório completo e profissional
- TODAS as vulnerabilidades documentadas com evidências
- Recomendações claras e acionáveis
- Resumo executivo compreensível para não-técnicos

### ❌ Se falhou:
- Se falta evidência → capture screenshots adicionais
- Se severidade é duvidosa → recalcule com CVSS calculator
- Se recomendações são vagas → seja específico sobre correções

### 🔗 O que este arquivo entrega ao cliente:
| Seção | Para quem | Impacto |
|-------|-----------|---------|
| Resumo Executivo | Gerentes/Executivos | Decisão de investimento em segurança |
| Detalhamento | Desenvolvedores | Onde e como corrigir |
| Recomendações | Equipe de segurança | Plano de ação |

**Parabéns! Você completou o teste de segurança web.**

---

## Próximos Passos
→ Revisar `A-troubleshooting.md` para problemas comuns
→ Consultar `B-referencia-rapida.md` para payloads
→ Ver `C-quando-parar.md` para critérios de parada

---
