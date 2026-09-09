# 🌐 HTTP e Web

> **HTTP** é o protocolo que usa a web. Toda vez que você abre um site, seu navegador faz uma requisição HTTP. Entender HTTP é essencial para web security.

## 📚 O que é HTTP e como a web funciona?

**HTTP (HyperText Transfer Protocol)** é o protocolo que permite a comunicação entre seu navegador (cliente) e servidores web. Quando você acessa um site, está usando HTTP/HTTPS.

### Por que isso é importante?

- **90% dos ataques** envolvem aplicações web (OWASP Top 10)
- **SQL Injection, XSS, CSRF** — todos exploram falhas HTTP
- **Burp Suite** — ferramenta principal para web hacking opera no nível HTTP
- **APIs** — a maioria dos sistemas modernos usa HTTP para comunicação

### Como funciona na prática?

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

Para entender HTTP, você precisa dominar:
- **Métodos** (GET, POST, PUT, DELETE)
- **Headers** (Content-Type, Authorization, Cookie)
- **Status codes** (200, 301, 403, 404, 500)
- **Cookies e sessões**
- **HTTPS/TLS** (HTTP seguro)

---

## 🏠 Analogia

```
Você (Navegador) ←→ Restaurante (Servidor Web)

Você pede: "Quero o prato do dia" (Requisição HTTP)
Restaurante responde: "Aqui está" (Resposta HTTP)

Se o prato é ruim (site hackeado), você não sabe até pedir
```

---

## 🔄 Como funciona HTTP

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
       │  <html>...conteúdo...</html>      │
       │ ◄──────────────────────────────   │
       │                                   │
```

---

## 📋 Métodos HTTP

| Método | O que faz | Seguro? |
|:-------|:----------|:--------|
| **GET** | Busca dados | ✅ (não envia dados sensíveis) |
| **POST** | Envia dados | ⚠️ (precisa HTTPS) |
| **PUT** | Atualiza dados | ⚠️ |
| **DELETE** | Deleta dados | ⚠️ |
| **HEAD** | Só cabeçalhos | ✅ |
| **OPTIONS** | Métodos permitidos | ✅ |

---

## 📊 Códigos de Resposta

| Código | Significado | O que fazer |
|:-------|:------------|:------------|
| **200** | OK | Tudo certo |
| **301** | Redirect permanente | Redirecionou |
| **302** | Redirect temporário | Redirecionou |
| **400** | Bad Request | Erro do cliente |
| **401** | Unauthorized | Precisa logar |
| **403** | Forbidden | Sem permissão |
| **404** | Not Found | Não existe |
| **500** | Internal Server Error | Erro do servidor |

---

## 📝 Headers Importantes

### Requisição (Request)
```http
GET /login HTTP/1.1
Host: exemplo.com
User-Agent: Mozilla/5.0
Accept: text/html
Cookie: session=abc123
```

### Resposta (Response)
```http
HTTP/1.1 200 OK
Content-Type: text/html
Set-Cookie: session=xyz789
Server: Apache/2.4.49
```

---

## 🔒 HTTP vs HTTPS

| HTTP | HTTPS |
|:-----|:------|
| Porta 80 | Porta 443 |
| Texto plano | Criptografado (TLS/SSL) |
| INSEGURO | SEGURO |
| http:// | https:// |

**HTTPS** = HTTP + Criptografia (TLS)

---

## 🔧 Comandos Práticos

### Requisição HTTP com curl
```bash
# GET simples
curl http://example.com

# Ver cabeçalhos
curl -I http://example.com

# Ver tudo (cabeçalhos + corpo)
curl -v http://example.com

# POST com dados
curl -X POST -d "user=admin&pass=123" http://example.com/login

# Com JSON
curl -X POST -H "Content-Type: application/json" \
  -d '{"user":"admin","pass":"123"}' \
  http://example.com/login
```

### Requisição HTTP com wget
```bash
# Baixar arquivo
wget http://example.com/arquivo.txt

# Baixar e renomear
wget -O arquivo.txt http://example.com/arquivo.txt
```

---

## 🔐 Cookies e Sessões

```
1. Você faz login (POST /login)
2. Servidor cria sessão e envia cookie
   Set-Cookie: session=abc123
3. Todo pedido seguinte envia o cookie
   Cookie: session=abc123
4. Servidor verifica: "ah, é o usuário X"
```

**Se roubar o cookie, você vira o usuário!**

---

## 🕸️ O que é uma API?

**API** é quando o servidor retorna **dados** (JSON) em vez de **página** (HTML):

```bash
# Web tradicional
curl http://example.com/usuarios
# Retorna: <html><body>Lista de usuários...</body></html>

# API
curl http://example.com/api/usuarios
# Retorna: [{"id":1,"nome":"João"},{"id":2,"nome":"Maria"}]
```

**APIs são o novo alvo principal de ataques!**

---

## ✅ Checkpoint

- [ ] Consigo explicar o que é HTTP
- [ ] Sei a diferença entre GET e POST
- [ ] Consigo usar `curl` para fazer requisições
- [ ] Entendo a diferença entre HTTP e HTTPS
- [ ] Sei o que são cookies e APIs

---

<div align="center">

**⬅️ [Anterior: Linux Básico](../02-sistemas/06-linux-basico.md)** | **[Próximo: Máquinas Virtuais](../02-sistemas/08-maquinas-virtuais.md) ➡️**

</div>