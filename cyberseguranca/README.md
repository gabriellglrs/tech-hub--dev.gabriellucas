# Trilha de Aprendizado em Cybersegurança

> Do zero ao avançado seguindo o fluxo de ataque real.

---

## O que é esta trilha?

Esta é uma trilha de aprendizado completa para quem quer entrar no mundo da cybersegurança. **Não é um cheat sheet** — é um guia progressivo que te leva do absoluto início até técnicas avançadas, sempre seguindo o **fluxo de ataque real** usado por profissionais.

### Fluxo de Ataque

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE ATAQUE                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. RECONHECIMENTO     → Descobrir o que existe no alvo     │
│  2. ANÁLISE DE REDE    → Interpretar o que está passando    │
│  3. WEB & APLICAÇÕES   → Encontrar falhas em sites          │
│  4. EXPLORAÇÃO         → Quebrar senhas e entrar            │
│  5. PÓS-EXPLORAÇÃO     → Explorar mais e se manter lá      │
│  6. DEFESA             → Proteger sistemas e redes          │
│  7. RESPOSTA           → Investigar o que aconteceu         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Módulos da Trilha

| # | Módulo | Arquivos | Descrição |
|---|--------|----------|-----------|
| 1 | [Reconhecimento](01-reconhecimento/) | 2 | Descobrir alvos: DNS, Nmap, OSINT, subdomínios |
| 2 | [Análise de Rede](02-analise-rede/) | 2 | Capturar e interpretar tráfego: Wireshark, TCPDump, Netcat |
| 3 | [Web & Aplicações](03-web-aplicacoes/) | 2 | Testar sites: Gobuster, FFUF, SQLMap, Nikto |
| 4 | [Exploração](04-exploracao/) | 2 | Quebrar senhas: Hydra, John, Hashcat, SecLists |
| 5 | [Pós-Exploração](05-pos-exploracao/) | 2 | Manter acesso: Impacket, Linpeas, pivoting |
| 6 | [Engenharia Reversa](06-reversing/) | 2 | Entender binários: Ghidra, Radare2, exploits |
| 7 | [Defesa](07-defesa/) | 2 | Proteger: Hardening, IDS/IPS, SIEM, WAF |
| 8 | [Resposta a Incidentes](08-resposta/) | 2 | Investigar: Forense computacional, análise de malware |
| 9 | [Ambientes Especiais](09-ambientes/) | 3 | Cloud, Containers, Wireless, Mobile |
| 10 | [Governança & Criptografia](10-governanca/) | 2 | GRC, LGPD, ISO 27001, Criptografia |

---

## Ordem de Leitura

```
INÍCIO
  │
  ├── [1] Reconhecimento ──────────────── Por onde começar
  │
  ├── [2] Análise de Rede ─────────────── Entender o que vê na rede
  │
  ├── [3] Web & Aplicações ────────────── Testar sites e apps
  │
  ├── [4] Exploração ──────────────────── Quebrar senhas e entrar
  │
  ├── [5] Pós-Exploração ──────────────── Explorar após o acesso
  │
  ├── [6] Engenharia Reversa ──────────── Avançado: entender binários
  │
  ├── [7] Defesa ──────────────────────── Proteger (pode estudar em paralelo)
  │
  ├── [8] Resposta a Incidentes ───────── Investigar ataques
  │
  ├── [9] Ambientes Especiais ─────────── Cloud, Mobile, Wireless
  │
  └── [10] Governança & Criptografia ──── LGPD, ISO 27001, Cripto
```

---

## Pré-requisitos

- **Linux básico:** Navegar no terminal, criar/editar arquivos
- **Uma VM Linux:** Ubuntu 22.04+ ou Kali Linux
- **Conexão com internet:** Para instalar ferramentas
- **Tempo:** Cada módulo leva 2-4 horas para estudar

### Ambiente Recomendado

```bash
# Ubuntu 22.04+ com as ferramentas básicas
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget

# Clonar este repositório
git clone https://github.com/SEU_USUARIO/minhas_config_linux_terminal.git
cd minhas_config_linux_terminal/cyberseguranca
```

---

## Aviso Legal e Ético

> **ATENÇÃO:** Este material é exclusivamente para fins educacionais.

- Use as ferramentas **apenas em sistemas que você tem autorização para testar**
- Laboratórios próprios (VirtualBox, Docker, TryHackMe, HackTheBox) são o local ideal
- O uso indevido de técnicas de cybersegurança é **crime** (Lei 12.737/2012 - Lei Carolina Dieckmann)
- Ao estudar este material, você concorda em usar o conhecimento de forma ética e responsável

---

## Como Usar Este Material

1. **Comece pelo Módulo 1** — não pule etapas
2. **Pratique cada comando** — não apenas leia
3. **Crie seu laboratório** — VMs no VirtualBox ou containers no Docker
4. **Documente o que aprende** — crie seus próprios cheatsheets
5. **Estude ética primeiro** — sempre pergunte: "isso é legal?"

---

## Ferramentas por Categoria

### Reconhecimento
`Nmap` · `Masscan` · `Whois` · `Dig` · `TheHarvester` · `Subfinder` · `Nuclei` · `httpx`

### Análise de Rede
`Wireshark` · `TCPDump` · `Netcat` · `Socat` · `Bettercap` · `Responder`

### Web
`Gobuster` · `FFUF` · `Nikto` · `WPScan` · `SQLMap` · `WAFw00f` · `WhatWeb`

### Exploração
`Hydra` · `John` · `Hashcat` · `SecLists`

### Pós-Exploração
`Impacket` · `Enum4linux-ng` · `Chisel` · `Linpeas` · `Winpeas`

### Engenharia Reversa
`Ghidra` · `Radare2` · `GDB/GEF` · `Pwntools` · `AFL++`

### Defesa
`Lynis` · `UFW` · `Suricata` · `Snort` · `Wazuh` · `Elastic Stack` · `Fail2Ban`

### Resposta
`Autopsy` · `Volatility` · `Plaso` · `YARA` · `Cuckoo` · `REMnux`

### Especializado
`Trivy` · `Kube-bench` · `Aircrack-ng` · `MobSF` · `Frida`

### Governança
`Eramba` · `OpenSCAP` · `SimpleRisk`

---

## Contribuindo

Se encontrar erros ou quiser adicionar conteúdo, contribua pelo repositório Git.

---

## Licença

Este material é educacional. Use de forma responsável.
