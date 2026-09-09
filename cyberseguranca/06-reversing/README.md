# Módulo 6: Engenharia Reversa

> Entender binários e criar exploits para vulnerabilidades.

---

## O que você vai aprender

Neste módulo, você vai aprender a **entender como programas funcionam** sem ter o código-fonte, e a **criar exploits** para vulnerabilidades encontradas. É a fase mais técnica e avançada da trilha.

## Pré-requisitos

- Módulo 4 (Exploração) concluído
- Conhecimento de programação (Python, C básico)
- Conhecimento de arquitetura de computadores (registradores, stack, heap)

## Fluxo de Estudo

```
1. 01-engenharia-reversa.md → Ghidra, Radare2, GDB/GEF
        ↓
2. 02-exploit-e-fuzzing.md → Pwntools, AFL++, Checksec
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-engenharia-reversa.md](01-engenharia-reversa.md) | Analisar binários e encontrar vulnerabilidades | `Ghidra, Radare2, GDB/GEF` |
| 2 | [02-exploit-e-fuzzing.md](02-exploit-e-fuzzing.md) | Criar exploits e fuzzing automático | `Pwntools, AFL++, Checksec` |

## Dicas Práticas

- **Comece com `strings`** — antes de abrir no Ghidra, veja o que o binário diz
- **Ghidra é gratuito e poderoso** — decompilador da NSA, melhor que IDA Free
- **GDB + GEF para debug** — entenda o que acontece na execução
- **Pwntools para exploits** — biblioteca Python que facilita tudo

## Erros Comuns

1. **Pular direto para Ghidra** — sempre faça triagem primeiro (`file`, `strings`, `checksec`)
2. **Não entender o binário** — antes de explorar, entenda o que o programa faz
3. **Esquecer as proteções** — `checksec` mostra NX, PIE, Canary, RELRO

## Referências

- [Ghidra Book](https://ghidra-sre.org/)
- [TryHackMe - Reverse Engineering](https://tryhackme.com/room/rer2)
- [PwnTools Documentation](https://docs.pwntools.com/)

---

**Anterior:** [Módulo 5: Pós-Exploração](../05-pos-exploracao/)
**Próximo:** [Módulo 7: Defesa](../07-defesa/)
