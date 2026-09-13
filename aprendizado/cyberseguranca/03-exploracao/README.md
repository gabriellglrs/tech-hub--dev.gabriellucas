# 🎯 Módulo 3: Exploração

> Do brute force ao buffer overflow — ganhe acesso, quebre senhas, exploite serviços e mantenha persistência.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 12-15 horas | ⭐⭐⭐ Intermediário/Avançado | 11 | 20+ |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Preparar wordlists customizadas (SecLists, Crunch, CeWL)
- [ ] Enumerar usuários e verificar password policies (enum4linux-ng, NetExec)
- [ ] Executar brute force e password spraying (Hydra, Medusa, NetExec)
- [ ] Identificar e explorar vetores de credential stuffing e reuso
- [ ] Explorar serviços de rede (SMB, FTP, SSH, RDP, VNC, NFS)
- [ ] Executar Pass-the-Hash com Impacket e NetExec
- [ ] Fazer poisoning LLMNR/NBT-NS e relay NTLM (Responder, ntlmrelayx)
- [ ] Usar Metasploit avançado (auxiliary scanners, resource scripts, multi-handler)
- [ ] Gerar payloads customizados com msfvenom
- [ ] Fazer reverse shells manuais e estabilizar shells
- [ ] Executar buffer overflow básico em x86 (Immunity Debugger + mona.py)
- [ ] Enumerar e explorar SNMP (onesixtyone, snmpwalk, snmpset)

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico (terminal, permissões) | Sim | Módulo 00 |
| Redes (TCP/IP, portas, protocolos) | Sim | Módulo 00 |
| Nmap básico | Sim | Módulo 01 |
| Burp Suite e web apps básico | Recomendado | Módulo 02 |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────────────────┐
│                        EXPLORAÇÃO                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  1. PREPARAÇÃO                                              │    │
│  │  01 → Wordlists: SecLists, Crunch, CeWL                    │    │
│  └──────────────────────────┬──────────────────────────────────┘    │
│                             ▼                                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  2. ENUMERAÇÃO                                              │    │
│  │  02 → Usuários, escopo, pass-pol (enum4linux-ng, NetExec)  │    │
│  └──────────────────────────┬──────────────────────────────────┘    │
│                             ▼                                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  3. ATAQUE DE CREDENCIAIS                                   │    │
│  │  03 → Brute force & spraying (Hydra, Medusa, NetExec)      │    │
│  │  04 → Credential stuffing & reuso cross-service             │    │
│  └──────────────────────────┬──────────────────────────────────┘    │
│                             ▼                                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  4. EXPLORAÇÃO DE SERVIÇOS                                  │    │
│  │  05 → SMB, FTP, SSH, RDP, VNC, NFS (EternalBlue, BlueKeep) │    │
│  │  06 → Pass-the-Hash & Impacket (secretsdump, psexec)        │    │
│  └──────────────────────────┬──────────────────────────────────┘    │
│                             ▼                                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  5. ATAQUES DE REDE                                         │    │
│  │  07 → NTLM Relay & Responder (LLMNR, ntlmrelayx, mitm6)   │    │
│  └──────────────────────────┬──────────────────────────────────┘    │
│                             ▼                                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  6. FRAMEWORKS & PAYLOADS                                   │    │
│  │  08 → Metasploit avançado & msfvenom (auxiliary, .rc)       │    │
│  │  09 → Shells manuais (reverse/bind, Python PTY, socat)     │    │
│  └──────────────────────────┬──────────────────────────────────┘    │
│                             ▼                                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  7. EXPLOITAÇÃO AVANÇADA                                    │    │
│  │  10 → Buffer overflow x86 (Vulnserver, Immunity, mona.py)  │    │
│  │  11 → SNMP enum & exploitation (onesixtyone, snmpset)       │    │
│  └─────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 01 | [01-preparacao-e-wordlists.md](01-preparacao-e-wordlists.md) | SecLists, Crunch, CeWL — wordlists por cenário | `seclists, crunch, cewl` | 40min |
| 02 | [02-reconhecimento-de-usuarios-e-escopo.md](02-reconhecimento-de-usuarios-e-escopo.md) | Enumeração de usuários, password policy, escopo | `enum4linux-ng, smbclient, rpcclient, kerbrute, ldapsearch, nxc` | 50min |
| 03 | [03-brute-force-e-spraying.md](03-brute-force-e-spraying.md) | Brute force, password spraying, cracking de hashes | `hydra, medusa, ncrack, john, hashcat, nxc` | 60min |
| 04 | [04-credential-stuffing-e-reuso.md](04-credential-stuffing-e-reuso.md) | Credential stuffing, reuso cross-service, admin panels | `hydra, nxc, burp` | 35min |
| 05 | [05-exploracao-de-servicos-de-rede.md](05-exploracao-de-servicos-de-rede.md) | Exploração SMB, FTP, SSH, RDP, VNC, NFS | `nxc, smbclient, xfreerdp, msfconsole` | 60min |
| 06 | [06-pass-the-hash-e-impacket.md](06-pass-the-hash-e-impacket.md) | Pass-the-Hash, secretsdump, psexec/wmiexec/smbexec | `nxc, secretsdump.py, psexec.py, wmiexec.py` | 50min |
| 07 | [07-ntlm-relay-e-responder.md](07-ntlm-relay-e-responder.md) | LLMNR/NBT-NS poisoning, NTLM relay, ADCS abuse | `responder, ntlmrelayx.py, mitm6` | 80min |
| 08 | [08-metasploit-e-msfvenom.md](08-metasploit-e-msfvenom.md) | Auxiliary scanners, resource scripts, msfvenom, handlers | `msfconsole, msfvenom, searchsploit` | 90min |
| 09 | [09-exploracao-manual-e-payloads.md](09-exploracao-manual-e-payloads.md) | Reverse/bind shells em 6 linguagens, estabilização de shell | `python, php, bash, nc, socat, rlwrap` | 50min |
| 10 | [10-buffer-overflow-basico.md](10-buffer-overflow-basico.md) | x86 registers, stack, Vulnserver TRUN exploit | `immunity, mona.py, pattern_create, msfvenom` | 90min |
| 11 | [11-snmp-enum-e-exploitation.md](11-snmp-enum-e-exploitation.md) | SNMP v1/v2c/v3, enumeração, escrita de configs | `onesixtyone, snmpwalk, snmp-check, nxc` | 45min |

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Rodar rockyou.txt sem motivo | Horas de processamento | Comece com Top1000.txt, escale só se necessário |
| Não verificar `--pass-pol` antes de spray | Contas bloqueadas | Sempre verifique lockout threshold primeiro |
| Hydra com `-t 64` em SSH | Falsos positivos, rate-limiting | Use `-t 4` para SSH |
| Não identificar formato do hash | Perda de tempo tentando modos errados | Rode `john --list=formats` ou `hashid` primeiro |
| Usar encoder para evadir EDR | EDRs modernos usam análise comportamental | Encoders servem para remoção de bad chars, não evasão |
| Pular labs de binário | Não compreende stacks/overflows | Faça Narnia/PicoCTF antes de avançar |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — Labs organizados por arquivo, com comandos reais e links diretos

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| HackTricks — Brute Force | Ref | [book.hacktricks.xyz](https://book.hacktricks.xyz/generic-methodologies-and-resources/brute-force) |
| PayloadsAllTheThings | Ref | [github.com/swisskyrepo](https://github.com/swisskyrepo/PayloadsAllTheThings) |
| NetExec Wiki | Ref | [netexec.wiki](https://www.netexec.wiki/) |
| Metasploit Unleashed | Ref | [offsec.com](https://www.offsec.com/metasploit-unleashed/) |
| Exploit-DB | Ref | [exploit-db.com](https://www.exploit-db.com/) |
| Hashcat Example Hashes | Ref | [hashcat.net](https://hashcat.net/wiki/doku.php?id=example_hashes) |
| GTFOBins | Ref | [gtfobins.github.io](https://gtfobins.github.io/) |
| LOLBAS | Ref | [lolbas-project.github.io](https://lolbas-project.github.io/) |

---

## ✅ Checklist do Módulo

- [ ] Li todos os 11 arquivos
- [ ] Instalei e verifiquei todas as ferramentas
- [ ] Completei os labs práticos (pelo menos 8 de 12)
- [ ] Consigo explicar quando usar cada ferramenta
- [ ] Sei a diferença entre brute force e password spraying
- [ ] Consigo fazer Pass-the-Hash e NTLM relay
- [ ] Consigo gerar payloads com msfvenom e configurar handlers
- [ ] Consigo fazer um buffer overflow básico em x86

---

<div align="center">

**⬅️ [Módulo 2: Web & Aplicações](../02-web-aplicacoes/)** | **[Módulo 4: Pós-Exploração](../04-pos-exploracao/) ➡️**

</div>
