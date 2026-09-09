# Laboratório Prático — Reconhecimento e Enumeração

> Guia completo de exercícios para praticar o que aprendeu. Cada exercício tem objetivo, passo a passo, macetes e o que esperar do resultado.

---

## Pré-requisitos

- [ ] Ferramentas instaladas (ver Instalação no módulo principal)
- [ ] Conta no TryHackMe (gratuita: https://tryhackme.com)
- [ ] Conta no HackTheBox (gratuita: https://hackthebox.com)
- [ ] whois, dig, nslookup instalados (`sudo apt install whois dnsutils`)
- [ ] subfinder, amass, theHarvester instalados
- [ ] nmap instalado (`sudo apt install nmap`)

---

## O que você vai praticar

| Exercício | Conhecimento | Ferramentas | Dificuldade | Tempo |
|:----------|:-------------|:------------|:-----------:|:-----:|
| 1 | DNS, registros, name servers | whois, dig, nslookup | ⭐ | 20 min |
| 2 | Subdomínios, DNS brute force | subfinder, theHarvester, amass | ⭐⭐ | 30 min |
| 3 | Portas, serviços, versões | nmap, masscan | ⭐⭐ | 40 min |
| 4 | OSINT, fontes públicas | theHarvester | ⭐⭐ | 25 min |
| 5 | NSE scripts, vulnerabilidades | nmap --script | ⭐⭐⭐ | 45 min |
| 6 | Técnicas completas de reconhecimento | whois, dig, nmap, subfinder, theHarvester | ⭐⭐⭐⭐ | 60 min |

---

## Exercício 1: Whois e DNS Lookup

### Objetivo
Descobrir informações de um domínio usando whois e dig, identificando name servers, registros DNS e dados de registro.

### Conhecimentos Praticados
- Consulta WHOIS de domínios
- Registros DNS (A, AAAA, MX, NS, TXT)
- Name servers e zones

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| whois | `whois dominio.com` |
| dig | `dig dominio.com` |
| dig (curto) | `dig +short dominio.com` |
| dig (DNS público) | `dig @8.8.8.8 dominio.com` |
| nslookup | `nslookup dominio.com` |

### Passo a Passo

```
PASSO 1: Consultar WHOIS do domínio
├── Comando: whois tryhackme.com
├── O que esperar: Informações de registro, name servers, data de criação
└── Se der errado: Verificar se whois está instalado (sudo apt install whois)

PASSO 2: Consultar registros A com dig
├── Comando: dig +short tryhackme.com
├── O que esperar: Endereços IP do domínio
└── Se der errado: Tentar com dig @8.8.8.8 tryhackme.com

PASSO 3: Consultar name servers
├── Comando: dig NS tryhackme.com +short
├── O que esperar: Lista de name servers (ex: ns1.dominio.com)
└── Se der errado: Usar dig tryhackme.com NS

PASSO 4: Consultar registros MX (email)
├── Comando: dig MX tryhackme.com +short
├── O que esperar: Servidores de email associados
└── Se der errado: Verificar se o domínio existe com whois

PASSO 5: Consultar registros TXT
├── Comando: dig TXT tryhackme.com +short
├── O que esperar: Registros SPF, DKIM, verificação
└── Se der errado: Usar dig tryhackme.com TXT

PASSO 6: Usar nslookup para comparação
├── Comando: nslookup tryhackme.com
├── O que esperar: Mesmo resultado do dig (IP do domínio)
└── Se der errado: Verificar conectividade com ping
```

### Macetes
> **Macete 1:** `dig +short` retorna apenas o IP, sem texto extra — ideal para scripts.

> **Macete 2:** `dig @8.8.8.8` usa DNS público do Google, útil quando seu DNS local está bloqueado.

> **Macete 3:** `whois | grep -i "name server"` filtra apenas os name servers rapidamente.

### Checklist
- [ ] Consultar WHOIS de um domínio
- [ ] Identificar registros A, MX, NS e TXT
- [ ] Usar dig com DNS público
- [ ] Comparar resultados entre whois, dig e nslookup

### Link para o exercício
https://tryhackme.com/room/dnsindns

### Tempo estimado: 20 minutos

---

## Exercício 2: Enumeração de Subdomínios

### Objetivo
Encontrar subdomínios ocultos de um alvo usando múltiplas ferramentas de enumeração.

### Conhecimentos Praticados
- Subdomínios e sua importância
- DNS brute force
- Passive DNS enumeration

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| subfinder | `subfinder -d dominio.com` |
| theHarvester | `theHarvester -d dominio.com -b all` |
| amass | `amass enum -d dominio.com` |

### Passo a Passo

```
PASSO 1: Enumeração passiva com subfinder
├── Comando: subfinder -d tryhackme.com -o subfinder.txt
├── O que esperar: Lista de subdomínios encontrados
└── Se der errado: Instalar com go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

PASSO 2: Enumeração com theHarvester
├── Comando: theHarvester -d tryhackme.com -b all -l 500
├── O que esperar: Emails e subdomínios de múltiplas fontes
└── Se der errado: Usar -b google,bing,duckduckgo em vez de all

PASSO 3: Enumeração com amass
├── Comando: amass enum -d tryhackme.com -o amass.txt
├── O que esperar: Lista extensa de subdomínios (mais demorado)
└── Se der errado: Usar amass enum -passive -d tryhackme.com para modo passivo

PASSO 4: Combinar e deduplicar resultados
├── Comando: cat subfinder.txt amass.txt | sort -u > todos_subdominios.txt
├── O que esperar: Lista unificada sem duplicatas
└── Se der errado: Verificar se os arquivos existem com ls -la

PASSO 5: Verificar quais subdomínios estão ativos
├── Comando: while read sub; do ping -c 1 -W 1 $sub 2>/dev/null && echo "$sub ATIVO"; done < todos_subdominios.txt
├── O que esperar: Lista de subdomínios que respondem a ping
└── Se der errado: Usar httpx para verificar HTTP em vez de ping
```

### Macetes
> **Macete 1:** Combinar múltiplas fontes (subfinder + amass + theHarvester) aumenta a cobertura.

> **Macete 2:** `subfinder -d dominio.com -silent` retorna apenas os domínios, sem banners.

> **Macete 3:** `amass enum -passive` é mais rápido pois não faz brute force ativo.

### Checklist
- [ ] Usar subfinder para enumeração passiva
- [ ] Usar theHarvester para coletar emails e subdomínios
- [ ] Usar amass para enumeração extensa
- [ ] Combinar e deduplicar resultados

### Link para o exercício
https://tryhackme.com/room/ohsint

### Tempo estimado: 30 minutos

---

## Exercício 3: Scan de Portas com Nmap

### Objetivo
Mapear portas abertas e serviços de um servidor usando Nmap.

### Conhecimentos Praticados
- Portas TCP/UDP
- Detecção de serviços e versões
- Tipos de scan

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| nmap (básico) | `nmap -sV -sC alvo` |
| nmap (rápido) | `nmap -T4 -Pn alvo` |
| masscan | `masscan alvo -p0-65535 --rate=1000` |

### Passo a Passo

```
PASSO 1: Scan rápido das portas comuns
├── Comando: nmap -T4 -Pn tryhackme.com
├── O que esperar: Lista de portas abertas nas portas 1-1000
└── Se der errado: Usar -Pn para ignorar verificação de host

PASSO 2: Scan de todas as portas
├── Comando: nmap -T4 -Pn -p- tryhackme.com
├── O que esperar: Todas as 65535 portas verificadas
└── Se der errado: Usar masscan para scan mais rápido

PASSO 3: Detecção de versões
├── Comando: nmap -sV -T4 -Pn tryhackme.com
├── O que esperar: Versões dos serviços (ex: Apache 2.4.41)
└── Se der errado: O scan pode demorar, ser paciente

PASSO 4: Scripts padrão
├── Comando: nmap -sC -sV -T4 -Pn tryhackme.com
├── O que esperar: Resultados dos scripts default do NSE
└── Se der errado: Usar --script=default para ser explícito

PASSO 5: Salvar resultado
├── Comando: nmap -sV -sC -T4 -Pn -oA scan_result tryhackme.com
├── O que esperar: Arquivos scan_result.nmap, .xml e .grepable
└── Se der errado: Verificar permissões de escrita no diretório
```

### Macetes
> **Macete 1:** `-sV` detecta versões dos serviços — essencial para identificar vulnerabilidades.

> **Macete 2:** `-sC` roda scripts padrão que podem revelar informações extras.

> **Macete 3:** `-T4` aumenta a velocidade do scan (use -T5 com cuidado, pode ser detectado).

> **Macete 4:** `-Pn` ignora verificação de host — útil quando o alvo bloqueia ping.

### Checklist
- [ ] Realizar scan básico de portas
- [ ] Scan de todas as 65535 portas
- [ ] Detectar versões dos serviços
- [ ] Usar scripts NSE padrão
- [ ] Salvar resultados em múltiplos formatos

### Link para o exercício
https://tryhackme.com/room/nmap01

### Tempo estimado: 40 minutos

---

## Exercício 4: OSINT com theHarvester

### Objetivo
Coletar emails e subdomínios de uma empresa usando técnicas de OSINT (Open Source Intelligence).

### Conhecimentos Praticados
- OSINT e fontes públicas
- Coleta de informações passivas
- Análise de dados coletados

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| theHarvester | `theHarvester -d dominio.com -b all` |
| theHarvester (limitado) | `theHarvester -d dominio.com -b google,bing -l 200` |

### Passo a Passo

```
PASSO 1: Coleta básica com Google
├── Comando: theHarvester -d tryhackme.com -b google -l 100
├── O que esperar: Emails e subdomínios encontrados no Google
└── Se der errado: Reduzir -l para 50 se houver rate limiting

PASSO 2: Coleta com múltiplas fontes
├── Comando: theHarvester -d tryhackme.com -b google,bing,duckduckgo -l 200
├── O que esperar: Mais resultados combinando fontes
└── Se der errado: Remover fontes que retornam erro

PASSO 3: Coleta completa com todas as fontes
├── Comando: theHarvester -d tryhackme.com -b all -l 500
├── O que esperar: Lista extensa de emails e subdomínios
└── Se der errado: Usar -b google,bing,linkedin em vez de all

PASSO 4: Salvar resultados
├── Comando: theHarvester -d tryhackme.com -b all -l 500 -f resultado_harvester.html
├── O que esperar: Arquivo HTML com todos os dados coletados
└── Se der errado: Verificar se o diretório de destino existe

PASSO 5: Analisar emails encontrados
├── Comando: cat resultado_harvester.html | grep -oP '[\w.]+@[\w.]+' | sort -u
├── O que esperar: Lista limpa de emails únicos
└── Se der errado: Usar theHarvester com -f para formato CSV
```

### Macetes
> **Macete 1:** `theHarvester -b all` usa todas as fontes disponíveis — results mais completos.

> **Macete 2:** `-l 500` aumenta o limite de resultados por fonte (padrão: 100).

> **Macete 3:** Usar `-f` para salvar em formato HTML facilita a análise visual.

### Checklist
- [ ] Coletar dados com Google e Bing
- [ ] Combinar múltiplas fontes
- [ ] Identificar emails corporativos
- [ ] Salvar e analisar resultados

### Link para o exercício
https://tryhackme.com/room/ohsint

### Tempo estimado: 25 minutos

---

## Exercício 5: Scan Completo com Nmap Scripts

### Objetivo
Usar scripts NSE (Nmap Scripting Engine) para descobrir vulnerabilidades e informações detalhadas do alvo.

### Conhecimentos Praticados
- Scripts NSE do Nmap
- Detecção de vulnerabilidades
- Enumeração HTTP e SMB

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| nmap (vuln) | `nmap --script vuln alvo` |
| nmap (http-enum) | `nmap --script=http-enum alvo` |
| nmap (smb) | `nmap --script=smb-* alvo` |

### Passo a Passo

```
PASSO 1: Scan de vulnerabilidades
├── Comando: nmap --script vuln -T4 -Pn tryhackme.com
├── O que esperar: Vulnerabilidades conhecidas encontradas
└── Se der errado: O scan demora, ser paciente (10-15 min)

PASSO 2: Enumeração HTTP
├── Comando: nmap --script=http-enum,http-headers,http-title -T4 -Pn tryhackme.com
├── O que esperar: Diretórios, headers e títulos das páginas
└── Se der errado: Verificar se a porta 80/443 está aberta

PASSO 3: Enumeração SMB
├── Comando: nmap --script=smb-enum-shares,smb-enum-users -T4 -Pn tryhackme.com
├── O que esperar: Shares e usuários do SMB (se porta 445 aberta)
└── Se der errado: SMB pode não estar disponível no alvo

PASSO 4: SSL/TLS enums
├── Comando: nmap --script=ssl-enum-ciphers -T4 -Pn tryhackme.com
├── O que esperar: Versões SSL/TLS e cifras suportadas
└── Se der errado: Usar -p 443 para forçar porta HTTPS

PASSO 5: Scan completo com todos os scripts
├── Comando: nmap -sC -sV --script=default,vuln -T4 -Pn -oA scan_completo tryhackme.com
├── O que esperar: Relatório completo com serviços, versões e vulnerabilidades
└── Se der errado: Salvar parcialmente com -oN e continuar depois
```

### Macetes
> **Macete 1:** `--script vuln` roda todos os scripts de vulnerabilidade — demora mais mas é completo.

> **Macete 2:** `--script=http-enum` descobre diretórios e arquivos ocultos no web server.

> **Macete 3:** `--script=smb-*` é útil em ambientes Windows para descobrir shares e usuários.

> **Macete 4:** Combinar `-sC` com `--script=vuln` dá o máximo de informação possível.

### Checklist
- [ ] Rodar scan de vulnerabilidades
- [ ] Enumerar serviços HTTP
- [ ] Enumerar SMB (se disponível)
- [ ] Analisar SSL/TLS
- [ ] Gerar relatório completo

### Link para o exercício
https://tryhackme.com/room/nmap

### Tempo estimado: 45 minutos

---

## Exercício 6: Reconhecimento Completo (Desafio Final)

### Objetivo
Fazer reconhecimento completo de um alvo usando todas as ferramentas e técnicas do módulo, seguindo a ordem: reconhecimento passivo → ativo → enumeração.

### Conhecimentos Praticados
- Todas as técnicas do módulo
- Ordem correta de reconhecimento
- Documentação e relatório

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| whois | `whois dominio.com` |
| dig | `dig dominio.com` |
| subfinder | `subfinder -d dominio.com` |
| theHarvester | `theHarvester -d dominio.com -b all` |
| nmap | `nmap -sV -sC --script vuln alvo` |

### Passo a Passo

```
PASSO 1: Reconhecimento passivo — WHOIS e DNS
├── Comando: whois gh0st.thm && dig gh0st.thm +short && dig NS gh0st.thm +short
├── O que esperar: Informações de registro, IP e name servers
└── Se der errado: Documentar mesmo que parcial

PASSO 2: Reconhecimento passivo — OSINT
├── Comando: theHarvester -d gh0st.thm -b all -l 500 -f osint.html
├── O que esperar: Emails e subdomínios da empresa
└── Se der errado: Reduzir fontes ou limite

PASSO 3: Enumeração de subdomínios
├── Comando: subfinder -d gh0st.thm -o subdominios.txt
├── O que esperar: Lista de subdomínios encontrados
└── Se der errado: Tentar amass se subfinder falhar

PASSO 4: Reconhecimento ativo — Port scan
├── Comando: nmap -sV -sC -T4 -Pn -p- gh0st.thm -oA nmap_completo
├── O que esperar: Todas as portas abertas com serviços e versões
└── Se der errado: Demora ~15 min, ser paciente

PASSO 5: Scan de vulnerabilidades
├── Comando: nmap --script vuln -T4 -Pn gh0st.thm -oA vuln_scan
├── O que esperar: Vulnerabilidades potenciais encontradas
└── Se der errado: Filtrar apenas portas abertas do scan anterior

PASSO 6: Documentar tudo em relatório
├── Comando: Criar relatório com IP, domínio, portas, serviços, vulnerabilidades
├── O que esperar: Documento organizado com todas as descobertas
└── Se der errado: Usar formato markdown para facilitar
```

### Macetes
> **Macete 1:** Seguir a ordem: passivo → ativo → enumeração reduz chances de ser detectado.

> **Macete 2:** Documentar cada passo enquanto faz — depois fica difícil lembrar.

> **Macete 3:** Usar `-oA` para salvar em todos os formatos (nmap, xml, grepable).

> **Macete 4:** Verificar se o alvo é da TryHackMe antes de escanear (não escaneie alvos reais sem autorização).

### Checklist
- [ ] Reconhecimento passivo completo (WHOIS, DNS, OSINT)
- [ ] Enumeração de subdomínios
- [ ] Scan de portas completo
- [ ] Scan de vulnerabilidades
- [ ] Relatório documentado

### Link para o exercício
https://tryhackme.com/room/gh0st

### Tempo estimado: 60 minutos

---

## Desafio Final

Após completar todos os exercícios, tente fazer o reconhecimento completo da sala **https://tryhackme.com/room/gh0st** sem consultar esta referência. Documente tudo em um relatório com:

1. Informações WHOIS e DNS
2. Subdomínios encontrados
3. Portas abertas e serviços
4. Vulnerabilidades identificadas
5. Próximos passos para exploração

---

## Progresso

| Exercício | Concluído | Notas |
|:----------|:---------:|:------|
| 1 - Whois e DNS Lookup | ⬜ | |
| 2 - Enumeração de Subdomínios | ⬜ | |
| 3 - Scan de Portas com Nmap | ⬜ | |
| 4 - OSINT com theHarvester | ⬜ | |
| 5 - Scan com Nmap Scripts | ⬜ | |
| 6 - Reconhecimento Completo | ⬜ | |
