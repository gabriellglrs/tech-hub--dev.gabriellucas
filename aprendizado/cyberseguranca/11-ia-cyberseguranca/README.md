# Módulo 11 — IA para Cybersegurança

> Como usar Inteligência Artificial no terminal para acelerar seus estudos e trabalhos de segurança.

---

## O que você vai aprender

- [ ] Instalar e usar Ollama (LLMs locais)
- [ ] Configurar CAI Framework para pentest automatizado
- [ ] Usar PromptSentinel para detectar prompt injection
- [ ] Aplicar IA em cada fase do pentest
- [ ] Criar prompts eficazes para segurança
- [ ] Entender e prevenir prompt injection

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Ollama, pip, npm |
| Módulos 1-6 | ⭐⭐⭐ | Conhecimento de ataque e defesa |
| Python | ⭐ | pip install |

---

## Navegação

| Arquivo | Conteúdo |
|:--------|:---------|
| [01-ia-local-ollama.md](01-ia-local-ollama.md) | Ollama: instalação, modelos, uso na prática |
| [02-ferramentas-ia-cli.md](02-ferramentas-ia-cli.md) | CAI, PromptSentinel, numasec — Tool Cards completos |
| [03-ia-por-fase.md](03-ia-por-fase.md) | IA para cada fase do pentest |
| [04-prompts-seguranca.md](04-prompts-seguranca.md) | Biblioteca de prompts prontos |
| [05-prompt-injection.md](05-prompt-injection.md) | Ataques e defesas contra prompt injection |

---

## Ferramentas Principais

| Ferramenta | Uso | Instalação |
|:-----------|:----|:-----------|
| **Ollama** | LLMs locais | `curl -fsSL https://ollama.com/install.sh \| sh` |
| **CAI Framework** | Pentest com IA | `pip install cai-framework` |
| **PromptSentinel** | Detecção de prompt injection | `pip install promptsentinel` |

## Referências

- [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [Alias Robotics CAI](https://github.com/aliasrobotics/cai)
- [Ollama Models](https://ollama.com/library)
- [PromptSentinel](https://github.com/promptsentinel)
