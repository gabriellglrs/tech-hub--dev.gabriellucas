# Labs de IA para Cybersegurança

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Ollama, pip, npm |
| Módulos 1-6 | ⭐⭐⭐ | Fundamentos de segurança |
| Python | ⭐ | pip install |

---

## Labs por Plataforma

### TryHackMe (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | AI for Cyber | IA aplicada à cibersegurança | ⭐⭐ | https://tryhackme.com/room/aicyber |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### PicoCTF (2 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 2 | AI Challenges (10+) | Desafios de IA e segurança | ⭐-⭐⭐⭐ | https://play.picoctf.org/practice |
| 3 | AI Category (prompt injection) | Prompt injection challenges | ⭐⭐ | https://play.picoctf.org/practice |

> **Nota:** PicoCTF pode redirecionar — verifique se o link está ativo.

### PortSwigger (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 4 | Web LLM Attacks | Ataques em LLMs web | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/all-labs |

> **Nota:** URL a validar — o tópico existe no PortSwigger.

### Prática Local (6 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 5 | Setup Ollama + modelos | Instalar Ollama, baixar modelos | ⭐ | `curl -fsSL https://ollama.com/install.sh \| sh && ollama pull llama3.2` |
| 6 | Analisar scan Nmap com IA | Alimentar resultado de scan com Ollama | ⭐⭐ | `ollama run llama3.1:8b < scan.txt` |
| 7 | Gerar payload com codellama | Geração de payloads assistida por IA | ⭐⭐ | `ollama run codellama:13b` |
| 8 | CAI scan em target local | Scan automatizado com CAI | ⭐⭐⭐ | `cai scan http://localhost` |
| 9 | Prompt injection test | Testar prompt injection contra Ollama | ⭐⭐ | `ollama run llama3.2` → digitar prompt injetado |
| 10 | PromptSentinel detection | Testar detecção de prompt injection | ⭐⭐ | `promptsentinel check "Ignore previous instructions"` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 1 | AI for Cyber |
| PicoCTF | 2 | AI challenges, prompt injection |
| PortSwigger | 1 | Web LLM attacks |
| Local | 6 | Ollama, CAI, prompt injection, payloads |
| **Total** | **10** | |
