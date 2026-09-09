# 📍 Endereçamento IP

> **IP** é o "endereço" de cada dispositivo na rede. É como o CEP da sua casa — sem ele, o carteiro (dados) não sabe onde entregar.

## 📚 O que é Endereçamento IP?

O **endereçamento IP** é o sistema de identificação único de cada dispositivo conectado a uma rede. Cada computador, servidor ou dispositivo recebe um número exclusivo (o IP) que permite que outros dispositivos o encontrem e se comuniquem com ele.

### Por que isso é importante?

- **Todo ataque começa com um IP** — para atacar alguém, você precisa saber o endereço dele
- **IPs revelam localização** — geolocalização, ISP, provedor
- **Rastreamento de atacantes** — OSINT, logs, forense digital
- **Firewalls filtram por IP** — bloquear ou permitir acesso

### Como funciona na prática?

```
Seu PC (192.168.1.10)              Servidor (142.250.74.46)
       │                                    │
       │  "Quero acessar google.com"        │
       │  ───────────────────────────→      │
       │                                    │
       │  Resposta: "Aqui está!"            │
       │  ←───────────────────────────      │
```

Para entender endereçamento IP, você precisa dominar:
- **Classes de IP** (A, B, C, D, E)
- **Máscara de sub-rede** (onde termina a rede)
- **CIDR** (notação simplificada)
- **IP público vs privado** (quem está na internet)

---

## 🏠 Analogia

```
Seu computador: 192.168.1.105
                ↑    ↑    ↑   ↑
                |    |    |   └── Número do dispositivo
                |    |    └────── Rede local
                |    └─────────── Sub-rede
                └──────────────── Rede maior
```

**É como um endereço postal:**
- País → Estado → Cidade → Rua → Número

---

## 🔢 O que é um IP?

Um IP é um número composto por **4 octetos** (0-255), separados por pontos:

```
192.168.1.105

Cada octeto vai de 0 a 255
Mínimo: 0.0.0.0
Máximo: 255.255.255.255
```

---

## 📊 Classes de IP

| Classe | Faixa | Uso | Rede/Host |
|:-------|:------|:----|:----------|
| **A** | 1.0.0.0 a 126.255.255.255 | Redes grandes | 1 octeto rede, 3 hosts |
| **B** | 128.0.0.0 a 191.255.255.255 | Redes médias | 2 octetos rede, 2 hosts |
| **C** | 192.0.0.0 a 223.255.255.255 | Redes pequenas | 3 octetos rede, 1 host |

### IPs Especiais

| IP | O que é |
|:---|:--------|
| `127.0.0.1` | Localhost (seu próprio computador) |
| `192.168.x.x` | Rede privada (casa, escritório) |
| `10.x.x.x` | Rede privada (empresas) |
| `172.16.x.x a 172.31.x.x` | Rede privada |
| `0.0.0.0` | Todos os endereços |
| `255.255.255.255` | Broadcast (todos os dispositivos) |

---

## 🎭 Máscara de Sub-rede

A máscara define **qual parte do IP é a rede** e qual é o **host**:

```
IP:        192.168.1.105
Máscara:   255.255.255.0
           ──────────────
           Rede   | Host
           (fixo) | (variável)
```

### CIDR (notação moderna)

Em vez de escrever `255.255.255.0`, usamos `/24`:

| CIDR | Máscara | hosts disponíveis |
|:-----|:--------|:------------------|
| /8 | 255.0.0.0 | 16.7 milhões |
| /16 | 255.255.0.0 | 65.534 |
| /24 | 255.255.255.0 | 254 |
| /30 | 255.255.255.252 | 2 |

---

## 🔧 Comandos Práticos

### Ver seu IP
```bash
# Linux
ip addr show

# Windows
ipconfig
```

### Ver IP público (o que a internet vê)
```bash
curl ifconfig.me
# Ou:
curl icanhazip.com
```

### Testar conectividade
```bash
# Ping para verificar se o IP responde
ping 192.168.1.1

# Ping para IP público
ping 8.8.8.8

# Ping para domínio (usa DNS)
ping google.com
```

---

## 🧮 Exercício Prático

1. Abra o terminal
2. Execute `ip addr show`
3. Identifique:
   - Qual é o seu IP?
   - Qual é a máscara?
   - Qual é o gateway?

---

## 💡 Dicas

> **192.168.x.x** é sempre rede privada — nunca é acessível direto da internet

> **127.0.0.1** é sempre você mesmo — testar serviços locais

> **8.8.8.8** é o DNS do Google — útil para testar internet

---

## ✅ Checkpoint

- [ ] Consigo explicar o que é um IP
- [ ] Sei a diferença entre IP público e privado
- [ ] Consigo usar `ip addr show`
- [ ] Entendo o que é uma máscara de sub-rede

---

<div align="center">

**⬅️ [Anterior: O que é uma Rede](../01-redes/01-o-que-e-uma-rede.md)** | **[Próximo: DNS](../01-redes/03-dns.md) ➡️**

</div>
