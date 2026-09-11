# Redes no Terminal

> O terminal e sua ferramenta #1 para diagnosticar e atacar redes. Aqui voce domina os comandos de rede.

---

## Descobrir Informacoes

```bash
# Meu endereco IP
ip a                        # Linux (recomendado)
ifconfig                    # Linux (antigo)
ip addr show                # Mesma coisa

# IP externo
curl ifconfig.me
curl icanhazip.com
```

---

## Testar Conectividade

```bash
# Ping basico
ping 8.8.8.8
ping -c 4 google.com        # 4 pacotes apenas

# Trace route
traceroute google.com       # Caminho ate o destino
tracepath google.com        # Similar, sem precisar de root

# Testar porta especifica
ping -c 1 -W 2 192.168.1.1 # 1 pacote, 2s timeout
```

---

## Resolucao DNS

```bash
nslookup google.com         # Basico
dig google.com              # Detalhado
dig google.com +short       # Apenas IP
dig google.com ANY          # Todos os registros

# Tipos de registro
dig MX gmail.com            # Servidores de email
dig NS google.com           # Servidores DNS
dig TXT google.com          # Registros TXT
dig A google.com            # Registro A (IPv4)
dig AAAA google.com         # Registro AAAA (IPv6)
dig CNAME www.google.com    # Registro CNAME

# Zona de transferencia
dig @ns1.example.com example.com AXFR  # Zone transfer (se permitido)
```

---

## Portas e Conexoes

```bash
# Portas abertas no SEU computador
ss -tlnp                    # TCP listening
ss -ulnp                    # UDP listening
ss -tunp                    # Todas as conexoes
netstat -tlnp               # Versao antiga

# Quem esta usando uma porta
lsof -i :80
fuser 80/tcp
ss -tlnp | grep :80
```

---

## curl — Requests HTTP

```bash
# GET basico
curl https://example.com

# GET com headers
curl -I https://example.com          # So headers
curl -v https://example.com          # Verboso

# POST
curl -X POST -d "user=admin&pass=123" https://site.com/login

# POST com JSON
curl -X POST -H "Content-Type: application/json" -d '{"user":"admin"}' https://api.com/login

# Salvar arquivo
curl -O https://site.com/arquivo.txt
curl -o saida.txt https://site.com/arquivo.txt

# Autenticacao
curl -u usuario:senha https://api.com/dados

# Seguir redirects
curl -L https://bit.ly/xyz

# Cookie
curl -b cookies.txt -c cookies.txt https://site.com
```

---

## wget — Baixar Arquivos

```bash
# Download basico
wget https://site.com/arquivo.txt

# Salvar com outro nome
wget -O saida.txt https://site.com/arquivo.txt

# Download em background
wget -b https://site.com/large-file.zip

# Espelhar site inteiro
wget -m -k -p https://site.com

# Continue download interrompido
wget -c https://site.com/large-file.zip
```

---

## whois — Informacoes de Dominio

```bash
# Instalar
sudo apt install whois

# Consultar dominio
whois google.com
# Domain Name: GOOGLE.COM
# Registrar: MarkMonitor Inc.
# Creation Date: 1997-09-15

# Consultar por IP
whois 8.8.8.8
# NetRange: 8.8.8.0 - 8.8.8.255
# NetName: GOOGLE
```

---

## host — DNS Rapido

```bash
host google.com             # IP do dominio
host -t MX gmail.com        # Servidores de email
host -t NS google.com       # Servidores DNS
```

---

## ip route — Roteamento

```bash
ip route show               # Tabela de roteamento
ip route get 8.8.8.8        # Rota ate um destino
```

---

## arp — Tabela ARP

```bash
arp -a                      # Tabela ARP
ip neigh                    # Versao moderna
```

---

## Nmap — O Mais Importante

> Aqui so o basico. No Modulo 01 voce vai dominar.

```bash
# Scan basico
nmap 192.168.1.1

# Scan com versao
nmap -sV 192.168.1.1

# Scan agressivo
nmap -A 192.168.1.1

# Scan de rede
nmap 192.168.1.0/24

# Scan rapido
nmap -T4 192.168.1.1

# Scan silencioso (SYN)
sudo nmap -sS 192.168.1.1

# Scan UDP
nmap -sU 192.168.1.1

# Todos os portas
nmap -p- 192.168.1.1
```

---

## Exercicios Praticos

### Exercicio 1: IP

```bash
# Descubra seu IP
ip a | grep "inet "

# Descubra seu IP externo
curl ifconfig.me
```

### Exercicio 2: DNS

```bash
# Resolva google.com
dig google.com +short

# Encontre servidores de email do gmail
dig MX gmail.com +short
```

### Exercicio 3: Portas

```bash
# Veja portas abertas no seu computador
ss -tlnp

# Veja quem esta usando a porta 22
lsof -i :22
```

### Exercicio 4: HTTP

```bash
# Headers de um site
curl -I https://example.com

# Baixe um arquivo
wget -O /tmp/teste.txt https://example.com/
```

### Exercicio 5: Nmap

```bash
# Scan basico no localhost
nmap localhost

# Scan com deteccao de versao
nmap -sV localhost
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Descobrir seu IP com `ip a`
- [ ] Testar conectividade com `ping`
- [ ] Resolver DNS com `dig` e `nslookup`
- [ ] Ver portas abertas com `ss -tlnp`
- [ ] Fazer requests HTTP com `curl`
- [ ] Baixar arquivos com `wget`
- [ ] Consultar dominios com `whois`
- [ ] Fazer scan basico com `nmap`

---

<div align="center">

**⬅️ [Anterior: Pipes](06-pipes-e-redirecionamento.md)** | **[Proximo: Bash Basico](08-bash-scripting-basico.md) ➡️**

</div>
