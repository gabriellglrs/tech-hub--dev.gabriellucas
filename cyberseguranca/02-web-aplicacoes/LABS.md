# Laboratório Prático — Web & Aplicações

> Guia completo de exercícios para praticar o que aprendeu. Cada exercício tem objetivo, passo a passo, macetes e o que esperar do resultado.

---

## Pré-requisitos

- [ ] Ferramentas instaladas (ver Instalação no módulo principal)
- [ ] Conta no TryHackMe (gratuita: https://tryhackme.com)
- [ ] Conta no HackTheBox (gratuita: https://hackthebox.com)
- [ ] whatweb, wafw00f instalados
- [ ] gobuster/feroxbuster instalados
- [ ] sqlmap instalado (`sudo apt install sqlmap`)
- [ ] nikto instalado (`sudo apt install nikto`)
- [ ] ffuf instalado (`go install github.com/ffuf/ffuf/v2@latest`)
- [ ] Wordlists (SecLists: `sudo apt install seclists` ou `git clone https://github.com/danielmiessler/SecLists`)

---

## O que você vai praticar

| Exercício | Conhecimento | Ferramentas | Dificuldade | Tempo |
|:----------|:-------------|:------------|:-----------:|:-----:|
| 1 | CMS, frameworks, WAF detection | whatweb, wafw00f | ⭐ | 20 min |
| 2 | Directory brute force, wordlists | gobuster, feroxbuster | ⭐⭐ | 30 min |
| 3 | SQLi types, database enumeration | sqlmap | ⭐⭐⭐ | 40 min |
| 4 | Web vulnerabilities, headers | nikto | ⭐⭐ | 35 min |
| 5 | Parameter fuzzing, GET/POST | ffuf | ⭐⭐⭐ | 30 min |
| 6 | Técnicas completas de pentest web | all | ⭐⭐⭐⭐ | 90 min |

---

## Exercício 1: Enumeração com WhatWeb e Wafw00f

### Objetivo
Identificar tecnologias, CMS, frameworks e WAF (Web Application Firewall) de um site.

### Conhecimentos Praticados
- Detecção de CMS (WordPress, Joomla, Drupal)
- Identificação de frameworks e bibliotecas
- Detecção de WAF

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| whatweb | `whatweb -v alvo.com` |
| whatweb (agressivo) | `whatweb -a 3 alvo.com` |
| wafw00f | `wafw00f alvo.com` |
| wafw00f (todos) | `wafw00f -a alvo.com` |

### Passo a Passo

```
PASSO 1: Scan básico com whatweb
├── Comando: whatweb tryhackme.com
├── O que esperar: Tecnologias, CMS, headers identificados
└── Se der errado: Instalar com sudo apt install whatweb

PASSO 2: Scan verbose com whatweb
├── Comando: whatweb -v tryhackme.com
├── O que esperar: Detalhes de cada tecnologia encontrada
└── Se der errado: Usar -v para verbose e -a 3 para modo agressivo

PASSO 3: Scan agressivo
├── Comando: whatweb -a 3 tryhackme.com
├── O que esperar: Mais detalhes, mas maior chance de detecção
└── Se der errado: Usar modo padrão se o alvo bloquear

PASSO 4: Detecção de WAF
├── Comando: wafw00f tryhackme.com
├── O que esperar: Nome do WAF ou "No WAF detected"
└── Se der errado: Instalar com pip3 install wafw00f

PASSO 5: Scan completo de WAF
├── Comando: wafw00f -a tryhackme.com
├── O que esperar: Todos os checks de WAF executados
└── Se der errado: Usar -v para verbose

PASSO 6: Combinar resultados
├── Comando: whatweb -v tryhackme.com 2>&1 | tee whatweb.txt && wafw00f tryhackme.com 2>&1 | tee waf.txt
├── O que esperar: Arquivos de texto com resultados
└── Se der errado: Criar script bash para automatizar
```

### Macetes
> **Macete 1:** `whatweb -v` retorna mais detalhes de cada tecnologia encontrada.

> **Macete 2:** `wafw00f -a` faz todos os checks — útil para identificar WAFs específicos.

> **Macete 3:** Combinar whatweb + wafw00f dá visão completa do alvo web.

> **Macete 4:** Use `whatweb -a 3` para modo agressivo (mais detalhes, mais risco de detecção).

### Checklist
- [ ] Identificar CMS e frameworks com whatweb
- [ ] Detectar WAF com wafw00f
- [ ] Salvar resultados em arquivos
- [ ] Combinar informações de ambas ferramentas

### Link para o exercício
https://tryhackme.com/room/dvwa

### Tempo estimado: 20 minutos

---

## Exercício 2: Descoberta de Diretórios com Gobuster

### Objetivo
Encontrar diretórios e arquivos ocultos em um site usando brute force de diretórios.

### Conhecimentos Praticados
- Directory brute force
- Wordlists para web
- Códigos de resposta HTTP

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| gobuster | `gobuster dir -u alvo.com -w wordlist.txt` |
| feroxbuster | `feroxbuster -u alvo.com -w wordlist.txt` |
| dirsearch | `dirsearch -u alvo.com` |

### Passo a Passo

```
PASSO 1: Preparar wordlist
├── Comando: ls /usr/share/wordlists/dirbuster/
├── O que esperar: Listas como directory-list-2.3-medium.txt
└── Se der errado: Usar /usr/share/seclists/Discovery/Web-Content/

PASSO 2: Scan básico com gobuster
├── Comando: gobuster dir -u tryhackme.com -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
├── O que esperar: Lista de diretórios encontrados
└── Se der errado: Usar wordlist menor para teste rápido

PASSO 3: Filtrar por código HTTP
├── Comando: gobuster dir -u tryhackme.com -w wordlist.txt -b 403,404,500
├── O que esperar: Apenas diretórios com resposta 200/301/302
└── Se der errado: Incluir 403 se quiser ver diretórios proibidos

PASSO 4: Adicionar extensões
├── Comando: gobuster dir -u tryhackme.com -w wordlist.txt -x php,html,txt,js
├── O que esperar: Arquivos com essas extensões também testados
└── Se der errado: Adicionar extensões específicas do alvo

PASSO 5: Usar feroxbuster (alternativa mais rápida)
├── Comando: feroxbuster -u tryhackme.com -w wordlist.txt --threads 50
├── O que esperar: Scan mais rápido com threads paralelas
└── Se der errado: Reduzir threads se houver rate limiting

PASSO 6: Salvar resultados
├── Comando: gobuster dir -u tryhackme.com -w wordlist.txt -o resultados.txt
├── O que esperar: Arquivo com todos os diretórios encontrados
└── Se der errado: Redirecionar output com > para arquivo
```

### Macetes
> **Macete 1:** `-b 404` filtra respostas 404 — reduz falsos positivos.

> **Macete 2:** `-x php,html,txt` testa múltiplas extensões — mais completo que só diretórios.

> **Macete 3:** feroxbuster é mais rápido que gobuster para scans grandes.

> **Macete 4:** Comece com wordlist pequena (`-w small.txt`) para testar antes de usar a grande.

### Checklist
- [ ] Realizar scan de diretórios básico
- [ ] Filtrar códigos HTTP
- [ ] Testar extensões de arquivo
- [ ] Comparar resultados entre gobuster e feroxbuster
- [ ] Salvar e analisar resultados

### Link para o exercício
https://tryhackme.com/room/dvwa

### Tempo estimado: 30 minutos

---

## Exercício 3: SQL Injection com SQLMap

### Objetivo
Detectar e explorar SQL Injection automaticamente usando sqlmap, enumerando bancos de dados.

### Conhecimentos Praticados
- SQL Injection (SQLi)
- Enumeração de bancos de dados
- Extração de dados

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| sqlmap (básico) | `sqlmap -u "alvo.com/page?id=1"` |
| sqlmap (batch) | `sqlmap -u "url" --batch` |
| sqlmap (dbs) | `sqlmap -u "url" --dbs` |

### Passo a Passo

```
PASSO 1: Verificar URL vulnerável
├── Exemplo: http://testphp.vulnweb.com/listproducts.php?cat=1
├── O que esperar: Página com parâmetro na URL
└── Se der errado: Usar DVWA ou outro site de teste

PASSO 2: Testar SQLi básico
├── Comando: sqlmap -u "http://testphp.vulnweb.com/listproducts.php?cat=1" --batch
├── O que esperar: SQLMap detecta se é vulnerável ou não
└── Se der errado: Adicionar --level=5 --risk=3 para teste mais agressivo

PASSO 3: Listar bancos de dados
├── Comando: sqlmap -u "http://testphp.vulnweb.com/listproducts.php?cat=1" --dbs --batch
├── O que esperar: Lista de bancos de dados do servidor
└── Se der errado: Confirmar SQLi com --flush-session e tentar novamente

PASSO 4: Selecionar banco de dados
├── Comando: sqlmap -u "url" -D nome_banco --tables --batch
├── O que esperar: Lista de tabelas do banco selecionado
└── Se der errado: Verificar nome do banco com --dbs

PASSO 5: Extrair dados de tabela
├── Comando: sqlmap -u "url" -D nome_banco -T tabela --dump --batch
├── O que esperar: Conteúdo completo da tabela (usuários, senhas, etc.)
└── Se der errado: Usar --start=1 --stop=100 para limitar registros

PASSO 6: Extrair todos os dados
├── Comando: sqlmap -u "url" --dump-all --batch
├── O que esperar: Todos os bancos, tabelas e dados extraídos
└── Se der errado: Usar --threads 10 para acelerar
```

### Macetes
> **Macete 1:** `--batch` faz tudo automaticamente sem pedir confirmação — ideal para automação.

> **Macete 2:** `--level=5 --risk=3` testa mais payloads — maior chance de encontrar SQLi.

> **Macete 3:** `--dbs` primeiro, depois `--tables`, depois `--dump` — siga a ordem correta.

> **Macete 4:** Para POST requests, use `--data="campo=valor"` ou `--forms` para auto-detect.

### Checklist
- [ ] Detectar SQLi com sqlmap
- [ ] Enumerar bancos de dados
- [ ] Listar tabelas de um banco
- [ ] Extrair dados sensíveis
- [ ] Documentar findings

### Link para o exercício
https://tryhackme.com/room/sqlinjectionlm

### Tempo estimado: 40 minutos

---

## Exercício 4: Scan de Vulnerabilidades com Nikto

### Objetivo
Identificar vulnerabilidades conhecidas em web servers usando nikto.

### Conhecimentos Praticados
- Vulnerabilidades de web server
- Headers de segurança
- Misconfigurations

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| nikto (básico) | `nikto -h alvo.com` |
| nikto (tuning) | `nikto -h alvo.com -Tuning 123bde` |
| nikto (tunnel) | `nikto -h alvo.com -useproxy http://proxy:8080` |

### Passo a Passo

```
PASSO 1: Scan básico
├── Comando: nikto -h tryhackme.com
├── O que esperar: Lista de vulnerabilidades e misconfigurations
└── Se der errado: Instalar com sudo apt install nikto

PASSO 2: Scan com tuning específico
├── Comando: nikto -h tryhackme.com -Tuning 123bde
├── O que esperar: Testes específicos (1=Informação, 2=Vulnerabilidades, 3=Misconfigs)
└── Se der errado: Usar -Tuning 0 para todos os testes

PASSO 3: Scan via proxy
├── Comando: nikto -h tryhackme.com -useproxy http://127.0.0.1:8080
├── O que esperar: Scan passando pelo proxy (para MITM)
└── Se der errado: Verificar se proxy está rodando

PASSO 4: Scan com timeout
├── Comando: nikto -h tryhackme.com -timeout 10
├── O que esperar: Scan com timeout maior por request
└── Se der errado: Reduzir timeout se houver muitas falhas de conexão

PASSO 5: Salvar em formato XML
├── Comando: nikto -h tryhackme.com -o nikto_resultado.xml -Format xml
├── O que esperar: Arquivo XML para análise posterior
└── Se der errado: Usar -Format htm para HTML legível

PASSO 6: Scan em massa (múltiplos alvos)
├── Comando: nikto -h lista_alvos.txt -o nikto_massa.txt
├── O que esperar: Scan de todos os alvos na lista
└── Se der errado: Criar arquivo com um alvo por linha
```

### Macetes
> **Macete 1:** `-Tuning 123bde` foca em testes específicos — mais rápido que rodar todos.

> **Macete 2:** `-C all` força todos os checks — útil para auditoria completa.

> **Macete 3:** `-o arquivo.xml -Format xml` gera saída estruturada para parsing automatizado.

> **Macete 4:** Use `-useproxy` quando quiser que o scan passe pelo seu proxy interceptador.

### Checklist
- [ ] Realizar scan básico
- [ ] Testar tuning específico
- [ ] Scan via proxy
- [ ] Salvar em formato XML
- [ ] Analisar vulnerabilidades encontradas

### Link para o exercício
https://tryhackme.com/room/dvwa

### Tempo estimado: 35 minutos

---

## Exercício 5: Fuzzing com ffuf

### Objetivo
Descobrir parâmetros e endpoints ocultos via fuzzing de parâmetros GET/POST.

### Conhecimentos Praticados
- Parameter fuzzing
- GET/POST parameter discovery
- Fuzzing de headers

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| ffuf (dir) | `ffuf -u alvo.com/FUZZ -w wordlist.txt` |
| ffuf (param) | `ffuf -u alvo.com/page?FUZZ=test -w params.txt` |
| ffuf (POST) | `ffuf -u alvo.com/login -X POST -d "FUZZ=admin" -w wordlist.txt` |

### Passo a Passo

```
PASSO 1: Directory fuzzing básico
├── Comando: ffuf -u tryhackme.com/FUZZ -w /usr/share/wordlists/dirb/common.txt
├── O que esperar: Diretórios encontrados com status 200
└── Se der errado: Usar wordlist menor para teste

PASSO 2: Filtrar por status code
├── Comando: ffuf -u tryhackme.com/FUZZ -w wordlist.txt -mc 200,301,302
├── O que esperar: Apenas diretórios com esses status codes
└── Se der errado: Usar -mc 200 para apenas OK

PASSO 3: Filtro por tamanho de resposta
├── Comando: ffuf -u tryhackme.com/FUZZ -w wordlist.txt -fs 4242
├── O que esperar: Exclui respostas com tamanho 4242 (falsos positivos)
└── Se der errado: Verificar tamanho da resposta 404 para filtrar

PASSO 4: Parameter fuzzing GET
├── Comando: ffuf -u "tryhackme.com/page?FUZZ=test" -w /usr/share/wordlists/params.txt -mc 200
├── O que esperar: Parâmetros aceitos pela aplicação
└── Se der errado: Criar wordlist de parâmetros comuns

PASSO 5: Parameter fuzzing POST
├── Comando: ffuf -u tryhackme.com/login -X POST -d "FUZZ=admin" -w users.txt -mc 200
├── O que esperar: Usuários que existem (resposta diferente)
└── Se der errado: Filtrar por tamanho de resposta em vez de status

PASSO 6: Fuzzing de subdomínios
├── Comando: ffuf -u http://FUZZ.tryhackme.com -w subdomains.txt -mc 200
├── O que esperar: Subdomínios que respondem
└── Se der errado: Usar DNS resolution com -recursion
```

### Macetes
> **Macete 1:** `FUZZ` é o placeholder — posiciona onde o fuzzing deve ocorrer.

> **Macete 2:** `-mc 200` filtra por status code — essencial para reduzir ruído.

> **Macete 3:** `-fs <tamanho>` filtra por tamanho de resposta — útil quando status é igual para todos.

> **Macete 4:** Para POST, `-d "FUZZ=admin"` testa valores no body da requisição.

### Checklist
- [ ] Directory fuzzing básico
- [ ] Filtrar por status e tamanho
- [ ] Parameter fuzzing GET
- [ ] Parameter fuzzing POST
- [ ] Subdomain fuzzing

### Link para o exercício
https://tryhackme.com/room/dvwa

### Tempo estimado: 30 minutos

---

## Exercício 6: Pentest Web Completo (Desafio Final)

### Objetivo
Realizar pentest completo de uma aplicação web, seguindo a ordem: enumeração → scan → exploração → documentação.

### Conhecimentos Praticados
- Todas as técnicas do módulo
- Metodologia de pentest web
- Documentação profissional

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| whatweb/wafw00f | Enumeração inicial |
| gobuster/ffuf | Descoberta de conteúdo |
| nikto | Scan de vulnerabilidades |
| sqlmap | Exploração de SQLi |

### Passo a Passo

```
PASSO 1: Enumeração inicial
├── Comando: whatweb -v alvo.com && wafw00f alvo.com
├── O que esperar: Tecnologias, CMS e WAF identificados
└── Se der errado: Documentar mesmo que parcial

PASSO 2: Descoberta de conteúdo
├── Comando: gobuster dir -u alvo.com -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -b 404 -x php,html,txt
├── O que esperar: Diretórios e arquivos encontrados
└── Se der errado: Usar feroxbuster para alternativa mais rápida

PASSO 3: Fuzzing de parâmetros
├── Comando: ffuf -u "alvo.com/page?FUZZ=test" -w params.txt -mc 200
├── O que esperar: Parâmetros aceitos pela aplicação
└── Se der errado: Criar wordlist com parâmetros comuns (id, user, page, search)

PASSO 4: Scan de vulnerabilidades
├── Comando: nikto -h alvo.com -Tuning 123bde -o nikto_pentest.txt
├── O que esperar: Vulnerabilidades e misconfigurations
└── Se der errado: Aumentar timeout se houver conexões perdidas

PASSO 5: Exploração de SQLi
├── Comando: sqlmap -u "alvo.com/page?id=1" --batch --dbs --dump
├── O que esperar: Bancos de dados e dados extraídos
└── Se der errado: Usar --forms se a URL não tiver parâmetros visíveis

PASSO 6: Documentar findings
├── Ação: Criar relatório com: achados, risco, evidências, recomendações
├── O que esperar: Documento profissional com todos os passos
└── Se der errado: Usar template de relatório de pentest
```

### Macetes
> **Macete 1:** Siga a ordem: enum → scan → exploit → documentar — nunca pule etapas.

> **Macete 2:** Documente cada ferramenta usada e seus resultados — essencial para o relatório.

> **Macete 3:** Use `-o` para salvar saída de cada ferramenta em arquivos separados.

> **Macete 4:** Para POST forms, use `sqlmap -u "url" --forms --batch` para auto-detect.

### Checklist
- [ ] Enumeração completa (tecnologias, WAF)
- [ ] Descoberta de conteúdo (diretórios, arquivos)
- [ ] Fuzzing de parâmetros
- [ ] Scan de vulnerabilidades
- [ ] Exploração de SQLi
- [ ] Relatório documentado

### Link para o exercício
https://tryhackme.com/room/dvwa

### Tempo estimado: 90 minutos

---

## Desafio Final

Após completar todos os exercícios, tente o pentest completo da sala **https://tryhackme.com/room/dvwa** (DVWA - Damn Vulnerable Web Application). Seu objetivo:

1. Enumerar tecnologias e WAF
2. Encontrar diretórios ocultos
3. Identificar parâmetros vulneráveis
4. Explorar SQL Injection
5. Extrair dados do banco
6. Documentar todo o processo em relatório

**Dica:** DVWA tem múltiplos níveis de dificuldade (Low → Impossible). Comece pelo nível mais baixo.

---

## Progresso

| Exercício | Concluído | Notas |
|:----------|:---------:|:------|
| 1 - Enumeração com WhatWeb/Wafw00f | ⬜ | |
| 2 - Diretórios com Gobuster | ⬜ | |
| 3 - SQL Injection com SQLMap | ⬜ | |
| 4 - Vulnerabilidades com Nikto | ⬜ | |
| 5 - Fuzzing com ffuf | ⬜ | |
| 6 - Pentest Web Completo | ⬜ | |
