# 🔍 Módulo 8: Labs de Resposta a Incidentes

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Linux intermediário | ⭐⭐⭐ | Comandos avançados, permissões, processos |
| Conceitos de segurança | ⭐⭐ | Tipos de ataques, indicadores de comprometimento |
| Redes básicas | ⭐⭐ | TCP/IP, sockets, tráfego de rede |
| Análise forense | ⭐ | Conceitos básicos de preservação de evidências |
| Python básico | ⭐ | Útil para scripts de análise |

---

## Exercício 1: Preservação de Evidências

**Tempo estimado:** 30 min

**Objetivo:** Criar imagens forenses de disco e memória, preservando a integridade das evidências para análise posterior.

**Conhecimentos envolvidos:**
- Cópia bit-a-bit
- Write blockers
- Cadeia de custódia
- Hashes de integridade

**Ferramentas:**
- dd
- ewfmount
- md5sum / sha256sum

**Passo a passo:**

```bash
# 1. Criar partição de teste (simular evidência)
sudo dd if=/dev/zero of=/tmp/teste evidencia.img bs=1M count=100
sudo mkfs.ext4 /tmp/teste evidencia.img
mkdir -p /mnt/evidencia
sudo mount /tmp/teste evidencia.img /mnt/evidencia

# 2. Colocar dados de teste
echo "Evidência importante" | sudo tee /mnt/evidencia/arquivo_secreto.txt
echo "Logs de sistema" | sudo tee /mnt/evidencia/logs.txt
sudo umount /mnt/evidencia

# 3. Calcular hash da evidência original
md5sum /tmp/teste evidencia.img
sha256sum /tmp/teste evidencia.img

# 4. Criar imagem forense bit-a-bit
sudo dd if=/dev/sda of=/tmp/disk_image.dd bs=4M status=progress
# OU para partição específica:
sudo dd if=/dev/sda1 of=/tmp/partition.dd bs=4M status=progress

# 5. Criar imagem E01 (formato forense padrão)
# Instalar ewf-tools
sudo apt install -y ewf-tools
ewfexport /tmp/disk_image.dd -t /tmp/evidencia -f ewf -u

# 6. Montar imagem E01 para verificação
sudo ewfmount /tmp/evidencia.E01 /mnt/evidencia

# 7. Calcular hash da cópia
md5sum /mnt/evidencia/ewf1
sha256sum /mnt/evidencia/ewf1

# 8. Verificar integridade
echo "Original: $(md5sum /tmp/disk_image.dd)"
echo "Cópia:   $(md5sum /mnt/evidencia/ewf1)"

# 9. Documentar cadeia de custódia
cat > /tmp/cadeia_custodia.txt << EOF
Data: $(date)
Analista: $(whoami)
Evidência: /dev/sda
Hash MD5: $(md5sum /dev/sda | awk '{print $1}')
Hash SHA256: $(sha256sum /dev/sda | awk '{print $1}')
Descrição: Imagem forense do disco principal
EOF

# 10. Desmontar
sudo umount /mnt/evidencia
```

**Macetes:**
- **SEMPRE** trabalhe em cópia, nunca na evidência original
- Use `dd` com `status=progress` para acompanhar o progresso
- Calcule hashes ANTES e DEPOIS da cópia
- Documente tudo: data, hora, analista, dispositivo
- Formato E01 é padrão forense (comprime e protege)
- Use `bs=4M` para melhor performance

**Checklist:**
- [ ] Evidência de teste criada
- [ ] Hash original calculado (MD5 e SHA256)
- [ ] Imagem forense criada com dd
- [ ] Imagem E01 criada com ewfexport
- [ ] Hash da cópia verificado
- [ ] Cadeia de custódia documentada
- [ ] Integridade verificada

**Link de referência:** https://cyberdefenders.org/

---

## Exercício 2: Análise de Memória com Volatility

**Tempo estimado:** 45 min

**Objetivo:** Analisar um dump de memória para identificar processos maliciosos, conexões de rede suspeitas e artefatos de malware.

**Conhecimentos envolvidos:**
- Análise de processos
- Conexões de rede
- Detecção de malware
- Artefatos de memória

**Ferramentas:**
- volatility3
- python3

**Passo a passo:**

```bash
# 1. Instalar Volatility 3
sudo apt update && sudo apt install -y python3 python3-pip
pip3 install volatility3

# 2. Verificar se está funcionando
vol3 --help

# 3. Listar plugins disponíveis
vol3 --help | grep windows

# 4. Analisar dump de memória (substitua pelo seu arquivo)
vol3 -f /caminho/para/memdump.raw windows.pslist

# 5. Listar processos com detalhes (PIDs, threads)
vol3 -f /caminho/para/memdump.raw windows.pslist --pid 0

# 6. Verificar conexões de rede
vol3 -f /caminho/para/memdump.raw windows.netscan

# 7. Listar processos com árvore de chamadas
vol3 -f /caminho/para/memdump.raw windows.pstree

# 8. Procurar por malware (malfind)
vol3 -f /caminho/para/memdump.raw windows.malfind

# 9. Verificar handles de arquivos abertos
vol3 -f /caminho/para/memdump.raw windows.handles --pid <PID_SUSPEITO>

# 10. Extrair processos suspeitos
vol3 -f /caminho/para/memdump.raw windows.dump --pid <PID_SUSPEITO> --dump /tmp/

# 11. Analisar DLLs carregadas
vol3 -f /caminho/para/memdump.raw windows.dlllist --pid <PID_SUSPEITO>

# 12. Verificar registros do registry
vol3 -f /caminho/para/memdump.raw windows.registry.hivelist
```

**Macetes:**
- Comece por `windows.pslist` para visão geral
- Use `windows.netscan` para encontrar conexões externas
- `windows.malfind` identifica código injetado em processos
- Compare processos suspeitos com listas normais do Windows
- Procure por processos com nomes estranhos ou PIDs altos
- Use `windows.filescan` para encontrar arquivos abertos

**Checklist:**
- [ ] Volatility 3 instalado e funcionando
- [ ] Lista de processos analisada (pslist)
- [ ] Conexões de rede verificadas (netscan)
- [ ] Árvore de processos analisada (pstree)
- [ ] Pelo menos 1 processo suspeito identificado
- [ ] Processos com injeção de código procurados (malfind)
- [ ] Processo suspeito extraído para análise

**Link de referência:** https://tryhackme.com/room/volatility

---

## Exercício 3: Timeline com Plaso

**Tempo estimado:** 50 min

**Objetivo:** Criar uma linha do tempo completa de eventos a partir de evidências forenses, correlacionando timestamps de diferentes fontes.

**Conhecimentos envolvidos:**
- Timestamps (UTC, timezone)
- Correlação de eventos
- Fontes de timeline
- Análise temporal

**Ferramentas:**
- log2timeline (Plaso)
- psort

**Passo a passo:**

```bash
# 1. Instalar Plaso
sudo apt update && sudo apt install -y plaso

# 2. Verificar instalação
log2timeline.py --help
psort.py --help

# 3. Criar timeline a partir de imagem de disco
log2timeline.py timeline.plaso /caminho/para/evidencia.dd

# 4. Criar timeline de diretório específico
log2timeline.py timeline.plaso /caminho/para/evidencia/ --storage-file timeline.plaso

# 5. Processar com filtros de tempo
log2timeline.py timeline.plaso /caminho/para/evidencia.dd \
  --datetime-filter "2024-01-01 00:00:00 - 2024-12-31 23:59:59"

# 6. Gerar CSV da timeline
psort.py timeline.plaso -o l2tcsv timeline.csv

# 7. Filtrar por tipo de evento
psort.py timeline.plaso -o l2tcsv timeline_filtered.csv \
  "event_type LIKE 'file'"

# 8. Filtrar por intervalo de tempo específico
psort.py timeline.plaso -o l2tcsv timeline_windows.csv \
  "datetime >= '2024-01-01 08:00:00' AND datetime <= '2024-01-01 18:00:00'"

# 9. Analisar timeline com grep
grep -i "suspicious" timeline.csv
grep -i "malware" timeline.csv
grep -i "login" timeline.csv

# 10. Criar timeline HTML (visual)
psort.py timeline.plaso -o html timeline.html

# 11. Estatísticas da timeline
psort.py timeline.plaso --analysis statistics

# 12. Timeline do registro do Windows
log2timeline.py winreg.plaso /caminho/para/NTUSER.DAT
```

**Macetes:**
- `log2timeline.py` coleta dados; `psort.py` filtra e formata
- Comece com coleta ampla e depois refine com filtros
- Use `--storage-file` para salvar progresso
- Filtre por horários específicos de incidente
- O formato CSV é bom para análise no Excel/Google Sheets
- Combine timelines de diferentes fontes para correlação

**Checklist:**
- [ ] Plaso instalado e funcionando
- [ ] Timeline criada a partir de evidência
- [ ] Timeline exportada para CSV
- [ ] Pelo menos 2 filtros aplicados
- [ ] Eventos suspeitos identificados
- [ ] Timeline HTML gerada (visual)
- [ ] Análise estatística realizada

**Link de referência:** https://cyberdefenders.org/

---

## Exercício 4: Análise com Autopsy

**Tempo estimado:** 60 min

**Objetivo:** Realizar análise forense completa usando o Autopsy, incluindo recuperação de arquivos deletados, análise de metadata e busca por palavras-chave.

**Conhecimentos envolvidos:**
- Sistema de arquivos
- Arquivos deletados
- Metadata e timestamps
- Busca por conteúdo

**Ferramentas:**
- Autopsy (The Sleuth Kit)
- Java Runtime

**Passo a passo:**

```bash
# 1. Instalar Autopsy
sudo apt update && sudo apt install -y autopsy

# 2. Iniciar Autopsy
sudo autopsy

# 3. Acessar interface web
# Abrir navegador em http://localhost:9999/autopsy

# --- NA INTERFACE WEB ---

# 4. Criar novo caso
# - Case Name: Investigacao_001
# - Case Number: 001
# - Examiner: [SeuNome]

# 5. Adicionar evidência
# - Adicionar imagem de disco ou diretório
# - Selecionar tipo: Disk Image ou Local Directory

# 6. Analisar resultados do ingest
# - Wait para processamento completo
# - Verificar abas: Results, Data Sources, Views

# 7. Explorar sistema de arquivos
# - Data Sources → Imagem → File System
# - Navegar diretórios
# - Verificar arquivos deletados (icones vermelhos)

# 8. Usar Timeline
# - Aba: Timeline
# - Filtrar por data/hora
# - Visualizar eventos em linha do tempo

# 9. Buscar por palavras-chave
# - Keyword Search: inserir termo
# - Usar regex para padrões complexos
# - Exemplo: \b\d{3}-\d{2}-\d{4}\b (SSN)

# 10. Analisar metadados
# - Clicar em arquivo → Metadata
# - Ver: timestamps, permissões, owner, size

# 11. Extrair evidências
# - Clicar direito → Export
# - Salvar arquivos relevantes

# 12. Gerar relatório
# - Generate Report → HTML ou PDF
# - Selecionar módulos incluídos
```

**Macetes:**
- O Autopsy cria automaticamente um "Known Files" hash database
- Use "File Type by Extension" para encontrar arquivos com extensões erradas
- O módulo "Hash Lookup" identifica malware conhecido
- "Keyword Search" aceita expressões regulares
- Timeline é poderoso para reconstruir sequência de eventos
- Salve o caso regularmente

**Checklist:**
- [ ] Autopsy instalado e acessível
- [ ] Caso criado com dados corretos
- [ ] Evidência adicionada e processada
- [ ] Sistema de arquivos explorado
- [ ] Arquivos deletados identificados
- [ ] Timeline analisada
- [ ] Pelo menos 3 buscas por palavras-chave realizadas
- [ ] Metadados de arquivos analisados
- [ ] Evidências exportadas
- [ ] Relatório gerado

**Link de referência:** https://digitalcorps.ssu.edu/autopsy-training/

---

## Exercício 5: Detecção de Malware com Yara

**Tempo estimado:** 40 min

**Objetivo:** Criar regras YARA para identificar padrões de malware, strings suspeitas e comportamentos maliciosos em arquivos.

**Conhecimentos envolvidos:**
- YARA rules
- Patterns e strings
- Condições lógicas
- Metadados de regras

**Ferramentas:**
- YARA
- apt

**Passo a passo:**

```bash
# 1. Instalar YARA
sudo apt update && sudo apt install -y yara

# 2. Verificar instalação
yara --version

# 3. Criar diretório de regras
mkdir -p ~/yara_rules
cd ~/yara_rules

# 4. Criar primeira regra - Detectar strings suspeitas
nano regra_simples.yar
```

```yara
rule Detect_Suspicious_Strings {
    meta:
        author = "Analista"
        description = "Detecta strings comuns em malware"
        date = "2024-01-01"

    strings:
        $s1 = "cmd.exe /c" nocase
        $s2 = "powershell -enc" nocase
        $s3 = "CreateRemoteThread" nocase
        $s4 = "WriteProcessMemory" nocase
        $s5 = "VirtualAllocEx" nocase

    condition:
        2 of them
}
```

```bash
# 5. Criar regra avançada - Detectar padrões de rede
nano regra_rede.yar
```

```yara
rule Detect_C2_Communication {
    meta:
        author = "Analista"
        description = "Detecta padrões de comunicação C2"
        severity = "high"

    strings:
        $http1 = "POST" ascii
        $http2 = "User-Agent:" ascii
        $c2_pattern = /https?:\/\/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/
        $encoded = "base64" nocase
        $obfusc = /\x[0-9a-fA-F]{2}/ ascii

    condition:
        $http1 and $http2 and ($c2_pattern or $encoded) and #obfusc > 5
}
```

```bash
# 6. Criar regra para detectar anti-análise
nano regra_anti_analise.yar
```

```yara
rule Detect_Anti_Analysis {
    meta:
        author = "Analista"
        description = "Detecta técnicas de anti-análise"

    strings:
        $vm1 = "VMware" nocase
        $vm2 = "VirtualBox" nocase
        $vm3 = "Sandboxie" nocase
        $debug1 = "IsDebuggerPresent" ascii
        $debug2 = "CheckRemoteDebuggerPresent" ascii
        $sleep = "Sleep" ascii
        $env = "GetEnvironmentVariable" ascii

    condition:
        uint16(0) == 0x5A4D and
        (1 of ($vm*) or 1 of ($debug*)) and
        #sleep > 3
}
```

```bash
# 7. Testar regras com arquivos
# Criar arquivo de teste
echo "cmd.exe /c dir" > /tmp/teste_suspeito.exe
echo "normal text file" > /tmp/teste_normal.txt

# Testar regra simples
yara regra_simples.yar /tmp/teste_suspeito.exe
yara regra_simples.yar /tmp/teste_normal.txt

# 8. Escanear diretório inteiro
yara -r ~/yara_rules/ /caminho/para/diretorio/

# 9. Buscar arquivos que NÃO correspondem a regras
yara -w regra_simples.yar /tmp/

# 10. Usar regras de comunidade
git clone https://github.com/Yara-Rules/rules.git /tmp/yara-community
yara -r /tmp/yara-community/malware/ /caminho/para/evidencia/

# 11. Criar regra com hex
nano regra_hex.yar
```

```yara
rule Detect_PE_Header {
    strings:
        $mz = { 4D 5A }

    condition:
        $mz at 0
}
```

```bash
# 12. Relatório de correspondências
yara -s regra_simples.yar /tmp/teste_suspeito.exe
```

**Macetes:**
- `nocase` torna a busca case-insensitive
- Use `at 0` para verificar posição específica (MZ header)
- Combine strings com condições para reduzir falsos positivos
- `#string > N` conta ocorrências
- Comece com regras simples e adicione complexidade
- Valide regras contra arquivos conhecidos

**Checklist:**
- [ ] YARA instalado e funcionando
- [ ] Pelo menos 3 regras customizadas criadas
- [ ] Regra simples testada com sucesso
- [ ] Regra de rede criada
- [ ] Regra de anti-análise criada
- [ ] Teste com arquivos suspeitos e normais
- [ ] Regras de comunidade testadas
- [ ] Regra hex criada

**Link de referência:** https://yara.readthedocs.io/en/stable/

---

## Exercício 6: Investigação Completa (Final Challenge)

**Tempo estimado:** 120 min

**Objetivo:** Realizar uma investigação completa de incidente de segurança, desde a preservação de evidências até o relatório final, usando todas as ferramentas do módulo.

**Conhecimentos envolvidos:**
- Todas as técnicas dos exercícios anteriores
- Metodologia de investigação
- Documentação e relatórios
- Análise correlacionada

**Ferramentas:**
- dd, ewfmount (preservação)
- Volatility (memória)
- Autopsy (disco)
- YARA (malware)
- Plaso (timeline)

**Passo a passo:**

```bash
# FASE 1: PRESERVAÇÃO E COLETA
# 1. Identificar e preservar evidências
echo "=== FASE 1: PRESERVAÇÃO ==="

# Criar workspace de investigação
mkdir -p ~/investigacao/{evidencias,analise,relatorio}
cd ~/investigacao

# Preservar imagem de disco (simular)
dd if=/dev/sda of=./evidencias/disk_image.dd bs=4M status=progress

# Calcular hashes
md5sum ./evidencias/disk_image.dd > ./evidencias/hashes.md5
sha256sum ./evidencias/disk_image.dd > ./evidencias/hashes.sha256

# Documentar cadeia de custódia
cat > ./evidencias/cadeia_custodia.txt << EOF
INVESTIGAÇÃO #001 - CADEIA DE CUSTÓDIA
=====================================
Data da Coleta: $(date)
Responsável: $(whoami)
Evidência: Disco rígido /dev/sda
Tamanho: $(ls -lh /dev/sda | awk '{print $5}')
Hash MD5: $(md5sum /dev/sda | awk '{print $1}')
Hash SHA256: $(sha256sum /dev/sda | awk '{print $1}')
Descrição: Disco do servidor comprometido
EOF
```

```bash
# FASE 2: ANÁLISE DE MEMÓRIA
echo "=== FASE 2: ANÁLISE DE MEMÓRIA ==="

# 2. Analisar dump de memória
vol3 -f ./evidencias/memdump.raw windows.pslist > ./analise/memoria_pslist.txt
vol3 -f ./evidencias/memdump.raw windows.netscan > ./analise/memoria_netscan.txt
vol3 -f ./evidencias/memdump.raw windows.malfind > ./analise/memoria_malfind.txt
vol3 -f ./evidencias/memdump.raw windows.pstree > ./analise/memoria_pstree.txt

# Extrair processos suspeitos
for pid in $(grep -i "suspicious\|inject" ./analise/memoria_malfind.txt | awk '{print $2}'); do
    vol3 -f ./evidencias/memdump.raw windows.dump --pid $pid --dump ./analise/processo_$pid.exe
done
```

```bash
# FASE 3: ANÁLISE DE DISCO
echo "=== FASE 3: ANÁLISE DE DISCO ==="

# 3. Montar e analisar disco
mkdir -p /mnt/evidencia
sudo ewfmount ./evidencias/disk_image.E01 /mnt/evidencia

# Listar arquivos modificados recentemente
find /mnt/evidencia -mtime -7 -type f > ./analise/arquivos_recentes.txt

# Procurar por artefatos suspeitos
find /mnt/evidencia -name "*.exe" -o -name "*.dll" -o -name "*.bat" > ./analise/executaveis.txt

# Verificar logs
cp -r /mnt/evidencia/Windows/System32/winevt/Logs/ ./analise/event_logs/ 2>/dev/null
```

```bash
# FASE 4: DETECÇÃO DE MALWARE
echo "=== FASE 4: DETECÇÃO DE MALWARE ==="

# 4. Criar regras YARA para este caso
cat > ./analise/regra_caso.yar << 'EOF'
rule Incidente_001_Malware {
    meta:
        author = "Investigador"
        description = "Regra específica para este incidente"
    strings:
        $s1 = "cmd.exe /c" nocase
        $s2 = "powershell" nocase
        $s3 = "Invoke-WebRequest" nocase
        $c2 = /https?:\/\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/
    condition:
        2 of them
}
EOF

# Escanear evidências
yara -r ./analise/regra_caso.yar /mnt/evidencia/ > ./analise/yara_results.txt

# Escanear processos extraídos
yara -r ./analise/regra_caso.yar ./analise/*.exe 2>/dev/null

# Usar regras de comunidade
yara -r /tmp/yara-community/malware/ /mnt/evidencia/ > ./analise/yara_community.txt 2>/dev/null
```

```bash
# FASE 5: TIMELINE
echo "=== FASE 5: CRIAÇÃO DE TIMELINE ==="

# 5. Criar timeline
log2timeline.py ./analise/timeline.plaso /mnt/evidencia/ \
  --storage-file ./analise/timeline.plaso

# Gerar CSV
psort.py ./analise/timeline.plaso -o l2tcsv ./analise/timeline.csv

# Filtrar eventos suspeitos
grep -i "suspicious\|malware\|attack" ./analise/timeline.csv > ./analise/timeline_suspeitos.csv

# Filtrar por horário do incidente
psort.py ./analise/timeline.plaso -o l2tcsv ./analise/timeline_incidente.csv \
  "datetime >= '2024-01-01 10:00:00' AND datetime <= '2024-01-01 14:00:00'"
```

```bash
# FASE 6: CORRELAÇÃO E RELATÓRIO
echo "=== FASE 6: CORRELAÇÃO E RELATÓRIO ==="

# 6. Correlacionar achados
cat > ./relatorio/relatorio_final.md << EOF
# RELATÓRIO DE INVESTIGAÇÃO #001

## Resumo Executivo
Data: $(date)
Analista: $(whoami)
Status: Em andamento

## Evidências Coletadas
- Imagem de disco: disk_image.dd
- Hash MD5: $(cat ./evidencias/hashes.md5 | awk '{print $1}')
- Hash SHA256: $(cat ./evidencias/hashes.sha256 | awk '{print $1}')

## Achados Principais

### Memória
$(cat ./analise/memoria_malfind.txt | head -20)

### Arquivos Suspeitos
$(cat ./analise/yara_results.txt | head -20)

### Timeline
$(cat ./analise/timeline_suspeitos.csv | head -10)

## IOC (Indicators of Compromise)
- IPs maliciosos: [listar IPs encontrados]
- Domínios: [listar domínios]
- Hashes de malware: [listar hashes]
- Arquivos: [listar caminhos]

## Linha do Tempo do Incidente
1. [Hora] - Evento inicial
2. [Hora] - Progressão
3. [Hora] - Impacto

## Recomendações
1. Isolar sistemas comprometidos
2. Bloquear IPs e domínios maliciosos
3. Remover malware identificado
4. Atualizar sistemas e patch
5. Implementar monitoramento aprimorado

## Anexos
- evidencias/hashes.md5
- analise/memoria_malfind.txt
- analise/yara_results.txt
- analise/timeline.csv
EOF

# Gerar relatório HTML
psort.py ./analise/timeline.plaso -o html ./relatorio/timeline.html

echo "=== INVESTIGAÇÃO CONCLUÍDA ==="
echo "Relatório: ./relatorio/relatorio_final.md"
echo "Timeline: ./relatorio/timeline.html"
```

**Macetes:**
- **Documente tudo** desde o início
- Siga a ordem: Preservar → Coletar → Analisar → Correlacionar → Reportar
- Nunca trabalhe na evidência original
- Correlacione achados de diferentes ferramentas
- Mantenha cadeia de custódia documentada
- IOC é crucial para detecção futura
- Revise o relatório antes de finalizar

**Checklist:**
- [ ] Workspace de investigação criado
- [ ] Evidências preservadas com hashes
- [ ] Cadeia de custódia documentada
- [ ] Análise de memória completa (Volatility)
- [ ] Análise de disco completa (Autopsy/montagem)
- [ ] Detecção de malware realizada (YARA)
- [ ] Timeline criada e filtrada (Plaso)
- [ ] Achados correlacionados
- [ ] IOC documentados
- [ ] Relatório final gerado
- [ ] Timeline HTML produzida
- [ ] Recomendações documentadas

**Link de referência:** https://cyberdefenders.org/
