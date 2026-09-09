# Módulo 13: Frontend Security

> XSS, CSRF, CSP, CORS e outras vulnerabilidades do lado do cliente.

---

## O que você vai aprender

Neste módulo, você vai aprender a **testar a segurança de aplicações frontend** — desde XSS e CSRF até políticas de segurança como CSP e CORS. O frontend é a interface entre o usuário e o sistema.

## Pré-requisitos

- Módulo 3 (Web & Aplicações) concluído
- Conhecimento de HTML, CSS e JavaScript básico
- Noções de HTTP e cookies

## Fluxo de Estudo

```
1. 01-xss-e-csrf.md → XSS (Stored, Reflected, DOM), CSRF, bypass
        ↓
2. 02-seguranca-de-aplicacoes.md → CSP, CORS, Clickjacking, seed security
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-xss-e-csrf.md](01-xss-e-csrf.md) | XSS, CSRF, bypass de filtros | `Burp, XSStrike, Dalfox` |
| 2 | [02-seguranca-de-aplicacoes.md](02-seguranca-de-aplicacoes.md) | CSP, CORS, Clickjacking | `Burp, csp-bypass, xss.game` |

## Dicas Práticas

- **Teste XSS em todos os inputs** — parâmetros, headers, cookies
- **CSRF precisa de estado** — o ataque funciona quando o usuário está logado
- **CSP não é invencível** — existem várias técnicas de bypass

## Erros Comuns

1. **Ignorar DOM-based XSS** — o código JavaScript pode ser manipulado no cliente
2. **Não testar bypass de CSP** —=substitua `<` por `%3C`, use event handlers
3. **Esquecer de testar cookies** — flags HttpOnly e Secure são essenciais

---

**Anterior:** [Módulo 12: Database Security](../12-database-security/)
