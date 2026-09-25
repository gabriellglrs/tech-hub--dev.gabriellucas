# Apêndice C — O que Fazer se NADA Funcionar

Às vezes, TUDO dá errado. Aqui está o que fazer em cada cenário:

### Cenário 1: "Burp não intercepta nada"
```bash
# 1. Intercept ON? (botão azul em Proxy → Intercept)
# 2. Browser usa o proxy? (127.0.0.1:8080)
# 3. Alvo está no Scope? (Target → Scope → Add)
# 4. Teste: curl -x http://127.0.0.1:8080 https://evilcorp.com -k
# 5. Erro SSL → reinstale o CA cert (18-troubleshooting.md)
```

### Cenário 2: "ffuf retorna 404 para tudo"
```bash
# 1. A URL está certa? Teste um caminho que EXISTE:
ffuf -u https://evilcorp.com/FUZZ -w small.txt -mc all
# 2. SPA (React/Vue)? As rotas são só no JS → foque em API discovery (Passo 2.7)
# 3. WAF bloqueou? -t 2 -p 2 e wordlist menor
# 4. Confirme com curl: curl -I https://evilcorp.com/robots.txt
```

### Cenário 3: "Nenhuma injeção funciona (SQLi/NoSQLi/SSTI/CMDi)"
```bash
# 1. Você testou parâmetros SUFICIENTES? (mínimo: 5 da Fase 2)
# 2. O WAF está engolindo payloads? Veja a resposta (403 vs 400 vs 200 igual)
#    → encoding: %27 para ' , %3B para ;
# 3. Confirme que o parâmetro chega ao backend:
#    altere o valor e veja se a resposta MUDA
# 4. Teste no lab primeiro (SQLi: portswigger lab) para validar seu fluxo
# 5. Alvo pode ser seguro aqui → DOCUMENTE e avance (não pare a fase)
```

### Cenário 4: "XSS não reflete / não executa"
```bash
# 1. O input volta em QUAL parte do HTML? (view-source: procure o valor)
# 2. Está com entity encoding (&lt;)? → tente outros contextos (attribute, JS, URL)
# 3. CSP bloqueia? curl -sI https://alvo | grep -i content-security-policy
#    → se tem CSP, teste DOM XSS (não depende de inline script)
# 4. WAF bloqueia tag? → payloads de 19-referencia-rapida.md (event handlers)
```

### Cenário 5: "SQLMap diz not injectable"
```bash
# 1. Teste manualmente ANTES (Passo 3A.1) — se manual não mostra nada, sqlmap também não
# 2. suba nível: --level=5 --risk=2
# 3. técnica específica: --technique=BEU
# 4. pelo Burp: --proxy=http://127.0.0.1:8080 --random-agent
# 5. sessão/cookie necessária? --cookie="session=..." ou --load-cookies
```

### Cenário 6: "Nuclei retorna 0 resultados"
```bash
# 1. Templates atualizados? nuclei -update-templates
# 2. Scan básico rodou? (sem -severity) → se achar info, filtre depois
# 3. URL certa? (https vs http, porta)
# 4. Rate limit/WAF → -rate-limit 5
# 5. 0 vulns conhecidas = alvo bem atualizado → achados MANUAIS das fases 3-5 valem mais
```

### Cenário 7: "Fui bloqueado / WAF me baniu"
```bash
# 1. Pare TODOS os ataques imediatamente
pkill -f ffuf; pkill -f nuclei; pkill -f sqlmap
# 2. Mude de IP (VPN) e confirme: curl -s https://ifconfig.me
# 3. Espere a janela de ban (fail2ban: 10min, 1h, 24h)
# 4. Volte com: -t 2 -p 2 (ffuf), -rate-limit 5 (nuclei), --delay=2 (sqlmap)
# 5. Ban permanente do alvo? → troque de vetor e volte depois (06-opsec.md)
```

### Cenário 8: "Race condition nunca funciona"
```bash
# 1. Burp Repeater → Send group in parallel (não sequencial!)
# 2. Aumente para 10-20 requissições no script Python
# 3. Timing apertado: use threading.Event para disparar juntas
# 4. Locks robustos = vitória do alvo → documente "mitigado" e avance
```

### Cenário 9: "Upload bloqueia tudo"
```bash
# 1. Whitelist? (só aceita .jpg/.png) → polyglot com exiftool
# 2. Content-Type validado? → mude para image/jpeg
# 3. Magic bytes? → GIF89a no início
# 4. WAF no conteúdo PHP? → SVG (XSS) ou extensão alternativa (.phtml)
# 5. Servidor não executa PHP? → .asp/.jsp conforme o stack (Fase 2)
```

### Cenário 10: "Não encontrei NENHUMA vulnerabilidade"
```bash
# 1. Revise a Fase 1 — importou mesmo? ls -la 08-alimentacao/
# 2. Fase 2 completa? 09-descoberta/parametros.txt tem ≥3 parâmetros?
# 3. Testou ≥5 parâmetros em cada vetor das fases 3-5?
# 4. Rode o Nuclei (Fase 6) como rede de segurança
# 5. Alvo realmente robusto → ISSO É RESULTADO VÁLIDO:
echo "- Alvo sem vulnerabilidades exploráveis nos vetores testados (SQLi, XSS, SSRF, XXE, upload, lógica)" >> 14-relatorio/final/RELATORIO-SEGURANCA.md
```

### Regra de ouro quando tudo falha

> **Se uma ferramenta não funciona, use a ALTERNATIVA da tabela do [18 — Troubleshooting](18-troubleshooting.md). Se a alternativa também falhar, documente o erro e AVANCE para a próxima fase. Nunca pare uma fase inteira por causa de UMA ferramenta quebrada.** Um relatório honesto com "tentado X, resultado Y" vale mais que sucesso inventado.

### Quando parar de vez (escopo e ética)

**Pare IMEDIATAMENTE se:**
1. Dano colateral — afetou serviço fora do escopo
2. Alvo caiu ou ficou lento
3. Acessou dados de usuários reais
4. Período de teste expirou

**Pare por ética se:**
1. Não há mais o que testar (endpoints cobertos)
2. Repetição de vulns já documentadas
3. Fora do escopo definido
4. Risco de dano irreversível

**Situações especiais:**
- **403/401** → não tente bypassar sem autorização explícita
- **WAF** → reduza velocidade, nunca tente DoS
- **Dados sensíveis encontrados** → não exfiltre, documente e reporte

**Durante o teste:** todos os requests dentro do escopo · velocidade controlada · logs salvos · nenhum dado real exfiltrado.

**Em dúvida? PARE e consulte o responsável pelo alvo.**

**Voltar ao índice:** [README](README.md)
