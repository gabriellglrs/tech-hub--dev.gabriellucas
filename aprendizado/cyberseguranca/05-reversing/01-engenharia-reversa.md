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
# Ghidra (pré-instalado no Kali)
ls /opt/ghidra/
# ghidraRun  ghidra supporting files

# GDB + GEF
sudo apt install -y gdb
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Radare2
sudo apt install -y radare2

# checksec
sudo apt install -y checksec
```

---

## Tool Card: Triagem de Binários (file/strings/readelf)

**O que é:** Primeira etapa de qualquer análise de binário — identificar tipo, arquitetura e conteúdo.

### 🎯 Quando usar Triagem de Binários
- Você recebeu um binário desconhecido e precisa saber o que é (ELF, PE, shellcode)
- Antes de qualquer análise reversa, é obrigatório identificar arquitetura (x86, x64, ARM)
- Precisa descobrir se o binário tem proteções (NX, PIE, canary) antes de testar vulnerabilidades
- Está investigando malware e precisa classificar o tipo de arquivo rapidamente

### 🛠️ Como Triagem de Binários te ajuda
- `file` identifica formato e arquitetura em segundos, evitando perda de tempo
- `strings` revela senhas hardcoded, URLs, chaves API e mensagens de debug escondidas
- `readelf` mostra seções ELF, simbolos e dependências para mapear o binário
- `checksec` revela proteções de segurança que definem sua estratégia de ataque

### ➡️ Depois de usar Triagem de Binários — Próximos passos
1. Com base no tipo (ELF/PE), escolha a ferramenta de análise: Ghidra para decompilação, GDB para debug dinâmico
2. Se `checksec` mostrar NX enabled, explore ROP em vez de shellcode na stack
3. Use strings encontradas como entrada para Ghidra — busque referências cruzadas
4. Documente tipo, arquitetura e proteções antes de prosseguir para análise estática ou dinâmica

### file — Identificar tipo do binário

```bash
file /bin/ls
# OUTPUT ESPERADO:
# /bin/ls: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), ...

# Para binário malicioso:
file suspicious.exe
# OUTPUT ESPERADO:
# suspicious.exe: PE32+ executable (GUI) x86-64, for MS Windows
```

### strings — Extrair strings legíveis

```bash
# Extrair todas as strings
strings /bin/ls | head -20
# OUTPUT ESPERADO:
# /lib64/ld-linux-x86-64.so.2
# libc.so.6
# __libc_start_main
# GLIBC_2.2.5
# ...

# Buscar senhas ou chaves
strings programa | grep -i "password\|key\|secret\|admin"
# OUTPUT ESPERADO:
# password=admin123
# api_key=sk-1234567890abcdef

# Contar strings
strings /bin/ls | wc -l
# OUTPUT ESPERADO:
# 342
```

### readelf — Informações do ELF

```bash
# Cabeçalho ELF
readelf -h /bin/ls
# OUTPUT ESPERADO:
# ELF Header:
#   Magic:   7f 45 4c 46 02 01 01 00 ...
#   Class:                             ELF64
#   Data:                              2's complement, little endian
#   Machine:                           Advanced Micro Devices X86-64
#   Type:                              DYN (Shared object file)

# Seções
readelf -S /bin/ls | head -15
# OUTPUT ESPERADO:
# Section Headers:
#   [Nr] Name              Type             Address           Offset
#   [ 0]                   NULL             0000000000000000  00000000
#   [ 1] .interp           PROGBITS         00000000000002a0  000002a0
#   [ 2] .note.gnu.prop    NOTE             00000000000002c0  000002c0
```

### checksec — Verificar proteções

```bash
checksec --file=/bin/ls
# OUTPUT ESPERADO:
# RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      Symbols
# Full RELRO      Canary found      NX enabled    PIE enabled     No RPATH   No RUNPATH   No Symbols

# O que procurar:
# RELRO: Full > Partial > No (proteção contra overwrite de GOT)
# CANARY: Found > Not Found (proteção contra stack overflow)
# NX: Enabled > Disabled (não-execução da stack)
# PIE: Enabled > Disabled (ASLR no binário)
```

---

## Tool Card: Ghidra

**O que é:** Decompiler open-source da NSA — transforma binário em código C aproximado. Interface gráfica.

### 🎯 Quando usar o Ghidra
- Precisa entender a lógica de um binário sem código fonte (malware, crackme, CTF)
- Encontrou uma função suspeita e quer ver o que ela faz em código C
- Está analisando vulnerabilidade e precisa localizar buffer overflow ou format string
- Quer mapear chamadas de sistema e fluxo de execução do programa

### 🛠️ Como o Ghidra te ajuda
- Decompila binário para código C aproximado, muito mais legível que assembly
- Permite renomear funções e variáveis para documentar o que cada parte faz
- Cross-references mostram onde cada string e função é usada no programa
- Interface gráfica facilita navegação entre Listing (assembly) e Decompiler (C)

### ➡️ Depois de usar o Ghidra — Próximos passos
1. Identifique funções perigosas: `strcpy`, `gets`, `sprintf`, `system` — são vetores de vulnerabilidade
2. Use GDB/GEF para debug dinâmico das funções encontradas no Ghidra
3. Crie um mapa das chamadas de sistema para entender interações com SO
4. Se encontrar vulnerabilidade, crie exploit com pwntools baseado no código descompilado

### Iniciar Ghidra

```bash
# No Kali, executar:
/opt/ghidra/ghidraRun

# OUTPUT ESPERADO:
# INFO  Using log file: /home/user/.ghidra/.ghidra_11.0/application.log
# INFO  Launching Ghidra...
```

### Tutorial passo a passo

```
1. Criar novo projeto:
   File → New Project → Non-Shared Project → Next
   Nome: "Analise-Reversa" → Finish

2. Importar binário:
   File → Import File → selecionar binário
   Format: Executable and Linking Format (ELF) ou Portable Executable (PE)
   Options: Auto-analyze = ON
   OK

3. Abrir CodeBrowser (duplo-clique no binário na lista):
   → Janela principal com Decompiler, Listing, Functions

4. Navegar no CodeBrowser:
   Decompiler (à direita): código C aproximado
   Listing (à esquerda): assembly
   Functions (à esquerda): lista de todas as funções

5. Encontrar função main:
   Pressione "G" → digite "main" → Enter
   → Decompiler mostra o código C da função main

6. Renomear variáveis:
   Clique direito no parâmetro → Rename Global
   → Dê nomes descritivos (usuario, senha, resultado)

7. Adicionar comentários:
   Clique direito → Set Comment
   → Documente o que cada trecho faz

8. Cross-references:
   Clique direito em uma string → References → Show References To
   → Veja onde a string é usada no programa

9. Buscar strings sensíveis:
   Window → Defined Strings
   → Filtre por "password", "key", "admin"

10. Salvar projeto:
    File → Save Project (Ctrl+S)
```

### O que procurar no Ghidra

| Padrão | O que significa | Ação |
|:-------|:----------------|:-----|
| `strcpy`, `gets`, `sprintf` | Buffer overflow | Criar exploit de overflow |
| `%x`, `%s`, `%n` | Format string | Testar format string vuln |
| `system("/bin/sh")` | Shell oculta | Pode ser backdoor |
| `ptrace` | Anti-debug | Precisa bypass |
| `strcmp` com string fixa | Senha hardcoded | Quebrar comparação |

---

## Tool Card: GDB + GEF

**O que é:** GNU Debugger — executa binário passo a passo, inspeciona memória, registradores e variáveis. GEF adiciona interface visual.

### 🎯 Quando usar o GDB + GEF
- Precisa executar binário passo a passo para entender comportamento em tempo real
- Quer inspecionar stack, heap e registradores durante execução
- Está debugando exploit e precisa ver se buffer overflow sobrescreveu return address
- Encontrou vulnerabilidade no Ghidra e quer confirmar dinamicamente

### 🛠️ Como o GDB + GEF te ajuda
- Breakpoints em endereços específicos pausam execução para inspeção
- `info registers` e `x/20x $rsp` mostram estado exato da CPU e memória
- GEF adiciona visualização gráfica da stack, heap e código Assembly
- `disassemble` mostra código máquina traduzido para Assembly legível

### ➡️ Depois de usar o GDB + GEF — Próximos passos
1. Documente offsets encontrados: quantos bytes até return address, até variáveis de controle
2. Calcule endereço de shellcode ou ROP gadgets com base nos offsets mapeados
3. Crie exploit com pwntools usando os endereços e offsets do GDB
4. Teste exploit em ambiente isolado — nunca em produção ou redes não autorizadas

### Comandos essenciais

```bash
# Iniciar GDB com binário
gdb ./binary

# OUTPUT ESPERADO:
# GNU gdb (Ubuntu 13.1-3ubuntu2.1) 13.1
# Reading symbols from ./binary...
# (gdb)
```

### Comandos de GDB

| Comando | O que faz | Output esperado |
|:--------|:----------|:----------------|
| `break main` | Breakpoint no main | Breakpoint 1 at 0x... |
| `break *0x401000` | Breakpoint em endereço | Breakpoint 2 at 0x401000 |
| `run` | Executar programa | Starting program: ./binary |
| `continue` | Continuar até próximo breakpoint | Continuing... |
| `stepi` | Executar 1 instrução | 0x401005 in main () |
| `nexti` | Pular chamada de função | 0x401008 in main () |
| `info registers` | Ver registradores | rax=0x0 rbx=0x7fff... |
| `x/20x $rsp` | Ver 20 words na stack | 0x7fffffffe000: 0x00000001 0x00000000 ... |
| `x/s 0x402000` | Ver string em endereço | 0x402000: "password" |
| `print $rax` | Ver valor do registrador | $1 = 0x0 |
| `disassemble main` | Ver assembly do main | Dump of assembler code for main |
| `backtrace` | Ver chamadas de função | #0 main () at binary.c:10 |
| `quit` | Sair do GDB | (gdb) |

### Exemplo completo de debug

```bash
gdb ./binary
(gdb) break main
Breakpoint 1 at 0x401136
(gdb) run
Starting program: /home/user/binary

Breakpoint 1, 0x0000555555555136 in main ()
(gdb) info registers rdi rsi
rdi            0x1                 1
rsi            0x7fffffffe188     140737488347528
(gdb) x/s $rsi
0x7fffffffe188: "./binary"
(gdb) stepi
0x000055555555513a in main ()
(gdb) x/10x $rsp
0x7fffffffe060: 0x00000001 0x00000000 0xf7fc3000 0x00000000
0x7fffffffe070: 0x00000000 0x00000000 0xf7e1e083 0x00007fff
```

### Instalar GEF

```bash
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
# OUTPUT ESPERADO:
# [*] Searching for GEF dependencies
# [*] Installing GEF...
# [*] Done!
# [*] Run 'gdb' to start using GEF
```

---

## Tool Card: x64dbg (Referência Windows)

**O que é:** Debugger open-source para Windows — equivalente ao GDB para Windows. Usado em labs HTB/THM com binários PE.

### 🎯 Quando usar o x64dbg
- Precisa debugar binários Windows (.exe, .dll) em ambiente de pentest
- Está fazendo labs HTB/THM que exigem análise de executáveis PE
- Quer analisar malware Windows dinamicamente, observando chamadas de API
- Precisa de breakpoints, step-by-step e inspeção de memória em Windows

### 🛠️ Como o x64dbg te ajuda
- Interface visual para ver registradores, stack, memória e código assembly em tempo real
- F7 (Step Into) e F8 (Step Over) permitem navegar código função por função
- Breakpoints (F2) pausam execução em pontos críticos para inspeção
- Follow in Dump (Ctrl+G) mostra conteúdo de memória em hex e ASCII

### ➡️ Depois de usar o x64dbg — Próximos passos
1. Identifique offsets e endereços de retorno do binário Windows
2. Use informações para montar exploit ou payload em ferramentas como Metasploit
3. Documente chamadas de API suspeitas (CreateFile, WriteProcessMemory) se analisar malware
4. Se encontrar vulnerabilidade, relate responsibly ou use em lab autorizado

### Instalação

```
# Download: https://x64dbg.com/
# Não instalar no Kali — usar em VM Windows ou para referência

# Na VM Windows:
# 1. Baixar x64dbg.zip
# 2. Extrair e executar x96dbg.exe
# 3. Abrir binário: File → Open → selecionar .exe
```

### Comandos essenciais

| Comando | Tecla | O que faz |
|:--------|:------|:----------|
| Run | F9 | Executar programa |
| Step Into | F7 | Entrar em chamada de função |
| Step Over | F8 | Pular chamada de função |
| Breakpoint | F2 | Colocar breakpoint |
| Follow in Dump | Ctrl+G | Ver memória |
| Comments | Ctrl+; | Adicionar comentário |

### Quando usar x64dbg

- Labs HTB com binários Windows (PE)
- Análise de malware Windows
- Reverse engineering de aplicativos .exe

---

## Tool Card: AFL++ (Fuzzing)

**O que é:** American Fuzzy Lop Plus Plus — ferramenta de fuzzing que gera entradas aleatórias para encontrar crashes.

### 🎯 Quando usar o AFL++
- Precisa encontrar vulnerabilidades em binários de forma automatizada
- Quer testar robustez de programa antes de deploy ou durante auditoria de segurança
- Está fazendo CTF e precisa achar crashes em binários desconhecidos
- Quer descobrir bugs em software proprietário sem código fonte

### 🛠️ Como o AFL++ te ajuda
- Gera milhares de entradas aleatórias por segundo para testar caminhos do programa
- Detecta crashes automaticamente e salva inputs causadores em `output/crash*`
- Métricas mostram cobertura de código (unique paths) e estabilidade do binário
- Ferramentas auxiliares (afl-gcc) instrumentam binário para rastrear execução

### ➡️ Depois de usar o AFL++ — Próximos passos
1. Analise cada crash com GDB: `gdb ./fuzzy < output/crash-xxx` para ver registradores e stack
2. Identifique tipo de vulnerabilidade: buffer overflow, NULL pointer, integer overflow
3. Crie exploit reproduzindo o crash com inputs controlados
4. Documente CVE/bug encontrado com PoC (Proof of Concept) para relatório

### Instalação

```bash
sudo apt install -y afl++
```

### Uso básico

```bash
# Compilar binário para fuzzing
afl-gcc -o fuzzy program.c

# Criar diretório de input/output
mkdir input output

# Seed inicial
echo "test" > input/seed.txt

# Rodar fuzzing
afl-fuzz -i input/ -o output/ ./fuzzy

# OUTPUT ESPERADO:
# american fuzzy lop++ 4.01a
# ┌─ Process timing ──────────────────────────┐
# │        run time : 0 days, 0 hrs, 2 min    │
# │   executions : 123456                      │
# │      harvest : 12000 unique paths          │
# │   stability : 100.00%                      │
# │        crashes : 3                         │
# └────────────────────────────────────────────┘
```

### O que procurar

| Métrica | O que significa |
|:--------|:----------------|
| `crashes > 0` | Encontrou bugs! |
| `executions` | Quantas entradas testou |
| `stability` | Se é 100%, o binário é determinístico |
| `unique paths` | Quantos caminhos diferentes explorou |

### Analisar crashes

```bash
# Listar crashes encontrados
ls output/crash*
# crash-abc123  crash-def456

# Reproduzir crash
./fuzzy < output/crash-abc123

# Se causar segmentation fault, analisar com GDB:
gdb ./fuzzy
(gdb) run < output/crash-abc123
# Program received signal SIGSEGV
# Verificar registradores e stack para entender o overflow
```

---

## Tool Card: pwntools

**O que é:** Biblioteca Python para criar exploits — simplifica interação com binários, sockets, e payloads.

### 🎯 Quando usar o pwntools
- Precisa automatizar exploração de vulnerabilidades (buffer overflow, format string)
- Quer criar exploit interativo para CTFs ou labs de pentest
- Precisa interagir com binário via rede (CTF remoto) ou local
- Vai desenvolver payloads customizados e testar exploits de forma reprodutível

### 🛠️ Como o pwntools te ajuda
- `process()` e `remote()` simplificam conexão com binário local ou remoto
- `sendline()`, `recv()`, `interactive()` facilitam troca de dados com programa
- Funções de packing (`p64`, `p32`) convertem endereços para formato correto
- Templates prontos aceleram criação de exploits para CTFs e labs

### ➡️ Depois de usar o pwntools — Próximos passos
1. Teste exploit em ambiente isolado (VM ou container) — nunca em produção
2. Documente offsets, gadgets e payload usado para reutilização futura
3. Se exploit funcionou, crie versão payloads para payloads específicos (reverse shell, bind shell)
4. Submeta resultado em plataforma de CTF ou documente para relatório de pentest

### Instalação

```bash
pip3 install pwntools
```

### Template de exploit

```python
#!/usr/bin/env python3
# exploit.py — Template básico de exploit com pwntools

from pwn import *

# Conectar ao binário local
p = process('./binary')

# Conectar via rede (CTF)
# p = remote('challenge.ctf.com', 1337)

# Enviar payload
payload = b'A' * 64  # 64 bytes para preencher buffer
payload += b'\x41\x42\x43\x44'  # Sobrescrever return address

p.sendline(payload)

# Ver output
print(p.recvline())
# OUTPUT ESPERADO:
# b'Program started\n'

# Para binário interativo
p.interactive()
```

### Funções principais

| Função | O que faz |
|:-------|:----------|
| `process('./bin')` | Executar binário local |
| `remote('ip', port)` | Conectar via rede |
| `p.sendline(data)` | Enviar dados + newline |
| `p.send(data)` | Enviar dados sem newline |
| `p.recv(n)` | Receber n bytes |
| `p.recvline()` | Receber 1 linha |
| `p.recvuntil(b'x')` | Receber até encontrar 'x' |
| `p.interactive()` | Modo interativo |

---

## Ferramentas

| Ferramenta | Tipo | Grátis? |
|:---|:---|:---|
| **Ghidra** | Decompiler | ✅ NSA open-source |
| **radare2 / rizin** | Framework RE | ✅ |
| **IDA Free** | Disassembler | Parcial |
| **Binary Ninja** | Decompiler | Pago |
| **x64dbg** | Debugger Windows | ✅ |
| **AFL++** | Fuzzing | ✅ |
| **pwntools** | Exploit dev | ✅ |

## Dicas

- Comece por `strings` e `ltrace/strace` antes de abrir no Ghidra
- Procure por funções perigosas: `gets, strcpy, sprintf, system`
- Use `checksec` antes de qualquer análise — proteções definem a estratégia
- GEF é muito melhor que GDB puro para visualização

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
