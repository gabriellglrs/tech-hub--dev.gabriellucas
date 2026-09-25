## Validação Manual — Como Confirmar Cada Achado

A Fase 6 já fez a validação formal; este guia é a **referência rápida** para confirmar qualquer achado à mão, sem scanner, quando precisar re-verificar.

### Regra de ouro
> Um achado só existe se você conseguir **reproduzi-lo 3 vezes seguidas** e mostrar o request/response exato. Caso contrário, é falso positivo — remova.

---

### 1. SQL Injection
```http
GET /api/users?id=1' OR '1'='1-- HTTP/1.1
```
- [ ] Resposta com mais dados que o original
- [ ] `sqlmap -u "URL" --batch` confirma o DBMS
- [ ] UNION SELECT extrai dado real

### 2. XSS
```http
GET /search?q=<script>alert('XSS')</script>
```
- [ ] Alert no Firefox (não só no Repeater)
- [ ] Refletido SEM entity encoding no HTML
- [ ] `alert(document.cookie)` funciona (impacto real)

### 3. CSRF
- [ ] POST state-changing aceito SEM token
- [ ] PoC HTML aberto em outra aba executa a ação
- [ ] Cookie sem `SameSite=Strict/Lax` (ou validação de token ausente)

### 4. SSRF
```http
GET /api/fetch?url=http://127.0.0.1
```
- [ ] Resposta do servidor interno visível
- [ ] OU Collaborator recebeu conexão (blind)
- [ ] `http://169.254.169.254` responde (cloud)

### 5. Command Injection
```http
GET /api/ping?host=127.0.0.1;id
```
- [ ] Output de `id` (uid/gid) presente
- [ ] `; cat /etc/passwd` retorna conteúdo

### 6. XXE
- [ ] `/etc/passwd` aparece na resposta do XML
- [ ] OU log do seu servidor/Collaborator com `?data=...` (blind)

### 7. File Upload
- [ ] Webshell acessível por URL e executa `?cmd=id`
- [ ] Sobrevive após re-login (persistência real)

### 8. Auth Bypass / JWT
- [ ] Endpoint admin acessível SEM token ou com token inválido
- [ ] JWT `alg:none` aceito OU chave crackeada e assinatura refeita

### 9. Race Condition
- [ ] ≥ 2 requests simultâneos processados
- [ ] Efeito colateral observado (saldo, cupom, estoque)
- [ ] Reproduz 3×

### 10. IDOR
- [ ] ID de outro usuário acessível com SEU token
- [ ] Dados de terceiros visíveis (sem PII real em lab)

---

### Checklist final de revalidação
| # | Achado | 3× reproduzido? | Evidência salva? | ☑ |
|---|--------|:---:|:---:|:---:|
| 1 | | | | [ ] |
| 2 | | | | [ ] |
| 3 | | | | [ ] |

**Falso positivo:** comportamento esperado do app · não reproduzível · impacto nulo · WAF bloqueia na prática.
**Não reproduziu?** → Não entre no relatório. Documente "não reproduzível em data de reteste".

**Voltar:** [12 — Fase 6](12-fase6-validacao.md)
