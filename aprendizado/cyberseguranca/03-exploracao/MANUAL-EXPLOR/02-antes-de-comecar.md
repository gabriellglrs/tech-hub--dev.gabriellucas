## Antes de Começar

### O que é Exploração?

Exploração é a fase em que você **usa** as vulnerabilidades que encontrou — você transforma "o alvo é vulnerável a X" em "eu entrei". É o passo que separa quem só escaneou de quem provou impacto real.

Em segurança ofensiva, exploração significa:
- Testar credenciais em serviços abertos (brute force)
- Quebrar hashes de senhas que você coletou
- Executar exploits de vulnerabilidades conhecidas (CVEs)
- Ganhar uma sessão (shell, acesso ao sistema)
- **Provar** o acesso com evidências documentadas

### Por que NÃO pular fases?

Se você pular a Fase 1 (alimentação) e sair rodando Hydra no alvo inteiro, você pode:
- Travar contas reais de usuários (completamente antiético e ilegal em produção)
- Brute force em serviço que não tem vulnerabilidade nenhuma, desperdiçando horas
- Perder CVEs com exploit pronto porque não olhou o output do Nmap
- Levar ban do IPS/WAF na primeira tentativa

**Cada fase gera dados que alimentam a próxima.** Pular fases = trabalhar no escuro — e o alvo sabe que você está batendo nele.

### Conceitos que você PRECISA saber antes de começar

| Conceito | O que é | Exemplo |
|----------|---------|---------|
| **Serviço** | Programa escutando numa porta | OpenSSH na porta 22 |
| **Banner** | Identificação do serviço | `SSH-2.0-OpenSSH_8.9p1 Ubuntu` |
| **CVE** | Vulnerabilidade catalogada | CVE-2017-0144 (EternalBlue) |
| **CVSS** | Nota de gravidade (0-10) | 9.8 = crítico |
| **Exploit** | Código que abusa da vulnerabilidade | `exploit/windows/smb/ms17_010_eternalblue` |
| **Payload** | O que roda no alvo após o exploit | `windows/x64/meterpreter/reverse_tcp` |
| **Reverse shell** | Alvo conecta DE VOLTA para você | O firewall deixa saída, mas não entrada |
| **LHOST** | Seu IP (onde a shell volta) | `10.0.0.100` (seu Kali) |
| **RHOSTS** | IP do alvo | `10.0.0.1` |
| **Sessão** | Conexão ativa com o alvo | `Meterpreter session 1 opened` |
| **Hash** | Senha transformada em texto fixo | `5f4dcc3b5aa765d61d8327deb882cf99` (MD5 de "password") |
| **Hashcat modo** | ID numérico do tipo de hash | `-m 0` = MD5, `-m 1000` = NTLM |
| **Wordlist** | Lista de candidatos | rockyou.txt, Top1000.txt |
| **Lockout** | Bloqueio por excesso de tentativas | AD trava conta após 5 tentativas |
| **Rate limit** | Limite de tentativas por tempo | WAF bloqueia após 10 requests/min |
| **Escopo** | O que você PODE testar | `*.evilcorp.com`, IPs 10.0.0.0/24 |

---

### Preparação do Ambiente

Execute cada item abaixo ANTES de começar qualquer ataque. Marque com ☑ quando concluir.

| # | O que fazer | Comando | Por quê | ☑ |
|---|-------------|---------|---------|:---:|
| 1 | Ter a estrutura do recon pronta | `ls ~/recon/targets/evilcorp/` | A Fase 1 importa dessas pastas (Módulo 01) | [ ] |
| 2 | Ter os testes web prontos (Módulo 02) | `ls ~/recon/targets/evilcorp/09-descoberta/ 10-injecao/ 2>/dev/null` | A Fase 1 importa `logins-formularios.txt` e hashes do MANUAL-WEB | [ ] |
| 3 | Criar as pastas da exploração | `mkdir -p 15-alimentacao 16-vetores 17-bruteforce 18-cracking 19-exploracao 20-validacao 21-relatorio` | Organizar tudo por fase | [ ] |
| 4 | Entrar na pasta do alvo | `cd ~/recon/targets/evilcorp` | Todo trabalho ficará aqui | [ ] |
| 5 | Atualizar sistema | `sudo apt update && sudo apt upgrade -y` | Ferramentas atualizadas | [ ] |
| 6 | Instalar SecLists + rockyou | Veja [03-setup-ferramentas.md](03-setup-ferramentas.md) | Brute force sem wordlist = nada | [ ] |
| 7 | Instalar Hydra/John/Hashcat/Metasploit | Veja [03-setup-ferramentas.md](03-setup-ferramentas.md) | Ferramentas centrais deste módulo | [ ] |
| 8 | Rodar o checklist automático | Veja [04-checklist-setup.md](04-checklist-setup.md) | Garantir que TUDO funciona | [ ] |
| 9 | Confirmar AUTORIZAÇÃO | Escrever em arquivo: alvos IN e OUT | Ilegal sem autorização por escrito | [ ] |
| 10 | Ligar a VPN | `nordvpn connect && curl -s https://ifconfig.me` | Seu IP real não pode aparecer | [ ] |

**Depois de criar as pastas, sua estrutura deve parecer:**
```
~/recon/targets/evilcorp/
├── 01-intel/            ← Módulo 01 (já feito)
├── 02-enum/             ← Módulo 01 (já feito)
├── 03-fingerprint/      ← Módulo 01 (já feito)
├── 04-discovery/        ← Módulo 01 + 02 (já feito)
├── 05-vulns/            ← Módulo 01 (já feito)
├── 06-validacao/        ← Módulo 01 (já feito)
├── 07-relatorio/        ← Módulo 01 (já feito)
├── 08-alimentacao/      ← Módulo 02 / MANUAL-WEB (se fez o módulo web)
├── 09-descoberta/       ← Módulo 02 (logins-formularios.txt, parametros.txt)
├── 10-injecao/          ← Módulo 02 (sqlmap-dump.txt)
├── 11-cliente-auth/     ← Módulo 02
├── 12-especializados/   ← Módulo 02
├── 13-validacao/        ← Módulo 02 (evidencias.md)
├── 14-relatorio/        ← Módulo 02 (RELATORIO-SEGURANCA.md)
├── 15-alimentacao/      ← Fase 1: importa dados dos módulos 01 e 02
├── 16-vetores/          ← Fase 2: matriz de decisão de ataque
├── 17-bruteforce/       ← Fase 3: saídas do Hydra
├── 18-cracking/         ← Fase 4: hashes e resultados do John/Hashcat
├── 19-exploracao/       ← Fase 5: logs do Metasploit, payloads, sessões
├── 20-validacao/        ← Fase 6: evidências de acesso
└── 21-relatorio/        ← Fase 7: relatório final de exploração
```

**Crie as subpastas agora:**
```bash
cd ~/recon/targets/evilcorp
mkdir -p 15-alimentacao 16-vetores 17-bruteforce 18-cracking 19-exploracao 20-validacao 21-relatorio
```

> **Importante:** A exploração CONTINUA a árvore dos módulos anteriores — recon (01 → 07), web (08 → 14) e exploração (15 → 21). Assim todos os dados do mesmo alvo ficam num lugar só, e o Módulo 04 (pós-exploração) sabe exatamente onde procurar.

---

### Ferramentas Necessárias

Verifique se cada ferramenta está instalada. Se alguma não estiver, instale-a.

| Ferramenta | Para que serve | Como verificar | Como instalar se faltar |
|------------|---------------|----------------|------------------------|
| `hydra` | Brute force de logins | `hydra -h` | `sudo apt install hydra` |
| `john` | Crackear hashes (CPU) | `john --help` | `sudo apt install john` |
| `hashcat` | Crackear hashes (GPU) | `hashcat --version` | `sudo apt install hashcat` |
| `hashid` | Identificar tipo de hash | `hashid -h` | `sudo apt install hashid` |
| `msfconsole` | Metasploit Framework | `msfconsole --version` | `sudo apt install metasploit-framework` |
| `searchsploit` | Buscar exploits (Exploit-DB) | `searchsploit --version` | `sudo apt install exploitdb` |
| `medusa` | Brute force paralelo (alternativa ao Hydra) | `medusa -h` | `sudo apt install medusa` |
| `ncrack` | Brute force de serviços de rede | `ncrack --version` | `sudo apt install ncrack` |
| `seclists` | Wordlists completas | `ls /usr/share/seclists` | `sudo apt install seclists` |
| `cewl` | Gerar wordlist de um site | `cewl --version` | `sudo apt install cewl` |
| `crunch` | Gerar wordlist por padrão | `crunch -h` | `sudo apt install crunch` |
| `unshadow` | Juntar /etc/passwd + /etc/shadow | `which unshadow` | `sudo apt install john` |
| `nmap` | (Módulo 01) scan de portas | `nmap --version` | `sudo apt install nmap` |
| `curl` | Testar endpoints HTTP | `curl --version` | `sudo apt install curl` |
| `ncat` | Testar portas/serviços | `ncat --version` | `sudo apt install ncat` |
| `proxychains4` | Anonimato | `proxychains4 --version` | `sudo apt install proxychains4` |

---

**Se preparou tudo → Avance para [03 - Setup de Ferramentas](03-setup-ferramentas.md)**
