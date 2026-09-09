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

### Resumo da ordem — Por que essa sequência?

Forense segue: **preservar → coletar → analisar → reportar**.

```
PASSO 1: Preservar evidências → Não alterar o estado original
├── POR QUE: Evidências contaminadas são inadmissíveis
├── O QUE FAZER: Fazer imagem bit-a-bit do disco/memória
├── COMANDO: sudo dd if=/dev/sda of=disk.img bs=4M
├── QUANDO AVANÇAR: Quando tiver imagem segura
└── DICAS: Trabalhe sempre em cópia, nunca no original

        ↓

PASSO 2: Montar evidências → Acessar dados sem alterar
├── POR QUE: Montar diretamente altera timestamps
├── O QUE FAZER: Usar mount -o loop,ro (read-only) ou ewfmount
├── COMANDO: sudo ewfmount evidence.E01 /mnt/evidence
├── QUANDO AVANÇAR: Quando tiver acesso aos dados
└── DICAS: Verifique integridade com hash: md5sum disk.img

        ↓

PASSO 3: Timeline → Criar linha do tempo
├── POR QUE: Timeline revela sequência de eventos
├── O QUE FAZER: Usar Plaso ou log2timeline
├── COMANDO: log2timeline.py timeline.plaso disk.img
├── QUANDO AVANÇAR: quando tiver timeline gerada
└── DICAS: Foque em horários de atividade suspeita

        ↓

PASSO 4: Carregamento de memória → Analisar RAM
├── POR QUE: Muitos dados ficam só na memória (senhas, chaves)
├── O QUE FAZER: Usar Volatility3
├── COMANDO: volatility3 -f mem.raw windows.pslist
├── QUANDO AVANÇAR: Quando tiver lista de processos
└── DICAS: Procure por processos estranhos, conexões de rede

        ↓

PASSO 5: Analisar malware → Entender o que foi encontrado
├── POR QUE: Precisa saber se é malicioso e como funciona
├── O QUE FAZER: Usar Ghidra (estático), REMnux/Cuckoo (dinâmico)
├── COMANDO: yara -r rules/ suspicious_file
├── QUANDO PARAR: Quando tiver relatório completo
└── ÉTICA: Não execute malware em produção!
```

---

## Lab Prático

1. **TryHackMe — Forensics: Basics** — Crie imagens forense com `dd`, analise com Autopsy/SleuthKit e recupere arquivos deletados.
   - https://tryhackme.com/room/forensicsbasics
2. **TryHackMe — Volatility** — Analise dumps de memória com Volatility 3, identifique processos maliciosos e extraia artefatos de rede.
   - https://tryhackme.com/room/volatility
3. **NIST CFReDS** — Casos reais de forense digital com evidências para praticar cadeia de custódia e timeline analysis.
   - https://cfreds.nist.gov
