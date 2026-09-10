## Módulo 06: Análise de Rede

### Labs Existentes (LABS.md)

| # | Lab | Plataforma | URL | Status Validação |
|---|-----|-----------|-----|-----------------|
| 1 | Captura de Pacotes com tcpdump | TryHackMe | https://tryhackme.com/room/introtoshark | ⏳ Pendente validação |
| 2 | Análise com Wireshark | TryHackMe | https://tryhackme.com/room/wireshark | ⏳ Pendente validação |
| 3 | Interceptação com mitmproxy | TryHackMe | https://tryhackme.com/room/dvwa | ⚠️ Link incorreto (dvwa não é mitmproxy) |
| 4 | MITM com bettercap | TryHackMe | https://tryhackme.com/room/metasploitexploitation | ⚠️ Link incorreto (metasploit não é bettercap) |
| 5 | Proxychains e Anonimato | TryHackMe | https://tryhackme.com/room/dvwa | ⚠️ Link incorreto (dvwa não é proxychains) |
| 6 | Análise Completa de Tráfego | TryHackMe | https://tryhackme.com/room/cent | ⏳ Pendente validação |

**Resumo existente:** 6 exercícios, todos THM. Ferramentas: tcpdump, Wireshark/tshark, mitmproxy, bettercap, proxychains/tor. **Problema:** 3 links apontam para salas erradas (dvwa, metasploitexploitation).

### Labs Candidatos Novos

| # | Lab | Plataforma | URL | Tópico Coberto | Status Validação |
|---|-----|-----------|-----|---------------|-----------------|
| 1 | Wireshark: The Basics | TryHackMe | https://tryhackme.com/room/wireshark | Filtros Wireshark, análise básica | ⏳ Pendente (rate-limit) |
| 2 | Wireshark: Packet Operations | TryHackMe | https://tryhackme.com/room/wiresharkpacketoperations | Operações avançadas de pacotes | ⏳ Pendente (rate-limit) |
| 3 | TShark | TryHackMe | https://tryhackme.com/room/tshark | Análise CLI de pacotes | ⏳ Pendente (rate-limit) |
| 4 | Network Traffic Analysis | TryHackMe | https://tryhackme.com/room/roomnetworktrafficanalysis | Análise de tráfego completo | ⏳ Pendente (rate-limit) |
| 5 | Forensics (pcap) | TryHackMe | https://tryhackme.com/room/forensics | Análise forense de rede | ⏳ Pendente (rate-limit) |
| 6 | Packed Light | TryHackMe | https://tryhackme.com/room/packedlight | Análise de pcap, detecção de keylogger | ⏳ Pendente (rate-limit) |
| 7 | PCAP Analysis | TryHackMe | https://tryhackme.com/room/pcapanalysis | Análise de pcap | ⏳ Pendente (rate-limit) |
| 8 | Basic Packet Capture | TryHackMe | https://tryhackme.com/room/basicpacketcapture | Captura básica | ⏳ Pendente (rate-limit) |
| 9 | Sniff | TryHackMe | https://tryhackme.com/room/sniff | Sniffing de rede | ⏳ Pendente (rate-limit) |
| 10 | Starting Point (Network) | HackTheBox | https://app.hackthebox.com/starting-point | Máquinas guiadas de rede | ✅ Ativo |
| 11 | Forensics (packet analysis) | PicoCTF | https://play.picoctf.org/practice | Desafios CTF de análise de pacotes | ⚠️ Redirect (403 bot detection) |
| 12 | Bandit advanced | OverTheWire | ssh://bandit.labs.overthewire.org:2220 | Conceitos de rede avançados | ✅ Ativo |

### Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|--------|-------------|-----------|---------------|
| Deep packet inspection (DPI) | Security+ Domain 3 | Importante | Mencionado em monitoramento de rede |
| Netflow/sFlow analysis | Security+ Domain 3 | Importante | Fluxo de tráfego para detecção de anomalias |
| DNS analysis/profiling | CEH Module 08 | Crítico | Parte essencial de sniffing |
| Wireless packet analysis | CEH Module 08 | Importante | Análise de tráfego 802.11 |
| Encrypted traffic analysis | Security+ Domain 3 | Importante | Análise de TLS/SSL sem decodificação |
| Network forensics methodology | OSCP (indireto) | Importante | Metodologia para investigação de rede |

### Resumo

- **Labs existentes:** 6 (THM) — 3 com links incorretos que precisam ser corrigidos
- **Labs candidatos novos:** 12 (9 THM, 1 HTB, 1 PicoCTF, 1 OTW)
- **Total potencial:** 18 labs
- **Plataforma mais forte:** TryHackMe (9 rooms dedicados a análise de rede)
- **Gaps críticos:** DNS profiling, Netflow analysis
- **Ação necessária:** Corrigir 3 links errados no LABS.md existente
