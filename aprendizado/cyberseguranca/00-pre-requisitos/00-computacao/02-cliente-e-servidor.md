# Cliente e Servidor

> Todo ataque, toda defesa, toda comunicacao na internet segue o modelo cliente/servidor. Entender isso e entender a base de como a web funciona, como funciona DNS, como funciona SSH — e como funciona Reconhecimento.

---

## O que e o modelo Cliente/Servidor?

E o modelo mais usado de comunicacao em redes. Um lado **pede** (cliente), o outro lado **responde** (servidor).

### Analogia: Restaurante

```
┌─────────────────────────────────────────────────┐
│              RESTAURANTE                         │
│                                                  │
│   VOCE (Cliente)          GARCOM (Servidor)      │
│                                                  │
│   "Quero o prato      ←→   "Certo, vou buscar    │
│    do dia"                   pra voce"            │
│                                                  │
│   Voce PEDE             O garcom RESPONDE        │
│   Voce RECEBE           O garcom ENTREGA         │
└─────────────────────────────────────────────────┘
```

- **Voce** e o cliente: faz requisicoes
- **O garcom** e o servidor: processa e responde
- **O cardapio** e o protocolo: as regras da comunicacao

---

## Como funciona na pratica?

### Exemplo: Acessando um site

```
SEU NAVEGADOR (Cliente)
        │
        │  "Quero acessar google.com"
        │  (Requisicao HTTP)
        │
        ▼
SERVIDOR WEB (Google)
        │
        │  "Aqui esta a pagina"
        │  (Resposta HTTP)
        │
        ▼
SEU NAVEGADOR exibe o site
```

### Exemplo: Consulta DNS

```
SEU COMPUTADOR (Cliente)
        │
        │  "Qual o IP do google.com?"
        │  (Requisicao DNS)
        │
        ▼
SERVIDOR DNS
        │
        │  "O IP e 142.250.74.46"
        │  (Resposta DNS)
        │
        ▼
SEU COMPUTADOR conecta ao IP
```

### Exemplo: Acesso remoto (SSH)

```
SEU COMPUTADOR (Cliente)
        │
        │  "Quero acessar o servidor remotamente"
        │  (Conexao SSH na porta 22)
        │
        ▼
SERVIDOR REMOTO (com sshd rodando)
        │
        │  "Qual sua senha?"
        │  (Autenticacao)
        │
        ▼
SEU COMPUTADOR envia senha
        │
        ▼
SERVIDOR concede acesso
        │
        ▼
Voce tem um terminal no servidor remoto
```

---

## Terminologia importante

| Termo | O que e | Exemplo |
|:------|:--------|:--------|
| **Cliente** | Quem faz a requisicao | Navegador, terminal SSH, ferramenta Nmap |
| **Servidor** | Quem processa e responde | Servidor web, servidor DNS, servidor SSH |
| **Requisicao (Request)** | O que o cliente pede | "Quero a pagina index.html" |
| **Resposta (Response)** | O que o servidor retorna | "Aqui esta o HTML da pagina" |
| **Porta** | Numero da "sala" onde o servico escuta | 80=HTTP, 443=HTTPS, 22=SSH |
| **Protocolo** | Regras da comunicacao | HTTP, DNS, SSH, FTP |

---

## Os 3 atores de toda comunicacao

```
┌──────────┐          ┌──────────┐          ┌──────────┐
│ CLIENTE  │ ──────► │ SERVIDOR │ ──────► │ SERVIDOR │
│          │          │  WEB     │          │   DNS    │
│ Navegador│          │          │          │          │
└──────────┘          └──────────┘          └──────────┘
     │                      │
     │ "Quero google.com"   │ "Preciso do IP"
     │ ────────────────────►│ ──────────────►
     │                      │ ◄──────────────
     │                      │ "IP: 142.x.x.x"
     │ ◄────────────────────│
     │ "Aqui esta o site"   │
```

Nesse exemplo:
1. **Voce (cliente)** digita "google.com" no navegador
2. **Servidor DNS** traduz o nome em IP
3. **Servidor Web (Google)** envia o site de volta

---

## Por que isso e CRITICO para Cybersecurity?

### Perspectiva ofensiva (Reconhecimento)

Quando voce faz reconhecimento, voce esta descobrindo:
- **Quais servidores existem** (IPs, dominios)
- **Quais servicos estao rodando** (HTTP, SSH, DNS)
- **Quais portas estao abertas** (onde "escutam")
- **Quais versoes** estao usando

```
Voce (cliente/atacante)
        │
        │  Nmap scan
        │
        ▼
Alvo (servidor)
        │
        │  Portas abertas:
        │  22 → sshd (OpenSSH 8.2)
        │  80 → httpd (Apache 2.4.41)
        │  443 → httpd (Apache 2.4.41)
```

### Perspectiva defensiva

Quando voce defende um sistema, voce esta:
- **Monitorando** quem esta conectando
- **Bloqueando** clientes maliciosos
- **Protegendo** servidores de ataques
- **Analisando** logs de requisicoes

---

## Cliente e Servidor na Web

### A comunicacao HTTP

```
┌──────────┐                                ┌──────────┐
│  CLIENTE │                                │ SERVIDOR │
│(Navegador│                                │   WEB    │
└────┬─────┘                                └────┬─────┘
     │                                           │
     │  1. REQUEST                               │
     │  GET /index.html HTTP/1.1                 │
     │  Host: google.com                         │
     │ ─────────────────────────────────────────►│
     │                                           │
     │  2. RESPONSE                              │
     │  HTTP/1.1 200 OK                          │
     │  Content-Type: text/html                  │
     │  <html>...conteudo...</html>              │
     │◄───────────────────────────────────────── │
     │                                           │
```

### O que cada parte significa

**Request (Requisicao):**
```
GET /index.html HTTP/1.1    ← Metodo + Caminho + Versao do HTTP
Host: google.com            ← Qual site voce quer
```

**Response (Resposta):**
```
HTTP/1.1 200 OK             ← Versao do HTTP + Codigo de status
Content-Type: text/html     ← Tipo do conteudo
<html>...</html>            ← O conteudo em si
```

---

## IP, Porta e Servico — A triade fundamental

Para que um cliente acesse um servico, ele precisa de 3 coisas:

```
┌─────────────────────────────────────────┐
│         ACESSO A UM SERVICO              │
│                                          │
│  1. IP do servidor                       │
│     "ONDE esta o servidor?"              │
│     Ex: 192.168.1.50                     │
│                                          │
│  2. Porta                                │
│     "QUAL sala do servico?"              │
│     Ex: 80 (HTTP), 22 (SSH)             │
│                                          │
│  3. Protocolo                            │
│     "COMO falar com o servico?"          │
│     Ex: HTTP, SSH, DNS                   │
│                                          │
│  Exemplo completo:                       │
│  http://192.168.1.50:80                  │
│  (Protocolo://IP:Porta)                 │
└─────────────────────────────────────────┘
```

---

## Tipos de Servidores mais comuns

| Servidor | Porta padrao | O que faz | Ferramenta para atacar/defender |
|:---------|:-------------|:----------|:--------------------------------|
| **Web** | 80 (HTTP), 443 (HTTPS) | Hospeda sites | Nmap, Nikto, ffuf |
| **SSH** | 22 | Acesso remoto | Hydra, Nmap |
| **DNS** | 53 | Traduz nomes em IPs | dig, nslookup, dnsrecon |
| **Email** | 25, 587 (SMTP), 110 (POP3), 143 (IMAP) | Envia/recebe emails | theHarvester |
| **FTP** | 21 | Transferencia de arquivos | Nmap, Hydra |
| **Banco de Dados** | 3306 (MySQL), 5432 (PostgreSQL) | Armazena dados | Nmap, sqlmap |
| **SMB** | 445 | Compartilhamento Windows | enum4linux, CrackMapExec |

---

## Exercicio Practico

### Exercicio 1: Identificando atores

Para cada situacao, identifique quem e o cliente e quem e o servidor:

1. Voce acessa google.com no navegador
2. Voce faz ssh usuario@servidor.com
3. Seu computador consulta o IP do github.com
4. O Nmap escaneia um servidor alvo

<details>
<summary>Respostas</summary>

1. Cliente: seu navegador | Servidor: servidor web do Google
2. Cliente: seu computador | Servidor: servidor remoto (com sshd)
3. Cliente: seu computador | Servidor: servidor DNS
4. Cliente: Nmap (seu computador) | Servidor: servidor alvo

</details>

### Exercicio 2: Conectando conceitos

Voce descobriu que um servidor tem:

```
IP: 200.100.50.25
Porta 22: sshd (OpenSSH 8.2)
Porta 80: httpd (Apache 2.4.41)
Porta 443: httpd (Apache 2.4.41)
```

Responda:

1. Para acessar o site, qual endereco voce usaria?
2. Para acessar remotamente, qual endereco usaria?
3. Qual protocolo o Apache usa?
4. Se voce quiser fazer brute force na senha SSH, qual porta atacar?

<details>
<summary>Respostas</summary>

1. http://200.100.50.25 ou https://200.100.50.25
2. ssh root@200.100.50.25
3. HTTP (porta 80) e HTTPS (porta 443)
4. Porta 22 (SSH)

</details>

### Exercicio 3: Raciocinio

Por que o reconhecimento sempre comeca descobrindo o **IP** e as **portas abertas** de um alvo?

<details>
<summary>Resposta</summary>

Porque para atacar ou testar qualquer servico, voce precisa saber:
1. **ONDE** o servico esta (IP)
2. **QUAL porta** ele esta escutando
3. **QUE servico** esta rodando naquela porta

Sem essas 3 informacoes, voce nao tem para onde enviar seu ataque/teste. E por isso que reconhecimento e a primeira fase de qualquer pentest.

</details>

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Explicar o que e cliente e servidor
- [ ] Dar exemplos de clientes e servidores
- [ ] Entender a triade IP + Porta + Protocolo
- [ ] Conectar o modelo cliente/servidor com Reconhecimento
- [ ] Entender por que descobrir portas abertas e o primeiro passo de qualquer ataque

---

<div align="center">

**⬅️ [Anterior: Processos e Servicos](01-processos-e-servicos.md)** | **[Proximo: O que e uma Rede](../01-redes/03-o-que-e-uma-rede.md) ➡️**

</div>
