# Comandos de Rede Essenciais

> Estes sao os comandos que voce vai usar **o tempo todo** em cyberseguranca. Memorize-os — eles sao sua ferramenta de diagnostico e reconhecimento.

---

## O que sao comandos de rede?

Sao ferramentas no terminal que mostram informacoes sobre a conexao de rede do seu computador. Com eles voce descobre seu IP, testa conexoes, verifica portas abertas e diagnostica problemas.

### Por que isso e importante?

- **Todo hacker comeca com diagnostico** — antes de atacar, voce precisa entender a rede
- **Firewalls bloqueiam por IP/porta** — voce precisa saber o que esta aberto
- **Problemas de rede** sao os mais comuns — saber diagnosticar salva horas
- **Logs mostram IPs** — identificar origem de ataques

---

## Descobrir informacoes

```bash
# Meu endereco IP
ip a                    # Linux (recomendado)
ifconfig                # Linux (antigo, ainda funciona)
ipconfig                # Windows

# Informacoes detalhadas da rede
ip addr show            # Detalhes da interface
ip route show           # Tabela de roteamento
cat /etc/resolv.conf    # Servidores DNS configurados
```

---

## Testar conectividade

```bash
# Testar se um host esta acessivel
ping 8.8.8.8            # Google DNS
ping google.com         # Testar resolucao DNS

# Trace route (caminho ate o destino)
traceroute google.com   # Linux
tracert google.com      # Windows

# Testar porta especifica
ping -c 4 192.168.1.1  # Enviamos 4 pacotes
```

---

## Resolucao DNS

```bash
# Descobrir IP de um dominio
nslookup google.com     # Formato simples
dig google.com          # Formato detalhado
host google.com         # Formato curto

# Tipos de consulta
dig MX gmail.com        # Servidores de email
dig NS google.com       # Servidores DNS
dig TXT google.com      # Registros TXT
```

---

## Ver conexoes e portas

```bash
# Portas abertas no seu computador
netstat -tlnp           # TCP listening
netstat -ulnp           # UDP listening
ss -tlnp                # Versao moderna (recomendado)

# Conexoes ativas
netstat -tunp           # Todas as conexoes TCP/UDP
ss -tunp                # Versao moderna

# Processo usando uma porta
lsof -i :80             # Quem esta usando porta 80?
fuser 80/tcp            # PID do processo na porta 80
```

---

## Whois — Informacoes de dominios

**Whois** mostra informacoes publicas sobre um dominio: dono, data de criacao, servidores DNS, contato.

### Por que e importante para reconhecimento?

```
Whois revela:
├── Quem registrou o dominio (nome, email, empresa)
├── Quando foi criado (pode indicar site novo = menos maduro)
├── Servidores DNS (pode revelar infraestrutura)
├── Registradora (pode ajudar em ataques de phishing)
└── Contato do abusode (para reportar vulnerabilidades)
```

### Comandos

```bash
# Instalar whois (se nao tiver)
sudo apt install -y whois

# Consultar dominio
whois google.com

# Saida exemplo:
# Domain Name: GOOGLE.COM
# Registry Domain ID: 2138514_DOMAIN_COM-VRSN
# Registrar WHOIS Server: whois.markmonitor.com
# Updated Date: 2024-01-01T00:00:00Z
# Creation Date: 1997-09-15T00:00:00Z
# Registrar: MarkMonitor Inc.
# Registrant Organization: Google LLC
# Registrant Country: US

# Consultar por IP
whois 8.8.8.8

# Saida exemplo:
# NetRange: 8.8.8.0 - 8.8.8.255
# CIDR: 8.8.8.0/24
# NetName: GOOGLE
# Organization: Google LLC (GOGL)
# Country: US
```

### O que voce pode fazer com essas informacoes?

| Informacao | Uso no reconhecimento |
|:-----------|:----------------------|
| **Creation Date** | Site novo = possivelmente menos seguro |
| **Registrant Organization** | Identificar empresa dona |
| **Name Servers** | Descobrir infraestrutura DNS |
| **Registrar** | Saber onde o dominio foi registrado |
| **Abuse Contact** | Reportar vulnerabilidades (etico) |

---

## Nmap — O Comando Mais Importante

**Nmap (Network Mapper)** e a ferramenta #1 para scan de portas e descoberta de redes. Voce vai usar ele CONSTANTEMENTE no Modulo 01.

> **Nota:** Aqui voce aprende o basico. No Modulo 01 (Reconhecimento) voce vai dominar todas as opcoes.

### O que e Nmap?

```
Nmap e como um raio-x de um servidor:
├── Descobre quais portas estao abertas
├── Identifica quais servicos estao rodando
├── Mostra versoes dos servicos
├── Detecta o sistema operacional
└── Executa scripts de vulnerabilidade
```

### Comandos basicos

```bash
# Instalar Nmap (geralmente ja vem no Kali)
sudo apt install -y nmap

# Scan basico (quais portas estao abertas?)
nmap 192.168.1.50

# Saida exemplo:
# PORT     STATE SERVICE
# 22/tcp   open  ssh
# 80/tcp   open  http
# 443/tcp  open  https
# 3306/tcp open  mysql

# Scan com deteccao de versao
nmap -sV 192.168.1.50

# Saida exemplo:
# PORT     STATE SERVICE VERSION
# 22/tcp   open  ssh     OpenSSH 8.2p1
# 80/tcp   open  http    Apache/2.4.41
# 443/tcp  open  http    Apache/2.4.41
# 3306/tcp open  mysql   MySQL 8.0.26

# Scan agressivo (versao + scripts + SO)
nmap -A 192.168.1.50

# Scan de uma rede inteira
nmap 192.168.1.0/24

# Scan em todas as portas (1-65535)
nmap -p- 192.168.1.50

# Scan rapido (so as 100 portas mais comuns)
nmap -F 192.168.1.50
```

### Por que Nmap e CRITICO?

```
Nmap e a porta de entrada para todo reconhecimento:

1. Scan basico → Descobre portas abertas
2. Scan de versao → Descobre servicos e versoes
3. Scripts NSE → Encontra vulnerabilidades
4. Scan de rede → Mapeia toda a infraestrutura
5. Fingerprinting → Identifica SO e aplicacoes

SEM Nmap, voce nao sabe onde atacar.
COM Nmap, voce tem o mapa do terreno.
```

### Analogia

```
Nmap e como um alarme para portas:

Imagine um predio com 65535 portas.
Nmap toca cada porta e espera resposta:

"Porta 22, voce esta aberta?" → "Sim, estou!"
"Porta 80, voce esta aberta?" → "Sim, estou!"
"Porta 443, voce esta aberta?" → "Sim, estou!"
"Porta 8080, voce esta aberta?" → "Nao estou..."

Resultado: Portas 22, 80 e 443 estao abertas.
```

---

## Exercicios Praticos

### Exercicio 1: Descubra seu IP

```bash
ip a | grep "inet "     # Mostra IPs das interfaces
```

### Exercicio 2: Teste seu DNS

```bash
nslookup github.com
# Anote o IP retornado
ping -c 3 <IP_retornado>
```

### Exercicio 3: Veja portas abertas

```bash
ss -tlnp
# Identifique: porta 22 (SSH), porta 80 (HTTP), porta 443 (HTTPS)
```

### Exercicio 4: Trace a rota

```bash
traceroute google.com
# Veja quantos saltos ate o Google
```

### Exercicio 5: Whois

```bash
# Descubra informacoes sobre um dominio
whois google.com
# Responda:
# 1. Quem e o registrante?
# 2. Quando o dominio foi criado?
# 3. Quais sao os name servers?
```

### Exercicio 6: Nmap basico

```bash
# Scan basico no SEU computador (localhost)
nmap localhost

# Scan em uma rede local (SEU laboratorio)
nmap 192.168.56.0/24

# Responda:
# 1. Quantas portas abertas voce encontrou?
# 2. Quais servicos estao rodando?
# 3. Quais versoes dos servicos?
```

---

## Macetes

| Comando | Dica |
|:--------|:-----|
| `ip a` | Use em vez de `ifconfig` (e o padrao novo) |
| `ss` | Use em vez de `netstat` (e mais rapido) |
| `dig` | Use em vez de `nslookup` (mais detalhes) |
| `ping -c 4` | Use `-c` para limitar pacotes no Linux |
| `nmap -sV` | Sempre use para ver versoes dos servicos |
| `nmap -A` | Scan agressivo — use com cuidado |

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Descobrir meu IP com `ip a`
- [ ] Testar conexao com `ping`
- [ ] Resolver DNS com `nslookup` ou `dig`
- [ ] Ver portas abertas com `ss -tlnp`
- [ ] Ver quem usa uma porta com `lsof -i :PORTA`
- [ ] Consultar informacoes de dominio com `whois`
- [ ] Fazer um scan basico com `nmap`
- [ ] Entender a importancia do Nmap para reconhecimento

---

<div align="center">

**⬅️ [Anterior: Editores de Texto](13-editores-texto.md)** | **[Proximo: Conceitos de Seguranca](../03-seguranca/09-conceitos-seguranca.md) ➡️**

</div>
