# Módulo 3: Web & Aplicações

> Encontrar falhas em sites e aplicações web.

---

## O que você vai aprender

Neste módulo, você vai aprender a **testar aplicações web** para encontrar falhas. Sites são o alvo mais comum de ataques, e saber testar é essencial para qualquer profissional de segurança.

## Pré-requisitos

- Módulo 1 (Reconhecimento) concluído
- Conhecimento básico de HTTP (headers, status codes, métodos)

## Fluxo de Estudo

```
1. 01-descoberta-e-enumeracao.md → Gobuster, FFUF, WhatWeb, Nikto, WPScan
        ↓
2. 02-injecao-e-fuzzing.md → SQLMap, WAFw00f
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-descoberta-e-enumeracao.md](01-descoberta-e-enumeracao.md) | Descobrir diretórios, tecnologias e vulnerabilidades | `Gobuster, FFUF, WhatWeb, Nikto, WPScan` |
| 2 | [02-injecao-e-fuzzing.md](02-injecao-e-fuzzing.md) | Testar SQL Injection e detectar WAFs | `SQLMap, WAFw00f` |

## Dicas Práticas

- **Gobuster para descoberta** — sempre comece com `common.txt`
- **FFUF para fuzzing** — mais flexível que Gobuster para testes avançados
- **Nikto para vulnerabilidades** — lento, mas completo
- **SQLMap automatiza SQLi** — use `--batch` para não ficar respondendo perguntas

## Erros Comuns

1. **Não testar WAF primeiro** — se tem WAF, seus ataques podem ser bloqueados
2. **Usar wordlists muito grandes** — comece com listas pequenas e vá aumentando
3. **Esquecer o `-fc 404`** — filtre respostas de 404 para não ter falsos positivos

## Referências

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [TryHackMe - Web Fundamentals](https://tryhackme.com/room/owasptop10)
- [HackTricks - Web](https://book.hacktricks.wiki/)

---

**Anterior:** [Módulo 2: Análise de Rede](../02-analise-rede/)
**Próximo:** [Módulo 4: Exploração](../04-exploracao/)
