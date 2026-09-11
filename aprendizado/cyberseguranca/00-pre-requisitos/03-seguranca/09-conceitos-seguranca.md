# Conceitos de Seguranca

> Antes de aprender QUALQUER ferramenta de ataque, voce precisa entender: o que e seguranca, por que ela existe, e quais sao as regras que separam um profissional de um criminoso.

---

## O que e Cybersecurity?

**Cybersecurity (Seguranca Cibernetica)** e o conjunto de praticas, processos e tecnologias projetados para proteger sistemas, redes e dados contra ataques digitais, acesso nao autorizado e danos.

### Por que isso importa?

Toda vez que voce:
- Acessa um site
- Envia um email
- Faz login em uma conta
- Conecta em uma rede WiFi

Voce esta interagindo com sistemas que podem ser atacados. Cybersecurity existe para garantir que esses sistemas continuem funcionando e que seus dados fiquem seguros.

---

## Os 3 pilares da Seguranca (Triade CIA)

Toda decisao de seguranca gira em torno de 3 pilares:

```
         Confidencialidade
                /\
               /  \
              / CIA \
             /________\
    Integridade    Disponibilidade
```

### Confidencialidade

**O que e:** Apenas quem tem autorizacao pode ver os dados.

**Exemplo do mundo real:**
Imagine uma carta selada. So quem tem a chave da caixa de correio pode abrir e ler. Se alguem romper o lacre, a confidencialidade foi violada.

**Exemplo tecnico:**
Se voce tem uma senha para acessar seu email, essa senha e confidencial. Se vazar, qualquer pessoa pode ler seus emails.

**Ataque que viola confidencialidade:** Vazamento de senhas, SQL Injection que expoe dados.

### Integridade

**O que e:** Os dados nao podem ser alterados sem autorizacao.

**Exemplo do mundo real:**
Imagine um contrato assinado. Se alguem mudar uma clausula sem voce saber, a integridade do documento foi violada.

**Exemplo tecnico:**
Se voce transfere R$100 e o sistema registra R$1000, a integridade dos dados financeiros foi comprometida.

**Ataque que viola integridade:** SQL Injection que altera dados, modificacao de arquivos de log.

### Disponibilidade

**O que e:** O sistema precisa estar funcionando quando precisar dele.

**Exemplo do mundo real:**
Imagine um hospital com portas trancadas. Se os pacientes nao conseguem entrar, o hospital nao esta disponivel.

**Exemplo tecnico:**
Se o site de um banco cai e voce nao consegue fazer uma transferencia, a disponibilidade foi comprometida.

**Ataque que viola disponibilidade:** DDoS ( Distributed Denial of Service) — atacante sobrecarrega o servidor com milhoes de requisicoes ate ele cair.

---

## O que e um Ataque?

Um ataque e qualquer tentativa de acessar, alterar ou destruir dados ou sistemas **sem autorizacao**.

### Componentes de um ataque

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   ATACANTE   │ ──► │  VETOR DE   │ ──► │  VULNERABI-  │
│ (Ameaca)     │     │   ATAQUE     │     │  LIDADE      │
└──────────────┘     └──────────────┘     └──────────────┘
                                                   │
                                                   ▼
                                            ┌──────────────┐
                                            │   IMPACTO    │
                                            └──────────────┘
```

| Componente | O que e | Exemplo |
|:-----------|:--------|:--------|
| **Atacante (Threat Actor)** | Quem realiza o ataque | Grupo criminoso, funcionario malicioso |
| **Vetor de Ataque** | Como o ataque acontece | Email phishing, site malicioso |
| **Vulnerabilidade** | Falha que permite o ataque | Senha fraca, software desatualizado |
| **Exploit** | Codigo que explora a vulnerabilidade | Codigo que injeta SQL malicioso |
| **Payload** | O que o exploit executa | Reverse shell, ransomware |
| **Impacto** | Consequencia do ataque | Vazamento de dados, perda financeira |

---

## Tipos de Ameacas

| Tipo | Quem e | Motivacao | Exemplo |
|:-----|:-------|:----------|:--------|
| **Script Kiddie** | Iniciante usando ferramentas prontas | Curiosidade, fama | Usar Metasploit sem entender |
| **Hacker (Black Hat)** | Expert tecnico | Lucro, espionagem | Explorar zero-day |
| **Insider** | Funcionario da empresa | Vinganca, lucro | Vazar dados internos |
| **Hacktivista** | Grupo com motivacao politica | Ideologia | Anonymous |
| **APT (Advanced Persistent Threat)** | Grupo organizado (geralmente estados) | Espionagem, sabotagem | APT28 (Rusia), APT41 (China) |

---

## Tipos de Malware

| Tipo | O que faz | Como se propaga |
|:-----|:----------|:---------------|
| **Virus** | Se anexa a arquivos | Arquivos infectados, USB |
| **Worm** | Se espalha sozinho pela rede | Rede (sem intervencao humana) |
| **Trojan** | Finge ser algo util | Downloads falsos, emails |
| **Ransomware** | Sequestra dados e cobra resgate | Email, RDP, exploits |
| **Spyware** | Espia suas acoes | Software gratuito, trojans |
| **Rootkit** | Esconde processos maliciosos | Exploracao, trojans |
| **Keylogger** | Grava o que voce digita | Trojans, phishing |

---

## O que e um Pentest?

**Pentest (Penetration Test)** e uma simulacao de ataque autorizada. Um profissional contratado tenta encontrar e explorar falhas em um sistema para encontrar problemas **antes** de um atacante real.

```
┌─────────────────────────────────────────────────┐
│              DIFERENCA FUNDAMENTAL               │
│                                                  │
│  ATAQUE CRIMINOSO          PENTEST               │
│  ├── Sem autorizacao       ├── Com autorizacao   │
│  ├── Ilegal                ├── Legal             │
│  ├── Destroi/dano          ├── Reporta e ajuda  │
│  ├── Esconde rastros       ├── Documenta tudo   │
│  └── Motivo: lucro         └── Motivo: melhorar │
│                                                  │
└─────────────────────────────────────────────────┘
```

### Fases de um Pentest

```
1. Reconhecimento (onde estamos agora)
   ↓
2. Enumeração (descobrir detalhes)
   ↓
3. Analise de Vulnerabilidades
   ↓
4. Exploracao (exploit)
   ↓
5. Pos-exploracao
   ↓
6. Relatorio
```

> **Nota:** Este curso segue essas fases. Estamos na Fase 1 (Reconhecimento). O Modulo 00 e a base para tudo que vem pela frente.

---

## Seguranca Ofensiva vs. Defensiva

| Aspecto | Ofensiva (Red Team) | Defensiva (Blue Team) |
|:--------|:--------------------|:---------------------|
| **Objetivo** | Encontrar falhas ANTES do atacante | Proteger e detectar ataques |
| **Metodologia** | Ataca o sistema para encontrar falhas | Monitora, configura, defende |
| **Ferramentas** | Nmap, Metasploit, Burp Suite | Wazuh, Suricata, SIEM |
| **Perspectiva** | "Como eu entraria?" | "Como eu protejo?" |
| **Resultado** | Relatorio de vulnerabilidades | Regras, defesas, deteccao |

### Purple Team

**Purple Time** e quando as equipes ofensiva e defensiva trabalham juntas. O Red Team ataca, o Blue Team defende, e ambos aprendem.

---

## Controles de Seguranca

| Tipo | O que faz | Exemplo |
|:-----|:----------|:--------|
| **Preventivo** | Evita o ataque antes que aconteca | Firewall, senhas fortes, criptografia |
| **Detectivo** | Descobre o ataque enquanto acontece ou depois | IDS, logs, monitoramento |
| **Corretivo** | Responde ao ataque e minimiza dano | Restaurar backup, isolar sistema |

---

## Principios de Seguranca

| Principio | O que significa | Exemplo |
|:----------|:----------------|:--------|
| **Least Privilege** | Menor permissao possivel | Usuario comum sem sudo |
| **Defense in Depth** | Multiplas camadas de protecao | Firewall + IDS + Antivirus |
| **Zero Trust** | Nao confiar em ninguem | Verificar tudo, sempre |
| **Separation of Duties** | Dividir responsabilidades | Quem aprova nao executa |
| **Need to Know** | So quem precisa ve | Dados sensiveis restritos |

---

## Termos que voce vai encontrar no Modulo 01

Para que voce nao fique perdido quando encontrar esses termos no Reconhecimento:

| Termo | Definicao simples | Onde aparece |
|:------|:------------------|:-------------|
| **CVE** | Identificador unico de uma vulnerabilidade conhecida (ex: CVE-2024-1234) | Nuclei, Nmap scripts |
| **CVSS** | Nota de severidade de uma vulnerabilidade (0-10) | Relatorios de scan |
| **Zero-day** | Vulnerabilidade desconhecida pelo fabricante | Ameacas avancadas |
| **Attack Surface** | Conjunto de pontos por onde um sistema pode ser atacado | Reconhecimento |
| **Asset** | Ativo que precisa ser protegido (servidor, dados, rede) | Gerenciamento |
| **Risk** | Probabilidade de um ataque acontecer e causar dano | Analise |
| **Exposure** | Grau de exposicao de um sistema a ataques | Scan |
| **Misconfiguration** | Configuracao incorreta que cria vulnerabilidade | Nuclei, Nikto |

---

## Etica e Legalidade — OBRIGATORIO antes de qualquer pratica

### Esta secao e a mais importante deste modulo.

Voce pode ter todo o conhecimento tecnico do mundo. Se nao respeitar as regras eticas e legais, voce nao e um profissional de seguranca — e um criminoso.

### A regra de ouro

```
╔═══════════════════════════════════════════════════════════╗
║  NUNCA, EM NENHUMA HIPOTESE, teste sistemas que voce     ║
║  NAO tenha AUTORIZACAO ESCRITA para testar.              ║
║                                                          ║
║  Sem autorizacao = CRIME.                                ║
║                                                          ║
║  Nao importa se voce "so queria aprender".               ║
║  Nao importa se voce "nao ia fazer nada mal".            ║
║  Nao importa se "ninguem vai saber".                     ║
║                                                          ║
║  SEM AUTORIZACAO = CRIME.                                ║
╚═══════════════════════════════════════════════════════════╝
```

### O que e autorizacao?

Autorizacao e uma **permissao por escrito** do dono do sistema para que voce teste a seguranca. Ela deve incluir:

| Elemento | O que e |
|:---------|:--------|
| **Escopo (Scope)** | Quais sistemas, redes e aplicacoes podem ser testados |
| **Metodos permitidos** | Quais tecnicas podem ser usadas |
| **Janela de teste** | Periodo em que o teste pode ocorrer |
| **Contato de emergencia** | Quem acionar se algo dar errado |
| **Relatorio** | Como e quando os resultados serao entregues |

### Diferenca entre estudar e atacar

| Estudar uma tecnica | Atacar um sistema |
|:--------------------|:-----------------|
| Rodar Nmap no SEU computador | Rodar Nmap no servidor de outra pessoa |
| Usar Metasploitable (VM vulneravel) | Usar Metasploit em sistema real |
| Praticar em CTF (Capture The Flag) | Testar em site de empresa sem permissao |
| Ler sobre SQL Injection | Injetar SQL em site alheio |

### Ambientes seguros para praticar

| Ambiente | O que e | Link |
|:---------|:--------|:-----|
| **Kali Linux (sua VM)** | Seu laboratorio pessoal | Local |
| **Metasploitable** | VM intencionalmente vulneravel | Local |
| **TryHackMe** | Plataforma com labs guiados | tryhackme.com |
| **HackTheBox** | Maquinas para praticar | hackthebox.com |
| **PortSwigger** | Labs de web security | portswigger.net |
| **OverTheWire** | Wargames de Linux | overthewire.org |
| **PicoCTF** | CTFs para iniciantes | picoctf.org |

### Leis e consequencias

| Pais | Lei | Consequencia |
|:-----|:----|:-------------|
| **EUA** | Computer Fraud and Abuse Act (CFAA) | Multa + ate 20 anos de prisao |
| **Brasil** | Lei 12.737/2012 (Lei Carolina Dieckmann) | Multa + ate 5 anos de prisao |
| **Europa** | NIS2 Directive + leis nacionais | Multa + prisao |
| **Reino Unido** | Computer Misuse Act 1990 | Multa + prisao |

> **Nota:** Mesmo no Brasil, o acesso nao autorizado a sistema de informatica e crime (Art. 154-A do Codigo Penal). "So estava aprendendo" nao e defesa legal.

### Principios eticos do Hacker

| Principio | O que significa |
|:----------|:----------------|
| **Autorizacao** | So teste com permissao por escrito |
| **Escopo** | Nao va alem do que foi combinado |
| **Confidencialidade** | Nao compartilhe vulnerabilidades publicamente |
| **Documentacao** | Registre tudo que voce fez |
| **Responsabilidade** | Reporte vulnerabilidades ao dono, nao publicamente |
| **Nao-dano** | Nao destrua dados ou sistems durante testes |

### Bug Bounty — Hacker legal e pago

Plataformas como **HackerOne** e **Bugcrowd** permitem que voce teste sistemas de empresas **com autorizacao implicita** (dentro das regras do programa). Se encontrar vulnerabilidades reais, voce pode ganhar dinheiro legalmente.

---

## Exercicio: Teste etico

Para cada situacao, responda: **e etico e legal?**

1. Voce roda `nmap localhost` no SEU computador
2. Voce roda `nmap google.com` do SEU computador
3. Voce usa SQL Injection em um site que voce encontrou
4. Voce pratica em uma maquina do TryHackMe
5. Voce usa Hydra para tentar adivinhar a senha do WiFi do vizinho
6. Voce testa o site da empresa onde voce trabalha, mas sem pedir autorizacao ao TI

<details>
<summary>Respostas</summary>

1. **SIM** — e seu computador, voce pode
2. **NAO** — scan de portas em sistema sem autorizacao e ilegal
3. **NAO** — sem autorizacao do dono do site, e crime
4. **SIM** — a plataforma autoriza o teste
5. **NAO** — acesso nao autorizado a rede alheia e crime
6. **NAO** — voce precisa de autorizacao formal do departamento de TI

</details>

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Explicar o que e Cybersecurity
- [ ] Definir os 3 pilares da Triade CIA
- [ ] Diferenciar seguranca ofensiva e defensiva
- [ ] Listar os tipos de ameacas
- [ ] Explicar o que e um pentest e suas fases
- [ ] Diferenciar estudar uma tecnica de atacar um sistema
- [ ] Listar ambientes seguros para praticar
- [ ] Entender que SEM AUTORIZACAO = CRIME
- [ ] Definir autorizacao e escopo
- [ ] Conhecer as principais leis de cybercrime

---

<div align="center">

**⬅️ [Anterior: Maquinas Virtuais](../02-sistemas/08-maquinas-virtuais.md)** | **[Proximo: Comandos de Rede](../04-ferramentas/12-comandos-rede.md) ➡️**

</div>
