# Labs — Terminal Linux

> 25+ exercicios praticos para voce DOMINAR o terminal. Cada exercicio tem objetivo, passo a passo e verificacao.

---

## Nivel 1: Basico (Exercicios 1-8)

### Lab 1: Navegacao

**Objetivo:** Navegar entre diretorios sem ajuda.

```bash
# 1. Descubra onde esta
pwd

# 2. Va para a raiz e confirme
cd /
pwd
# Deve mostrar: /

# 3. Volte ao home
cd ~
pwd

# 4. Navegue ate /var/log
cd /var/log

# 5. Volte ao home usando caminho relativo
cd ../../home/$(whoami)

# 6. Volta ao ultimo diretorio
cd -

# 7. Liste tudo
ls -la
```

**Verificacao:** Conseguiu navegar sem erros.

---

### Lab 2: Arquivos

**Objetivo:** Criar, copiar, mover e deletar arquivos.

```bash
# 1. Crie pasta de trabalho
mkdir -p lab

# 2. Crie 3 arquivos
touch lab/{a,b,c}.txt

# 3. Lista
ls lab/

# 4. Copie a.txt para backup.txt
cp lab/a.txt lab/backup.txt

# 5. Renomeie backup.txt
mv lab/backup.txt lab/novo.txt

# 6. Adicione conteudo
echo "Hello" > lab/a.txt
cat lab/a.txt

# 7. Deleta c.txt
rm lab/c.txt

# 8. Deleta tudo
rm -rf lab/
```

**Verificacao:** Pasta lab nao existe mais.

---

### Lab 3: Permissoes

**Objetivo:** Entender e mudar permissoes.

```bash
# 1. Crie um arquivo
touch teste.txt

# 2. Veja permissoes
ls -la teste.txt
# Deve mostrar: -rw-r--r--

# 3. Mude para 755
chmod 755 teste.txt
ls -la teste.txt
# Deve mostrar: -rwxr-xr-x

# 4. Crie um script
echo '#!/bin/bash' > script.sh
echo 'echo "Hello!"' >> script.sh

# 5. Tente rodar (erro)
./script.sh

# 6. De permissao
chmod +x script.sh

# 7. Roda
./script.sh
```

**Verificacao:** Script roda sem erros.

---

### Lab 4: Processos

**Objetivo:** Listar e matar processos.

```bash
# 1. Abra processo em background
sleep 1000 &

# 2. Veja o PID
ps aux | grep sleep

# 3. Mate com kill
kill <PID>

# 4. Confirme que morreu
ps aux | grep sleep
# So deve mostrar o proprio grep

# 5. Use htop
htop
# Navegue, veja processos, saia com q
```

**Verificacao:** Processo foi morto com sucesso.

---

### Lab 5: Texto

**Objetivo:** Manipular texto com ferramentas basicas.

```bash
# 1. Crie um log de teste
cat > log.txt << EOF
2024-01-06 10:00:00 INFO Conexao OK
2024-01-06 10:01:00 ERROR Falha auth
2024-01-06 10:02:00 INFO Login OK
2024-01-06 10:03:00 ERROR Timeout
2024-01-06 10:04:00 INFO Logout
EOF

# 2. Mostre so erros
grep "ERROR" log.txt

# 3. Conte erros
grep -c "ERROR" log.txt

# 4. Primeira e ultima linha
head -1 log.txt
tail -1 log.txt

# 5. Ordene
sort log.txt

# 6. Remova duplicatas (nao tem, mas pratique)
sort log.txt | uniq
```

**Verificacao:** Conseguiu filtrar e contar.

---

### Lab 6: Pipes

**Objetivo:** Encadear comandos com pipes.

```bash
# 1. Liste processos e conte
ps aux | wc -l

# 2. Liste arquivos e ordene por tamanho
ls -la | sort -k 5 -rn | head -5

# 3. Salve resultado em arquivo
ls -la | head -10 > minha_lista.txt

# 4. Adicione mais
echo "Fim" >> minha_lista.txt

# 5. Confirme
cat minha_lista.txt
```

**Verificacao:** Arquivo criado com conteudo correto.

---

### Lab 7: Redes

**Objetivo:** Diagnosticar rede.

```bash
# 1. Seu IP
ip a | grep "inet "

# 2. IP externo
curl ifconfig.me

# 3. Ping
ping -c 3 google.com

# 4. DNS
dig google.com +short

# 5. Portas abertas
ss -tlnp
```

**Verificacao:** Conseguiu obter todas as informacoes.

---

### Lab 8: curl

**Objetivo:** Fazer requests HTTP.

```bash
# 1. Headers
curl -I https://example.com

# 2. GET
curl https://example.com

# 3. Salvar
curl -o /tmp/teste.html https://example.com

# 4. Verboso
curl -v https://example.com

# 5. JSON
curl -s https://httpbin.org/get | head -5
```

**Verificacao:** Todos os requests funcionaram.

---

## Nivel 2: Intermediario (Exercicios 9-16)

### Lab 9: find

**Objetivo:** Encontrar arquivos complexamente.

```bash
# 1. Arquivos .txt em todo o sistema (limitado a /home)
find /home -name "*.txt" -type f

# 2. Arquivos grandes (maiores que 10MB)
find / -size +10M -type f 2>/dev/null | head -10

# 3. Arquivos modificados hoje
find . -mtime -1 -type f

# 4. Deletar todos os .log de uma pasta
mkdir -p /tmp/teste
touch /tmp/teste/{a,b,c}.log
find /tmp/teste -name "*.log" -exec rm {} \;
ls /tmp/teste/
```

**Verificacao:** Arquivos encontrados e deletados.

---

### Lab 10: awk e sed

**Objetivo:** Manipular colunas e texto.

```bash
# 1. Extrair usuarios do sistema
awk -F: '$3 >= 1000 {print $1}' /etc/passwd

# 2. Trocar texto em arquivo
echo "Hello World" > teste.txt
sed -i 's/World/Linux/' teste.txt
cat teste.txt

# 3. Deletar linhas em branco
cat > multilinhas.txt << EOF
Linha 1

Linha 2

Linha 3
EOF

sed '/^$/d' multilinhas.txt

# 4. Extrair IPs de log
echo "Failed from 192.168.1.100" | sed -n 's/.*from \([0-9.]*\).*/\1/p'
```

**Verificacao:** Manipulacoes funcionaram.

---

### Lab 11: Script basico

**Objetivo:** Primeiro script funcional.

```bash
cat > scan.sh << 'EOF'
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Uso: $0 <ip>"
    exit 1
fi

IP=$1

echo "=== Scan de $IP ==="
ping -c 1 -W 2 $IP &> /dev/null && echo "[+] Host ativo" || echo "[-] Host inativo"
nmap -sV $IP 2>/dev/null | grep "open"
EOF

chmod +x scan.sh
./scan.sh localhost
```

**Verificacao:** Script rodou e mostrou resultados.

---

### Lab 12: Script com loops

**Objetivo:** Automatizar com loops.

```bash
cat > batch_scan.sh << 'EOF'
#!/bin/bash

REDE="192.168.56"

echo "=== Scan da rede $REDE.0/24 ==="

for HOST in $(seq 1 20); do
    IP="${REDE}.${HOST}"
    if ping -c 1 -W 1 $IP &> /dev/null; then
        echo "[+] $IP ativo"
    fi
done

echo "=== Scan completo ==="
EOF

chmod +x batch_scan.sh
# ./batch_scan.sh  # Nao rode em rede real sem autorizacao
```

**Verificacao:** Script escrito corretamente.

---

### Lab 13: Funcoes

**Objetivo:** Reutilizar codigo com funcoes.

```bash
cat > ferramentas.sh << 'EOF'
#!/bin/bash

# Funcoes
log() {
    echo -e "\033[0;32m[+] $1\033[0m"
}

erro() {
    echo -e "\033[0;31m[-] $1\033[0m"
}

verificar_host() {
    local IP=$1
    if ping -c 1 -W 2 $IP &> /dev/null; then
        log "$IP ativo"
        return 0
    else
        erro "$IP inativo"
        return 1
    fi
}

# Uso
verificar_host 127.0.0.1
verificar_host 192.168.99.99
EOF

chmod +x ferramentas.sh
./ferramentas.sh
```

**Verificacao:** Funcoes executaram corretamente.

---

### Lab 14: Arrays

**Objetivo:** Trabalhar com arrays.

```bash
cat > array_demo.sh << 'EOF'
#!/bin/bash

# Array simples
declare -a IPS=("127.0.0.1" "8.8.8.8" "1.1.1.1")

echo "=== IPs ==="
for IP in "${IPS[@]}"; do
    echo "Testando $IP..."
    ping -c 1 -W 2 $IP &> /dev/null && echo "  OK" || echo "  FALHOU"
done

# Array associativo
declare -a SERVICOS
SERVICOS[22]="SSH"
SERVICOS[80]="HTTP"
SERVICOS[443]="HTTPS"

echo ""
echo "=== Portas ==="
for PORTA in "${!SERVICOS[@]}"; do
    echo "Porta $PORTA: ${SERVICOS[$PORTA]}"
done
EOF

chmod +x array_demo.sh
./array_demo.sh
```

**Verificacao:** Arrays iterados corretamente.

---

### Lab 15: Regexp

**Objetivo:** Validar input com expressoes regulares.

```bash
cat > validacao.sh << 'EOF'
#!/bin/bash

validar_ip() {
    [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

validar_email() {
    [[ $1 =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Testes
for IP in "192.168.1.1" "999.999.999.999" "nao_e_ip"; do
    if validar_ip "$IP"; then
        echo "[+] $IP: IP valido"
    else
        echo "[-] $IP: IP invalido"
    fi
done

for EMAIL in "user@email.com" "invalido" "@.com"; do
    if validar_email "$EMAIL"; then
        echo "[+] $EMAIL: Email valido"
    else
        echo "[-] $EMAIL: Email invalido"
    fi
done
EOF

chmod +x validacao.sh
./validacao.sh
```

**Verificacao:** Validacoes funcionaram.

---

### Lab 16: Trap e cleanup

**Objetivo:** Script seguro com cleanup.

```bash
cat > seguro.sh << 'EOF'
#!/bin/bash
set -euo pipefail

# Arquivo temporario
TEMP=$(mktemp)

# Cleanup automatico
cleanup() {
    echo "Limpando..."
    rm -f "$TEMP"
}
trap cleanup EXIT

# Trabalhar com temporario
echo "Dados temporarios" > "$TEMP"
cat "$TEMP"

echo "Script terminou — arquivo temporario limpo!"
EOF

chmod +x seguro.sh
./seguro.sh
# Confirme que /tmp/temp_xxxx nao existe mais
```

**Verificacao:** Arquivo temporario foi deletado.

---

## Nivel 3: Avancado (Exercicios 17-22)

### Lab 17: Script de recon

**Objetivo:** Script completo de reconhecimento.

```bash
cat > recon.sh << 'EOF'
#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    echo "Uso: $0 <alvo>"
    echo "Exemplo: $0 example.com"
    exit 1
}

[ $# -eq 0 ] && usage

ALVO=$1
DATA=$(date +%Y%m%d_%H%M%S)
DIR="recon_${ALVO}_${DATA}"
mkdir -p "$DIR"

log() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

log "Iniciando recon em $ALVO"

# DNS
log "Enumerando DNS..."
dig $ALVO ANY +noall +answer > "$DIR/dns.txt" 2>/dev/null
dig $ALVO +short > "$DIR/dns_ip.txt" 2>/dev/null

# Whois
log "Consultando WHOIS..."
whois $ALVO > "$DIR/whois.txt" 2>/dev/null

# Nmap
log "Rodando Nmap..."
nmap -sV -sC $ALVO > "$DIR/nmap.txt" 2>/dev/null

# HTTP
log "Testando HTTP..."
curl -sI "http://$ALVO" > "$DIR/http_headers.txt" 2>/dev/null

log "Recon completo! Resultados em: $DIR/"
ls -la "$DIR/"
EOF

chmod +x recon.sh
```

**Verificacao:** Script escrito e funcional.

---

### Lab 18: Script de monitoramento

**Objetivo:** Monitorar mudancas no sistema.

```bash
cat > monitor.sh << 'EOF'
#!/bin/bash

SNAPSHOT="/tmp/snapshot"
LOG="/var/log/monitor.log"

mkdir -p "$SNAPSHOT"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

# Snapshot atual
snapshot_atual() {
    systemctl list-units --type=service --state=running > "$SNAPSHOT/services_current.txt"
    ss -tlnp > "$SNAPSHOT/ports_current.txt"
    cut -d: -f1 /etc/passwd > "$SNAPSHOT/users_current.txt"
}

# Comparar
comparar() {
    local ARQ=$1
    local NOME=$2

    if [ -f "$SNAPSHOT/${ARQ}_prev.txt" ]; then
        if ! diff -q "$SNAPSHOT/${ARQ}_prev.txt" "$SNAPSHOT/${ARQ}_current.txt" > /dev/null 2>&1; then
            log "MUDANCA DETECTADA em $NOME!"
            diff "$SNAPSHOT/${ARQ}_prev.txt" "$SNAPSHOT/${ARQ}_current.txt" | tee -a "$LOG"
        fi
    fi
}

# Inicializar snapshot
if [ ! -f "$SNAPSHOT/services_prev.txt" ]; then
    snapshot_atual
    cp "$SNAPSHOT/"*_current.txt "$SNAPSHOT/"*_prev.txt 2>/dev/null
    log "Snapshot inicial criado"
    exit 0
fi

# Verificar mudancas
comparar "services" "servicos"
comparar "ports" "portas"
comparar "users" "usuarios"

# Atualizar snapshot
snapshot_atual
cp "$SNAPSHOT/"*_current.txt "$SNAPSHOT/"*_prev.txt 2>/dev/null
EOF

chmod +x monitor.sh
```

**Verificacao:** Script funcional.

---

### Lab 19: Vim

**Objetivo:** Editar eficientemente com Vim.

```bash
# Exercicio 1: Criar arquivo
vim lab_vim.txt
# i → digitar texto → Esc → :wq

# Exercicio 2: Substituicao
vim lab_vim.txt
# :%s/foo/bar/g

# Exercicio 3: Macro
vim lab_vim.txt
# qa → A; → Esc → j → q → 10@a

# Exercicio 4: Split
vim lab_vim.txt
# :vsp outro.txt
# Ctrl+w para navegar
```

**Verificacao:** Edicoes feitas no Vim.

---

### Lab 20: Tmux

**Objetivo:** Gerenciar multiplos terminais.

```bash
# Criar sessao
tmux new -s lab

# Split vertical
Ctrl+b %

# No novo pane, abra htop
htop

# Split horizontal
Ctrl+b "

# No novo pane, abra vim
vim notas.txt

# Renomear
Ctrl+b ,
# Digite: lab_pentest

# Desanexe
Ctrl+b d

# Reconecte
tmux a -t lab
```

**Verificacao:** Sessao tmux criada e gerenciada.

---

### Lab 21: Script com args

**Objetivo:** Script que aceita argumentos.

```bash
cat > args.sh << 'EOF'
#!/bin/bash
set -euo pipefail

TARGET=""
PORTS="1-65535"
VERBOSE=false

usage() {
    cat << UEOF
Uso: $0 [opcoes]

Opcoes:
  -t, --target IP    IP ou dominio (obrigatorio)
  -p, --port PORTA   Portas (default: 1-65535)
  -v, --verbose      Modo verboso
  -h, --help         Mostra ajuda

Exemplo:
  $0 -t 192.168.1.1 -p 22,80,443
  $0 --target example.com --verbose
UEOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--target) TARGET="$2"; shift 2 ;;
        -p|--port) PORTS="$2"; shift 2 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -h|--help) usage ;;
        *) echo "Opcao invalida: $1"; usage ;;
    esac
done

[ -z "$TARGET" ] && { echo "ERRO: Target obrigatorio"; usage; }

echo "Target: $TARGET"
echo "Portas: $PORTS"
$VERBOSE && echo "Modo verboso ativo"

nmap -p "$PORTS" -sV "$TARGET"
EOF

chmod +x args.sh
./args.sh -h
```

**Verificacao:** Script aceita argumentos.

---

### Lab 22: Configuracao

**Objetivo:** Personalizar ambiente.

```bash
# Bashrc
cat >> ~/.bashrc << 'EOF'

# Aliases uteis
alias ll='ls -la'
alias ports='ss -tlnp'
alias myip='curl ifconfig.me'
alias scan='nmap -sV -sC'
alias update='sudo apt update && sudo apt upgrade -y'

# Funcao para backup
backup() {
    tar -czf "backup_$(date +%Y%m%d).tar.gz" "$@"
    echo "Backup criado!"
}
EOF

source ~/.bashrc

# Vimrc
cat > ~/.vimrc << 'EOF'
set number
set relativenumber
syntax on
set tabstop=4
set expandtab
set autoindent
set hlsearch
set incsearch
EOF
```

**Verificacao:** Aliases funcionam.

---

## Nivel 4: Profissional (Exercicios 23-27)

### Lab 23: Script de automacao completo

**Objetivo:** Script profissional com todas as features.

```bash
cat > pentest_auto.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail

# === CONFIG ===
VERSION="1.0"
LOG_DIR="/tmp/pentest_$(date +%Y%m%d)"
mkdir -p "$LOG_DIR"

# === CORES ===
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' B='\033[0;34m' NC='\033[0m'

# === FUNCOES ===
log() { echo -e "${G}[+]${NC} $1"; echo "[$(date)] $1" >> "$LOG_DIR/pentest.log"; }
warn() { echo -e "${Y}[!]${NC} $1"; }
err() { echo -e "${R}[-]${NC} $1" >&2; }
banner() { echo -e "${B}=== $1 ===${NC}"; }

# === DEPENDENCIAS ===
check_deps() {
    local DEPS=(nmap curl whois dig)
    for DEP in "${DEPS[@]}"; do
        command -v "$DEP" &> /dev/null || { err "Falta: $DEP"; exit 1; }
    done
}

# === MAIN ===
main() {
    local TARGET="${1:-}"
    [ -z "$TARGET" ] && { err "Uso: $0 <target>"; exit 1; }

    check_deps
    banner "PENTEST AUTOMATIZADO v$VERSION"
    log "Alvo: $TARGET"
    log "Resultados em: $LOG_DIR"

    banner "RECON"
    whois "$TARGET" > "$LOG_DIR/whois.txt" 2>/dev/null || warn "WHOIS falhou"
    dig "$TARGET" ANY > "$LOG_DIR/dns.txt" 2>/dev/null || warn "DNS falhou"
    log "Recon completo"

    banner "SCAN"
    nmap -sV -sC -T3 "$TARGET" | tee "$LOG_DIR/nmap.txt"
    log "Scan completo"

    banner "HTTP"
    curl -sI "http://$TARGET" > "$LOG_DIR/http.txt" 2>/dev/null || warn "HTTP falhou"

    banner "RESUMO"
    log "Portas abertas: $(grep -c "open" "$LOG_DIR/nmap.txt" 2>/dev/null || echo 0)"
    log "Fim do pentest"
}

main "$@"
SCRIPT

chmod +x pentest_auto.sh
```

**Verificacao:** Script profissional completo.

---

### Lab 24: Monitor com cron

**Objetivo:** Sistema de monitoramento automatizado.

```bash
# Script de monitor
cat > /tmp/monitor_sys.sh << 'EOF'
#!/bin/bash
LOG="/var/log/sys_monitor.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"; }

# CPU
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
(( $(echo "$CPU > 80" | bc -l) )) && log "ALERTA: CPU $CPU%"

# Memoria
MEM=$(free | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}')
(( $(echo "$MEM > 90" | bc -l) )) && log "ALERTA: Memoria $MEM%"

# Disco
DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
[ "$DISK" -gt 90 ] && log "ALERTA: Disco ${DISK}%"
EOF

chmod +x /tmp/monitor_sys.sh

# Agendar
(crontab -l 2>/dev/null; echo "*/5 * * * * /tmp/monitor_sys.sh") | crontab -
```

**Verificacao:** Monitor configurado.

---

### Lab 25: Dotfiles

**Objetivo:** Configurar ambiente profissional.

```bash
# Criar pasta de dotfiles
mkdir -p ~/dotfiles

# Git aliases
cat >> ~/.bashrc << 'EOF'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline'

# Funcao para criar projeto
projeto() {
    mkdir -p "$1" && cd "$1"
    git init
    echo "# $1" > README.md
    git add . && git commit -m "Initial commit"
    echo "Projeto $1 criado!"
}
EOF

source ~/.bashrc
```

**Verificacao:** Aliases funcionam.

---

## Checklist Final

- [ ] Completei todos os labs basicos (1-8)
- [ ] Completei todos os labs intermediarios (9-16)
- [ ] Completei todos os labs avancados (17-22)
- [ ] Completei todos os labs profissionais (23-27)
- [ ] Consigo escrever scripts bash do zero
- [ ] Consigo usar Vim para edicao rapida
- [ ] Consigo usar tmux para multi-terminal
- [ ] Consigo automatizar tarefas com cron

---

<div align="center">

**⬅️ [Voltar ao Modulo](README.md)**

</div>
