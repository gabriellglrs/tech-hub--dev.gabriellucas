# ROADMAP - Reestruturação da Pasta cyberseguranca

## Visão Geral

Transformar 24 guias de referência (cheat sheets) em uma **trilha de aprendizado** para iniciantes absolutos, organizada pelo **fluxo de ataque**: Reconhecimento → Exploração → Pós-exploração → Defesa.

## Objetivo

- **Público:** Iniciante absoluto em cybersegurança
- **Formato:** Guias didáticos com progressão lógica, sem laboratório complexo
- **Organização:** Por fluxo de ataque (RE-EX-POS-DEF)
- **Conteúdo:** Reutilizar ferramentas existentes, reorganizar por ordem de aprendizado

## Fluxo de Ataque

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE ATAQUE                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. RECONHECIMENTO     → O que existe?                      │
│  2. ANÁLISE DE REDE    → O que está passando?               │
│  3. WEB & APLICAÇÕES   → Onde estão as falhas?              │
│  4. EXPLORAÇÃO         → Como entrar?                       │
│  5. PÓS-EXPLORAÇÃO     → O que mais posso fazer?            │
│  6. DEFESA             → Como me proteger?                   │
│  7. RESPOSTA           → O que aconteceu?                   │
│                                                             │
│  + MÓDULOS ESPECIAIS: Cloud, Mobile, Wireless               │
│  + FUNDAMENTOS: Criptografia, Governança                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Estrutura de Módulos (10 módulos)

| # | Módulo | Pasta | Arquivos | Descrição |
|---|--------|-------|----------|-----------|
| 1 | Reconhecimento | `01-reconhecimento/` | 2 | Descobrir alvos e informações |
| 2 | Análise de Rede | `02-analise-rede/` | 2 | Capturar e interpretar tráfego |
| 3 | Web & Aplicações | `03-web-aplicacoes/` | 2 | Testar aplicações web |
| 4 | Exploração | `04-exploracao/` | 2 | Quebrar senhas e explorar serviços |
| 5 | Pós-Exploração | `05-pos-exploracao/` | 2 | Manter acesso e movimentação lateral |
| 6 | Engenharia Reversa | `06-reversing/` | 2 | Entender binários e criar exploits |
| 7 | Defesa | `07-defesa/` | 2 | Hardening, IDS/IPS, SIEM, WAF |
| 8 | Resposta a Incidentes | `08-resposta/` | 2 | Forense e análise de malware |
| 9 | Ambientes Especiais | `09-ambientes/` | 3 | Cloud, Containers, Mobile, Wireless |
| 10 | Governança & Cripto | `10-governanca/` | 2 | GRC, LGPD, ISO 27001, Criptografia |

**Total:** 10 módulos × 2-3 arquivos = **27 arquivos de conteúdo** + **11 READMEs** (1 principal + 10 por módulo)

---

## Árvore de Diretórios Final

```
cyberseguranca/
├── README.md                          ← GUIA PRINCIPAL (novo)
│
├── 01-reconhecimento/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-dns-e枚umeracao.md           ← (renomeado de 01-reconhecimento.md)
│   └── 02-osint-e-subdominios.md      ← (GO Tools + TheHarvester)
│
├── 02-analise-rede/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-sniffing-e-captura.md       ← (Wireshark, TCPDump, Netcat, Socat)
│   └── 02-proxy-e-anonimato.md        ← (Proxychains, Tor, Bettercap, Responder)
│
├── 03-web-aplicacoes/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-descoberta-e-enumeracao.md  ← (Gobuster, FFUF, WhatWeb, WPScan, Nikto)
│   └── 02-injecao-e-fuzzing.md        ← (SQLMap, WAFw00f)
│
├── 04-exploracao/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-brute-force-e-cracking.md   ← (Hydra, John, Hashcat)
│   └── 02-wordlists-e-ferramentas.md  ← (SecLists, Crunch, CeWL)
│
├── 05-pos-exploracao/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-enum-e-movimentacao.md      ← (Impacket, Enum4linux-ng)
│   └── 02-pivoting-e-tunneling.md     ← (Chisel, Ligolo-ng, Linpeas/Winpeas)
│
├── 06-reversing/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-engenharia-reversa.md       ← (Ghidra, Radare2, GDB/GEF)
│   └── 02-exploit-e-fuzzing.md        ← (Pwntools, AFL++, Checksec)
│
├── 07-defesa/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-hardening-e-firewall.md     ← (Lynis, CIS, UFW, iptables, nftables)
│   └── 02-monitoramento-e-siem.md     ← (Suricata, Snort, Zeek, Wazuh, ELK)
│
├── 08-resposta/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-forense-computacional.md    ← (Autopsy, Volatility, Plaso)
│   └── 02-analise-malware.md          ← (Ghidra, YARA, Cuckoo, REMnux)
│
├── 09-ambientes/
│   ├── README.md                      ← Navegação do módulo
│   ├── 01-cloud-e-containers.md       ← (AWS, Azure, GCP, Docker, K8s, Trivy)
│   ├── 02-wireless.md                 ← (Aircrack-ng, Wifite, Evil Twin)
│   └── 03-mobile.md                   ← (MobSF, Frida, Apktool, Objection)
│
└── 10-governanca/
    ├── README.md                      ← Navegação do módulo
    ├── 01-grc-e-compliance.md         ← (NIST CSF, LGPD, ISO 27001, Eramba)
    └── 02-criptografia.md             ← (AES, RSA, TLS, Hash, Certificados)
```

---

## Mapeamento de Arquivos Existentes → Novos Arquivos

### Módulo 1: Reconhecimento

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `offensive/01-reconhecimento.md` | `01-reconhecimento/01-dns-e枚umeracao.md` | Renomear, adicionar introdução didática |
| `offensive/07-go-tools.md` | `01-reconhecimento/02-osint-e-subdominios.md` | Reorganizar, integrar com subfinder/httpx/nuclei |

### Módulo 2: Análise de Rede

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `offensive/04-sniffing-rede.md` | `02-analise-rede/01-sniffing-e-captura.md` | Manter, adicionar contexto didático |
| `offensive/05-proxy-anonimato.md` | `02-analise-rede/02-proxy-e-anonimato.md` | Renomear, reorganizar |

### Módulo 3: Web & Aplicações

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `offensive/02-webapp-testing.md` | `03-web-aplicacoes/01-descoberta-e-enumeracao.md` | Separar descoberta de exploração |
| `offensive/02-webapp-testing.md` | `03-web-aplicacoes/02-injecao-e-fuzzing.md` | Separar SQLMap/WAFw00f |

### Módulo 4: Exploração

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `offensive/03-brute-force.md` | `04-exploracao/01-brute-force-e-cracking.md` | Manter, adicionar introdução |
| `offensive/08-wordlists.md` | `04-exploracao/02-wordlists-e-ferramentas.md` | Manter, integrar com Crunch |

### Módulo 5: Pós-Exploração

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `offensive/06-post-exploracao.md` | `05-pos-exploracao/01-enum-e-movimentacao.md` | Separar enumeração de tunneling |
| `offensive/06-post-exploracao.md` | `05-pos-exploracao/02-pivoting-e-tunneling.md` | Extrair Chisel, Ligolo-ng, Linpeas |

### Módulo 6: Engenharia Reversa

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `reversing-exploit/01-engenharia-reversa.md` | `06-reversing/01-engenharia-reversa.md` | Manter, adicionar introdução |
| `reversing-exploit/02-exploit-development.md` + `03-analise-binaria.md` | `06-reversing/02-exploit-e-fuzzing.md` | Combinar em um guia |

### Módulo 7: Defesa

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `blue-team/01-hardening.md` + `02-firewall.md` | `07-defesa/01-hardening-e-firewall.md` | Combinar hardening + firewall |
| `blue-team/03-ids-ips.md` + `04-siem-soc.md` + `05-waf-defensivo.md` | `07-defesa/02-monitoramento-e-siem.md` | Combinar IDS + SIEM + WAF |

### Módulo 8: Resposta a Incidentes

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `forense-malware/01-forense-computacional.md` | `08-resposta/01-forense-computacional.md` | Manter |
| `forense-malware/02-analise-malware.md` | `08-resposta/02-analise-malware.md` | Manter |

### Módulo 9: Ambientes Especiais

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `wireless-cloud-mobile/02-cloud.md` + `04-container-k8s.md` | `09-ambientes/01-cloud-e-containers.md` | Combinar cloud + containers |
| `wireless-cloud-mobile/01-wireless.md` | `09-ambientes/02-wireless.md` | Manter |
| `wireless-cloud-mobile/03-mobile.md` | `09-ambientes/03-mobile.md` | Manter |

### Módulo 10: Governança & Criptografia

| Arquivo Atual | Novo Arquivo | O que muda |
|---------------|--------------|------------|
| `governanca-criptografia/01-grc.md` + `02-lgpd.md` + `03-iso27001.md` | `10-governanca/01-grc-e-compliance.md` | Combinar GRC + LGPD + ISO |
| `governanca-criptografia/04-criptografia.md` | `10-governanca/02-criptografia.md` | Manter |

---

## Arquivos a Criar (Novos)

### 1. `cyberseguranca/README.md` (Guia Principal)

**Título:** Trilha de Aprendizado em Cybersegurança
**Descrição:** Guia completo para iniciantes - do zero ao avançado seguindo o fluxo de ataque
**Conteúdo:**
- Boas-vindas e objetivos da trilha
- Fluxo de ataque visual (RE-EX-POS-DEF)
- Tabela de módulos com links
- Ordem de leitura recomendada
- Pré-requisitos (Linux básico, terminal)
- Aviso legal e ético
- Dicas de estudo

### 2-11. READMEs por Módulo (10 arquivos)

Cada README de módulo deve conter:
- Nome do módulo e posição na trilha
- Objetivo de aprendizado
- Fluxo do módulo (ordem dos arquivos)
- Tabela de arquivos com links
- Pré-requisitos do módulo
- Dicas práticas
- Referências externas (opcional)

---

## Ordem de Leitura Recomendada

```
INÍCIO
  │
  ├── [1] Módulo 1: Reconhecimento
  │       ├── 01-dns-e枚umeracao.md    (Whois, Dig, Nmap, Masscan)
  │       └── 02-osint-e-subdominios.md (Subfinder, Nuclei, httpx, TheHarvester)
  │
  ├── [2] Módulo 2: Análise de Rede
  │       ├── 01-sniffing-e-captura.md  (Wireshark, TCPDump, Netcat, Socat)
  │       └── 02-proxy-e-anonimato.md   (Proxychains, Tor, Bettercap, Responder)
  │
  ├── [3] Módulo 3: Web & Aplicações
  │       ├── 01-descoberta-e-enumeracao.md (Gobuster, FFUF, WhatWeb, Nikto, WPScan)
  │       └── 02-injecao-e-fuzzing.md       (SQLMap, WAFw00f)
  │
  ├── [4] Módulo 4: Exploração
  │       ├── 01-brute-force-e-cracking.md  (Hydra, John, Hashcat)
  │       └── 02-wordlists-e-ferramentas.md (SecLists, Crunch, CeWL)
  │
  ├── [5] Módulo 5: Pós-Exploração
  │       ├── 01-enum-e-movimentacao.md     (Impacket, Enum4linux-ng)
  │       └── 02-pivoting-e-tunneling.md    (Chisel, Ligolo-ng, Linpeas/Winpeas)
  │
  ├── [6] Módulo 6: Engenharia Reversa
  │       ├── 01-engenharia-reversa.md      (Ghidra, Radare2, GDB/GEF)
  │       └── 02-exploit-e-fuzzing.md       (Pwntools, AFL++, Checksec)
  │
  ├── [7] Módulo 7: Defesa
  │       ├── 01-hardening-e-firewall.md    (Lynis, CIS, UFW, iptables)
  │       └── 02-monitoramento-e-siem.md    (Suricata, Wazuh, ELK)
  │
  ├── [8] Módulo 8: Resposta a Incidentes
  │       ├── 01-forense-computacional.md   (Autopsy, Volatility, Plaso)
  │       └── 02-analise-malware.md         (Ghidra, YARA, Cuckoo)
  │
  ├── [9] Módulo 9: Ambientes Especiais
  │       ├── 01-cloud-e-containers.md      (AWS, Azure, Docker, K8s)
  │       ├── 02-wireless.md                (Aircrack-ng, Wifite, Evil Twin)
  │       └── 03-mobile.md                  (MobSF, Frida, Apktool)
  │
  └── [10] Módulo 10: Governança & Criptografia
          ├── 01-grc-e-compliance.md        (NIST, LGPD, ISO 27001)
          └── 02-criptografia.md            (AES, RSA, TLS, Hash)
```

---

## Total Estimado de Arquivos

| Tipo | Quantidade |
|------|------------|
| README principal | 1 |
| READMEs de módulo | 10 |
| Arquivos de conteúdo | 27 |
| **TOTAL** | **38 arquivos** |

### Detalhamento por Módulo

| Módulo | Arquivos de Conteúdo | READMEs |
|--------|---------------------|---------|
| 01-reconhecimento | 2 | 1 |
| 02-analise-rede | 2 | 1 |
| 03-web-aplicacoes | 2 | 1 |
| 04-exploracao | 2 | 1 |
| 05-pos-exploracao | 2 | 1 |
| 06-reversing | 2 | 1 |
| 07-defesa | 2 | 1 |
| 08-resposta | 2 | 1 |
| 09-ambientes | 3 | 1 |
| 10-governanca | 2 | 1 |
| **Total** | **27** | **11** |

---

## Conteúdo dos READMEs de Módulo

### Template Padrão

```markdown
# [Ícone] [Nome do Módulo]

> [Frase de impacto que explica o objetivo]

---

## O que você vai aprender

[2-3 frases sobre o que este módulo cobre]

## Pré-requisitos

- [Módulo anterior] ou conhecimento equivalente
- [Ferramentas específicas]

## Fluxo de Estudo

```
1. [Arquivo 1] → [O que aprende]
        ↓
2. [Arquivo 2] → [O que aprende]
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-xxx.md](01-xxx.md) | [Descrição] | `tool1, tool2` |
| 2 | [02-xxx.md](02-xxx.md) | [Descrição] | `tool1, tool2` |

## Dicas Práticas

- [Dica 1]
- [Dica 2]

## Referências

- [Link externo 1]
- [Link externo 2]
```

---

## Alterações nos Arquivos de Conteúdo

### Princípio: Manter o conteúdo, melhorar a apresentação

Os 24 arquivos existentes já são de alta qualidade. As alterações serão:

1. **Adicionar introdução didática** em cada arquivo
   - Contexto: por que aprender esta ferramenta
   - Onde se encaixa no fluxo de ataque
   - O que você vai conseguir fazer depois

2. **Adicionar seção "Próximo Passo"** ao final de cada arquivo
   - Link para o próximo arquivo na trilha
   - Sugestão de prática

3. **Melhorar formatação** para iniciantes
   - Adicionar avisos legais mais visíveis
   - Simplificar exemplos complexos
   - Adicionar seção "Erros Comuns"

4. **Não alterar:**
   - Comandos e exemplos existentes
   - Tabelas de flags
   - Seções de instalação

---

## Dependências entre Módulos

```
Módulo 1 (Reconhecimento)
    ↓
Módulo 2 (Análise de Rede) ←──┐
    ↓                          │
Módulo 3 (Web & Aplicações)   │
    ↓                          │
Módulo 4 (Exploração) ←───────┤
    ↓                          │
Módulo 5 (Pós-Exploração) ────┘
    ↓
Módulo 6 (Engenharia Reversa) [independente, mas útil após Módulo 5]
    ↓
Módulo 7 (Defesa) [independente, pode ser estudado em paralelo]
    ↓
Módulo 8 (Resposta) [depende de Módulo 7]
    ↓
Módulo 9 (Ambientes Especiais) [independente]
    ↓
Módulo 10 (Governança) [independente, pode ser estudado a qualquer momento]
```

---

## Próximos Passos

1. **Criar pastas** na nova estrutura
2. **Mover arquivos** existentes para as novas pastas
3. **Renomear arquivos** conforme o mapeamento
4. **Criar READMEs** de módulo (10 arquivos)
5. **Criar README principal** (1 arquivo)
6. **Adicionar introduções** didáticas nos arquivos de conteúdo
7. **Adicionar seções "Próximo Passo"** nos arquivos
8. **Testar navegação** entre links
9. **Remover pastas antigas** (vazias)
