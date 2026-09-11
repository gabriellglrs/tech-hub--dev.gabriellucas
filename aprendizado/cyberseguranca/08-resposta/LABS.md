# Labs de Resposta a Incidentes

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Volatility 3, Autopsy, Sleuth Kit |
| Módulos 1-6 | ⭐⭐⭐ | Conhecimento prévio de ataque e rede |
| Linux básico | ⭐ | dd, mount, hash |

---

## Labs por Plataforma

### TryHackMe (8 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Forensics | Análise forense básica, dd, Autopsy | ⭐⭐ | https://tryhackme.com/room/forensics |
| 2 | Volatility Essentials | Volatility 3, análise de memória | ⭐⭐ | https://tryhackme.com/room/volatilityessentials |
| 3 | Memory Forensics | RAM forensics avançado | ⭐⭐⭐ | https://tryhackme.com/room/memoryforensics |
| 4 | Autopsy | Autopsy GUI, disk analysis | ⭐⭐ | https://tryhackme.com/room/autopsy |
| 5 | Disk Analysis & Autopsy | Análise de disco completa | ⭐⭐ | https://tryhackme.com/room/diskanalysisautopsy |
| 6 | Redline | Forensics com Redline | ⭐⭐⭐ | https://tryhackme.com/room/redline |
| 7 | Windows Forensics 1 | Windows event logs, registry | ⭐⭐ | https://tryhackme.com/room/windowsforensics1 |
| 8 | Windows Forensics 2 | Windows forensics avançado | ⭐⭐⭐ | https://tryhackme.com/room/windowsforensics2 |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### CyberDefenders (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 9 | Blue Team Labs | Forensics, malware analysis, OSINT | ⭐-⭐⭐⭐ | https://cyberdefenders.org/ |

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 10 | Starting Point (forensics) | Forensics básico | ⭐⭐ | https://app.hackthebox.com/starting-point |

### PicoCTF (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 11 | Forensics (40+ challenges) | Forensics geral | ⭐-⭐⭐⭐⭐ | https://play.picoctf.org/practice |

> **Nota:** PicoCTF pode redirecionar — verifique se o link está ativo.

### Prática Local (6 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 12 | dd imagem forense | Criar imagem bit-a-bit | ⭐⭐ | `sudo dd if=/dev/sda of=disk.img bs=4M status=progress` |
| 13 | Volatility pslist | Listar processos na memória | ⭐⭐ | `vol -f memoria.raw windows.pslist` |
| 14 | YARA scan | Identificar padrões de malware | ⭐⭐⭐ | `yara -r rules/ suspicious_file` |
| 15 | SleuthKit fls | Listar arquivos no disco | ⭐⭐ | `fls -r -m / evidence.E01` |
| 16 | bulk_extractor | Extrair emails/URLs de imagem | ⭐⭐ | `bulk_extractor -o bulk_out disk.img` |
| 17 | Plaso timeline | Criar linha do tempo | ⭐⭐⭐ | `log2timeline.py timeline.plaso disk.img` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 8 | Forensics, Volatility, Autopsy, Windows |
| CyberDefenders | 1 | Blue team labs |
| HackTheBox | 1 | Starting point forensics |
| PicoCTF | 1 | Forensics challenges |
| Local | 6 | dd, Volatility, YARA, SleuthKit, Plaso |
| **Total** | **17** | |
