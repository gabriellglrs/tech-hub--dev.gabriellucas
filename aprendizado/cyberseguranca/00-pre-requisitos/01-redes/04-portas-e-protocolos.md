# Portas e Protocolos

> Portas e protocolos sao a base de toda comunicacao em rede. Entender isso e entender como voce vai descobrir servicos, vulnerabilidades e pontos de entrada durante Reconhecimento.

---

## O que e um Servico? (LEIA PRIMEIRO)

**Antes de entender portas, voce precisa entender servicos.**

Um **servico** e um programa que roda em background e fica "escutando" por conexoes. E como um garcom parado na area, esperando alguem pedir.

```
Servidor: 192.168.1.50

Servico SSH (sshd)
├── Roda como processo no servidor
├── "Escuta" na porta 22
├── Quando alguem conecta na porta 22...
├── O sshd processa a requisicao
└── Concede acesso remoto (se tiver senha/chave)
```

**Sem servico, a porta e so um numero.** E o servico que da significado a porta.

| Porta | Servico (programa) | O que acontece quando voce conecta |
|:------|:-------------------|:-----------------------------------|
| 22 | sshd | Voce ganha um terminal remoto |
| 80 | httpd / nginx | Voce recebe uma pagina web |
| 443 | httpd / nginx + TLS | Voce recebe uma pagina web criptografada |
| 53 | named (DNS server) | O servidor responde consultas de DNS |
| 3306 | mysqld | Voce se conecta a um banco de dados |

> **Regra de ouro:** Porta = "sala" do predio. Servico = "funcionario" que trabalha naquela sala. Sem o funcionario, a sala esta vazia.

---

## O que e uma Porta?

Uma **porta** e um numero de 0 a 65535 que identifica um servico especifico em um computador. E como o numero do apartamento em um predio — cada servico tem o seu.

### Por que isso e importante?

- **Portas abertas = servicos ativos** — cada porta aberta e uma possivel entrada
- **Scan de portas** e o PRIMEIRO passo de qualquer reconhecimento
- **Firewalls bloqueiam portas** — entender portas e entender defesa
- **Cada porta tem um servico padrao** — porta 22=SSH, 80=HTTP, 443=HTTPS

### Como funciona?

```
Computador alvo: 192.168.1.50

Porta 22   → Servico SSH      (acesso remoto)
Porta 80   → Servico HTTP     (web server)
Porta 443  → Servico HTTPS    (web seguro)
Porta 3306 → Servico MySQL    (banco de dados)
Porta 4444 → Porta comum para shells reversos
```

---

## Analogia: Predio de Escritorios

```
┌─────────────────────────────────────────────┐
│            PREDIO (Servidor)                 │
│                                              │
│  Porta 80  → Recepcao (Web)                 │
│             Funcionario: Apache              │
│                                              │
│  Porta 443 → Sala VIP (HTTPS)               │
│             Funcionario: Apache + TLS        │
│                                              │
│  Porta 22  → Escritorio do chefe (SSH)      │
│             Funcionario: sshd                │
│                                              │
│  Porta 25  → Correio (Email)                 │
│             Funcionario: Postfix             │
│                                              │
│  Porta 3306 → Sala de dados (MySQL)          │
│             Funcionario: mysqld              │
└─────────────────────────────────────────────┘
```

- **Predio** = Servidor (computador)
- **Numero da sala** = Porta
- **Funcionario trabalhando na sala** = Servico
- **Voce entrando na sala** = Conexao do cliente

---

## TCP vs UDP

Antes de ver as portas, entenda os 2 protocolos de transporte:

| Caracteristica | TCP | UDP |
|:---------------|:----|:----|
| **Confiavel** | Sim — garante entrega | Nao — pode perder pacotes |
| **Ordem** | Garantida — dados chegam na ordem | Nao garantida |
| **Velocidade** | Mais lento (tem verificacao) | Mais rapido (sem verificacao) |
| **Conexao** | Orientado a conexao (3-way handshake) | Sem conexao |
| **Exemplo** | Web, SSH, Email, FTP | DNS, VoIP, Games, streaming |

### Analogia

```
TCP = Carta registrada
├── Voce envia
├── Correio confirma que chegou
├── Se perder, reenvia
└── Dados chegam na ordem

UDP = Panfleto jogado na calçada
├── Voce joga
├── Nao confirma se chegou
├── Se perder, azar
└── Rapido, mas sem garantia
```

### Por que isso importa para seguranca?

- **Nmap SYN scan (-sS)** explora o TCP handshake para detectar portas abertas
- **Nmap UDP scan (-sU)** e mais lento porque UDP nao confirma
- **DNS usa UDP** (porta 53) para consultas rapidas
- **SSH usa TCP** (porta 22) porque precisa de confiabilidade

---

## Faixas de Portas

| Faixa | Nome | O que e |
|:------|:-----|:--------|
| **0-1023** | Bem Conhecidas (Well-Known) | Servicos padrao da internet (HTTP, SSH, DNS) |
| **1024-49151** | Registradas | Servicos de empresas e aplicacoes |
| **49152-65535** | Dinamicas (Ephemeral) | Portas temporarias para conexoes de saida |

---

## Portas mais Importantes

### Portas Bem Conhecidas (0-1023)

| Porta | Protocolo | Servico | O que e | Relacao com Reconhecimento |
|:------|:----------|:--------|:--------|:---------------------------|
| **21** | TCP | FTP | Transferencia de arquivos | Enumerar arquivos, brute force |
| **22** | TCP | SSH | Acesso remoto seguro | Brute force, enumerar usuarios |
| **23** | TCP | Telnet | Acesso remoto (INSEGURO) | Interceptacao de dados |
| **25** | TCP | SMTP | Envio de email | Enumerar emails, spoofing |
| **53** | TCP/UDP | DNS | Resolucao de nomes | Zone transfer, DNS enum |
| **80** | TCP | HTTP | Web (sem criptografia) | Fingerprinting, directory busting |
| **110** | TCP | POP3 | Receber email | Brute force |
| **143** | TCP | IMAP | Receber email | Brute force |
| **443** | TCP | HTTPS | Web (com criptografia) | Fingerprinting, APIs |
| **445** | TCP | SMB | Compartilhamento Windows | Enumerar shares, EternalBlue |
| **3306** | TCP | MySQL | Banco de dados | SQL Injection, brute force |
| **3389** | TCP | RDP | Area de trabalho remota | Brute force, BlueKeep |

### Portas Registradas (1024-49151)

| Porta | Servico | Uso |
|:------|:--------|:----|
| **8080** | HTTP alternativo | Proxies, testes, APIs |
| **8443** | HTTPS alternativo | APIs seguras |
| **5432** | PostgreSQL | Banco de dados |
| **6379** | Redis | Cache |
| **27017** | MongoDB | Banco NoSQL |

---

## Como descobrir portas abertas?

### No SEU computador

```bash
# Ver portas em escuta (Linux)
ss -tlnp

# Saida exemplo:
# State   Recv-Q  Send-Q  Local Address:Port  Process
# LISTEN  0       128     0.0.0.0:22          users:(("sshd",pid=1234))
# LISTEN  0       128     0.0.0.0:80          users:(("nginx",pid=2345))
# LISTEN  0       128     0.0.0.0:443         users:(("nginx",pid=2345))
```

### Em um SERVIDOR ALVO (reconhecimento)

```bash
# Scan basico de portas com Nmap
nmap 192.168.1.50

# Scan com deteccao de versao
nmap -sV 192.168.1.50

# Scan agressivo (versao + scripts + SO)
nmap -A 192.168.1.50
```

> **Nota:** O Nmap e a ferramenta #1 para descobrir portas abertas. Voce vai aprende-lo detalhadamente no Modulo 01 (Reconhecimento).

---

## Por que isso e CRITICO para Reconhecimento?

Quando voce faz reconhecimento de um alvo, a PRIMEIRA coisa que voce descobre sao as portas abertas e os servicos rodando:

```
Resultado de um scan Nmap:

Host: 200.100.50.25
├── Porta 22/tcp  ABERTA  ssh (OpenSSH 8.2p1)
├── Porta 80/tcp  ABERTA  http (Apache/2.4.41)
├── Porta 443/tcp ABERTA  http (Apache/2.4.41)
└── Porta 3306/tcp ABERTA  mysql (MySQL 8.0.26)
```

### O que isso revela?

| Porta | Servico | O que voce pode fazer |
|:------|:--------|:----------------------|
| 22 (SSH) | sshd | Tentar brute force, enumerar usuarios |
| 80 (HTTP) | Apache | Fingerprinting, directory busting, testar falhas web |
| 443 (HTTPS) | Apache + TLS | Testar certificados, APIs, subdominios |
| 3306 (MySQL) | mysqld | Tentar brute force, SQL injection |

**Sem saber as portas abertas, voce nao sabe onde atacar.** E por isso que scan de portas e o primeiro passo de qualquer pentest.

---

## Exercicio Practico

### Exercicio 1: Portas e Servicos

Responda:

1. Qual e a porta do SSH?
2. Qual e a porta do HTTP?
3. Se voce quer acessar um site de forma segura, qual porta usar?
4. Se voce quer acessar um servidor remotamente, qual porta usar?
5. Qual protocolo e mais rapido: TCP ou UDP?

<details>
<summary>Respostas</summary>

1. 22
2. 80
3. 443 (HTTPS)
4. 22 (SSH)
5. UDP (mas menos confiavel)

</details>

### Exercicio 2: Raciocinio

Voce fez um scan e encontrou:

```
Host: 10.0.0.50
├── Porta 22/tcp  ABERTA  ssh (OpenSSH 7.6p1)
├── Porta 80/tcp  ABERTA  http (nginx/1.14.0)
├── Porta 443/tcp ABERTA  http (nginx/1.14.0)
├── Porta 3306/tcp ABERTA  mysql (MySQL 5.7.34)
└── Porta 8080/tcp ABERTA  http (Apache Tomcat/9.0.40)
```

Responda:

1. Quantos servicos estao rodando?
2. Qual versao do nginx esta sendo usada?
3. Se a versao do MySQL 5.7.34 tem uma CVE conhecida, qual porta voce atacaria?
4. O que a porta 8080 pode indicar?

<details>
<summary>Respostas</summary>

1. 5 servicos (SSH, HTTP na 80, HTTPS na 443, MySQL, HTTP na 8080)
2. nginx/1.14.0
3. Porta 3306
4. Pode ser um servico web alternativo, proxy, ou aplicacao interna (Tomcat = servidor Java)

</details>

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Explicar o que e um servico e como ele se relaciona com portas
- [ ] Listar as 10 portas mais importantes
- [ ] Diferenciar TCP e UDP
- [ ] Usar `ss -tlnp` para ver portas abertas
- [ ] Entender por que scan de portas e o primeiro passo de Reconhecimento
- [ ] Interpretar o resultado basico de um Nmap

---

<div align="center">

**⬅️ [Anterior: DNS](03-dns.md)** | **[Proximo: TCP/IP e OSI](05-tcp-ip-osi.md) ➡️**

</div>
