# HTTP e Web

> HTTP e o protocolo que faz a web funcionar. Toda vez que voce abre um site, seu navegador faz uma requisicao HTTP. Entender HTTP e essencial para web security — porque 90% dos ataques envolvem aplicacoes web.

---

## O que e HTTP e como a web funciona?

**HTTP (HyperText Transfer Protocol)** e o protocolo que permite a comunicacao entre seu navegador (cliente) e servidores web.

### Como funciona na pratica?

```
Seu navegador              Servidor web
     │                         │
     │  GET /index.html        │
     │  ──────────────────→    │
     │                         │
     │  HTTP/1.1 200 OK        │
     │  ←──────────────────    │
     │  <html>Olá</html>       │
```

Para entender HTTP, voce precisa dominar:
- **Metodos** (GET, POST, PUT, DELETE)
- **Headers** (Content-Type, Authorization, Cookie)
- **Status codes** (200, 301, 403, 404, 500)
- **Cookies e sessoes**
- **HTTPS/TLS** (HTTP seguro)
- **APIs REST** (comunicacao entre sistemas)

---

## Analogia

```
Voce (Navegador) ←→ Restaurante (Servidor Web)

Voce pede: "Quero o prato do dia" (Requisicao HTTP)
Restaurante responde: "Aqui esta" (Resposta HTTP)

Se o prato e ruim (site hackeado), voce nao sabe ate pedir
```

---

## Como funciona HTTP

```
┌──────────────┐                    ┌──────────────┐
│  NAVEGADOR   │                    │   SERVIDOR   │
│  (Cliente)   │                    │              │
└──────┬───────┘                    └──────┬───────┘
       │                                   │
       │  1. GET /index.html HTTP/1.1      │
       │  Host: google.com                 │
       │ ──────────────────────────────►   │
       │                                   │
       │  2. HTTP/1.1 200 OK              │
       │  Content-Type: text/html          │
       │  <html>...conteudo...</html>      │
       │ ◄──────────────────────────────   │
       │                                   │
```

---

## Metodos HTTP

| Metodo | O que faz | Quando usar | Seguranca |
|:-------|:----------|:------------|:----------|
| **GET** | Busca dados | Carregar pagina, listar itens | Seguro (nao envia dados sensiveis) |
| **POST** | Envia dados | Login, formulario, criar item | Precisa HTTPS |
| **PUT** | Atualiza dados | Editar perfil, alterar senha | Precisa HTTPS |
| **DELETE** | Deleta dados | Remover conta, deletar item | Precisa HTTPS |
| **HEAD** | Só cabeçalhos | Verificar se pagina existe | Seguro |
| **OPTIONS** | Metodos permitidos | Descobrir API | Seguro |

### Exemplo de cada metodo

```bash
# GET — buscar lista de usuarios
curl http://api.exemplo.com/usuarios
# Resposta: [{"id":1,"nome":"Joao"},{"id":2,"nome":"Maria"}]

# POST — criar usuario novo
curl -X POST http://api.exemplo.com/usuarios \
  -H "Content-Type: application/json" \
  -d '{"nome":"Pedro","email":"pedro@email.com"}'
# Resposta: {"id":3,"nome":"Pedro","email":"pedro@email.com"}

# PUT — atualizar usuario
curl -X PUT http://api.exemplo.com/usuarios/3 \
  -H "Content-Type: application/json" \
  -d '{"nome":"Pedro Santos","email":"pedro@email.com"}'
# Resposta: {"id":3,"nome":"Pedro Santos","email":"pedro@email.com"}

# DELETE — deletar usuario
curl -X DELETE http://api.exemplo.com/usuarios/3
# Resposta: {"message":"Usuario removido"}
```

---

## Codigos de Resposta

| Codigo | Significado | O que significa na pratica |
|:-------|:------------|:---------------------------|
| **200** | OK | Tudo certo, requisicao atendida |
| **301** | Redirect permanente | Site mudou de endereco |
| **302** | Redirect temporario | Redirecionamento temporario |
| **400** | Bad Request | Dados invalidos ou incompletos |
| **401** | Unauthorized | Precisa fazer login |
| **403** | Forbidden | Nao tem permissao |
| **404** | Not Found | Pagina ou recurso nao existe |
| **500** | Internal Server Error | Erro no servidor |
| **503** | Service Unavailable | Servidor sobrecarregado ou em manutencao |

### Por que isso importa para seguranca?

```
401 + 403 alternando = provavel sistema de autenticacao fraco
500 apos POST com dados = possivel SQL Injection
404 em paginas admin = existe pasta admin (mesmo que bloqueada)
```

---

## Headers Importantes

### Requisicao (Request)

```http
GET /login HTTP/1.1
Host: exemplo.com
User-Agent: Mozilla/5.0
Accept: text/html,application/xhtml+xml
Accept-Language: pt-BR,pt;q=0.9,en;q=0.8
Accept-Encoding: gzip, deflate, br
Cookie: session=abc123
Authorization: Basic YWRtaW46MTIzNA==
Content-Type: application/x-www-form-urlencoded
```

### Resposta (Response)

```http
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Set-Cookie: session=xyz789; HttpOnly; Secure; SameSite=Strict
Server: Apache/2.4.49
X-Powered-By: PHP/8.1
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
```

### Headers de seguranca

| Header | O que faz | Exemplo |
|:-------|:----------|:--------|
| `X-Content-Type-Options` | Impede que o browser adivinhe o tipo do arquivo | `nosniff` |
| `X-Frame-Options` | Impede que o site seja carregado em iframes | `DENY` |
| `X-XSS-Protection` | Ativa protecao XSS do browser | `1; mode=block` |
| `Strict-Transport-Security` | Forca HTTPS | `max-age=31536000` |
| `Content-Security-Policy` | Restringe fontes de conteudo | `default-src 'self'` |

---

## HTTP vs HTTPS

```
HTTP (porta 80)               HTTPS (porta 443)
┌─────────────────┐           ┌─────────────────┐
│ Texto PLANO     │           │ Texto CIFRADO    │
│                 │           │                  │
│ GET /login      │    TLS    │ GET /login       │
│ user=admin      │  ──────►  │ user=YWRtaW4=    │
│ pass=1234       │           │ pass=JDJ5JDQ=    │
│                 │           │                  │
│ Qualquer pessoa │           │ So o destinata-  │
│ pode ler        │           │ rio pode ler     │
└─────────────────┘           └─────────────────┘

SEM TLS:  Atacante ve: user=admin&pass=1234
COM TLS:  Atacante ve: 0x7f2a9b3c... (bytes cifrados)
```

### O que e TLS/SSL?

**TLS (Transport Layer Security)** e o protocolo que criptografa a comunicacao entre navegador e servidor. Antigo nome: SSL.

### Como funciona o handshake TLS?

```
Navegador                                    Servidor
    │                                            │
    │  1. "Quero me conectar! Aqui minhas       │
    │      cipher suites suportadas"             │
    │ ─────────────────────────────────────►     │
    │                                            │
    │  2. "Ok! Aqui meu certificado (com minha   │
    │      chave publica)"                       │
    │ ◄─────────────────────────────────────     │
    │                                            │
    │  3. "Verifiquei o certificado. Criei uma   │
    │      chave secreta e cifrei com sua chave  │
    │      publica"                              │
    │ ─────────────────────────────────────►     │
    │                                            │
    │  4. "Recebi! Agora vamos falar com         │
    │      criptografia"                         │
    │ ◄─────────────────────────────────────     │
    │                                            │
    │  ═══════ COMUNICACAO CIFRADA ═══════       │
    │                                            │
```

### Certificados SSL/TLS

O certificado e o "documento de identidade" do site. Ele prova que o servidor e realmente quem diz ser.

```
Certificado contem:
├── Dominio: www.exemplo.com
├── Emissor: Let's Encrypt (CA)
├── Validade: 2025-01-01 a 2025-04-01
├── Chave publica do servidor
└── Assinatura digital da CA
```

### Por que isso importa para seguranca?

```
Atacante pode:
├── Interceptar comunicacao (Man-in-the-Middle)
├── Falsificar certificado (se o CA for comprometido)
├── Usar certificado invalido (o browser avisa)
└── Explorar TLS antigo (SSL 3.0, TLS 1.0)

Protecao:
├── Verificar se o browser mostra cadeado verde
├── Checar se o certificado e valido (nao expirado)
├── Usar TLS 1.2+ (TLS 1.3 e o mais seguro)
└── Nunca ignorar avisos de certificado
```

---

## O que e HTML?

**HTML (HyperText Markup Language)** e a linguagem que cria o conteudo das paginas web. E o "esqueleto" de qualquer site.

### Como HTML funciona?

```html
<!DOCTYPE html>
<html>
<head>
    <title>Meu Site</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Bem-vindo!</h1>
    <p>Este e um site simples.</p>
    <a href="https://google.com">Ir para o Google</a>
    <form action="/login" method="POST">
        <input type="text" name="user" placeholder="Usuario">
        <input type="password" name="pass" placeholder="Senha">
        <button type="submit">Entrar</button>
    </form>
</body>
</html>
```

### Como voce ve HTML no browser?

```
Browser recebe HTML
    │
    ├── Renderiza o HTML (mostra o conteudo)
    ├── Baixa o CSS (estiliza)
    ├── Baixa o JavaScript (interatividade)
    └── Monta a pagina final
```

### Por que isso importa para seguranca?

```
Voce pode ver o HTML COMPLETO de qualquer site:

1. Abra o site
2. Pressione F12 (DevTools)
3. Va na aba "Elements" ou "Elements"
4. Ve todo o codigo HTML

O HTML revela:
├── Formularios (campos de login)
├── Links internos (pastas ocultas)
├── Comentarios com informacoes sensiveis
├── Scripts incorporados
└── Metadados (versoes, tecnologias)
```

---

## O que e JavaScript?

**JavaScript (JS)** e uma linguagem de programacao que roda NO NAVEGADOR. E o "musculo" do site — ele faz as coisas acontecerem.

### O que JavaScript faz?

```
HTML:  "Este e um botao"          → conteudo
CSS:   "Este botao e vermelho"    → aparencia
JS:    "Quando clicar, faca algo" → comportamento
```

### Exemplo de JavaScript

```javascript
// Quando o usuario clicar no botao
document.getElementById("meuBotao").addEventListener("click", function() {
    alert("Voce clicou!");
});

// Enviar formulario via AJAX (sem recarregar a pagina)
fetch("/api/login", {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({user: "admin", pass: "1234"})
})
.then(response => response.json())
.then(data => console.log(data));
```

### Por que JavaScript e CRITICO para seguranca?

```
JavaScript e a linguagem de ataques web:

1. XSS (Cross-Site Scripting)
   Atacante injeta JavaScript em pagina
   JS roda no navegador da vitima
   Rouba cookies, senhas, dados

2. CSRF (Cross-Site Request Forgery)
   JS faz requisicoes automaticamente
   Usuario nem percebe

3. Keylogger via JS
   JS grava tudo que voce digita
   Envia para atacante

4. DOM Manipulation
   JS modifica o HTML da pagina
   Mostra conteudo falso (phishing)
```

### Como voce ve o JavaScript?

```
1. Abra o site
2. Pressione F12
3. Va na aba "Console"
4. Digite JavaScript e execute
5. Va na aba "Sources" para ver os arquivos .js
```

---

## O que e uma API?

**API (Application Programming Interface)** e quando o servidor retorna **dados (JSON)** em vez de **pagina (HTML)**.

### Web tradicional vs API

```
Web tradicional:
curl http://example.com/usuarios
Retorna: <html><body>Lista de usuarios...</body></html>

API:
curl http://example.com/api/usuarios
Retorna: [{"id":1,"nome":"Joao"},{"id":2,"nome":"Maria"}]
```

### API REST — O padrao da industria

REST usa os verbos HTTP para definir acoes:

| Acao | Metodo | Endpoint | O que faz |
|:-----|:-------|:---------|:----------|
| Listar | GET | /api/usuarios | Lista todos |
| Buscar | GET | /api/usuarios/1 | Busca um |
| Criar | POST | /api/usuarios | Cria novo |
| Atualizar | PUT | /api/usuarios/1 | Atualiza um |
| Deletar | DELETE | /api/usuarios/1 | Deleta um |

### Como uma API funciona?

```
Cliente (App/mobile)                API Server
        │                               │
        │  GET /api/usuarios             │
        │  Authorization: Bearer abc123  │
        │ ─────────────────────────────► │
        │                               │
        │  HTTP/1.1 200 OK              │
        │  Content-Type: application/json│
        │  [{"id":1,"nome":"Joao"}]      │
        │ ◄───────────────────────────── │
```

### JSON — O formato das APIs

```json
{
    "id": 1,
    "nome": "Joao Silva",
    "email": "joao@email.com",
    "roles": ["admin", "user"],
    "ativo": true,
    "endereco": {
        "rua": "Rua A",
        "numero": 123
    }
}
```

### Por que APIs sao o novo alvo principal?

```
APIs sao mais perigosas que sites tradicionais:

1. Sem interface visual
   Nao da pra "ver" se algo esta errado

2. Dados em JSON (mais faceis de explotar)
   SQL Injection, NoSQL Injection, SSRF

3. Autenticacao fraca
   Tokens expirados, chaves hardcoded

4. Rate limiting ausente
   Brute force ilimitado

5. Documentacao publica
   Atacante sabe exatamente o que atacar
```

---

## Cookies e Sessoes

```
1. Voce faz login (POST /login)
2. Servidor cria sessao e envia cookie
   Set-Cookie: session=abc123; HttpOnly; Secure; SameSite=Strict
3. Todo pedido seguinte envia o cookie
   Cookie: session=abc123
4. Servidor verifica: "ah, e o usuario X"
```

### Flags de seguranca dos cookies

| Flag | O que faz | Por que e importante |
|:-----|:----------|:---------------------|
| `HttpOnly` | JS nao pode acessar o cookie | Impede roubo via XSS |
| `Secure` | Só envia por HTTPS | Impede interceptacao |
| `SameSite=Strict` | So envia para o mesmo site | Impede CSRF |
| `Domain` | Restringe para dominio especifico | Impede envio para dominios falsos |
| `Path` | Restringe para caminho especifico | Mais controle |

### O que acontece SEM essas flags?

```
SEM HttpOnly:
├── Atacante injeta JS via XSS
├── JS faz: document.cookie
├── Cookie vai pro servidor do atacante
└── Atacante se passa por vo

SEM Secure:
├── Cookie via HTTP (texto plano)
├── Atacante intercepta na rede
├── Cookie roubado
└── Atacante se passa por vo

SEM SameSite:
├── Voce esta logado no banco.com
├── Atacante envia form para banco.com/api/transferir
├── Browser envia cookie automaticamente
└── Transferencia e feita sem voce saber
```

---

## Comandos Praticos

### Requisicao HTTP com curl

```bash
# GET simples
curl http://example.com

# Ver cabecalhos
curl -I http://example.com

# Ver tudo (cabecalhos + corpo)
curl -v http://example.com

# POST com dados
curl -X POST -d "user=admin&pass=123" http://example.com/login

# Com JSON
curl -X POST -H "Content-Type: application/json" \
  -d '{"user":"admin","pass":"123"}' \
  http://example.com/login

# Com autenticacao Basic
curl -u admin:123 http://example.com/api/admin
```

### Analisar com浏览器 DevTools

```
1. Abra o site no browser
2. Pressione F12
3. Abas uteis:
   ├── Elements: ve o HTML completo
   ├── Console: execute JavaScript
   ├── Network: ve todas as requisicoes HTTP
   ├── Sources: ve os arquivos JS
   └── Application: ve cookies e storage
```

### Verificar certificado SSL

```bash
# Verificar certificado de um site
openssl s_client -connect example.com:443

# Verificar data de validade
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -dates
```

---

## Exercicio: Raciocinio de Seguranca

Para cada situacao, identifique o que esta errado e o que poderia ser explorado:

1. Voce ve `http://` (nao https) em um site de login
2. O cookie aparece sem `HttpOnly` e sem `Secure`
3. A API retorna erro 500 quando voce envia SQL `' OR 1=1--`
4. O formulario envia dados via GET em vez de POST
5. O site tem certificado expirado

<details>
<summary>Respostas</summary>

1. **Man-in-the-Middle** — senha pode ser interceptada
2. **Roubo via XSS** — JavaScript pode roubar o cookie
3. **SQL Injection** — o servidor nao trata input adequadamente
4. **Dados visiveis** — senha aparece na URL, nos logs, no historico
5. **Ataque MITM** — pode ser site falso, certificado nao verificado

</details>

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Explicar o que e HTTP e como funciona
- [ ] Diferenciar os metodos HTTP (GET, POST, PUT, DELETE)
- [ ] Interpretar codigos de resposta (200, 403, 404, 500)
- [ ] Entender HTTPS/TLS e como funciona a criptografia
- [ ] Explicar o que e HTML e como ver o codigo de um site
- [ ] Entender o papel do JavaScript na web e em ataques
- [ ] Diferenciar web tradicional de API REST
- [ ] Explicar cookies e a importancia das flags de seguranca
- [ ] Usar curl para fazer requisicoes HTTP
- [ ] Usar DevTools do browser para analisar um site

---

<div align="center">

**⬅️ [Anterior: Linux Basico](06-linux-basico.md)** | **[Proximo: Maquinas Virtuais](08-maquinas-virtuais.md) ➡️**

</div>
