# Módulo 11 — IA para Cybersegurança

> Como usar Inteligência Artificial no terminal para acelerar seus estudos e trabalhos de segurança.

---

## Por que IA + Cybersegurança?

A IA não substitui o profissional — ela **multiplica** sua produtividade. Em vez de decorar comandos, você usa a IA para:

- **Analisar resultados de scan** em segundos
- **Gerar payloads** personalizados
- **Escrever relatórios** automaticamente
- ** Interpretar logs** e identificar ameaças
- **Aprender mais rápido** com explicações sob demanda

---

## Arquitetura Geral

```
┌──────────────────────────────────────────────────────┐
│                    SEU TERMINAL                       │
│                                                      │
│  ┌─────────────┐    ┌──────────────┐                │
│  │  FERRAMENTAS │    │   IA LOCAL   │                │
│  │  clássicas   │◄──►│  (Ollama)    │                │
│  │              │    │              │                │
│  │  nmap        │    │  llama3      │                │
│  │  hydra       │    │  codellama   │                │
│  │  sqlmap      │    │  mistral     │                │
│  │  wireshark   │    │  deepseek    │                │
│  │  etc.        │    │  etc.        │                │
│  └──────┬───────┘    └──────┬───────┘                │
│         │                   │                        │
│         ▼                   ▼                        │
│  ┌─────────────────────────────────────┐             │
│  │     AGENTES DE IA PARA SEGURANÇA    │             │
│  │                                     │             │
│  │  NFGuard │ CyberStrike │ RAI       │             │
│  │  numasec │ Riftor │ Nemesis        │             │
│  │  CyberMind │ KaliGPT │ etc.        │             │
│  └─────────────────────────────────────┘             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Nível 1 — IA Local com Ollama (Recomendado)

O **Ollama** é a base para rodar modelos de IA localmente no terminal. Dados nunca saem da sua máquina.

### Instalação

```bash
# Instalar Ollama (Linux)
curl -fsSL https://ollama.com/install.sh | sh

# Verificar instalação
ollama --version

# Verificar serviço
systemctl status ollama
```

### Modelos Recomendados para Segurança

| Modelo | Tamanho | RAM Mínima | Uso Principal |
|:-------|:--------|:-----------|:--------------|
| `llama3.2` | 3B | 4GB | Chat geral, explicações |
| `llama3.1:8b` | 8B | 8GB | Análise de código, exploits |
| `codellama:13b` | 13B | 16GB | Geração de código, scripts |
| `mistral` | 7B | 8GB | Raciocínio, análise |
| `deepseek-r1` | 14B | 16GB | Raciocínio avançado, CTF |
| `qwen2.5-coder:32b` | 32B | 32GB | Código complexo |

### Comandos Básicos

```bash
# Baixar um modelo
ollama pull llama3.2

# Rodar um modelo (chat interativo)
ollama run llama3.2

# Listar modelos baixados
ollama ls

# Ver modelos rodando
ollama ps

# Parar um modelo
ollama stop llama3.2

# Remover um modelo
ollama rm llama3.2
```

### Uso na Prática — Analisar Scan do Nmap

```bash
# 1. Rodar scan e salvar em arquivo
nmap -sV -oN scan.txt 192.168.1.1

# 2. Alimentar com IA local
ollama run llama3.1:8b <<EOF
Analise este resultado de Nmap e identifique:
1. Serviços vulneráveis
2. Versões desatualizadas
3. Vetores de ataque possíveis
4. Prioridade de exploração

$(cat scan.txt)
EOF
```

### Uso na Prática — Gerar Payloads

```bash
ollama run codellama:13b <<EOF
Gere um payload em Python para explorar SQL Injection no campo de login 
de um formulário HTML. Use requests e bs4. Inclua tratamento de erros.
EOF
```

### Uso na Prática — Analisar Malware

```bash
# Analisar um script suspeito
ollama run deepseek-r1 <<EOF
Analise este script bash e identifique se é malicioso. 
Se for, explique o que faz passo a passo:

$(cat script_suspeito.sh)
EOF
```

---

## Nível 2 — Ferramentas de IA para Segurança (CLI)

Estas ferramentas usam IA diretamente no terminal, integradas com ferramentas de segurança.

### 2.1 NFGuard — Agente Multi-Ferramentas

**48+ ferramentas de segurança** orquestradas por IA multi-agente.

```bash
# Instalar
curl -sL https://raw.githubusercontent.com/dolutech/nfguard-cli/main/install.sh | sudo bash

# Configurar provedor de IA (Ollama local ou nuvem)
nano ~/.nfguard/providers.yaml

# Iniciar
nfguard
```

**Exemplos de uso:**
```
nfguard> Encontre todos os subdomínios de example.com e verifique portas abertas
nfguard> Escaneie target.com em busca de vulnerabilidades
nfguard> Teste o login para SQL injection
nfguard> Gere um relatório PDF dos nossos achados
nfguard> Verifique se a CVE-2024-1234 está no catálogo KEV
nfguard> Escaneie esta imagem Docker para vulnerabilidades conhecidas
```

**Skills embutidas:**
```
/full-recon       # Reconhecimento completo
/vuln-check       # Verificação de vulnerabilidades
/web-audit        # Auditoria web
```

### 2.2 CyberStrike — Pentest Autônomo

Framework de pentest com IA que combina Claude, GPT, Gemini com ferramentas de segurança.

```bash
# Instalar (npm)
npm i -g @cyberstrike-io/cyberstrike@latest

# Iniciar
cyberstrike

# Ou via curl
curl -fsSL https://cyberstrike.io/install.sh | bash
```

**Funcionalidades:**
- 13+ agentes especializados (recon, web, network, cloud, post-exploitation)
- 7.600+ skills de segurança
- 120+ casos de teste OWASP
- 56+ ferramentas embutidas
- 176+ ferramentas MCP
- Geração automática de relatórios

### 2.3 RAI — Assistente de Segurança Terminal

Agente nativo de terminal para o espectro completo de cibersegurança.

```bash
# Instalar com uv (recomendado)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install revolt-rai

# Ou com pip
pip install revolt-rai

# Ou com pipx
pipx install revolt-rai

# Iniciar
rai
```

**Comandos úteis:**
```bash
rai agents list              # Listar agentes disponíveis
rai threads                  # Gerenciar sessões
rai config show              # Ver configuração
rai skills list              # Listar skills disponíveis
rai claude                   # Modo Claude (sem API key)
```

**Uso em container Docker:**
```bash
docker run -it --rm \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -v ~/.rai:/home/rai/.rai \
  ghcr.io/revoltsecurities/revolt-rai:latest
```

### 2.4 numasec — Agente de Segurança AI

Agente AI open source que usa suas ferramentas locais.

```bash
# Instalar
npm install -g numasec

# Iniciar
numasec
```

**Comandos internos:**
```
/doctor                        # Verificar ferramentas locais
/mode appsec                   # Modo AppSec
/mode pentest                  # Modo Pentest
/runbook list                  # Listar workflows disponíveis
/runbook run appsec-web-triage <target>
/pwn <target>                  # Criar operação pentest
/share                         # Exportar operação
```

**Ferramentas que integra:**
```bash
# Instalar ferramentas que o numasec usa
sudo apt install nmap sqlmap ffuf gobuster nikto nuclei trivy checksec
```

### 2.5 Riftor — AI para Bug Bounty

Agente AI open source para pentest autorizado e bug bounty.

```bash
# Instalar
pip install riftor

# Ou com browser support
pip install 'riftor[browser]'

# Iniciar
riftor

# Modo headless
riftor -p "enumere 10.0.0.5"

# Verificar ferramentas
riftor --doctor
```

**Funcionalidades:**
- 350+ skills de metodologia
- Workers paralelos
- Browser opcional para SPA
- Enforcement de escopo
- Relatórios em md/html/json/SARIF
- Checklists OWASP/PTES

### 2.6 CyberMind — CLI para Kali Linux

Ferramenta AI em Go, binário único para Kali Linux.

```bash
# Instalar (Linux/Kali)
curl -fsSL https://raw.githubusercontent.com/gitmanfel/cybermind/main/install.sh | bash

# Iniciar
cybermind
```

**Modos disponíveis:**
```
Modo Scan        # Network e web scanning guiado por IA
Modo Recon       # OSINT, subdomínios, recon passivo/ativo
Modo Exploit     # Guias CVE, módulos Metasploit
Modo Payload     # Geração de payloads msfvenom
Modo Tool        # Deep-dive em qualquer ferramenta Kali
```

**Exemplos:**
```bash
cybermind tool sqlmap "encontre SQLi no login form"
cybermind tool nmap "escaneie vulnerabilidades SMB"
cybermind tool hashcat "quebre hashes NTLM"
cybermind tool bloodhound "encontre caminhos para domain admin"
```

### 2.7 KaliGPT — AI para Ethical Hacking

```bash
# Instalar
curl -sL https://raw.githubusercontent.com/SudoHopeX/KaliGPT/refs/heads/hackerx/install.sh | bash
sudo bash kaligptinstaller.sh

# Usar
kaligpt "Me ajude a encontrar XSS em target.com"
kaligpt -g "Como escanear subdomínios com ferramentas"
kaligpt -o "Explique este resultado do Nmap"
```

**Provedores suportados:**
- Gemini (padrão, online)
- Ollama (offline/local)
- OpenRouter (online)
- ChatGPT (online)
- LiteLLM (100+ provedores)

### 2.8 Nemesis — Copilot para Pentest

Assistente AI com filosofia "você dirige, a IA assiste".

```bash
# Instalar
git clone https://github.com/joaovicdev/nemesis
cd nemesis
uv sync
uv run nemesis

# Ou com Ollama (padrão)
ollama pull llama3.1:8b
```

**Agentes especializados:**
- Recon
- Scanning
- Enumeration
- Vulnerability
- Nuclei
- ffuf

**Fluxo de trabalho:**
1. Planning estruturado com planos de ataque multi-etapa
2. Agentes especializados executam ferramentas
3. Analyst filtra ruído e correlaciona achados
4. Achados progridem: RAW → UNVERIFIED → VALIDATED/DISMISSED

---

## Nível 3 — IA para Cada Fase da Segurança

### Fase 1: Reconhecimento

```bash
# Usar IA para analisar DNS
ollama run llama3.2 <<EOF
Liste todas as técnicas de enumeração de subdomínios 
que eu posso usar no domínio example.com. 
Para cada uma, dê o comando exato.
EOF

# Usar IA para interpretar Whois
whois example.com | ollama run llama3.2 "Analise este Whois e identifique informações úteis para pentest"
```

### Fase 2: Web & Aplicações

```bash
# IA para gerar wordlists personalizadas
ollama run codellama:13b <<EOF
Gere uma wordlist de 200 palavras para brute force 
em um site de e-commerce brasileiro. Inclua:
- Termos de login (admin, usuario, senha)
- Termos de e-commerce (pedido, carrinho, produto)
- Termos brasileiros (senha123, Brasil, etc)
EOF

# IA para analisar resultados do Nikto
nikto -h target.com -o nikto.txt
ollama run llama3.1:8b "Analise este relatório Nikto e priorize as vulnerabilidades: $(cat nikto.txt)"
```

### Fase 3: Exploração

```bash
# IA para gerar payloads
ollama run codellama:13b <<EOF
Gere payloads para SQL Injection nos seguintes contextos:
1. Login form (campo username)
2. URL com parâmetro id
3. Header HTTP User-Agent
Inclua payloads para MySQL, PostgreSQL e MSSQL.
EOF

# IA para analisar hashcat output
hashcat -m 0 hashes.txt rockyou.txt --potfile-path=pot.txt
ollama run llama3.2 "Analise estes resultados do hashcat e explique as senhas quebradas: $(cat pot.txt)"
```

### Fase 4: Pós-Exploração

```bash
# IA para interpretar LinPEAS
./linpeas.sh | ollama run llama3.1:8b <<EOF
Analise a saída do LinPEAS e identifique:
1. Vetores de escalação de privilégio
2. Credenciais expostas
3. Configurações inseguras
4. Prioridade de exploração
EOF
```

### Fase 5: Relatórios

```bash
# IA para gerar relatório
ollama run llama3.2 <<EOF
Gere um relatório profissional de pentest em formato Markdown com:
1. Resumo Executivo
2. Escopo e Metodologia
3. Vulnerabilidades encontradas (com CVSS)
4. Evidências (comandos executados)
5. Recomendações de correção
6. Classificação de risco

Dados do scan:
$(cat relatorio_bruto.txt)
EOF
```

---

## Nível 4 — Prompts Profissionais para Segurança

### Prompt para Análise de Vulnerabilidade

```
Você é um analista de segurança especializado em vulnerability assessment.
Analise o seguinte output de ferramenta de scan e forneça:

1. Lista de vulnerabilidades encontradas (CVE se disponível)
2. CVSS score estimado para cada uma
3. Vetor de ataque para cada vulnerabilidade
4. Exploração possível (PoC conceitual)
5. Recomendação de remediação
6. Prioridade (Crítica/Alta/Média/Baixa)

Dados:
[COLAR OUTPUT AQUI]
```

### Prompt para Geração de Exploit

```
Você é um pesquisador de segurança especializado em exploit development.
Crie um exploit conceitual (PoC) para a seguinte vulnerabilidade:

- CVE: [NUMERO]
- Serviço: [NOME]
- Versão: [VERSÃO]
- Tipo: [BUFFER OVERFLOW/SQLI/XSS/etc]

Requisitos:
- Código em Python 3
- Comentários explicativos em português
- Tratamento de erros
- Modo dry-run (não executar ataques reais)
- Apenas para fins educacionais
```

### Prompt para Análise de Malware

```
Você é um analista de malware especializado em engenharia reversa.
Analise o seguinte arquivo/código e identifique:

1. Tipo de malware (trojan/ransomware/spyware/etc)
2. Vetor de infecção
3. Comunicação C2 (se houver)
4. Técnicas de evasão
5. Dados que coleta
6. Indicadores de comprometimento (IOCs)
7. YARA rule para detecção

Código/Arquivo:
[COLAR AQUI]
```

### Prompt para Blue Team / Defesa

```
Você é um analista SOC especializado em detecção de ameaças.
Analise os seguintes logs e identifique:

1. Atividade suspeita
2. Indicadores de comprometimento (IOCs)
3. Técnicas MITRE ATT&CK utilizadas
4. Severidade do incidente
5. Ações de contenção recomendadas
6. Queries SIEM para detecção futura

Logs:
[COLAR LOGS AQUI]
```

---

## Nível 5 — Dicas Avançadas

### Ollama + Nmap Pipeline

```bash
#!/bin/bash
# Script: ai-scan.sh
# Escaneia e analisa com IA automaticamente

TARGET=$1
echo "[*] Escaneando $TARGET..."
nmap -sV -sC -oX scan.xml $TARGET

echo "[*] Analisando com IA..."
ollama run llama3.1:8b <<EOF
Analise este scan Nmap em XML e identifique vulnerabilidades:
$(cat scan.xml | xmllint --format -)
EOF
```

### Ollama + Metasploit Pipeline

```bash
#!/bin/bash
# Script: ai-msf.sh
# Usa IA para sugerir módulos do Metasploit

TARGET=$1
PORT=$2

SUGGESTION=$(ollama run llama3.2 <<EOF
Para o alvo $TARGET na porta $PORT, sugira:
1. Módulos do Metasploit mais adequados
2. Opções de payload
3. Configuração necessária
4. Comandos exatos do msfconsole
EOF
)

echo "$SUGGESTION"
```

### Cache de IA para Análises Repetidas

```bash
# Criar funções auxiliares no .zshrc

# Analisar com IA
ai-analise() {
    ollama run llama3.1:8b "Analise esta saída de segurança e identifique vulnerabilidades: $(cat $1)"
}

# Gerar relatório
ai-relatorio() {
    ollama run llama3.2 "Gere um relatório profissional de pentest: $(cat $1)"
}

# Gerar payload
ai-payload() {
    ollama run codellama:13b "Gere um payload para: $1"
}
```

### Modelos Específicos para Tarefas

| Tarefa | Modelo Recomendado | Motivo |
|:-------|:-------------------|:-------|
| Chat geral | `llama3.2` | Rápido, leve |
| Análise de código | `codellama:13b` | Focado em código |
| Raciocínio complexo | `deepseek-r1` | Chain-of-thought |
| Geração de exploits | `codellama:13b` | Código preciso |
| Análise de logs | `mistral` | Bom contexto |
| Relatórios | `llama3.2` | Formatação boa |
| CTF/Desafios | `deepseek-r1` | Raciocínio avançado |

---

## Segurança e Ética

> ⚠️ **REGRAS ABSOLUTAS:**

1. **Nunca** use IA para atacar sistemas sem autorização
2. **Nunca** envie dados sensíveis para provedores de nuvem
3. **Sempre** use modelos locais (Ollama) para dados confidenciais
4. **Sempre** tenha autorização por escrito antes de testar
5. **Nunca** compartilhe API keys em scripts ou repositórios
6. **Valide** sempre a saída da IA — modelos podem alucinar

---

## Próximos Passos

1. Instale o Ollama e teste com `llama3.2`
2. Experimente o NFGuard ou CyberStrike
3. Pratique os prompts deste módulo
4. Crie seus próprios workflows de IA + segurança
5. Integre IA em seu fluxo diário de estudo

---

**Módulo anterior:** [10. Governança & Criptografia](../10-governanca/)
**Voltar ao início:** [Voltar à Trilha](../README.md)
