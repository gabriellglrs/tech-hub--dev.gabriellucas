# Tabela de Notas — Auditoria da Trilha de Cybersegurança

**Gerado em:** 2026-09-10
**Escala:** 1-5 (Âncoras D-04 a D-08)
**Nota Geral:** Média dos 5 critérios arredondada para 1 casa decimal

---

## Tabela de Notas

| Módulo | Nota Geral | Correção Técnica | Completude | Labs | Progressão | Consistência | Arquivos |
|:-------|:----------:|:----------------:|:----------:|:----:|:----------:|:------------:|:--------:|
| **00-pre-requisitos** | **3.5** | 3.9 | 3.2 | 2.6 | 3.9 | 3.8 | 18 |
| **01-reconhecimento** | **3.3** | 3.8 | 3.8 | 3.0 | 3.0 | 3.0 | 4 |
| **02-web-aplicacoes** | **3.3** | 3.4 | 3.4 | 3.0 | 3.0 | 3.2 | 10 |
| **03-exploracao** | **3.2** | 3.5 | 3.5 | 3.0 | 3.0 | 3.0 | 4 |
| **04-pos-exploracao** | **3.0** | 3.0 | 3.0 | 3.0 | 3.0 | 3.0 | 4 |
| **05-reversing** | **3.0** | 3.0 | 3.0 | 3.0 | 3.0 | 3.0 | 4 |
| **06-analise-rede** | **3.4** | 4.0 | 4.0 | 3.0 | 3.0 | 3.0 | 4 |
| **07-defesa** | **3.8** | 4.0 | 3.8 | 3.5 | 4.0 | 4.0 | 4 |
| **08-resposta** | **3.9** | 4.0 | 4.0 | 3.5 | 4.0 | 4.0 | 4 |
| **09-ambientes** | **3.9** | 4.0 | 4.0 | 3.2 | 4.0 | 4.0 | 5 |
| **10-governanca** | **2.8** | 3.3 | 2.3 | 2.3 | 3.0 | 3.0 | 4 |
| **11-ia-cyberseguranca** | **3.7** | 4.0 | 3.5 | 3.0 | 4.0 | 4.0 | 2 |
| **MÉDIA GERAL** | **3.3** | 3.6 | 3.3 | 2.9 | 3.4 | 3.4 | 67 |

---

## Observações por Módulo

### Módulo 00: Pre-requisitos (3.5)
- **Âncora:** D-05/D-06 (entre nota 4 e 3)
- **Pontos fortes:** 4 arquivos com nota 4.0 (06-linux-basico, 10-python-basico, 12-comandos-rede, 13-editores-texto)
- **Pontos fracos:** 09-conceitos-seguranca.md é 100% teoria (viola core value); falta LABS.md; INSTALACAO.md recomenda Ubuntu
- **AUD-03:** Parcialmente atendido — 08-maquinas-virtuais.md tem guia Kali, mas INSTALACAO.md conflita

### Módulo 01: Reconhecimento (3.3)
- **Âncora:** D-06 (nota 3)
- **Pontos fortes:** Comandos DNS/Nmap bem documentados
- **Pontos fracos:** theHarvester ainda apresentado como ferramenta principal; Subfinder deveria ser priorizado; falta output esperado em ~40% dos comandos

### Módulo 02: Web Aplicações (3.3)
- **Âncora:** D-06 (nota 3)
- **Pontos fortes:** 10 arquivos — maior módulo; boa cobertura de ferramentas
- **Pontos fracos:** API security superficial; repetição de SQLi entre arquivos; XSS/CSP rasos; falta output esperado em ~50% dos comandos

### Módulo 03: Exploração (3.2)
- **Âncora:** D-06 (nota 3)
- **Pontos fortes:** Hydra e John cobertos
- **Pontos fracos:** Foca demais em password cracking; falta Metasploit/Searchsploit; wordlists superficial; falta output esperado em ~60% dos comandos

### Módulo 04: Pós-exploração (3.0)
- **Âncora:** D-06/D-07 (entre nota 3 e 2)
- **Pontos fortes:** Estrutura existe
- **Pontos fracos:** **Módulo mais fraco** — falta BloodHound para AD; pivoting superficial; falta output esperado em ~70% dos comandos; Labs genéricos

### Módulo 05: Reversing (3.0)
- **Âncora:** D-06/D-07 (entre nota 3 e 2)
- **Pontos fortes:** Estrutura existe
- **Pontos fracos:** Ghidra sub-utilizado; falta debuggers (GDB, x64dbg); fuzzing superficial; falta output esperado em ~60% dos comandos

### Módulo 06: Análise de Rede (3.4)
- **Âncora:** D-05/D-06 (entre nota 4 e 3)
- **Pontos fortes:** **Melhor módulo ofensivo** — tcpdump, Wireshark, Bettercap bem cobertos
- **Pontos fracos:** Falta output esperado em ~30% dos comandos; falta integração com módulo 07

### Módulo 07: Defesa (3.8)
- **Âncora:** D-05 (nota 4)
- **Pontos fortes:** Suricata > Snort bem justificado; Wazuh Docker quickstart; LABS.md excelente (6 exercícios)
- **Pontos fracos:** Falta output esperado em alguns comandos; Wazuh 4.7 pode estar defasado

### Módulo 08: Resposta (3.9)
- **Âncora:** D-05 (nota 4)
- **Pontos fortes:** **Melhor módulo** — Volatility3 correto; YARA bem coberto; LABS.md excepcional (6 exercícios, 745 linhas)
- **Pontos fracos:** Falta output esperado em comandos-chave; REMnux sem instalação detalhada

### Módulo 09: Ambientes (3.9)
- **Âncora:** D-05 (nota 4)
- **Pontos fortes:** Cobertura completa (Cloud, Containers, Wireless, Mobile); Trivy, MobSF, Frida bem documentados; LABS.md excelente
- **Pontos fracos:** Falta output esperado; Falco mencionado mas sem comandos; AWS CLI install pode estar defasado

### Módulo 10: Governança (2.8)
- **Âncora:** D-06/D-07 (entre nota 3 e 2)
- **Pontos fortes:** NIST CSF 2.0 mencionado; criptografia (OpenSSL, GPG) correta
- **Pontos fracos:** **Segundo módulo mais fraco** — 100% teórico; zero comandos práticos em GRC; LABS.md superficial; viola core value

### Módulo 11: IA para Cybersegurança (3.7)
- **Âncora:** D-05 (nota 4)
- **Pontos fortes:** README abrangente (633 linhas); CAI, Gideon, PentestGPT atuais; ollama para LLMs locais
- **Pontos fracos:** **Inconsistência estrutural** — só README + LABS.md, sem arquivos numerados; CAI sem instalação detalhada

---

## Módulo 00 — AUD-03: Orientação Kali Linux

**Status:** PARCIALMENTE ATENDIDO

**O que atende:**
- `08-maquinas-virtuais.md` fornece guia explícito de instalação do Kali Linux via VirtualBox

**O que NÃO atende:**
- `INSTALACAO.md` (raiz) recomenda "Ubuntu/Debian" — conflita com constraint KALI-ONLY
- `README.md` (raiz) menciona "Ubuntu Tutorial" nos pré-requisitos
- Falta instrução explícita "Primeiro instale Kali" no início do módulo 00
- Metasploitable e Juice Shop têm instruções menos detalhadas que Kali

---

## Módulo 11 — Inconsistência Estrutural

**Problema:** Módulo 11 tem apenas 2 arquivos (README.md + LABS.md), enquanto todos os outros módulos seguem o padrão README.md + 2-3 arquivos numerados + LABS.md.

**Impacto:** Estrutura inconsistente dificulta navegação e manutenção. O README.md de 633 linhas serve como todo o conteúdo, mas não segue o padrão do resto da trilha.

**Recomendação:** Dividir README.md em arquivos numerados (01-ia-ofensiva.md, 02-ia-defensiva.md, etc.) na Fase 3.

---

## Distribuição de Notas

| Faixa | Módulos | Quantidade |
|:------|:--------|:----------:|
| 4.0 - 4.5 | — | 0 |
| 3.5 - 3.9 | 07, 08, 09, 11 | 4 |
| 3.0 - 3.4 | 00, 01, 02, 03, 04, 05, 06 | 7 |
| 2.5 - 2.9 | 10 | 1 |
| 2.0 - 2.4 | — | 0 |
| 1.0 - 1.9 | — | 0 |

**Observação:** Nenhum módulo atinge nota 5.0. O melhor é 08-resposta (3.9). O pior é 10-governanca (2.8).
