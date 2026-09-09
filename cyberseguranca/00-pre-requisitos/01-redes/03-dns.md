# 🌍 DNS (Domain Name System)

> **DNS** é como uma agenda telefônica da internet. Em vez de decorar números (IPs), você digita nomes (google.com) e o DNS traduz.

## 📚 O que é DNS?

**DNS (Domain Name System)** é o sistema que traduz nomes de domínio (google.com) em endereços IP (142.250.74.46). Sem DNS, você precisaria decorar o IP de cada site que quer visitar.

### Por que isso é importante?

- **Spoofing DNS** — atacante redireciona sites para servidores maliciosos
- **Reconhecimento** — descobrir subdomínios e infraestrutura do alvo
- **Exfiltração** — dados podem ser escondidos em consultas DNS
- **Tunneling** — criar túneis de comunicação através do DNS

### Como funciona na prática?

```
Você digita: google.com
        ↓
Seu PC pergunta: "Qual o IP do google.com?"
        ↓
DNS respondente: "142.250.74.46"
        ↓
Você acessa o site usando o IP
```

Para entender DNS, você precisa dominar:
- **Tipos de registros** (A, AAAA, MX, NS, TXT, CNAME)
- **Consultas** (dig, nslookup, host)
- **Enumeração de subdomínios**
- **Ataques DNS** (cache poisoning, tunneling)

---

## 🏠 Analogia

Imagine que você quer ligar para a Padaria da Maria:

```
SEM DNS (o horror):
┌──────────────────────────────────────────┐
│ Você: "Quero ligar pro 11998765432"      │
│ (Tem que decorar o número de cada loja)  │
└──────────────────────────────────────────┘

COM DNS (a graça):
┌──────────────────────────────────────────┐
│ Você: "Quero ligar pra Padaria da Maria" │
│ DNS: "O número é 11998765432"            │
│ (Só precisa saber o nome)                │
└──────────────────────────────────────────┘
```

---

## 🔧 Como funciona na prática?

Quando você digita `google.com` no navegador:

```
Passo 1: Seu computador pergunta ao DNS
         "Qual o IP do google.com?"

Passo 2: DNS responde
         "O IP é 142.250.74.46"

Passo 3: Seu computador conecta ao IP
         "Conectando a 142.250.74.46..."

Passo 4: Site carrega!
```

---

## 📊 Tipos de Registro DNS

| Registro | O que faz | Exemplo |
|:---------|:----------|:--------|
| **A** | Nome → IPv4 | google.com → 142.250.74.46 |
| **AAAA** | Nome → IPv6 | google.com → 2a00:1450:4001:... |
| **CNAME** | Nome → Outro nome | www.google.com → google.com |
| **MX** | Servidor de email | google.com → smtp.google.com |
| **NS** | Name servers | google.com → ns1.google.com |
| **TXT** | Texto (verificação) | SPF, DKIM |

---

## 🔧 Comandos Práticos

### Consultar DNS (Linux/Mac)
```bash
# Ver IP de um domínio
dig google.com

# Saída simplificada
dig +short google.com
# 142.250.74.46

# Ver registros MX (email)
dig google.com MX

# Ver registros NS (name servers)
dig google.com NS

# Usar DNS específico
dig @8.8.8.8 google.com
```

### Consultar DNS (Windows)
```cmd
# Ver IP de um domínio
nslookup google.com

# Saída:
# Server:  dns.google
# Address:  8.8.8.8
# Non-authoritative answer:
# Name:    google.com
# Address:  142.250.74.46
```

### Testar DNS
```bash
# Ver se DNS está funcionando
nslookup google.com 8.8.8.8

# Se funcionar, retorna IP
# Se não funcionar, erro de timeout
```

---

## 📋 DNS Servers Conhecidos

| Provedor | IP |
|:---------|:---|
| Google | 8.8.8.8 e 8.8.4.4 |
| Cloudflare | 1.1.1.1 e 1.0.0.1 |
| OpenDNS | 208.67.222.222 |
| Quad9 | 9.9.9.9 |

---

## 🔐 DNS e Segurança

DNS é frequentemente atacado:

| Ataque | O que faz | Consequência |
|:-------|:----------|:-------------|
| **DNS Spoofing** | IP falso | Você vai pro site errado |
| **DNS Cache Poisoning** | Envenena cache | Redireciona para malicioso |
| **DNS Tunneling** | Esconde dados no DNS | Exfiltração de dados |

---

## ✅ Checkpoint

- [ ] Consigo explicar o que é DNS
- [ ] Sei a diferença entre A, MX e NS
- [ ] Consigo usar `dig` e `nslookup`
- [ ] Entendo por que DNS é importante em segurança

---

<div align="center">

**⬅️ [Anterior: Endereçamento IP](../01-redes/02-enderecamento-ip.md)** | **[Próximo: Portas e Protocolos](../01-redes/04-portas-e-protocolos.md) ➡️**

</div>
