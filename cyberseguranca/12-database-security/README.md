# Módulo 12: Database Security

> Enumeração, brute force, injeção e exfiltração de dados em bancos de dados.

---

## O que você vai aprender

Neste módulo, você vai aprender a **testar a segurança de bancos de dados** — desde a enumeração de serviços até a extração de dados via SQL/NoSQL injection. Bancos de dados são o prêmio final para atacantes.

## Pré-requisitos

- Módulo 11 (API Security) concluído
- Conhecimento de SQL básico (SELECT, WHERE, JOIN)
- Noções de HTTP e APIs

## Fluxo de Estudo

```
1. 01-enumeracao-e-brute-force.md → Descobrir e enumerar bancos de dados
        ↓
2. 02-injecao-e-exfiltracao.md → SQL/NoSQL injection, extração de dados
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-enumeracao-e-brute-force.md](01-enumeracao-e-brute-force.md) | Enumerar MySQL, PostgreSQL, MongoDB, Redis | `nmap, hydra, medusa` |
| 2 | [02-injecao-e-exfiltracao.md](02-injecao-e-exfiltracao.md) | SQL injection avançado, NoSQL, extração | `sqlmap, burp, jSQL` |

## Dicas Práticas

- **Sempre enumere primeiro** — descubra versão, usuários e permissões antes de atacar
- **Use injection para escalar** — SQL injection pode dar acesso total ao servidor
- **Cuidado com produção** — nunca teste em bancos de dados reais sem autorização

## Erros Comuns

1. **Pular a enumeração** — atacar sem saber a versão do banco é ineficiente
2. **Não testar CRUD completo** — INSERT, UPDATE, DELETE são tão perigosos quanto SELECT
3. **Ignorar bancos NoSQL** — MongoDB, Redis e CouchDB também são vulneráveis

---

**Anterior:** [Módulo 11: API Security](../11-api-security/)
**Próximo:** [Módulo 13: Frontend Security](../13-frontend-security/)
