# 📋 Manual Completo de Testes Web — Checklist Operacional

> **Este é o arquivo mais importante deste módulo.** É nele que você vai consultar enquanto executa cada passo do teste web. Cada fase é explicada com o que fazer, por quê, como, o output esperado, e o que fazer se der errado.

<div align="center">

**Objetivo final:** Executar um teste de segurança web COMPLETO (Burp Suite + ferramentas CLI) e transformar os dados do Módulo 01 em vulnerabilidades confirmadas — de forma autorizada e documentada.

**Regra de ouro:** Nunca pule um passo. Cada fase alimenta a próxima. Este manual começa importando o que você coletou no Módulo 01 (Reconhecimento) e termina entregando os dados que o MANUAL-EXPLOR (Módulo 03) precisa.

**Tempo estimado completo:** 6 a 12 horas (dependendo do escopo)

</div>

---

## Índice

1. [Conhecimentos Mínimos — O que saber antes de começar](#conhecimentos-mínimos)
2. [Antes de Começar — Conceitos e Preparação](#antes-de-começar)
3. [Ferramentas Necessárias](#ferramentas-necessárias)
4. [Setup — Burp Suite, Proxy, Ferramentas CLI](#setup)
5. [Script de Pré-requisitos — Testar Tudo Antes de Começar](#script-de-pré-requisitos)
6. [Guia de Wordlists — Qual Usar para Cada Cenário](#guia-de-wordlists)
7. [OPSEC — Não Derrubar o Alvo e Não Exceder o Escopo](#opsec)
8. [Fase 1 — Alimentação (Módulo 01)](#fase-1)
9. [Fase 2 — Descoberta e Superfície de Ataque](#fase-2)
10. [Fase 3 — Testes de Injeção](#fase-3)
11. [Fase 4 — Cliente e Autenticação](#fase-4)
12. [Fase 5 — Vetores Especializados (SSRF, XXE, Upload, Lógica)](#fase-5)
13. [Fase 6 — Validação e Varredura (Nuclei)](#fase-6)
14. [Fase 7 — Relatório](#fase-7)
15. [Script de Automação — Rodar Tudo de Uma Vez](#script-de-automação)
16. [Alvos para Praticar — Onde Treinar](#alvos-para-praticar)
17. [Guia de Validação Manual — Como Confirmar um Achado](#guia-de-validação-manual)
18. [Apêndice A — Troubleshooting](#apendice-a)
19. [Apêndice B — Referência Rápida (Payloads)](#apendice-b)
20. [Apêndice C — O que fazer se NADA funcionar](#apendice-c)

---

## ⚠️ Aviso Legal

> Testes de segurança web **sem autorização** são **crime** (Lei 12.737/2012 — Carolina Dieckmann; e Lei 12.965/2014 — Marco Civil). Este manual só deve ser usado em:
> - **CTFs** (Capture The Flag)
> - **Labs de estudo** (TryHackMe, HackTheBox, PortSwigger Academy, OverTheWire, PicoCTF)
> - **Alvos próprios**
> - **Pentest com contrato POR ESCRITO**
> - **Bug bounty** somente dentro do escopo publicado do programa
>
> Fuzzing e injeção em produção real **derrubam serviços**, **apagam dados** e **acionam alarmes**. Um SQLi "de teste" pode virar EXFILTRAÇÃO de dados reais de clientes. Quando em dúvida, PARE e confirme o escopo.

---
