## Módulo 08: Resposta a Incidentes

### Labs Existentes (LABS.md)

| # | Lab | Plataforma | URL | Status Validação |
|---|-----|-----------|-----|-----------------|
| 1 | Preservação de Evidências | Local (Kali) | https://cyberdefenders.org/ | ✅ Ativo |
| 2 | Análise de Memória com Volatility | TryHackMe | https://tryhackme.com/room/volatility | ⏳ Pendente validação |
| 3 | Timeline com Plaso | Local (Kali) | https://cyberdefenders.org/ | ✅ Ativo |
| 4 | Análise com Autopsy | Local (Kali) | https://digitalcorps.ssu.edu/autopsy-training/ | ⏳ Pendente validação |
| 5 | Detecção de Malware com Yara | Local (Kali) | https://yara.readthedocs.io/ | ✅ Ativo |
| 6 | Investigação Completa (Final) | Local (Kali) | https://cyberdefenders.org/ | ✅ Ativo |

**Resumo existente:** 6 exercícios, maioria labs locais. Ferramentas: dd/ewfmount, Volatility 3, Plaso, Autopsy, YARA. **Forte em:** ferramentas forenses reais. **Fraqueza:** poucos labs em plataformas interativas.

### Labs Candidatos Novos

| # | Lab | Plataforma | URL | Tópico Coberto | Status Validação |
|---|-----|-----------|-----|---------------|-----------------|
| 1 | Forensics | TryHackMe | https://tryhackme.com/room/forensics | Análise forense de memória | ⏳ Pendente (rate-limit) |
| 2 | Volatility Essentials | TryHackMe | https://tryhackme.com/room/volatilityessentials | Volatility 3 completo | ⏳ Pendente (rate-limit) |
| 3 | Memory Forensics | TryHackMe | https://tryhackme.com/room/memoryforensics | Análise de memória avançada | ⏳ Pendente (rate-limit) |
| 4 | Autopsy | TryHackMe | https://tryhackme.com/room/autopsy | Autopsy GUI forensics | ⏳ Pendente (rate-limit) |
| 5 | Disk Analysis & Autopsy | TryHackMe | https://tryhackme.com/room/diskanalysisautopsy | Análise de disco com Autopsy | ⏳ Pendente (rate-limit) |
| 6 | Redline | TryHackMe | https://tryhackme.com/room/redline | Memory analysis com Redline | ⏳ Pendente (rate-limit) |
| 7 | Windows Forensics 1 | TryHackMe | https://tryhackme.com/room/windowsforensics1 | Forensics Windows básico | ⏳ Pendente (rate-limit) |
| 8 | Windows Forensics 2 | TryHackMe | https://tryhackme.com/room/windowsforensics2 | Forensics Windows avançado | ⏳ Pendente (rate-limit) |
| 9 | Forensics (40+ challenges) | PicoCTF | https://play.picoctf.org/practice | Steganography, file analysis, memory | ⚠️ Redirect (403 bot detection) |
| 10 | Blue Team Labs (forensics) | CyberDefenders | https://cyberdefenders.org/ | Labs forenses gratuitos | ✅ Ativo |
| 11 | Starting Point (forensics) | HackTheBox | https://app.hackthebox.com/starting-point | Cenários forenses guiados | ✅ Ativo |

### Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|--------|-------------|-----------|---------------|
| Disk forensics (ntfs, ext4 analysis) | Security+ Domain 4 | Crítico | 28% do exame — forensics é essencial |
| Log analysis (Windows Event Logs) | Security+ Domain 4 | Crítico | Fundamento de resposta a incidentes |
| Memory acquisition (live forensics) | OSCP (indireto) | Importante | Coleta de evidências em sistemas ativos |
| Network forensics (pcap analysis) | Security+ Domain 3 | Importante | Correlação com módulo 06 |
| Malware analysis (static/dynamic) | CEH Module 07 | Crítico | Módulo 07 do CEH não coberto no curso |
| Chain of custody procedures | Security+ Domain 4 | Importante | Processo legal de evidências |
| IOC documentation | Security+ Domain 4 | Importante | Indicadores de comprometimento |

### Resumo

- **Labs existentes:** 6 (locais + THM + CyberDefenders)
- **Labs candidatos novos:** 11 (8 THM, 1 PicoCTF, 1 CyberDefenders, 1 HTB)
- **Total potencial:** 17 labs
- **Plataforma mais forte:** TryHackMe (8 rooms de forensics)
- **Força do módulo:** Labs locais com ferramentas reais (Volatility, Autopsy, YARA, Plaso)
- **Gaps críticos:** Disk forensics, Windows Event Logs, Malware analysis
- **Observação:** CyberDefenders.org é plataforma gratuita complementar excelentepara labs forenses
