# 🛡️ Trilha de Aprendizado em Cybersegurança

> Do zero ao profissional seguindo o fluxo real de ataque e defesa.

---

## 🌟 O que é Cybersegurança?

**Cybersegurança** é proteger sistemas, redes e dados contra ataques digitais. É como a segurança de uma casa, mas no mundo digital — em vez de trancas e alarmes, temos firewalls e senhas.

### Por que aprender?

- **Empresas precisam de profissionais** — falta 3.5 milhões de pessoas no mundo
- **Salários altos** — iniciantes ganham R$ 3.000-5.000, experientes R$ 10.000+
- **Trabalho remoto** — muitas vagas home office
- **Desafio intelectual** — sempre aprendendo coisas novas

### O que você vai aprender?

```
ATACANTE (Offensive)          DEFENSOR (Defensive)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Reconhecimento → Descobrir    Proteger → Hardening
Exploração → Entrar           Detectar → IDS/SIEM
Pós-Exp → Escalar             Investigar → Forense
```

### Pré-requisitos (O que você precisa ter)

| Pré-requisito | Por quê | Onde aprender |
|:--------------|:--------|:-------------:|
| **Linux básico** | Todas as ferramentas rodam em Linux | [Ubuntu Tutorial](https://ubuntu.com/tutorials) |
| **Terminal** | Você vai digitar comandos o tempo todo | [Linux Terminal](https://linuxcommand.org/) |
| **Redes básicas** | Entender IP, porta, DNS | [TryHackMe - Intro to Networking](https://tryhackme.com/room/introtonetworking) |
| **HTML/HTTP** | Para entender web security | [MDN - HTTP](https://developer.mozilla.org/pt-BR/docs/Web/HTTP) |

### Quanto tempo leva?

| Ritmo | Duração | Recomendação |
|:------|:--------|:-------------|
| **Intensivo** | 2-3 meses | 4-6 horas/dia |
| **Moderado** | 4-6 meses | 2-3 horas/dia |
| **Flexível** | 6-12 meses | 1 hora/dia |

### Plataformas de Prática (Gratuitas)

| Plataforma | O que é | Link |
|:-----------|:--------|:----:|
| **TryHackMe** | Salas guiadas para iniciantes | [tryhackme.com](https://tryhackme.com) |
| **HackTheBox** | Máquinas para pentest | [hackthebox.com](https://hackthebox.com) |
| **PortSwigger** | Labs de web security | [portswigger.net](https://portswigger.net/web-security) |
| **OverTheWire** | Desafios de Linux | [overthewire.org](https://overthewire.org) |
| **PicoCTF** | CTF para iniciantes | [picoctf.org](https://picoctf.org) |

---

## 🎯 Por que esta trilha?

Esta trilha segue a **ordem real usada por profissionais** de cybersegurança (OSCP, CEH, NIST). Cada módulo é pré-requisito do próximo — não pule etapas!

---

## 🗺️ Fluxo de Aprendizado

```
FASE 1: FUNDAMENTOS (Módulos 1-3)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ┌─────────────┐
   │ 1. RECONHECIMENTO │ ← Descobrir o que existe
   └──────┬──────┘
          ↓
   ┌─────────────┐
   │ 2. WEB & APPS     │ ← Entender aplicações web
   └──────┬──────┘
          ↓
   ┌─────────────┐
   │ 3. EXPLORAÇÃO     │ ← Quebrar senhas e entrar
   └──────┬──────┘
          ↓
FASE 2: INTERMEDIÁRIO (Módulos 4-6)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ┌─────────────┐
   │ 4. PÓS-EXPLORAÇÃO │ ← Manter acesso e escalar
   └──────┬──────┘
          ↓
   ┌─────────────┐
   │ 5. ENGENHARIA REVERSA │ ← Entender binários
   └──────┬──────┘
          ↓
   ┌─────────────┐
   │ 6. ANÁLISE DE REDE    │ ← Capturar tráfego
   └──────┬──────┘
          ↓
FASE 3: DEFESA (Módulos 7-8)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ┌─────────────┐
   │ 7. DEFESA            │ ← Proteger sistemas
   └──────┬──────┘
          ↓
   ┌─────────────┐
   │ 8. RESPOSTA          │ ← Investigar incidentes
   └──────┬──────┘
          ↓
FASE 4: ESPECIALIZAÇÃO (Módulos 9-10)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ┌─────────────┐
   │ 9. AMBIENTES ESPECIAIS │ ← Cloud, Mobile, Wireless
   └──────┬──────┘
          ↓
   ┌─────────────┐
   │ 10. GOVERNANÇA       │ ← GRC, Criptografia, LGPD
   └──────┬──────┘
          ↓
FASE 5: IA + CYBERSEGURANÇA (Módulo 11)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ┌─────────────┐
   │ 11. IA NO TERMINAL   │ ← Ollama, NFGuard, CyberStrike
   └─────────────┘
```

---

## 📚 Módulos da Trilha

### Pré-Requisitos

| # | Módulo | Arquivos | Tempo | O que você vai aprender |
|:--|:-------|:--------:|:-----:|:------------------------|
| 0 | [Pré-Requisitos](00-pre-requisitos/) | 11 | 6-7h | Redes, Linux, VMs, Python, Windows, Segurança |

### Fase 1: Fundamentos

| # | Módulo | Arquivos | Tempo | O que você vai aprender |
|:--|:-------|:--------:|:-----:|:------------------------|
| 1 | [Reconhecimento](01-reconhecimento/) | 2 + Labs | 3-4h | DNS, Whois, Nmap, OSINT, subdomínios |
| 2 | [Web & Aplicações](02-web-aplicacoes/) | 8 + Labs | 8-10h | Web, API, Database, Frontend, SQL Injection, XSS |
| 3 | [Exploração](03-exploracao/) | 2 + Labs | 4-5h | Hydra, John, Hashcat, brute force |

### Fase 2: Intermediário

| # | Módulo | Arquivos | Tempo | O que você vai aprender |
|:--|:-------|:--------:|:-----:|:------------------------|
| 4 | [Pós-Exploração](04-pos-exploracao/) | 2 + Labs | 5-6h | LinPEAS, escalação, pivoting, movimentação |
| 5 | [Engenharia Reversa](05-reversing/) | 2 + Labs | 6-8h | Ghidra, GDB, buffer overflow, exploits |
| 6 | [Análise de Rede](06-analise-rede/) | 2 + Labs | 4-5h | tcpdump, Wireshark, MITM, proxies |

### Fase 3: Defesa

| # | Módulo | Arquivos | Tempo | O que você vai aprender |
|:--|:-------|:--------:|:-----:|:------------------------|
| 7 | [Defesa & Hardening](07-defesa/) | 2 + Labs | 5-6h | Firewalls, IDS/IPS, SIEM, UFW |
| 8 | [Resposta a Incidentes](08-resposta/) | 2 + Labs | 5-7h | Forense, malware, Volatility |

### Fase 4: Especialização

| # | Módulo | Arquivos | Tempo | O que você vai aprender |
|:--|:-------|:--------:|:-----:|:------------------------|
| 9 | [Ambientes Especiais](09-ambientes/) | 3 + Labs | 6-8h | Docker, K8s, AWS, Wireless, Mobile |
| 10 | [Governança & Criptografia](10-governanca/) | 2 + Labs | 4-5h | GRC, ISO 27001, LGPD, OpenSSL |

### Fase 5: IA + Cybersegurança

| # | Módulo | Arquivos | Tempo | O que você vai aprender |
|:--|:-------|:--------:|:-----:|:------------------------|
| 11 | [IA para Cybersegurança](11-ia-cyberseguranca/) | 2 + Labs | 4-6h | Ollama, NFGuard, CyberStrike, RAI, prompts, automação |

---

## 📊 Progresso Total

| Métrica | Valor |
|:--------|:-----:|
| Total de módulos | 12 (0-11) |
| Total de arquivos | 44+ |
| Total de exercícios | 84+ |
| Tempo estimado | ~65-75 horas |
| Nível | Iniciante → Avançado |

---

## 🧪 Laboratórios Práticos

Cada módulo tem um arquivo `LABS.md` com exercícios detalhados:
- Passo a passo completo
- Macetes e dicas
- Links diretos (TryHackMe, HackTheBox, PortSwigger)
- Checklists de validação

---

## 📖 Ordem de Estudo

1. Comece pelo **Módulo 1** e siga a ordem
2. Não pule módulos — cada um é pré-requisito do próximo
3. Pratique os labs antes de avançar
4. Documente seus aprendizados

---

## 🎓 Certificações Relacionadas

Esta trilha prepara para:
- **OSCP** (Offensive Security)
- **CEH** (Certified Ethical Hacker)
- **CompTIA Security+**
- **PTX** (eLearnSecurity)

---

## 📚 Recursos Adicionais

| Arquivo | Descrição |
|:--------|:----------|
| [GLOSSARIO.md](GLOSSARIO.md) | Todos os termos técnicos explicados |
| [INSTALACAO.md](INSTALACAO.md) | Guia completo de instalação das ferramentas |
| [11-ia-cyberseguranca/](11-ia-cyberseguranca/) | 🤖 IA para Cybersegurança — Ollama, NFGuard, CyberStrike, prompts |

---

<div align="center">

**Comece agora →** [Módulo 1: Reconhecimento](01-reconhecimento/)

</div>
