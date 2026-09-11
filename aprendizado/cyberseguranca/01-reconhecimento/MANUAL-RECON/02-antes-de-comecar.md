## Antes de Começar

### O que é Reconhecimento?

Reconhecimento (recon) é a fase de **coleta de informações** antes de qualquer ataque. É como um ladrão que observa uma casa antes de entrar: ele sabe quantas portas tem, quais janelas estão abertas, que horas os moradores saem.

Em segurança ofensiva, reconhecimento significa:
- Descobrir quais domínios e IPs pertencem ao alvo
- Identificar quais serviços estão rodando
- Encontrar portas de entrada (diretórios, APIs, subdomínios)
- Saber quais tecnologias o alvo usa (para buscar vulnerabilidades conhecidas)

### Por que NÃO pular fases?

Se você pular a Fase 1 (inteligência passiva) e ir direto para scan de portas, você pode:
- Perder subdomínios inteiros que não estão no DNS público
- Não encontrar APIs internas expostas
- Gastar horas escaneando IP errado

**Cada fase gera dados que alimentam a próxima.** Pular fases = trabalhar no escuro.

### Conceitos que você PRECISA saber antes de começar

| Conceito | O que é | Exemplo |
|----------|---------|---------|
| **Domínio** | Nome de um site | `evilcorp.com` |
| **Subdomínio** | Parte do domínio | `admin.evilcorp.com`, `staging.evilcorp.com` |
| **IP** | Endereço de uma máquina na rede | `192.168.1.100` |
| **Porta** | "Porta de entrada" de um serviço | Porta 80 = web, 22 = SSH, 443 = HTTPS |
| **Serviço** | Programa rodando na porta | Apache, Nginx, OpenSSH, MySQL |
| **WAF** | Firewall que bloqueia ataques | Cloudflare, AWS WAF, ModSecurity |
| **CMS** | Sistema que gerencia o site | WordPress, Joomla, Drupal |
| **CVE** | Vulnerabilidade conhecida catalogada | CVE-2024-1234 |
| **Wordlist** | Lista de palavras para brute force | common.txt, rockyou.txt |
| **OSINT** | Informações públicas sobre o alvo | Whois, Google, redes sociais |
| **Banner** | Texto que identifica um serviço | `SSH-2.0-OpenSSH_8.9p1` |

---

### Preparação do Ambiente

Execute cada item abaixo ANTES de começar qualquer scan. Marque com ☑ quando concluir.

| # | O que fazer | Comando | Por quê | ☑ |
|---|-------------|---------|---------|:---:|
| 1 | Criar estrutura de pastas | `mkdir -p ~/recon/{targets,results,logs}` | Organizar tudo por alvo | [ ] |
| 2 | Criar pasta do alvo | `mkdir -p ~/recon/targets/ALVO` | Manter dados separados | [ ] |
| 3 | Entrar na pasta do alvo | `cd ~/recon/targets/ALVO` | Todo trabalho ficará aqui | [ ] |
| 4 | Atualizar sistema | `sudo apt update && sudo apt upgrade -y` | Ferramentas atualizadas | [ ] |
| 5 | Instalar SecLists (wordlists) | `sudo apt install seclists -y` | Necessário para brute force | [ ] |
| 6 | Verificar ferramentas | Veja seção "Ferramentas Necessárias" abaixo | Garantir que tudo funciona | [ ] |
| 7 | Anotar o escopo | Escrever em arquivo: domínios IN e OUT | Saber o que pode escanear | [ ] |

**Depois de criar a pasta, sua estrutura deve parecer:**
```
~/recon/
├── targets/
│   └── evilcorp/              ← pasta do alvo (troque "evilcorp" pelo nome real)
│       ├── 01-intel/          ← Fase 1: WHOIS, DNS, subdomínios, OSINT
│       │   └── (vazia — será preenchida na Fase 1)
│       ├── 02-enum/           ← Fase 2: validação de subs, portas, serviços
│       │   └── (vazia — será preenchida na Fase 2)
│       ├── 03-fingerprint/    ← Fase 3: tecnologias, WAF, versões
│       │   └── (vazia — será preenchida na Fase 3)
│       ├── 04-discovery/      ← Fase 4: diretórios, arquivos, endpoints
│       │   └── (vazia — será preenchida na Fase 4)
│       ├── 05-vulns/          ← Fase 5: vulnerabilidades encontradas
│       │   └── (vazia — será preenchida na Fase 5)
│       ├── 06-validacao/      ← Fase 6: validação manual dos achados
│       │   └── (vazia — será preenchida na Fase 6)
│       └── 07-relatorio/      ← Fase 7: relatório final
│           └── (vazia — será preenchida na Fase 7)
├── results/
└── logs/
```

> **Importante:** Cada fase PREENCHE a sua pasta com arquivos. Ao final do curso, você vai ter ~35-40 arquivos organizados por fase. Cada arquivo alimenta as fases seguintes.

**Crie as subpastas agora:**
```bash
mkdir -p 01-intel 02-enum 03-fingerprint 04-discovery 05-vulns 06-validacao 07-relatorio
```

---

### Ferramentas Necessárias

Verifique se cada ferramenta está instalada. Se alguma não estiver, instale-a.

| Ferramenta | Para que serve | Como verificar | Como instalar se faltar |
|------------|---------------|----------------|------------------------|
| `subfinder` | Subdomínios passivos | `subfinder -version` | `sudo apt install subfinder` |
| `amass` | Subdomínios profundos | `amass -version` | `sudo apt install amass` |
| `httpx` | Validar subdomínios vivos | `httpx -version` | `sudo apt install httpx` |
| `nmap` | Scan de portas | `nmap --version` | `sudo apt install nmap` |
| `masscan` | Scan rápido em massa | `masscan --version` | `sudo apt install masscan` |
| `whatweb` | Identificar tecnologias | `whatweb --version` | `sudo apt install whatweb` |
| `gobuster` | Encontrar diretórios | `gobuster version` | `sudo apt install gobuster` |
| `ffuf` | Fuzzing avançado | `ffuf -V` | `sudo apt install ffuf` |
| `nuclei` | Scan de vulnerabilidades | `nuclei -version` | `sudo apt install nuclei` |
| `wafw00f` | Detectar WAF | `wafw00f --version` | `sudo apt install wafw00f` |
| `nikto` | Scanner web vulnerabilidades | `nikto -Version` | `sudo apt install nikto` |
| `wpscan` | Scanner WordPress | `wpscan --version` | `sudo apt install wpscan` |
| `ncat` | Banner grabbing | `ncat --version` | `sudo apt install ncat` |
| `curl` | Requests HTTP | `curl --version` | `sudo apt install curl` |
| `dig` | Consultas DNS | `dig -v` | `sudo apt install dnsutils` |
| `whois` | Informações do domínio | `whois --version` | `sudo apt install whois` |
| `theHarvester` | OSINT de subdomínios | `theHarvester -h` | `sudo apt install theharvester` |
| `proxychains4` | Anonimato | `proxychains4 --version` | `sudo apt install proxychains4` |

---
