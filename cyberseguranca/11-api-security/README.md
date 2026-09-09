# Módulo 11: API Security

> Testar segurança de APIs REST, GraphQL e WebSocket.

---

## O que você vai aprender

Neste módulo, você vai aprender a **testar APIs** para encontrar falhas. APIs são o novo alvo principal - mobile apps, SPAs e microserviços dependem delas.

## Pré-requisitos

- Módulo 3 (Web & Aplicações) concluído
- Conhecimento de HTTP (métodos, headers, status codes)
- Noções de JSON

## Fluxo de Estudo

```
1. 01-reconhecimento-e-documentacao.md → Descobrir e mapear APIs
        ↓
2. 02-teste-de-vulnerabilidades.md → BOLA, BFLA, Injeção, Auth
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-reconhecimento-e-documentacao.md](01-reconhecimento-e-documentacao.md) | Descobrir endpoints, documentação | `Postman, curl, ffuf, Arjun` |
| 2 | [02-teste-de-vulnerabilidades.md](02-teste-de-vulnerabilidades.md) | BOLA, BFLA, injeção, rate limit | `Kiterunner, Burp, nuclei` |

## Dicas Práticas

- **Sempre comece pela documentação** — Swagger/OpenAPI revela todos os endpoints
- **Teste autenticação** — tente acessar sem token, com token inválido, com token de outro usuário
- **BOLA é a vuln #1 em APIs** — tente acessar recursos de outros usuários alterando IDs

## Erros Comuns

1. **Ignorar endpoints não documentados** — use ffuf/Arjun para descobrir
2. **Não testar métodos HTTP** — um GET pode ser seguro mas o POST vulnerável
3. **Esquecer de testar rate limiting** — APIs sensíveis devem limitar tentativas

---

**Próximo:** [Módulo 12: Database Security](../12-database-security/)
