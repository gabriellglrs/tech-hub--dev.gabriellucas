# Bash Scripting — Avancado

> Funcoes, arrays, traps, debug — transforme scripts amadores em profissionais.

---

## Funcoes

### Sintaxe

```bash
#!/bin/bash

# Funcao simples
minha_funcao() {
    echo "Executando funcao..."
}

# Chamar
minha_funcao
```

### Funcao com retorno

```bash
#!/bin/bash

soma() {
    local A=$1
    local B=$2
    echo $((A + B))
}

# Usar resultado
RESULTADO=$(soma 5 3)
echo "Soma: $RESULTADO"    # Soma: 8
```

### Funcao com return

```bash
#!/bin/bash

existe_arquivo() {
    if [ -f "$1" ]; then
        return 0    # Sucesso (verdadeiro)
    else
        return 1    # Falha (falso)
    fi
}

if existe_arquivo "/etc/passwd"; then
    echo "Arquivo existe!"
else
    echo "Arquivo nao encontrado"
fi
```

### Variavel local

```bash
#!/bin/bash

minha_funcao() {
    local VARIAVEL="so existe aqui"
    echo $VARIAVEL
}

minha_funcao
# echo $VARIAVEL  # ERRO: variavel nao existe fora da funcao
```

---

## Arrays

### Array Simples

```bash
#!/bin/bash

# Definir
FRUTAS=("Maca" "Banana" "Laranja" "Uva")

# Acessar
echo ${FRUTAS[0]}           # Maca (primeiro)
echo ${FRUTAS[1]}           # Banana
echo ${FRUTAS[-1]}          # Uva (ultimo)
echo ${FRUTAS[@]}           # Todos
echo ${#FRUTAS[@]}          # Quantidade (4)
```

### Adicionar e Remover

```bash
FRUTAS+=("Morango")         # Adiciona
unset FRUTAS[1]             # Remove Banana
```

### Iterar

```bash
for FRUTA in "${FRUTAS[@]}"; do
    echo "Fruta: $FRUTA"
done
```

### Array Associativo (dicionario)

```bash
#!/bin/bash

declare -A PESSOA
PESSOA[NOME]="Joao"
PESSOA[IDADE]="25"
PESSOA[CIDADE]="SP"

echo ${PESSOA[NOME]}        # Joao
echo ${!PESSOA[@]}          # Todas as chaves (NOME IDADE CIDADE)
echo ${PESSOA[@]}           # Todos os valores
```

---

## Traps — Sinalizacao

```bash
#!/bin/bash

# Trap quando script termina
cleanup() {
    echo "Limpando..."
    rm -f /tmp/arquivo_temp
}

trap cleanup EXIT

# Trap quando receber Ctrl+C
trap 'echo "Interrompido!"; exit 1' INT

# Trap quando receber SIGTERM
trap 'echo "Terminado!"; exit 0' TERM

# Remover trap
trap - INT
```

### Exemplo pratico

```bash
#!/bin/bash

# Cria arquivo temporario
TEMP=$(mktemp)

# Garante que sera deletado
trap 'rm -f "$TEMP"' EXIT

echo "Trabalhando com $TEMP"
# ... fazer coisas ...

echo "Script terminou — arquivo deletado automaticamente"
```

---

## Debug

### Modo verbose

```bash
bash -x script.sh           # Mostra cada linha antes de executar

# Dentro do script
set -x                       # Liga debug
# ... codigo ...
set +x                       # Desliga debug
```

### Flags de erro

```bash
set -e                       # Sai se qualquer comando falhar
set -u                       # Erro se usar variavel nao definida
set -o pipefail              # Erro se pipe falhar

# Combinar (recomendado)
set -euo pipefail
```

### Exemplo com debug

```bash
#!/bin/bash
set -euo pipefail

echo "Inicio"
RESULTADO=$(comando_que_nao_existe)  # ERRO: comando nao existe
echo "Fim"  # Nao chega aqui
```

---

## Expressoes Regulares

```bash
#!/bin/bash

IP="192.168.1.100"

# Verificar padrao
if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "IP valido"
fi

# Extrair partes
if [[ $IP =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "Rede: ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
    echo "Host: ${BASH_REMATCH[4]}"
fi
```

---

## Substrings e Manipulacao

```bash
#!/bin/bash

TEXTO="Hello World Linux"

# Tamanho
echo ${#TEXTO}              # 18

# Substring
echo ${TEXTO:0:5}           # Hello
echo ${TEXTO:6:5}           # World

# Substituir
echo ${TEXTO/Linux/Unix}    # Hello World Unix

# Minusculo
echo ${TEXTO,,}             # hello world linux

# Maiusculo
echo ${TEXTO^^}             # HELLO WORLD LINUX
```

---

## Autocompletar

```bash
# Arquivo de completar
cat > ~/.bashrc.d/my_completion.sh << 'EOF'
_my_command() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="scan recon report"
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}
complete -F _my_command my_command
EOF
```

---

## Scripts Profissionais

### Template Base

```bash
#!/bin/bash
set -euo pipefail

# === CONFIGURACAO ===
VERSION="1.0"
AUTHOR="SeuNome"
LOG_FILE="/tmp/script.log"

# === CORES ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# === FUNCOES ===
log() {
    echo -e "${GREEN}[+]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

error() {
    echo -e "${RED}[-]${NC} $1" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
    exit 1
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

usage() {
    echo "Uso: $0 [opcoes]"
    echo "Opcoes:"
    echo "  -t, --target IP    Alvo do scan"
    echo "  -p, --port PORTA   Porta (default: 1-65535)"
    echo "  -h, --help         Mostra ajuda"
}

# === VERIFICACOES ===
check_deps() {
    for CMD in nmap curl; do
        if ! command -v "$CMD" &> /dev/null; then
            error "Dependencia nao encontrada: $CMD"
        fi
    done
}

# === MAIN ===
main() {
    local TARGET=""
    local PORT="1-65535"

    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--target) TARGET="$2"; shift 2 ;;
            -p|--port) PORT="$2"; shift 2 ;;
            -h|--help) usage; exit 0 ;;
            *) error "Opcao desconhecida: $1" ;;
        esac
    done

    if [ -z "$TARGET" ]; then
        usage
        error "Target obrigatorio!"
    fi

    check_deps

    log "Iniciando scan em $TARGET"
    nmap -p "$PORT" -sV "$TARGET" | tee "scan_${TARGET}.txt"
    log "Scan completo — scan_${TARGET}.txt"
}

main "$@"
```

---

## Validação de Input

```bash
#!/bin/bash

# Validar IP
validar_ip() {
    local IP=$1
    if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    fi
    return 1
}

# Validar email
validar_email() {
    local EMAIL=$1
    if [[ $EMAIL =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    fi
    return 1
}

# Uso
read -p "IP: " IP
if validar_ip "$IP"; then
    echo "IP valido: $IP"
else
    echo "IP invalido!"
fi
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Criar e usar funcoes
- [ ] Trabalhar com arrays simples e associativos
- [ ] Usar traps para limpeza e tratamento de sinais
- [ ] Debuggar scripts com `set -x` e `bash -x`
- [ ] Usar expressoes regulares em scripts
- [ ] Manipular substrings
- [ ] Escrever scripts profissionais com template

---

<div align="center">

**⬅️ [Anterior: Bash Basico](08-bash-scripting-basico.md)** | **[Proximo: Vim](10-edicao-vim.md) ➡️**

</div>
