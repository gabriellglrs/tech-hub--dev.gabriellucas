# Labs de Engenharia Reversa

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Ghidra, GDB, radare2, pwntools |
| Módulos 1-3 | ⭐⭐⭐ | Recon, Web, Exploração concluídos |
| Linux básico | ⭐⭐ | Comandos de terminal, permissões |

---

## Labs por Plataforma

### TryHackMe (4 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Buffer Overflow Prep | checksec, Ghidra, GDB, ROP chains | ⭐⭐⭐ | https://tryhackme.com/room/bufferoverflowprep |
| 2 | Gateway Intercept | GDB, crackme, reversing estático | ⭐⭐⭐ | https://tryhackme.com/room/gatewayintercept |
| 3 | Ghidra | Tutorial completo do Ghidra, decompilação | ⭐⭐ | https://tryhackme.com/room/ghidra |
| 4 | Reverse Engineering | RE básico com radare2, strings, assembly | ⭐⭐ | https://tryhackme.com/room/reverseengineer |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### OverTheWire (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 5 | Leviathan (8 levels) | RE basics, comparações, strings ocultas | ⭐⭐ | ssh://leviathan.labs.overthewire.org:2223 |

### PicoCTF (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 6 | Reverse Engineering (40+) | RE geral, binary, crypto | ⭐-⭐⭐⭐⭐ | https://play.picoctf.org/practice |

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 7 | Starting Point (RE basics) | Binário simples, strings, debug | ⭐⭐ | https://app.hackthebox.com/starting-point |

### Prática Local (3 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 8 | Crackmes.one | Binários de dificuldade crescente | ⭐-⭐⭐⭐⭐ | https://crackmes.one |
| 9 | Compile & Reverse seu próprio | Criar binário C, decompilar no Ghidra | ⭐⭐ | `gcc -o vuln vuln.c && gdb ./vuln` |
| 10 | Fuzzing local com AFL++ | Compilar binário, rodar fuzzing, analisar crash | ⭐⭐⭐ | `afl-gcc -o fuzzy program.c && afl-fuzz -i input/ -o output/ ./fuzzy` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 4 | Buffer overflow, Ghidra, GDB, RE básico |
| OverTheWire | 1 | Leviathan (RE basics) |
| PicoCTF | 1 | RE geral (40+ challenges) |
| HackTheBox | 1 | Starting point RE |
| Local | 3 | Crackmes, compilação, fuzzing |
| **Total** | **10** | |
