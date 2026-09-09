# 🌐 Comandos de Rede Essenciais

> Estes são os comandos que você vai usar **o tempo todo** em cybersegurança. Memorize-os — eles são sua ferramenta de diagnóstico.

---

## 📚 O que são comandos de rede?

São ferramentas no terminal que mostram informações sobre a conexão de rede do seu computador. Com eles você descobre seu IP, testa conexões, verifica portas abertas e diagnostica problemas.

### Por que isso é importante?

- **Todo hacker começa com diagnóstico** — antes de atacar, você precisa entender a rede
- **Firewalls bloqueiam por IP/porta** — você precisa saber o que está aberto
- **Problemas de rede** são os mais comuns — saber diagnosticar salva horas
- **Logs mostram IPs** — identificar origem de ataques

### Como funciona na prática?

```bash
# Seu computador
├── ip a              → "Qual meu IP?"
├── ping 8.8.8.8      → "Estou conectado?"
├── nslookup google.com → "Qual o IP do google?"
├── netstat -tlnp     → "Quais portas estão abertas?"
└── ss -tlnp          → "Versão moderna do netstat"
```

---

## 📋 Comandos por Categoria

### 🔍 Descobrir informações

```bash
# Meu endereço IP
ip a                    # Linux (recomendado)
ifconfig                # Linux (antigo, ainda funciona)
ipconfig                # Windows

# Informações detalhadas da rede
ip addr show            # Detalhes da interface
ip route show           # Tabela de roteamento
cat /etc/resolv.conf    # Servidores DNS configurados
```

### 🏓 Testar conectividade

```bash
# Testar se um host está acessível
ping 8.8.8.8            # Google DNS
ping google.com         # Testar resolução DNS

# Trace route (caminho até o destino)
traceroute google.com   # Linux
tracert google.com      # Windows

# Testar porta específica
ping -c 4 192.168.1.1  # Enviamos 4 pacotes
```

### 🌐 Resolução DNS

```bash
# Descobrir IP de um domínio
nslookup google.com     # Formato simples
dig google.com          # Formato detalhado
host google.com         # Formato curto

# Tipos de consulta
dig MX gmail.com        # Servidores de email
dig NS google.com       # Servidores DNS
dig TXT google.com      # Registros TXT
```

### 📊 Ver conexões e portas

```bash
# Portas abertas no seu computador
netstat -tlnp           # TCP listening
netstat -ulnp           # UDP listening
ss -tlnp                # Versão moderna (recomendado)

# Conexões ativas
netstat -tunp           # Todas as conexões TCP/UDP
ss -tunp                # Versão moderna

# Processo usando uma porta
lsof -i :80             # Quem está usando porta 80?
fuser 80/tcp            # PID do processo na porta 80
```

---

## 🎯 Exercícios Práticos

### Exercício 1: Descubra seu IP
```bash
ip a | grep "inet "     # Mostra IPs das interfaces
```

### Exercício 2: Teste seu DNS
```bash
nslookup github.com
# Anote o IP retornado
ping -c 3 <IP_retornado>
```

### Exercício 3: Veja portas abertas
```bash
ss -tlnp
# Identifique: porta 22 (SSH), porta 80 (HTTP), porta 443 (HTTPS)
```

### Exercício 4: Trace a rota
```bash
traceroute google.com
# Veja quantos saltos até o Google
```

---

## 💡 Macetes

| Comando | Dica |
|:--------|:-----|
| `ip a` | Use em vez de `ifconfig` (é o padrão novo) |
| `ss` | Use em vez de `netstat` (é mais rápido) |
| `dig` | Use em vez de `nslookup` (mais detalhes) |
| `ping -c 4` | Use `-c` para limitar pacotes no Linux |

---

## ✅ Checkpoint

- [ ] Consigo descobrir meu IP com `ip a`
- [ ] Consigo testar conexão com `ping`
- [ ] Consigo resolver DNS com `nslookup` ou `dig`
- [ ] Consigo ver portas abertas com `ss -tlnp`
- [ ] Consigo ver quem usa uma porta com `lsof -i :PORTA`

---

<div align="center">

**⬅️ [Anterior: Windows Básico](11-windows-basico.md)** | **[Próximo: Editores de Texto] ➡️**

</div>
