# Bash Scripting — Basico

> Scripts transformam comandos repetitivos em automatizados. Aqui voce aprende a criar seus primeiros scripts.

---

## O que e um script?

Um script e um arquivo de texto com comandos que o computador executa em sequencia. E como uma receita de culinaria: voce escreve os passos e o computador segue.

```bash
#!/bin/bash
# Meu primeiro script
echo "Hello World!"
echo "Hoje e $(date)"
```

---

## Criar e Rodar

### Criar

```bash
cat > hello.sh << 'EOF'
#!/bin/bash
echo "Hello World!"
EOF
```

### Tornar executavel

```bash
chmod +x hello.sh
```

### Rodar

```bash
./hello.sh                 # Roda o script
bash hello.sh              # Roda sem ser executavel
source hello.sh            # Roda no shell atual
. hello.sh                 # Mesma coisa
```

---

## Variaveis

### Definir

```bash
NOME="Joao"
IDADE=25
ENDERECO="/home/joao"
DATA=$(date)               # Comando dentro de variavel
ARQUIVOS=$(ls | wc -l)
```

### ⚠️ Regra

```
NOME = "Joao"     # ERRADO (espaços ao redor do =)
NOME="Joao"       # CERTO
```

### Usar

```bash
echo $NOME                 # Joao
echo "Meu nome e $NOME"    # Meu nome e Joao
echo "${NOME}_backup"       # Joao_backup (chaves delimitam)
echo $NOME                 # Joao
```

### Variaveis Especiais

| Variavel | Significado |
|:---------|:------------|
| `$0` | Nome do script |
| `$1`, `$2`, `$3` | Argumentos |
| `$#` | Quantidade de argumentos |
| `$@` | Todos os argumentos |
| `$?` | Codigo de retorno do ultimo comando |
| `$$` | PID do script |
| `$!` | PID do ultimo processo em background |

---

## Argumentos

```bash
#!/bin/bash
echo "Script: $0"
echo "Primeiro arg: $1"
echo "Segundo arg: $2"
echo "Todos: $@"
echo "Quantidade: $#"
```

### Rodar

```bash
./script.sh arg1 arg2
# Script: ./script.sh
# Primeiro arg: arg1
# Segundo arg: arg2
# Todos: arg1 arg2
# Quantidade: 2
```

---

## Ler do Usuario

```bash
#!/bin/bash
echo -n "Digite seu nome: "
read NOME
echo "Ola, $NOME!"
```

### Ler com prompt

```bash
read -p "IP do alvo: " IP
read -s -p "Senha: " SENHA          # Sem mostrar na tela
read -t 10 -p "Pressione Enter..."   # Timeout 10s
```

---

## Condicionais IF

### Sintaxe

```bash
if [ condicao ]; then
    # codigo se verdadeiro
elif [ condicao2 ]; then
    # codigo se condicao2
else
    # codigo se falso
fi
```

### Comparacoes

| Operador | Significado |
|:---------|:------------|
| `-eq` | Igual (numeros) |
| `-ne` | Diferente |
| `-gt` | Maior |
| `-lt` | Menor |
| `-ge` | Maior ou igual |
| `-le` | Menor ou igual |
| `=` | Igual (strings) |
| `!=` | Diferente (strings) |
| `-z` | String vazia |
| `-n` | String nao vazia |
| `-f` | Arquivo existe |
| `-d` | Diretorio existe |
| `-r` | Arquivo e legivel |
| `-w` | Arquivo e gravavel |
| `-x` | Arquivo e executavel |

### Exemplo

```bash
#!/bin/bash
IDADE=25

if [ $IDADE -ge 18 ]; then
    echo "Maior de idade"
else
    echo "Menor de idade"
fi
```

### Comando test

```bash
# Mesma coisa
if test $IDADE -ge 18; then
    echo "Maior de idade"
fi
```

---

## Loops

### for

```bash
# Lista
for FRUTA in "Maca" "Banana" "Laranja"; do
    echo "Fruta: $FRUTA"
done

# Numeros
for i in {1..10}; do
    echo "Numero: $i"
done

# Com passo
for i in {0..100..5}; do
    echo "Numero: $i"
done

# Arquivos
for ARQ in *.txt; do
    echo "Arquivo: $ARQ"
done

# Comando
for USUARIO in $(cat /etc/passwd | cut -d: -f1); do
    echo "Usuario: $USUARIO"
done

# C-style
for ((i=0; i<10; i++)); do
    echo "Numero: $i"
done
```

### while

```bash
# Enquanto condicao for verdadeira
CONTADOR=0
while [ $CONTADOR -lt 5 ]; do
    echo "Contador: $CONTADOR"
    CONTADOR=$((CONTADOR + 1))
done

# Ler arquivo linha por linha
while read LINHA; do
    echo "Linha: $LINHA"
done < arquivo.txt

# Sempre verdadeiro (loop infinito)
while true; do
    echo "Rodando..."
    sleep 1
done
```

### until

```bash
# Enquanto condicao for FALSA
CONTADOR=0
until [ $CONTADOR -ge 5 ]; do
    echo "Contador: $CONTADOR"
    CONTADOR=$((CONTADOR + 1))
done
```

### break e continue

```bash
# break — sai do loop
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break                    # Sai quando i=5
    fi
    echo $i
done

# continue — pula pro proximo
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        continue                 # Pula i=5
    fi
    echo $i
done
```

---

## Case

```bash
#!/bin/bash
echo "Escolha uma opcao:"
echo "1) Scan"
echo "2) Recon"
echo "3) Sair"

read OPCAO

case $OPCAO in
    1)
        echo "Iniciando scan..."
        ;;
    2)
        echo "Iniciando recon..."
        ;;
    3)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opcao invalida!"
        ;;
esac
```

---

## Operacoes Aritmeticas

```bash
# Soma
RESULTADO=$((5 + 3))
echo $RESULTADO            # 8

# Subtracao
RESULTADO=$((10 - 4))

# Multiplicacao
RESULTADO=$((3 * 7))

# Divisao
RESULTADO=$((20 / 4))

# Modulo
RESULTADO=$((10 % 3))

# Incremento
CONTADOR=0
CONTADOR=$((CONTADOR + 1))
# Ou
((CONTADOR++))
```

---

## Exemplo Completo

```bash
#!/bin/bash

# Script de scan basico
# Uso: ./scan.sh <ip>

# Verificar argumento
if [ $# -eq 0 ]; then
    echo "Uso: $0 <ip>"
    echo "Exemplo: $0 192.168.1.1"
    exit 1
fi

IP=$1

# Verificar se IP e valido
if ! [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERRO: IP invalido!"
    exit 1
fi

echo "=== Scan de $IP ==="
echo ""

# Ping
echo "[*] Testando conectividade..."
if ping -c 1 -W 2 $IP &> /dev/null; then
    echo "[+] Host ativo!"
else
    echo "[-] Host inativo"
    exit 1
fi

# Nmap
echo "[*] Rodando Nmap..."
nmap -sV $IP | tee scan_$IP.txt

echo ""
echo "[+] Scan salvo em scan_$IP.txt"
```

---

## Dicas

> **Shebang:** Sempre comece com `#!/bin/bash`

> **Aspas:** Use `"variavel"` quando a variavel pode ter espacos

> **Debug:** Use `bash -x script.sh` para ver cada linha sendo executada

> **Retorno:** `$?` mostra se o ultimo comando deu certo (0) ou erro (diferente de 0)

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Criar e rodar scripts bash
- [ ] Definir e usar variaveis
- [ ] Ler argumentos e entrada do usuario
- [ ] Usar IF/ELSE para condicionais
- [ ] Usar loops (for, while, until)
- [ ] Usar case para menu
- [ ] Fazer operacoes aritmeticas
- [ ] Escrever scripts completos

---

<div align="center">

**⬅️ [Anterior: Redes](07-redes-no-terminal.md)** | **[Proximo: Bash Avancado](09-bash-scripting-avancado.md) ➡️**

</div>
