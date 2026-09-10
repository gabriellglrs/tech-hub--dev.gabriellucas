# Relatório de Labs e Referências — Módulo 05: Engenharia Reversa

**Gerado em:** 2026-09-10
**Módulo:** 05-reversing
**Requisitos:** PESQ-01, PESQ-02

---

## Labs Existentes (LABS.md)

| # | Exercício | Plataforma | URL | Status Validação |
|:-:|:----------|:-----------|:----|:-----------------|
| 1 | Análise Estática com checksec/file | TryHackMe | https://tryhackme.com/room/bufferoverflowprep | ⏳ Pendente (rate-limit THM) |
| 2 | Descompilação com Ghidra | TryHackMe | https://tryhackme.com/room/bufferoverflowprep | ⏳ Pendente (rate-limit THM) |
| 3 | Debug com GDB/GEF | TryHackMe | https://tryhackme.com/room/gatewayintercept | ⏳ Pendente (rate-limit THM) |
| 4 | Buffer Overflow Básico | TryHackMe | https://tryhackme.com/room/bufferoverflowprep | ⏳ Pendente (rate-limit THM) |
| 5 | ROP Chain | TryHackMe | https://tryhackme.com/room/bufferoverflowprep | ⏳ Pendente (rate-limit THM) |
| 6 | Crackme Challenge | TryHackMe | https://tryhackme.com/room/gatewayintercept | ⏳ Pendente (rate-limit THM) |

**Observações:** 4 dos 6 exercícios apontam para bufferoverflowprep — problema de monocultura. Exercício 1-2 e 4-5 são todos BO-focused. Falta Ghidra específico (o lab.bufferoverflowprep não é sobre Ghidra), malware analysis, e reversing de binários reais. OverTheWire Leviathan e PicoCTF RE não estão nos labs existentes.

---

## Labs Candidatos Novos

| # | Lab/Sala | Plataforma | URL | Tópico Coberto | Status Validação |
|:-:|:---------|:-----------|:----|:---------------|:-----------------|
| 1 | Ghidra | TryHackMe | https://tryhackme.com/room/ghidra | Descompilação com Ghidra | ⏳ Pendente (rate-limit THM) |
| 2 | Reverse Engineering | TryHackMe | https://tryhackme.com/room/reverseengineer | RE completo | ⏳ Pendente (rate-limit THM) |
| 3 | Leviathan (8 levels) | OverTheWire | ssh://leviathan.labs.overthewire.org:2223 | RE básico (ltrace, strace, gdb) | ✅ Ativo |
| 4 | Reverse Engineering (40+) | PicoCTF | https://play.picoctf.org/practice | RE CTF challenges | ⏳ Pendente |

**Nota:** OverTheWire Leviathan é IDEAL para RE iniciante — 8 níveis progressivos usando ltrace, strace, gdb, sem necessidade de programação avançada. PicoCTF RE complementa com desafios CTF.

---

## Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|:-------|:-------------|:-----------|:--------------|
| Malware Analysis (estática + dinâmica) | CEH v13 Módulo 07 | Importante | Não coberto nos labs |
| YARA (pattern matching para malware) | CEH + Defesa | Importante | Padrão da indústria |
| Android RE (APK decompilation) | CEH v13 Módulo 17 | Opcional | Apenas CEH |
| Debugging avançado (x64dbg, OllyDbg) | CEH | Importante | Windows debugging não coberto |
| Anti-analysis techniques (packing, obfuscation) | CEH | Opcional | Técnicas de evasão |
| Assembly language basics | OSCP (indireto) | Importante | Fundamento para RE |
| File format analysis (PE, ELF headers) | OSCP (indireto) | Importante | Coberto parcialmente no exercício 1 |
| strings, hexdump, objdump avançado | OSCP | Importante | Ferramentas básicas não aprofundadas |

**Prioridade:** Crítico = presente em OSCP; Importante = presente em Security+; Opcional = apenas CEH

---

## Resumo

- Labs existentes: 6 (validados: 0, pendentes: 6 — rate-limit THM)
- Labs candidatos novos: 4 (2 THM + 1 OTW + 1 PicoCTF)
- Tópicos ausentes: 8 (críticos: 0, importantes: 6)
- Plataformas com cobertura: TryHackMe (4 rooms), OverTheWire (Leviathan 8 níveis), PicoCTF (40+ challenges)
- Plataformas com cobertura limitada: PortSwigger (não tem labs de RE), HackTheBox (não tem labs de RE)
- **Recomendação:** OverTheWire Leviathan deve ser a plataforma primária para RE iniciante. Adicionar Ghidra específico (THM ghidra room) e malware analysis (YARA, análise estática/dinâmica). PicoCTF RE complementa com desafios progressivos.
