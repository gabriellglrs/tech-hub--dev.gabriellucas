# 🔬 Módulo 6: Engenharia Reversa

> **"Para derrotar o inimigo, você precisa entender como ele pensa."**

---

## 📋 Informações do Módulo

| 📊 Detalhe | 📝 Valor |
|:---|:---|
| ⏱️ **Tempo Estimado** | 6-8 horas |
| 🎯 **Nível** | ⭐⭐⭐ Avançado |
| 📁 **Arquivos** | 2 |
| 🔧 **Ferramentas** | 7 principais |
| 📚 **Pré-requisitos** | C básico, conceitos de memória, Assembly básico |

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Analisar binários ELF e identificar vulnerabilidades
- [ ] Decomilar programas usando Ghidra e radare2
- [ ] Depurar aplicações com GDB/GEF
- [ ] Identificar proteções de binários (NX, PIE, Canary, RELRO)
- [ ] Criar exploits para buffer overflow
- [ ] Usar pwntools para automação de exploits
- [ ] Montar gadgets ROP para bypass de proteções

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                    🔬 ENGENHARIA REVERSA                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │  ANÁLISE     │───▶│  DECOMPILAÇÃO│───▶│  EXPLOIT     │      │
│  │  ESTÁTICA    │    │  & DEBUG     │    │  DEVELOPMENT │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │ file         │    │ Ghidra       │    │ pwntools     │      │
│  │ strings      │    │ radare2      │    │ ropper       │      │
│  │ checksec     │    │ GDB/GEF      │    │ ROPgadget    │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Arquivos do Módulo

| # | Arquivo | Conteúdo | Ferramentas |
|:-:|:--------|:---------|:------------|
| 1 | [01-engenharia-reversa.md](01-engenharia-reversa.md) | Análise estática e dinâmica de binários | `Ghidra` `radare2` `GDB/GEF` `checksec` |
| 2 | [02-exploit-e-fuzzing.md](02-exploit-e-fuzzing.md) | Criação de exploits e fuzzing automático | `pwntools` `ropper` `ROPgadget` |

---

## 🔧 Ferramentas Utilizadas

```
┌─────────────────────────────────────────────────────────────┐
│                    FERRAMENTAS DO MÓDULO                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📊 ANÁLISE ESTÁTICA          🐛 DEBUG/DINÂMICA             │
│  ├── Ghidra (NSA)             ├── GDB + GEF                 │
│  ├── radare2                  └── strace/ltrace              │
│  └── checksec                                               │
│                                                              │
│  💥 EXPLOIT                     🔧 UTILITÁRIOS               │
│  ├── pwntools                  ├── ropper                    │
│  └── ROPgadget                 └── nasm                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 💡 Dicas de Ouro

### ⚡ Dica 1: Sempre comece pela triagem
```bash
# Antes de abrir qualquer ferramenta pesada:
file programa           # Identifica tipo do binário
strings programa        # Mostra strings legíveis
checksec --file=programa # Mostra proteções
```

### ⚡ Dica 2: Ghidra é seu melhor amigo (e é grátis)
- Decompilador da NSA, tão bom quanto IDA Pro
- Suporta múltiplas arquiteturas
- Interface gráfica amigável para iniciantes

### ⚡ Dica 3: GDB + GEF = Superpoder
```bash
# Instale o GEF para uma experiência melhor
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
```

### ⚡ Dica 4: pwntools automatiza tudo
```python
from pwn import *
p = remote("target.com", 1337)
# ou
p = process("./vuln")
```

---

## ⚠️ Erros Comuns (e como evitar)

| ❌ Erro | ✅ Solução | 💬 Por quê? |
|:--------|:----------|:------------|
| Pular direto para o Ghidra | Sempre faça triagem primeiro | `file`, `strings` e `checksec` economizam tempo |
| Não entender o que o programa faz | Leia strings e fluxo básico | Explorar sem entender é caça às cegas |
| Ignorar as proteções | Rode `checksec` sempre | NX, PIE, Canary mudam completamente a abordagem |
| Copiar exploits sem entender | Estude cada byte do payload | CTFs e alvos reais são diferentes |
| Não usar VM isolada | Use VMware/VirtualBox com snapshot | Binários podem ser maliciosos |

---

## 🧪 Labs Recomendados

### 🟢 Iniciante
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Buffer Overflow Prep | TryHackMe | Buffer overflow básico | [Acessar](https://tryhackme.com/room/bufferoverflowoverflow) |
| Reverse Engineering | TryHackMe | Fundamentos de RE | [Acessar](https://tryhackme.com/room/rer2) |

### 🟡 Intermediário
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Narnia | VulnHub | Buffer overflow real | [Acessar](https://www.vulnhub.com/entry/narnia-1,226/) |
| Protostar | VulnHub | Stack exploitation | [Acessar](https://www.vulnhub.com/entry/protostar-stack0,49/) |

### 🔴 Avançado
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| ROP Emporium | ROP Emporium | ROP chains | [Acessar](https://ropemporium.com/) |
| Pwn Challenge | PicoCTF | Pwn avançado | [Acessar](https://picoctf.org/) |

---

## ✅ Checklist de Conclusão

Antes de avançar para o próximo módulo, verifique:

- [ ] Consigo identificar o tipo de binário com `file`
- [ ] Consigo extrair strings relevantes com `strings`
- [ ] Consigo analisar proteções com `checksec`
- [ ] Consigo navegar em um binário no Ghidra
- [ ] Consigo usar GDB/GEF para depurar um programa
- [ ] Consigo identificar um buffer overflow
- [ ] Consigo criar um exploit básico com pwntools
- [ ] Consigo montar um gadget ROP simples
- [ ] Completei pelo menos 2 labs deste módulo

---

## 🔗 Navegação

```
┌─────────────────────────────────────────────────────────────────┐
│                      🗺️ MAPA DA TRILHA                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ◀── Módulo 5: Pós-Exploração                                  │
│       │                                                         │
│       ▼                                                         │
│  ┌─────────────────────────────────────────┐ ◀── VOCÊ ESTÁ AQUI │
│  │  📌 Módulo 6: Engenharia Reversa       │                   │
│  │     01-engenharia-reversa.md           │                   │
│  │     02-exploit-e-fuzzing.md            │                   │
│  └─────────────────────────────────────────┘                   │
│       │                                                         │
│       ▼                                                         │
│  Módulo 7: Defesa e Hardening ──▶                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**⬅️ Anterior:** [Módulo 5: Pós-Exploração](../05-pos-exploracao/)
**➡️ Próximo:** [Módulo 7: Defesa e Hardening](../07-defesa/)

---

## 📖 Referências

- 📘 [Ghidra Book - Documentação Oficial](https://ghidra-sre.org/)
- 📗 [PwnTools Documentation](https://docs.pwntools.com/)
- 📙 [GDB Documentation](https://www.sourceware.org/gdb/documentation/)
- 📕 [radare2 Book](https://book.rada.re/)
- 🌐 [TryHackMe - Reverse Engineering](https://tryhackme.com/room/rer2)
- 🌐 [ROP Emporium](https://ropemporium.com/)

---

> **⏱️ Tempo estimado:** 6-8 horas | **🎯 Nível:** ⭐⭐⭐ Avançado | **📁 Próximo:** Módulo 7
