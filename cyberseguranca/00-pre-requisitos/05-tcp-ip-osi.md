# 📐 Modelo TCP/IP e OSI

> São **mapas** que mostram como os dados viajam pela internet. É como entender as camadas de uma onion (cebola) — cada camada tem uma função.

## 📚 O que são os Modelos TCP/IP e OSI?

São **modelos de referência** que dividem a comunicação de rede em camadas. Cada camada tem uma função específica e se comunica com as camadas adjacentes.

### Por que isso é importante?

- **Ataques acontecem em camadas específicas** — entender ajuda a saber onde atacar/defender
- **Firewalls operam em camadas diferentes** — Layer 3 (IP), Layer 4 (TCP/UDP), Layer 7 (HTTP)
- **Troubleshooting** — saber em qual camada está o problema acelera o diagnóstico
- **Ferramentas atacam camadas específicas** — Wireshark (L2-4), Burp (L7), Nmap (L3-4)

### Como funciona na prática?

```
Camada 7: Aplicação      → HTTP, DNS, FTP, SMTP
Camada 6: Apresentação   → TLS/SSL, criptografia
Camada 5: Sessão         → Sessões de conexão
Camada 4: Transporte     → TCP (confiável), UDP (rápido)
Camada 3: Rede           → IP, roteamento
Camada 2: Enlace         → MAC, switches
Camada 1: Física         → Cabos, sinais elétricos
```

Para entender os modelos, você precisa dominar:
- **TCP/IP (4 camadas)** — modelo real da internet
- **OSI (7 camadas)** — modelo de referência
- **Três vias do TCP** — handshake, transmissão, encerramento
- **Em qual camada cada ferramenta opera**

---

## 🧅 Analogia da Cebola

Imagine enviar uma carta:

```
Você escreve a carta (DADOS)
        ↓
Coloca em envelope (TCP/UDP)
        ↓
Coloca endereço no envelope (IP)
        ↓
Coloca no correio (Ethernet/WiFi)
        ↓
Carta chega ao destinatário!
```

Cada camada adiciona informações (como endereço, número de sequência, etc.)

---

## 📊 Modelo TCP/IP (4 camadas - o que se usa na prática)

| Camada | Nome | Função | Exemplo |
|:-------|:-----|:-------|:--------|
| 4 | **Aplicação** | O que o usuário vê | HTTP, DNS, SSH |
| 3 | **Transporte** | Entrega confiável | TCP, UDP |
| 2 | **Internet** | Endereçamento lógico | IP, ICMP |
| 1 | **Acesso à Rede** | Entrega física | Ethernet, WiFi |

---

## 📊 Modelo OSI (7 camadas - o que se estuda)

| Camada | Nome | Função | Exemplo |
|:-------|:-----|:-------|:--------|
| 7 | **Aplicação** | Interface com usuário | HTTP, FTP, DNS |
| 6 | **Apresentação** | Formatação, criptografia | TLS, SSL, JPEG |
| 5 | **Sessão** | Gerencia sessões | RPC, NetBIOS |
| 4 | **Transporte** | Entrega entre processos | TCP, UDP |
| 3 | **Rede** | Endereçamento lógico | IP, ICMP, Router |
| 2 | **Enlace** | Endereço físico | MAC, Switch |
| 1 | **Física** | Bits no cabo | Cabos, WiFi |

---

## 🔄 Como os dados viajam

```
ENVIANDO:
Camada 7 (Aplicação)  → Dados: "GET /index.html"
        ↓
Camada 4 (Transporte) → + Porta: "src:1234, dst:80"
        ↓
Camada 3 (Rede)       → + IP: "src:192.168.1.1, dst:142.250.74.46"
        ↓
Camada 2 (Enlace)     → + MAC: "src:aa:bb:cc:dd:ee:ff"
        ↓
Camada 1 (Física)     → Bits: 010101010101...

RECEBENDO:
Bits → MAC → IP → Porta → Dados (ordem reversa)
```

---

## 🎯 Qual camada cada ferramenta ataca?

| Ferramenta | Camada OSI | O que faz |
|:-----------|:----------:|:----------|
| **Hub** | 1 (Física) | Repete sinal para todos |
| **Switch** | 2 (Enlace) | Filtra por MAC |
| **Router** | 3 (Rede) | Roteia por IP |
| **Firewall** | 3-4 | Filtra IP/portas |
| **Proxy** | 7 (Aplicação) | Intercepta HTTP |

---

## 💡 Dicas

> **Não precisa memorizar tudo** — saiba a função de cada camada

> **OSI é teórico, TCP/IP é prática** — TCP/IP é o que realmente roda

> **Ataques atingem camadas específicas** — XSS é Camada 7, ARP spoofing é Camada 2

---

## ✅ Checkpoint

- [ ] Consigo listar as 4 camadas do TCP/IP
- [ ] Sei em que camada opera cada protocolo
- [ ] Entendo o conceito de encapsulamento
- [ ] Consigo dizer qual camada cada ferramenta ataca

---

<div align="center">

**⬅️ [Anterior: Portas e Protocolos](04-portas-e-protocolos.md)** | **[Próximo: Linux Básico] ➡️**

</div>
