# 📋 Manual Completo de Exploração — Checklist Operacional

> **Este é o arquivo mais importante deste módulo.** É nele que você vai consultar enquanto executa cada passo da exploração. Cada fase é explicada com o que fazer, por quê, como, o output esperado, e o que fazer se der errado.

<div align="center">

**Objetivo final:** Transformar vulnerabilidades em ACESSO REAL (credenciais, shell, dados) — de forma autorizada e documentada.

**Regra de ouro:** Nunca pule um passo. Cada fase alimenta a próxima. Este manual começa importando o que você coletou nos Módulos 01 e 02.

**Tempo estimado completo:** 4 a 8 horas (dependendo do escopo)

</div>

---

## Índice

1. [Conhecimentos Mínimos — O que saber antes de começar](#conhecimentos-mínimos)
2. [Antes de Começar — Conceitos e Preparação](#antes-de-começar)
3. [Ferramentas Necessárias](#ferramentas-necessárias)
4. [Setup — VPN, Hydra, John, Hashcat, Metasploit](#setup)
5. [Script de Pré-requisitos — Testar Tudo Antes de Começar](#script-de-pré-requisitos)
6. [Guia de Wordlists — Qual Usar para Cada Cenário](#guia-de-wordlists)
7. [OPSEC — Não Deixar Rastros e Não Travar Contas](#opsec)
8. [Fase 1 — Alimentação (Módulos 01 e 02)](#fase-1)
9. [Fase 2 — Priorização de Vetores](#fase-2)
10. [Fase 3 — Brute Force](#fase-3)
11. [Fase 4 — Cracking de Hashes](#fase-4)
12. [Fase 5 — Exploração (Metasploit)](#fase-5)
13. [Fase 6 — Validação e Impacto](#fase-6)
14. [Fase 7 — Relatório](#fase-7)
15. [Script de Automação — Rodar Tudo de Uma Vez](#script-de-automação)
16. [Alvos para Praticar — Onde Treinar](#alvos-para-praticar)
17. [Guia de Validação Manual — Como Confirmar um Achado](#guia-de-validação-manual)
18. [Apêndice A — Troubleshooting](#apendice-a)
19. [Apêndice B — Referência Rápida](#apendice-b)
20. [Apêndice C — O que fazer se NADA funcionar](#apendice-c)

---

## ⚠️ Aviso Legal

> Exploração **sem autorização** é **crime** (Lei 12.737/2012 — Carolina Dieckmann). Este manual só deve ser usado em:
> - **CTFs** (Capture The Flag)
> - **Labs de estudo** (TryHackMe, HackTheBox, OverTheWire, PicoCTF)
> - **Alvos próprios**
> - **Pentest com contrato POR ESCRITO**
>
> Brute force em produção real **trava contas**, aciona **alarmes** e **ban** seu IP. O Falso positivo destrói sua credibilidade; o acesso sem autorização destrói sua liberdade.

---
