# 🌐 O que é uma Rede?

> **Rede** é quando dois ou mais computadores se conectam para trocar informações. É como uma estrada que liga cidades — por onde os carros (dados) trafegam.

---

## 🏠 Analogia do Dia a Dia

Imagine sua casa:

```
┌─────────────────────────────────────────────────────┐
│                    SUA CASA                          │
│                                                      │
│   📱 Celular ─────┐                                 │
│                    │                                 │
│   💻 Notebook ─────┤─── 📡 Roteador ──── 🌐 Internet│
│                    │                                 │
│   🖥️ Desktop ──────┘                                 │
│                                                      │
└─────────────────────────────────────────────────────┘
```

- **Celular, Notebook, Desktop** = dispositivos na rede
- **Roteador** = o "gerente" que direciona o tráfego
- **Internet** = a rede mundial (a maior rede do mundo)

---

## 📋 Tipos de Rede

| Tipo | O que é | Exemplo |
|:-----|:--------|:--------|
| **PAN** | Rede pessoal (1 pessoa) | Bluetooth, smartwatch |
| **LAN** | Rede local (casa, escritório) | WiFi da sua casa |
| **WAN** | Rede ampla (cidade, país) | A internet |
| **MAN** | Rede metropolitana (cidade) | Rede da prefeitura |

---

## 🏗️ Componentes de uma Rede

### Dispositivos

| Dispositivo | O que faz | Analogia |
|:------------|:----------|:---------|
| **Computador** | Envia e recebe dados | Carro na estrada |
| **Roteador** | Conecta redes diferentes | Semáforo que direciona |
| **Switch** | Conecta dispositivos na mesma rede | Distribuidor de fluxo |
| **Modem** | Conecta sua casa à internet | Portão de entrada |
| **Firewall** | Filtra tráfego (bloqueia/libera | Segurança do portão |

### Meios de Transmissão

| Meio | O que é | Velocidade |
|:-----|:--------|:-----------|
| **Cabo UTP** | Cabo de rede (RJ45) | Rápido e estável |
| **Fibra óptica** | Luz via cabo de vidro | Muito rápido |
| **WiFi** | Sem fio (rádio) | Variável |
| **Bluetooth** | Curto alcance | Lento |

---

## 🔧 Comandos Práticos

### Ver sua rede (Linux)
```bash
# Ver endereço IP da sua interface
ip addr show

# Saída exemplo:
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP>
#     inet 192.168.1.105/24 brd 192.168.1.255 scope global eth0
#     ether aa:bb:cc:dd:ee:ff txqueuelen 1000
```

### Ver sua rede (Windows)
```cmd
# No Prompt de Comando:
ipconfig

# Saída exemplo:
# IPv4 Address. . . . . . . . . : 192.168.1.105
# Subnet Mask . . . . . . . . . : 255.255.255.0
# Default Gateway . . . . . . . : 192.168.1.1
```

### Testar conectividade
```bash
# Ver se um servidor está no ar
ping 8.8.8.8

# Saída:
# 64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=12.3 ms
# 64 bytes from 8.8.8.8: icmp_seq=2 ttl=117 time=11.8 ms

# Ctrl+C para parar
```

### Ver rota até um destino
```bash
# Linux
traceroute google.com

# Windows
tracert google.com
```

---

## 💡 Dicas Importantes

> **Todo dispositivo na rede tem um endereço IP** — sem ele, não existe comunicação

> **Roteador é o ponto único de saída** — tudo passa por ele

> **Firewall é opcional mas recomendado** — decide o que entra e sai

---

## ✅ Checkpoint

Antes de ir para o próximo arquivo, você deve conseguir:

- [ ] Explicar o que é uma rede
- [ ] Listar 3 tipos de rede
- [ ] Diferenciar roteador e switch
- [ ] Rodar `ip addr show` e entender a saída

---

<div align="center">

**⬅️ [Voltar ao README](README.md)** | **[Próximo: Endereçamento IP] ➡️**

</div>
