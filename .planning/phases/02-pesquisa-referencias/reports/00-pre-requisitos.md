# Relatório de Labs e Referências — Módulo 00: Pré-Requisitos

**Gerado em:** 2026-09-10
**Módulo:** 00-pre-requisitos
**Requisitos:** PESQ-01, PESQ-02

---

## Labs Existentes (LABS.md)

| # | Exercício | Plataforma | URL | Status Validação |
|:-:|:----------|:-----------|:----|:-----------------|
| — | *Módulo não possui LABS.md* | — | — | ⚠️ Sem LABS.md |

**Observações:** O módulo 00-pre-requisitos NÃO possui arquivo LABS.md (confirmado na auditoria da Fase 1). Este módulo cobre fundamentos de Linux, redes e introdução à segurança, mas não tem exercícios práticos documentados. Prioridade alta para criação na Fase 3.

---

## Labs Candidatos Novos

| # | Lab/Sala | Plataforma | URL | Tópico Coberto | Status Validação |
|:-:|:---------|:-----------|:----|:---------------|:-----------------|
| 1 | What is Networking | TryHackMe | https://tryhackme.com/room/whatisnetworking | Conceitos básicos de redes | ⏳ Pendente (rate-limit THM) |
| 2 | Intro to Networking | TryHackMe | https://tryhackme.com/room/introtonetworking | Introdução a redes | ⏳ Pendente (rate-limit THM) |
| 3 | Linux Fundamentals Part 1 | TryHackMe | https://tryhackme.com/room/linuxfundamentalspart1 | Linux básico | ⏳ Pendente (rate-limit THM) |
| 4 | Linux Fundamentals Part 2 | TryHackMe | https://tryhackme.com/room/linuxfundamentalspart2 | Linux intermediário | ⏳ Pendente (rate-limit THM) |
| 5 | Linux Fundamentals Part 3 | TryHackMe | https://tryhackme.com/room/linuxfundamentalspart3 | Linux avançado | ⏳ Pendente (rate-limit THM) |
| 6 | Bandit (34 níveis) | OverTheWire | ssh://bandit.labs.overthewire.org:2220 | Linux fundamentals via SSH | ✅ Ativo |
| 7 | General Skills (picoGym) | PicoCTF | https://play.picoctf.org/practice | Linux, scripting, encoding | ⏳ Pendente |
| 8 | Starting Point | HackTheBox | https://app.hackthebox.com/starting-point | Introdução a pentesting | ⏳ Pendente |

**Nota:** Labs listados aqui cobrem conteúdo que NÃO está no LABS.md atual (módulo não tem LABS.md). OverTheWire Bandit é a fonte primária para fundamentos Linux — 34 níveis progressivos ideais para iniciantes.

---

## Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|:-------|:-------------|:-----------|:--------------|
| CIA Triad, Zero Trust | Security+ SY0-701 Domínio 1 | Crítico | 12% do exame — fundamentos de segurança |
| Introdução a Cibersegurança (ameaças, controles, leis) | OSCP PEN-200 | Crítico | Módulo introdutório do OSCP |
| Introdução ao Ethical Hacking | CEH v13 Módulo 01 | Importante | Base conceitual para CEH |
| Criptografia básica | Security+ SY0-701 Domínio 1 | Importante | Parte dos fundamentos de segurança |
| Modelos de ameaças (threat actors) | Security+ SY0-701 Domínio 2 | Importante | 22% do exame — visão geral de ameaças |
| Controles de segurança (preventivos, detectivos, corretivos) | Security+ SY0-701 Domínio 1 | Importante | Fundamentos para defesa |
| Terminologia de rede (TCP/IP, OSI) | OSCP + Security+ | Crítico | Base para todos os módulos seguintes |

**Prioridade:** Crítico = presente em OSCP; Importante = presente em Security+; Opcional = apenas CEH

---

## Resumo

- Labs existentes: 0 (módulo não tem LABS.md)
- Labs candidatos novos: 8 (5 THM + 1 OTW + 1 PicoCTF + 1 HTB)
- Tópicos ausentes: 7 (críticos: 3)
- Plataformas com cobertura: OverTheWire (forte — Bandit 34 níveis), TryHackMe (5 rooms)
- Plataformas com cobertura limitada: PicoCTF (genérico), HackTheBox (Starting Point)
- **Observação especial:** OverTheWire Bandit é A MELHOR fonte para este módulo — 34 níveis progressivos de Linux básico, todos gratuitos e acessíveis via SSH.
