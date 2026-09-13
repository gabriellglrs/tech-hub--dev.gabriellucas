# AUDITORIA-03.md — Módulo 03-Exploração

**Data:** 2026-09-12
**Escopo:** Auditoria técnica do módulo 03-exploração contra padrão-ouro dos módulos 00/01/02
**Método:** Leitura de todos os arquivos existentes + pesquisa externa (HackTricks, Exploit-DB, Metasploit docs, TryHackMe, HackTheBox, PayloadsAllTheThings, GTFOBins)

---

## 1. Resumo do que os módulos 00/01/02 já cobrem (relevante para exploração)

### Módulo 00 — Pré-requisitos
- Redes (IP, DNS, portas, protocolos, TCP/IP, OSI)
- Linux básico (terminal, permissões, processos, systemctl)
- HTTP/HTTPS (métodos, status codes, cookies, APIs REST)
- VirtualBox e configuração de VMs
- Conceitos de segurança (CIA, ética, legalidade)
- Comandos de rede (whois, nmap básico) e editores (nano, vim)

**Relevância para exploração:** Base sólida — o aluno já entende rede, protocolos e ambiente Linux antes de chegar em exploração.

### Módulo 01 — Reconhecimento
- DNS e enumeração (whois, dig, nmap, masscan, subfinder, httpx)
- OSINT e subdomínios (theHarvester, Maltego, Recon-ng, SpiderFoot)
- Google dorking e certificate transparency (crt.sh, Censys, FOFA)
- Fingerprinting web (WhatWeb, Wappalyzer, wafw00f, Nikto, WPScan)
- Discovery de conteúdo (Gobuster, ffuf, Wayback Machine)
- Subdomain takeover (Subzy), cloud storage (S3/Azure/GCS)
- JavaScript analysis (LinkFinder, SecretFinder), CORS, APIs (Swagger, GraphQL)
- GitHub/GitLab OSINT (GitDorker, truffleHog)
- Banner grabbing e servidores (Netcat)
- Opsec e anonimato (ProxyChains, Tor)
- MANUAL-RECON: 21 arquivos com checklist operacional completo (7 fases de recon)
- 37 labs (TryHackMe, PortSwigger, HackTheBox, labs locais)

**Relevância para exploração:** O aluno já sabe descobrir superfície de ataque, enumerar serviços, identificar versões e detectar WAF. A transição natural é: reconhecimento → exploração.

### Módulo 02 — Web Aplicações (foco em exploração web)
| Técnica coberta | Arquivo |
|---|---|
| Burp Suite completo (Proxy, Repeater, Intruder, Decoder) | 01-burp-suite.md |
| SQL Injection avançado (SQLMap) | 02-injecao-e-fuzzing.md |
| API Security (BOLA, BFLA, GraphQL) | 03-api-security.md |
| NoSQL Injection (MongoDB, CouchDB) | 04-nosql-injection.md |
| XSS avançado + bypass de filtros/CSP | 05-xss-avancado.md |
| CSRF | 06-csrf.md |
| SSRF (cloud metadata, bypass, blind) | 07-ssrf.md |
| XXE (clássico, blind, SVG, OOB) | 08-xxe.md |
| File Upload bypass (extension, magic bytes, webshell) | 09-file-upload.md |
| SSTI (Jinja2, Twig, Freemarker) | 10-ssti.md |
| Insecure Deserialization (ysoserial, phpggc) | 11-insecure-deserialization.md |
| JWT (alg:none, weak key, KID injection) | 12-jwt-attacks.md |
| OAuth 2.0 attacks | 13-oauth-attacks.md |
| IDOR / Broken Access Control | 14-access-control.md |
| Business Logic (race conditions) | 15-business-logic.md |
| Headers de segurança (CSP, CORS, Clickjacking) | 16-headers-seguranca.md |
| Database enum e brute force | 17-database-enum.md |
| Nuclei scanning automatizado | 18-nuclei-web.md |

**Lacunas que AUDITORIA-02 identificou e NÃO foram criadas:**
- HTTP Request Smuggling (CL.TE, TE.CL)
- Open Redirect
- Prototype Pollution
- Web Cache Deception
- Host Header Injection

**Conclusão:** Módulo 02 é extenso e abrange bem exploração web. O módulo 03 NÃO deve repetir nenhum desses tópicos. Foco exclusivo: exploração não-web (serviços de rede, ferramentas ofensivas, cracking, buffer overflow).

---

## 2. Estado atual dos arquivos da 03 (completo vs. raso vs. ausente)

### Arquivos existentes
| Arquivo | Linhas | Avaliação |
|---|---|---|
| README.md | 161 | Integrador — mapa ASCII, navegação, checklist. Adequado para index. Menor: referências a ferramentas de IA duvidosas (NFGuard, CyberMind). |
| 01-brute-force-e-cracking.md | 852 | **Bom, mas com lacunas.** Hydra/John/Hashcat/Metasploit/Searchsploit têm instalação + flags + explicação. FALTAM outputs simulados completos em Hydra/John/Hashcat. hashid é raso (5 linhas). Duplicação interna significativa. Fluxo final cruza indevidamente com persistência (módulo 04). |
| 02-wordlists-e-ferramentas.md | 540 | **Bom.** SecLists/CeWL bem tratados. Crunch e keywordshitter rasos. Excelente organização por cenário. Labs duplicados com LABS.md. |
| LABS.md | 67 | **Parcialmente alinhado.** Labs 1-6 e 12-14 alinham com conteúdo. Labs 7-10 (binary exploitation) não têm respaldo no conteúdo ensinado. |

### Profundidade por ferramenta (arquivo 01)
| Ferramenta | Instalação | Flags | Output Esperado | Veredito |
|---|:---:|:---:|:---:|---|
| Hydra | Sim | Sim (tabela) | Parcial | Bom, sem output completo |
| John | Sim | Sim (tabela) | Não | Bom, sem output real |
| Hashcat | Sim | Sim (tabela) | Não | Bom, sem output real |
| hashid | Sim | Mínimo | Não | **Raso** |
| Metasploit | Sim | Sim | Sim (detalhado) | **Completo** |
| Searchsploit | Sim | Sim | Sim | **Completo** |

### Profundidade por ferramenta (arquivo 02)
| Ferramenta | Instalação | Flags | Output Esperado | Veredito |
|---|:---:|:---:|:---:|---|
| SecLists | Sim | N/A | Sim (estrutura) | Completo |
| Crunch | Sim | Mínimo | Não | **Raso** |
| CeWL | Sim | Sim | Parcial | Bom |
| keywordshitter | Sim | Parcial | Parcial | **Raso** |

### Ordem e progressão pedagógica
| Problema | Detalhe |
|---|---|
| Ordem invertida | Wordlists (02) deveria vir antes de brute-force (01), pois o aluno precisa saber onde encontrar wordlists antes de usá-las |
| Mistura de escopos | Arquivo 01 mistura brute force (Hydra), cracking (John/Hashcat), exploração (Metasploit) e busca de exploits (Searchsploit) — são disciplinas diferentes |
| Metasploit subordinado | Metasploit é ferramenta central de exploração e está escondido como "Tool Card" no final de 500 linhas de brute force |
| Labs sem respaldo | 4 labs de binary exploitation (Narnia, Behemoth, PicoCTF Binary, HTB Starting Point) não têm conteúdo de ensino correspondente |

### O que falta para uma fase de exploração completa (não-web)
**Ferramentas mencionadas mas sem conteúdo:** Medusa, Ncrack

**Tópicos ausentes completamente:**
| Tópico | Justificativa |
|---|---|
| Metasploit profundo | Só tem Tool Card rasa; faltam handlers, payloads, msfvenom, session management, pivoting |
| msfvenom | Geração de payloads (exe, apk, elf, hta, psh) — zero menção |
| Reverse shells manuais | Netcat, bash, python, php, powershell — essencial quando Metasploit não é opção |
| Bind shells | Conexão direta ao alvo — zero conteúdo |
| Shell stabilization | pythonpty, socat, rlwrap — estabilizar shells frágeis |
| Buffer overflow básico | LABS.md lista 3 labs mas não há uma linha sobre EIP overwrite, pattern_create, NOP sled, shellcode |
| Exploração manual em Python | pwntools, crafting de pacotes — essencial para CTFs e OSCP |
| Pivoting / Tunneling | Chisel, ligolo-ng, ssh tunneling, proxychains — passar de uma rede para outra |
| Credential harvesting não-web | Responder (LLMNR/NBT-NS poisoning) — fundamental em ambientes AD |
| Exploração de serviços non-web | SMB, FTP, SSH, RDP, SNMP, VNC, NFS — cada um com vetores específicos além de brute force |
| Credential reuse cross-service | Senha quebrada em SSH pode funcionar em SMB/RDP/WinRM |
| Enumeração de usuários | Pré-requisito para brute force eficiente (SMB null session, RID brute, kerbrute) |

---

## 3. Lacunas via pesquisa externa (com fontes e separação vs. módulo 04)

| # | Tópico/Ferramenta | Por que é essencial | Fonte(s) | Pertence ao 04? |
|---|---|---|---|---|
| 1 | **Exploração de serviços de rede** (SMB, FTP, SSH, RDP, SNMP) por serviço | Cada serviço tem vetores específicos além de brute force: SMB null sessions/EternalBlue/PrintNightmare, FTP anonymous/bounce, SSH key abuse/BlueKeep, SNMP community strings default | HackTricks Pentesting SMB/SSH/RDP/SNMP; PayloadsAllTheThings; kindatechnical.com Exploiting Network Services (2026) | Não — ganho de acesso inicial |
| 2 | **Password spraying e credential stuffing** | Testa 1 senha em muitos usuários (evita lockout). Método #1 em ambientes AD. CrackMapExec com `--pass-pol` verifica lockout policy antes | HackTricks AD Methodology; PayloadsAllTheThings AD Attack; Yunolay CME/NetExec Guide (2026) | Não — ganho de acesso inicial |
| 3 | **Pass-the-Hash (PtH)** | Autentica com hash NTLM sem senha plaintext. Funciona em SMB/RDP/WinRM. Presente em 82% de compromissos AD (Verizon DBIR 2025) | RingSafe Pass-the-Hash 2026; HackTricks PtH; Payload Playground Lateral Movement | Não — PtH é vetor de ganho de acesso a novos hosts |
| 4 | **Responder + NTLM Relay** | Responder envenena LLMNR/NBT-NS e captura NetNTLMv2. ntlmrelayx.py relays hashes para SMB/LDAP sem crackear. Ataque sem interação do usuário | HackTricks NTLM Theft/Relay; PayloadsAllTheThings NTLM Relay; SecureAuth Relay Guide (2026) | Não — relay é vetor de ganho de acesso |
| 5 | **CrackMapExec / NetExec** | Ferramenta central para pentest interno: valida credenciais em subnets, enumera shares/SAM, executa comandos via SMB/WMI/WinRM, faz PtH, dumping de SAM | Yunolay CME/NetExec Guide (2026); mr7.ai CME Review (2026); HackTricks SMB | Não — ferramenta de exploração/acesso |
| 6 | **Impacket suite** (psexec/wmiexec/smbexec/secretsdump) | Biblioteca Python que faz tudo via protocolos de rede. Cada um tem `-hashes` para PtH. Backend do CrackMapExec. Fundamental para execução manual | HackTricks Impacket; PayloadsAllTheThings AD Attack; SecureAuth Relay Guide | Não — psexec/wmiexec = ganho de acesso remoto |
| 7 | **Buffer overflow básico** (stack smashing) | Fundamento de exploit development. OSCP exige. Fluxo: crash → offset → bad chars → ret address → shellcode. Usa pattern_create, msfvenom, debugger | TryHackMe Buffer Overflow Prep; OverTheWire Narnia/Behemoth; Yunolay Stack Buffer Overflow Guide (2025) | Não — exploração inicial |
| 8 | **Exploração manual** (netcat + payloads manuais) | Nem sempre Metasploit está disponível ou é silencioso. Saber craft payloads manualmente é essencial para OSCP e quando EDR detecta Metasploit | HackTricks (cada serviço tem seção de exploitation manual); PayloadsAllTheThings Reverse Shell Cheatsheet | Não — é a exploração em si |
| 9 | **SNMP enum + exploitation** | Community strings default revelam users, processes, config. Writable community = mudança de config. Ferramentas: onesixtyone, snmpwalk, Metasploit SNMP modules | HackTricks Pentesting SNMP; Payload Playground SNMP Enumeration Guide (2026) | Não — reconhecimento e ganho de acesso |
| 10 | **Metasploit avançado** | Só tem 1 exemplo (MS17-010). Falta: auxiliary scanners, resource scripts, multi-handler, msfvenom, session management | HackTricks each service section; TryHackMe Metasploit Intro; PayloadsAllTheThings Metasploit Cheatsheet | Não — exploração em si |
| 11 | **Enumeração de usuários** | Brute force sem lista de usuários válidos é ineficiente. Técnicas: SMB null session, RID brute, kerbrute, LDAP enum | HackTricks SMB; PayloadsAllTheThings AD Attack; Yunolay CME Guide | Não — preparação para exploração |
| 12 | **Credential reuse cross-service** | Uma senha quebrada em SSH pode funcionar em SMB/RDP/WinRM/FTP. Testar credenciais em múltiplos serviços é padrão | HackTricks Remote Connections; Payload Playground Lateral Movement Guide | Não — fase de exploração/lateral movement |

---

## 4. Proposta de estrutura final para a pasta 03

Ordem corrigida respeitando a progressão lógica: wordlists → enumeração de usuários → brute-force → exploração de serviços → ferramentas avançadas.

```
03-exploracao/
├── README.md                              (index/mapa do módulo)
├── LABS.md                                (exercícios práticos)
├── 01-preparacao-e-wordlists.md           (SecLists, Crunch, CeWL, organização por cenário)
├── 02-reconhecimento-de-usuarios-e-escopo.md (SMB null session, RID brute, kerbrute, LDAP enum)
├── 03-brute-force-e-spraying.md           (Hydra, Medusa, Ncrack, password spraying, lockout policy)
├── 04-credential-stuffing-e-reuso.md      (credential stuffing, reuse cross-service, CrackMapExec)
├── 05-exploracao-de-servicos-de-rede.md   (SMB, FTP, SSH, RDP, VNC, NFS por serviço)
├── 06-pass-the-hash-e-impacket.md         (PtH, psexec, wmiexec, smbexec, secretsdump)
├── 07-ntlm-relay-e-responder.md           (LLMNR/NBT-NS poisoning, ntlmrelayx, mitm6)
├── 08-metasploit-e-msfvenom.md            (msfconsole avançado, msfvenom, handlers, sessions, resource scripts)
├── 09-exploracao-manual-e-payloads.md     (netcat, reverse shells manuais, shell stabilization, pwntools)
├── 10-buffer-overflow-basico.md           (stack smashing, EIP overwrite, pattern_create, NOP sled, shellcode)
├── 11-snmp-enum-e-exploitation.md         (onesixtyone, snmpwalk, Metasploit SNMP modules)
└── 12-checklist-de-validacao-de-acesso.md (opcional — checklist pós-exploração para confirmar acesso)
```

---

## 5. Proposta de estrutura para a subpasta manual-exploracao/

Seguindo o padrão da manual-recon (guia passo a passo, com o que fazer, output esperado, troubleshooting):

```
03-exploracao/manual-exploracao/
├── 00-checklist-setup.md                  (ambiente Kali, ferramentas instaladas, targets de prática)
├── 01-fase-preparacao.md                  (wordlists, escopo, enumeração de usuários)
├── 02-fase-brute-force-e-spraying.md      (Hydra, password spraying, lockout evasão)
├── 03-fase-credential-stuffing-e-reuso.md (credential stuffing, teste cross-service com CME)
├── 04-fase-exploracao-servicos.md         (SMB/FTP/SSH/RDP/SNMP — vetor por vetor)
├── 05-fase-pass-the-hash-e-impacket.md    (PtH com CME, psexec, wmiexec)
├── 06-fase-ntlm-relay-e-responder.md      (responder, ntlmrelayx, mitm6)
├── 07-fase-metasploit-e-payloads.md       (msfconsole, msfvenom, handlers, sessions)
├── 08-fase-exploracao-manual.md           (netcat, reverse shells, shell stabilization)
├── 09-fase-buffer-overflow-basico.md      (vulnserver, fluxo completo, debugger)
├── 10-fase-snmp.md                        (enum + exploitation)
├── 11-validacao-e-relatorio.md            (checklist de confirmação de acesso, documentação)
├── A-troubleshooting.md                   (erros comuns e soluções)
├── B-referencia-rapida.md                 (cheat sheet de comandos)
└── C-quando-parar.md                      (critérios de parada e transição para módulo 04)
```
