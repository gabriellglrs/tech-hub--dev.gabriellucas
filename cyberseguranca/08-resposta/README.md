# Módulo 8: Resposta a Incidentes

> Investigar ataques, preservar evidências e analisar malware.

---

## O que você vai aprender

Neste módulo, você vai aprender a **investigar incidentes de segurança** e **analisar malware**. É a fase de forense — quando algo deu errado, você precisa descobrir o que aconteceu, quem fez, e como prevenir no futuro.

## Pré-requisitos

- Módulo 7 (Defesa) recomendado
- Conhecimento de Linux e sistemas de arquivos
- VM isolada para análise de malware (REMnux ou similar)

## Fluxo de Estudo

```
1. 01-forense-computacional.md → Autopsy, Volatility, Plaso
        ↓
2. 02-analise-malware.md → Ghidra, YARA, Cuckoo, REMnux
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-forense-computacional.md](01-forense-computacional.md) | Preservar e analisar evidências digitais | `Autopsy, Volatility, Plaso, SleuthKit` |
| 2 | [02-analise-malware.md](02-analise-malware.md) | Entender o que malware faz sem se infectar | `Ghidra, YARA, Cuckoo, REMnux, Capa` |

## Dicas Práticas

- **Sempre usar cópia forense** — nunca analise o original
- **Documentar cadeia de custódia** — hash, quem acessou, quando
- **VM isolada para malware** — sem rede ou host-only + snapshot
- **YARA para classificação** — crie regras para detectar famílias de malware

## Erros Comuns

1. **Analisar malware no host** — sempre use VM isolada
2. **Não preservar evidências** — antes de analisar, faça imagem bit-a-bit
3. **Esquecer o hash** — SHA256 antes e depois para provar integridade

## Referências

- [Autopsy Documentation](https://www.autopsy.com/docs/)
- [TryHackMe - Forensics](https://tryhackme.com/room/volatility)
- [REMnux Documentation](https://remnux.org/)

---

**Anterior:** [Módulo 7: Defesa](../07-defesa/)
**Próximo:** [Módulo 9: Ambientes Especiais](../09-ambientes/)
