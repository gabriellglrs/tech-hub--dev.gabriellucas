# 🎯 Módulo 3: Exploração

> Quebre qualquer senha e explore serviços para obter acesso total.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 4-5 horas | ⭐⭐ Intermediário | 2 | 6 |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Realizar ataques de brute force em serviços (SSH, FTP, HTTP)
- [ ] Quebrar hashes de senhas com John e Hashcat
- [ ] Criar wordlists e lists de usuários customizados
- [ ] Identificar tipos de hash e escolher a ferramenta correta
- [ ] Entender mecanismos de autenticação e suas fraquezas

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico | Sim | Módulo 0 do curso |
| Redes (TCP/IP, portas) | Sim | Fundamentos de Redes |
| Módulo 1: Reconhecimento | Sim | [Módulo 1](../01-reconhecimento/) |
| Módulo 2: Web & Aplicações | Recomendado | [Módulo 2](../02-web-aplicacoes/) |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────┐
│                   EXPLORAÇÃO                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌─────────────────────────────────────────────────┐   │
│   │           BRUTE FORCE                           │   │
│   │                                                 │   │
│   │  • Hydra ──── SSH, FTP, HTTP, SMB, RDP         │   │
│   │  • Medusa ─── Múltiplos protocolos              │   │
│   │  • Ncrack ─── Serviços de rede                  │   │
│   └──────────────────────┬──────────────────────────┘   │
│                          │                               │
│                          ▼                               │
│   ┌─────────────────────────────────────────────────┐   │
│   │           QUEBRA DE HASHES                      │   │
│   │                                                 │   │
│   │  • hashid ──── Identificar tipo de hash         │   │
│   │  • John ────── CPU (muitos formatos)            │   │
│   │  • Hashcat ─── GPU (muito mais rápido)          │   │
│   └──────────────────────┬──────────────────────────┘   │
│                          │                               │
│                          ▼                               │
│   ┌─────────────────────────────────────────────────┐   │
│   │           WORDLISTS                             │   │
│   │                                                 │   │
│   │  • CeWL ────── Gerar de sites web               │   │
│   │  • Crunch ──── Gerar por padrão/charset         │   │
│   │  • SecLists ── Coleção completa                 │   │
│   └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 1 | [01-brute-force-e-cracking.md](01-brute-force-e-cracking.md) | Quebrar senhas e hashes de serviços | `Hydra, John, Hashcat, hashid` | 3h |
| 2 | [02-wordlists-e-ferramentas.md](02-wordlists-e-ferramentas.md) | Usar e criar listas de senhas e usuários | `CeWL, Crunch, SecLists` | 2h |

---

## 💡 Dicas de Ouro

> **Dica 1:** Sempre identifique o hash com `hashid` antes de tentar quebrar. Usar o modo errado é perda de tempo.

> **Dica 2:** John com `--wordlist` e `--rules` quebra muito mais senhas que apenas lista pura. Explore as regras!

> **Dica 3:** Hashcat na GPU é 10-100x mais rápido que John na CPU. Para hashes simples, sempre prefira Hashcat.

---

## 🤖 IA para Este Módulo

```bash
# Gerar wordlists inteligentes com IA
ollama run codellama:13b "Gere uma wordlist de 500 senhas comuns em português para brute force"

# Analisar hashes quebrados
ollama run llama3.2 "Analise estas senhas quebradas e identifique padrões fracos: $(cat pot.txt)"

# Sugerir modos Hashcat
hashid '$2y$10$hash'
ollama run llama3.2 "Qual modo do Hashcat devo usar para este hash: $(hashid '$2y$10$hash')"
```

**Ferramentas de IA para exploração:** NFGuard (`nfguard> Teste SQL injection no login`), CyberMind (`cybermind tool hashcat`)

---

## ⚠️ Erros Comuns (e como evitar)

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Usar `-t 64` no Hydra | Falsos positivos e bloqueio por rate-limiting | Comece com `-t 4` e aumente gradualmente |
| Não identificar o hash | Perda de tempo tentando modos errados | Rode `hashid` ou `hash-identifier` primeiro |
| Esquecer regras no John | Senhas complexas não quebradas | Use `--rules` ou crie regras customizadas |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

## 🎮 Labs Recomendados

| Lab | Plataforma | Dificuldade | Tempo | Link |
|:----|:----------:|:-----------:|:-----:|:----:|
| Brute It | TryHackMe | ⭐⭐ | 1h | [Link](https://tryhackme.com/room/bruteit) |
| Jack of All Trades | TryHackMe | ⭐⭐ | 45min | [Link](https://tryhackme.com/room/jackofalltrades) |

---

## 📖 Referências e Aprofundamento

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Hashcat Example Hashes | Referência | [hashcat.net](https://hashcat.net/wiki/doku.php?id=example_hashes) |
| TryHackMe - Brute Force | Lab | [tryhackme.com](https://tryhackme.com/room/bruteit) |
| HackTricks - Brute Force | Referência | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |

---

## ✅ Checklist do Módulo

- [ ] Li todos os arquivos
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs práticos
- [ ] Consigo explicar cada ferramenta
- [ ] Sei quando usar cada uma

---

<div align="center">

**⬅️ [Módulo 2: Web & Aplicações](../02-web-aplicacoes/)** | **[Módulo 4: Pós-Exploração](../04-pos-exploracao/) ➡️**

</div>
