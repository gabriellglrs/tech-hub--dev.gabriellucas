# 🔬 Engenharia Reversa

> Transformar binário em código compreensível. Entender o que o programa faz sem código fonte.

---

## 📚 O que é Engenharia Reversa?

**Engenharia Reversa** é analisar um programa computador para entender **como ele funciona** por dentro, sem ter o código fonte. É como desmontar um relógio para ver como as engrenagens se encaixam.

### Por que isso é importante?

- Programas podem ter **malware escondido** que nenhum antivirus detecta
- Precisa entender vulnerabilidades em **nível de binário**
- É a base para criar **exploits avançados** (buffer overflow, ROP)
- Empresas querem saber **o que um software faz** antes de usar

### Como funciona na prática?

```
Programa compilado (binário)
        ↓
Ferramenta de análise (Ghidra, radare2)
        ↓
Código fonte aproximado (decompilado)
        ↓
Assembly (linguagem de máquina legível)
        ↓
Entender a lógica → Encontrar vulnerabilidade
```

### Ferramentas que você vai usar

| Ferramenta | Para que serve |
|:---|:---|
| **Ghidra** | Decompilar (ver código aproximado) |
| **radare2** | Análise no terminal |
| **GDB/GEF** | Debug (executar passo a passo) |
| **checksec** | Verificar proteções do binário |
| **pwntools** | Criar exploits em Python |

### Tipos de análise

| Tipo | O que faz | Quando usar |
|:---|:---|:---|
| **Estática** | Analisa sem executar | Primeiro contato |
| **Dinâmica** | Executa e monitora | Entender comportamento |
| **Descompilação** | Volta para código fonte | Entender lógica |
| **Debug** | Executa passo a passo | Encontrar bugs |

### ⚠️ Aviso

> Engenharia reversa **não é crime** quando feita em programas que você tem direito de analisar. Evite:
> - Software com DRM protegido por lei
> - Programas de terceiros sem autorização
> - Malware em produção (use ambiente isolado)

## Instalação das Ferramentas

```bash
sudo apt install -y ghidra radare2 gdb
# Ghidra: download de https://ghidra-sre.org/
# GEF para GDB: bash -c "$(curl -fsSL https://raw.githubusercontent.com/hugsy/gef/main/gef.sh)"
```

---

## 🚀 Passo a Passo

### Passo 1: Triagem
```bash
file binary
checksec --file=binary  # proteções: NX, PIE, Canary, RELRO
strings binary | grep -i "password\|admin"
rabin2 -I binary        # info do binário
```

### Passo 2: Desassembly (radare2 / r2)
```bash
sudo apt install -y radare2
r2 binary
# Dentro do r2:
aaa        # analisar tudo
afl        # listar funções
pdf @ main # disassembly do main
```

### Passo 3: Decompilação (Ghidra)
```bash
# Abrir no Ghidra → CodeBrowser → decompiler
# Procurar por: strcpy, gets, scanf (vulns), strings sensíveis
# Renomear variáveis, criar comentários
```

### Passo 4: Debug dinâmico (gdb + GEF)
```bash
sudo apt install -y gdb
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"  # GEF
gdb ./binary
gef> break main
gef> run
gef> telescope $rsp
gef> checksec
```

---

## Ferramentas

| Ferramenta | Tipo | Grátis? |
|:---|:---|:---|
| **ghidra** | Decompiler | ✅ NSA open-source |
| **radare2 / rizin** | Framework RE | ✅ |
| **ida free** | Disassembler | Parcial |
| **binary ninja** | Decompiler | Pago |
| **x64dbg** | Debugger Windows | ✅ |

## Dicas

- Comece por `strings` e `ltrace/strace` antes de abrir no Ghidra
- Procure por funções perigosas: `gets, strcpy, sprintf, system`

## Lab Prático

### Resumo da ordem — Por que essa sequência?

Reversing segue: **analisar → entender → modificar**.

```
PASSO 1: Identificar o binário → Saber o que está analisando
├── POR QUE: Tipo de binário define quais ferramentas usar
├── O QUE FAZER: file binário, checksec binário
├── COMANDO: file ./programa && checksec --file=./programa
├── O QUE PROCURAR: ELF/PE (executável), arquitetura (x86/x64), proteções (NX, PIE)
├── QUANDO AVANÇAR: Quando souber o tipo e arquitetura
└── DICAS: Se tiver NX, não pode executar shellcode na stack

        ↓

PASSO 2: Descompilar → Ver código fonte aproximado
├── POR QUE: Código fonte é mais fácil de entender que assembly
├── O QUE FAZER: Usar Ghidra ou radare2 para decompilar
├── FERRAMENTA: ghidra (GUI) ou r2 -A binário (terminal)
├── O QUE PROCURAR: Funções principais, strings, chamadas de sistema
├── QUANDO AVANÇAR: Quando entender a lógica do programa
└── DICAS: Procure por "main", "login", "check", "password"

        ↓

PASSO 3: Analisar assembly → Entender como funciona por baixo
├── POR QUE: Decompilador nem sempre mostra tudo, assembly é preciso
├── O QUE FAZER: Usar GDB/GEF ou radare2 para debugar
├── COMANDO: gdb ./programa (dentro: info functions, disassemble main)
├── O QUE PROCURAR: Chamadas de sistema, comparações, loops
├── QUANDO AVANÇAR: Quando encontrar vulnerabilidade (buffer overflow, format string)
└── DICAS: breakpoints em funções de verificação

        ↓

PASSO 4: Identificar vulnerabilidade → Achar o bug
├── POR QUE: Precisa saber O QUE explorar antes de criar exploit
├── TIPOS COMUNS: Buffer overflow, format string, use-after-free
├── O QUE PROCURAR: strcpy, sprintf, gets (overflow), %x (format string)
├── QUANDO AVANÇAR: Quando tiver vulnerabilidade confirmada
└── DICAS: Fuze para encontrar input que causa crash

        ↓

PASSO 5: Criar exploit → Explorar a vulnerabilidade
├── POR QUE: O objetivo final é ganhar controle do programa
├── O QUE FAZER: Sobrescrever return address ou controlar fluxo
├── FERRAMENTAS: pwntools (Python), ropper (ROP gadgets)
├── QUANDO PARAR: Quando conseguir executar comando arbitrário
└── ÉTICA: Só teste em binários que você tem autorização!
```

---

**Labs:**

1. **TryHackMe — Reversing: Basics** — Pratique triagem com `strings`, `file`, `checksec` e disassembly básico no radare2 em binários CTF.
   - https://tryhackme.com/room/reversingasics
2. **TryHackMe — Reverse Engineering: Malware** — Decompile binários no Ghidra, identifique funções perigosas e reconstrua a lógica do programa.
   - https://tryhackme.com/room/reverseengineeringmalware
3. **Crackmes.one** — Baixe binários de dificuldade crescente, pratique reversing estático e dinâmico sem dicas.
   - https://crackmes.one
