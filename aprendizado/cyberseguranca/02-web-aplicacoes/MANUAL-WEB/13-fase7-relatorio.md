## FASE 7 — Geração de Relatório

**Tempo estimado:** 30-45 minutos
**Objetivo:** Documentar TODAS as vulnerabilidades confirmadas em formato profissional para o cliente/equipe de desenvolvimento.
**Por quê:** O relatório é o ÚNICO entregável que o cliente vê. Um relatório ruim faz o cliente ignorar vulns críticas; um bom gera ação imediata.

> **📡 Herança:** tudo vem de `13-validacao/evidencias.md` e `13-validacao/findings-todos.txt` (Fase 6). Só entra no relatório o que foi **validado e reproduzível**.

---

### Passo 7.1 — Criar Estrutura do Relatório

```bash
mkdir -p 14-relatorio/final

cat > 14-relatorio/final/RELATORIO-SEGURANCA.md << 'ENDOFFILE'
# Relatório de Teste de Segurança Web

## Informações Gerais
- **Alvo:** https://evilcorp.com
- **Data do teste:** [DATA]
- **Tester:** [Seu Nome]
- **Escopo:** Aplicação web completa (evilcorp.com e subdomínios)
- **Ferramentas:** Burp Suite Community, SQLMap, Nuclei, Hydra, ffuf
- **Metodologia:** OWASP Testing Guide v4.2

## Resumo Executivo
[Preencher — Passo 7.2]

## Vulnerabilidades Encontradas
[Preencher — Passo 7.3]

## Detalhamento de Vulnerabilidades
[Preencher — Passo 7.4]

## Recomendações
[Preencher — Passo 7.5]

## Anexos
[Preencher — Passo 7.6]
ENDOFFILE
```

---

### Passo 7.2 — Preencher Resumo Executivo (sem jargão técnico)

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

### Passo 7.3 — Tabela de Vulnerabilidades

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

### Passo 7.4 — Detalhar Cada Vulnerabilidade

Para cada item de `13-validacao/evidencias.md`:

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
1' OR '1'='1--

**Evidência:**
- Request original: `GET /api/users?id=1` → retorna 1 usuário
- Request com payload: retorna 50+ usuários com dados sensíveis
- SQLMap confirmou: MySQL 5.7, database `targetdb`
- UNION SELECT permitiu extrair tabela `users` completa

**Impacto:**
- Leitura de dados sensíveis (usuários, senhas hashes, emails)
- Possível execução de comandos no servidor de banco
- Bypass de autenticação
- Potencial takeover completo do banco de dados

**Recomendação:**
- Usar prepared statements/parameterized queries
- Validação de entrada (whitelist de caracteres)
- Princípio do menor privilégio no banco
- WAF com regras de SQLi

**Referências:**
- OWASP: https://owasp.org/www-community/attacks/SQL_Injection
- CWE-89: https://cwe.mitre.org/data/definitions/89.html
- CVSS Calculator: https://www.first.org/cvss/calculator/3.1
```

---

### Passo 7.5 — Recomendações

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
3. Rate limiting em endpoints de login
4. Security code review em endpoints críticos

### Detectivas (Médio prazo — 3-6 meses)
1. Logging de segurança (SIEM)
2. Monitoramento de intrusão
3. Testes de segurança periódicos (trimestrais)
4. Bug bounty program
```

---

### Passo 7.6 — Adicionar Anexos

```markdown
## Anexos

### Anexo A: Screenshots de Evidência
- `evidence-sqli.png` — SQL Injection retornando múltiplos usuários
- `evidence-xss.png` — XSS alert funcionando
- `evidence-ssrf.png` — SSRF acessando cloud metadata

### Anexo B: Logs de Requisições
- `request-response-sqli.txt` — Request/Response completo da SQLi
- `request-response-xss.txt` — Request/Response completo do XSS

### Anexo C: Ferramentas Utilizadas
- Burp Suite Community 2025.x / SQLMap 1.8.x / Nuclei 3.x / Hydra 9.x / ffuf 2.x

### Anexo D: Metodologia
- OWASP Testing Guide v4.2 / PTES / NIST SP 800-115
```

---

### Passo 7.7 — Salvar Relatório Final

```bash
# Copiar evidências
cp 13-validacao/evidencias.md 14-relatorio/final/ 2>/dev/null
cp 13-validacao/*.txt 14-relatorio/final/ 2>/dev/null
cp *.png 14-relatorio/final/ 2>/dev/null

ls -la 14-relatorio/final/
```

---

### Checklist da Fase 7

| # | Item | ☑ |
|---|------|:---:|
| 1 | Informações gerais preenchidas | [ ] |
| 2 | Resumo executivo escrito (sem jargão) | [ ] |
| 3 | Tabela de vulnerabilidades criada | [ ] |
| 4 | Cada vulnerabilidade detalhada (payload, evidência, impacto, fix) | [ ] |
| 5 | Recomendações corretivas/preventivas/detectivas | [ ] |
| 6 | Anexos incluídos (screenshots, logs, ferramentas) | [ ] |
| 7 | Relatório revisado e formatado | [ ] |

### ✅ Sinal de sucesso:
- Relatório completo e profissional
- TODAS as vulns documentadas com evidências e CVSS
- Recomendações claras e acionáveis
- Resumo executivo compreensível para não-técnicos

### ❌ Se falhou:
- Falta evidência → capture screenshots adicionais
- Severidade duvidosa → recalcule no CVSS calculator
- Recomendações vagas → seja específico sobre correções

### 🔗 O que este arquivo entrega ao cliente:
| Seção | Para quem | Impacto |
|-------|-----------|---------|
| Resumo Executivo | Gerentes/Executivos | Decisão de investimento em segurança |
| Detalhamento | Desenvolvedores | Onde e como corrigir |
| Recomendações | Equipe de segurança | Plano de ação |

**Parabéns! Você completou o teste de segurança web.**

---

## Próximos Passos
→ Revisar [18 — Troubleshooting](18-troubleshooting.md) para problemas comuns
→ Consultar [19 — Referência Rápida](19-referencia-rapida.md) para payloads
→ Ver [20 — Não Funcionou?](20-nao-funcionou.md) para critérios de parada
→ De volta ao fluxo: [MANUAL-EXPLOR — Visão Geral](../../03-exploracao/MANUAL-EXPLOR/14-visao-geral.md)
