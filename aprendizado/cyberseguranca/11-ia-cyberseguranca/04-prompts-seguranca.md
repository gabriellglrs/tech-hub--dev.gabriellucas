# Biblioteca de Prompts para Segurança

> Prompts prontos para usar com IA em tarefas de segurança.

---

## Prompts para Reconhecimento

### Enumeração de Subdomínios
```
Analise estes subdomínios encontrados e classifique por risco:
- Subdomínios com painéis de administração: CRÍTICO
- Subdomínios com APIs expostas: ALTO
- Subdomínios com serviços internos: MÉDIO
- Subdomínios estáticos: BAIXO

$(cat subdomains.txt)
```

### Análise de Resultados Nmap
```
Analise este resultado de Nmap e identifique:
1. Serviços vulneráveis (versão desatualizada)
2. Vetores de ataque possíveis
3. Prioridade de exploração (CRÍTICO > ALTO > MÉDIO > BAIXO)
4. Próximos passos recomendados

$(cat nmap_scan.txt)
```

### Análise de Shodan
```
Com base nestes resultados do Shodan, identifique:
1. Dispositivos com vulnerabilidades conhecidas
2. Serviços com credenciais padrão
3. Sistemas industrial (ICS/SCADA) expostos
4. Risco geral da organização

$(cat shodan_results.txt)
```

---

## Prompts para Web Testing

### SQL Injection
```
Gere payloads de SQL Injection para:
1. Bypass de autenticação (login form)
2. Union-based (parâmetro de busca)
3. Blind SQLi (parâmetro numérico)
4. Time-based (fallback)

Inclua bypass de WAF comuns (ASP.NET, Cloudflare, ModSecurity).
Formato: payload + explicação de quando usar.
```

### XSS
```
Gere payloads de XSS para:
1. Stored XSS (campo de comentário)
2. Reflected XSS (parâmetro de URL)
3. DOM-based XSS (fragmento #)
4. Bypass de CSP com JSONP

Inclua payloads que bypassam:
- Filtros de <script>
- Event handlers básicos
- Content Security Policy
```

### SSRF
```
Gere payloads de SSRF para:
1. Acesso a serviços internos (127.0.0.1)
2. Leitura de arquivos (file://)
3. Cloud metadata (169.254.169.254)
4. Bypass de filtro de IP

Inclua bypass de:
- Filtros de IP privado
- DNS rebinding
- Protocolo alternativo (gopher://)
```

---

## Prompts para Privilege Escalation

### Linux Privesc
```
Com base neste output do LinPEAS, sugira vetores de escalação de privilégio:

$(cat linpeas_output.txt)

Para cada vetor, forneça:
1. Comando exato para explorar
2. Requisitos (o que precisa ter)
3. Risco de detecção
4. Probabilidade de sucesso
```

### Windows Privesc
```
Com base neste output do WinPEAS, identifique oportunidades de escalação:

$(cat winpeas_output.txt)

Foque em:
1. Service misconfigurations
2. Unquoted service paths
3. AlwaysInstallElevated
4. Token impersonation
5. Stored credentials
```

---

## Prompts para Report Writing

### Resumo Executivo
```
Gere um resumo executivo para relatório de pentest com estes findings:

$(cat findings.txt)

O resumo deve conter:
1. Visão geral (1 parágrafo)
2. Nível de risco geral (CRÍTICO/ALTO/MÉDIO/BAIXO)
3. Principais vulnerabilidades (top 3)
4. Impacto nos negócios
5. Recomendações prioritárias
```

### Relatório Técnico
```
Gere a seção técnica deste achado para relatório de pentest:

Vulnerabilidade: [nome]
Severidade: [HIGH/MEDIUM/LOW]
Categoria: [OWASP Top 10]

Descrição técnica detalhada
Passos para reproduzir
PoC (Proof of Concept)
Impacto
Recomendação de correção
Referências (CVE, OWASP)
```

---

## Dicas de Uso

1. **Seja específico** — Quanto mais contexto, melhor a resposta
2. **Forneça exemplos** — Mostre o formato desejado
3. **Itere** — Se a resposta não for boa, refine o prompt
4. **Valide** — Sempre teste os payloads gerados em ambiente controlado
5. **Documente** — Salve prompts úteis para reutilizar
