## Alvos para Praticar

Nunca teste sem autorização. Use estes alvos legítimos:

### PortSwigger Web Security Academy (recomendado)
Sem cadastro obrigatório, labs gratuitos e atualizados. Cada fase deste manual tem um mini-checkpoint apontando para o lab certo:

| Tema | URL |
|------|-----|
| SQLi (WHERE clause) | https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data |
| XSS refletido | https://portswigger.net/web-security/cross-site-scripting/reflected/lab-html-context-notarily-blocking-quotes |
| Username enumeration | https://portswigger.net/web-security/authentication/username-enumeration/lab-subtly-different-responses |
| CSRF | https://portswigger.net/web-security/csrf |
| SSRF | https://portswigger.net/web-security/server-side-request-forgery/lab-basic-ssrf-against-the-local-server |
| XXE | https://portswigger.net/web-security/xxe/lab-exploiting-xxe-to-retrieve-files |
| File upload | https://portswigger.net/web-security/file-upload/path-traversal/lab-web-shell-upload-via-path-traversal |
| Race conditions | https://portswigger.net/web-security/race-conditions |

Índice geral: https://portswigger.net/web-security/all-labs

### Labs locais (Docker)
```bash
# Juice Shop (vulnerabilidades web modernas, OWASP)
docker pull bkimminich/juice-shop
docker run -d -p 3000:3000 --name juice-shop bkimminich/juice-shop

# DVWA (clássico, níveis Low→High)
docker pull vulnerables/web-dvwa
docker run -d -p 80:80 --name dvwa vulnerables/web-dvwa

# WebGoat (aula guiada)
docker pull webgoat/webgoat
docker run -d -p 8080:8080 --name webgoat webgoat/webgoat
```

### Plataformas com gamificação
- **TryHackMe:** rooms de Web Fundamentals e Burp Suite
- **HackTheBox:** máquinas iniciantes com web (Starting Point)
- **PicoCTF:** challenges web

### Seu próprio alvo de laboratório
```
1. Levante DVWA/Juice Shop em localhost
2. Rode este manual inteiro contra http://localhost
3. Compare seus findings com as soluções de cada lab
```

**Regra:** praticar em lab ANTES de um pentest real. O objetivo é errar aqui, não no alvo do cliente.
