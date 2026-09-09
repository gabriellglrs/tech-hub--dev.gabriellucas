# 🎯 Módulo 1: Reconhecimento e Enumeração

> Torne-se um detetive digital — descobra tudo sobre um alvo antes de ele saber que você existe.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 3-4 horas | ⭐ Iniciante | 2 | 8 |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Coletar informações passivas sobre um alvo sem ser detectado
- [ ] Enumerar registros DNS e descobrir subdomínios ocultos
- [ ] Mapear portas abertas e serviços em execução
- [ ] Identificar tecnologias e stacks utilizadas pelo alvo
- [ ] Montar um relatório completo de reconhecimento

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico (terminal, pacotes) | Sim | Módulo 0 do curso |
| Redes (IP, porta, DNS, HTTP) | Sim | Fundamentos de Redes |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────┐
│                    RECONHECIMENTO                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌──────────────┐      ┌──────────────────────────┐   │
│   │   PASSIVO    │      │        ATIVO             │   │
│   │              │      │                          │   │
│   │  • Whois     │──────│  • Nmap (portas)         │   │
│   │  • Dig       │      │  • Masscan (rápido)      │   │
│   │  • OSINT     │      │  • Subfinder (subs)      │   │
│   │              │      │  • httpx (vhosts)        │   │
│   └──────────────┘      │  • Nuclei (vulns)        │   │
│         │               │  • theHarvester (emails) │   │
│         ▼               └──────────────────────────┘   │
│   ┌──────────────┐              │                       │
│   │  INTELIGÊNCIA│              ▼                       │
│   │  + RELATÓRIO │      ┌──────────────────────────┐   │
│   └──────────────┘      │   RELATÓRIO FINAL        │   │
│                         └──────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 1 | [01-dns-e-enumeracao.md](01-dns-e-enumeracao.md) | Consultar DNS, descobrir portas e serviços | `Whois, Dig, Nmap, Masscan` | 2h |
| 2 | [02-osint-e-subdominios.md](02-osint-e-subdominios.md) | Coletar informações públicas e subdomínios | `Subfinder, theHarvester, httpx, Nuclei` | 2h |

---

## 💡 Dicas de Ouro

> **Dica 1:** Comece sempre pelo reconhecimento passivo (Whois, Dig) antes de escanear ativamente. Quanto menos rastros, melhor.

> **Dica 2:** O Nmap é sua ferramenta mais importante — domine `-sV`, `-sC`, `-O` e scripts antes de partir para outras ferramentas.

> **Dica 3:** Documente tudo em arquivos separados. Um `results/` organizado salva horas de retrabalho depois.

---

## ⚠️ Erros Comuns (e como evitar)

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Esquecer o `-Pn` no Nmap | Alvos que bloqueiam ping aparecem como offline | Use `-Pn` sempre que o host não responder a ping |
| Usar `-T5` (timing agressivo) | Detecção por IDS/IPS ou DoS acidental | Comece com `-T3` e aumente gradualmente |
| Não atualizar scripts do Nmap | Vulnerabilidades não detectadas | Rode `sudo nmap --script-updatedb` periodicamente |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

## 🎮 Labs Recomendados

| Lab | Plataforma | Dificuldade | Tempo | Link |
|:----|:----------:|:-----------:|:-----:|:----:|
| OHSINT | TryHackMe | ⭐ | 30min | [Link](https://tryhackme.com/room/ohsint) |
| Recon Enumeration | HackTricks | ⭐⭐ | 1h | [Link](https://book.hacktricks.wiki/) |

---

## 📖 Referências e Aprofundamento

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Nmap Official Guide | Guia | [nmap.org/book](https://nmap.org/book/) |
| TryHackMe - Recon Module | Lab | [tryhackme.com](https://tryhackme.com/room/ohsint) |
| HackTricks - Recon | Referência | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |

---

## ✅ Checklist do Módulo

- [ ] Li todos os arquivos
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs práticos
- [ ] Consigo explicar cada ferramenta
- [ ] Sei quando usar cada uma

---

<div align="center">

**⬅️ Módulo 0: Introdução** | **[Módulo 2: Web & Aplicações](../02-web-aplicacoes/) ➡️**

</div>
