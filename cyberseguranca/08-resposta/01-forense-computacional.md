# 🕵️ Forense Computacional

> Investigação pós-incidente: disco, memória, rede e timeline.

---

## Instalação das Ferramentas

```bash
sudo apt install -y autopsy sleuthkit volatility3 ewf-tools plaso
```

---

## 🚀 Passo a Passo

### Passo 1: Criar imagem forense (preservação)
```bash
# Imagem bit-a-bit com hash
sudo dd if=/dev/sda of=/evidencia/disco.img bs=4M status=progress
sha256sum /dev/sda > disco.sha256
sha256sum /evidencia/disco.img >> disco.sha256
# Verificar
sha256sum -c disco.sha256

# Formato EWF (EnCase) com ewf-tools
sudo apt install -y ewf-tools
sudo ewfacquire /dev/sda -t caso001
```

### Passo 2: Análise de disco (Autopsy / SleuthKit)
```bash
sudo apt install -y sleuthkit autopsy
# Autopsy web em http://localhost:9999
sudo autopsy

# Linha de comando:
fls -r -m / caso001.E01 | mactime -d > timeline.csv
ils caso001.E01
icat caso001.E01 12345 > arquivo_recuperado
```

### Passo 3: Timeline (Plaso / log2timeline)
```bash
sudo apt install -y plaso
log2timeline.py timeline.plaso /evidencia/disco.img
psort.py -o dynamic timeline.plaso > timeline.csv
# Filtrar por data do incidente
grep "2024-01-15" timeline.csv
```

### Passo 4: Memória (Volatility 3)
```bash
sudo apt install -y volatility3
vol -f memoria.raw windows.info
vol -f memoria.raw windows.pslist
vol -f memoria.raw windows.netscan
vol -f memoria.raw windows.malfind
vol -f memoria.raw windows.hashdump
# Dump de processo suspeito
vol -f memoria.raw windows.pslist --pid 1234 --dump
```

### Passo 5: Rede (Wireshark + Network Forense)
```bash
tshark -r captura.pcap -Y "http contains password" -T fields -e http.file_data
bulk_extractor -o bulk_out captura.pcap
```

---

## Ferramentas

| Ferramenta | Para quê |
|:---|:---|
| **autopsy** | GUI forense completa (disco, timeline, carving) |
| **sleuthkit (fls, icat)** | Análise de filesystem |
| **volatility3** | Análise de memória RAM |
| **plaso** | Super timeline |
| **bulk_extractor** | Extrair emails, URLs, CCs de imagem |
| **ewf-tools** | Formato forense EWF |

## Cadeia de Custódia — Checklist

- [ ] Hash SHA256 antes e depois
- [ ] Lacre físico + termo de apreensão
- [ ] Log de quem acessou (data, hora, ação)
- [ ] Cópia de trabalho, original preservado

## Lab Prático

1. **TryHackMe — Forensics: Basics** — Crie imagens forense com `dd`, analise com Autopsy/SleuthKit e recupere arquivos deletados.
   - https://tryhackme.com/room/forensicsbasics
2. **TryHackMe — Volatility** — Analise dumps de memória com Volatility 3, identifique processos maliciosos e extraia artefatos de rede.
   - https://tryhackme.com/room/volatility
3. **NIST CFReDS** — Casos reais de forense digital com evidências para praticar cadeia de custódia e timeline analysis.
   - https://cfreds.nist.gov
