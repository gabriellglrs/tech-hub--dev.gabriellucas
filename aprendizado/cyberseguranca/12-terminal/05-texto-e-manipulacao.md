# Texto e Manipulacao

> Logs, configuracoes, saidas de ferramentas — tudo e texto. Saber manipular texto e o diferencial do profissional.

---

## cat — Visualizar

```bash
cat arquivo.txt            # Mostra tudo
cat -n arquivo.txt         # Numerado
cat -b arquivo.txt         # Numerado (so linhas nao vazias)
cat -A arquivo.txt         # Mostra caracteres especiais
cat arquivo1.txt arquivo2.txt  # Concatena arquivos
```

---

## head e tail — Inicio e Fim

```bash
head arquivo.txt           # Primeiras 10 linhas
head -20 arquivo.txt       # Primeiras 20 linhas
head -c 100 arquivo.txt    # Primeiros 100 caracteres
tail arquivo.txt           # Ultimas 10 linhas
tail -20 arquivo.txt       # Ultimas 20 linhas
tail -f /var/log/syslog    # Acompanha em tempo real (logs)
```

### Exemplo pratico

```bash
# Acompanhar logs de autenticacao
tail -f /var/log/auth.log

# Vai mostrar novas linhas conforme elas aparecem
# Ctrl+C para parar
```

---

## less e more — Paginacao

```bash
less arquivo.txt           # Navega com setas, q para sair
more arquivo.txt           # Espaco para avancar, q para sair
```

### Atalhos do less

| Tecla | Funcao |
|:------|:-------|
| `q` | Sair |
| `↑↓` | Navegar linha por linha |
| `Espaco` | Proxima pagina |
| `b` | Pagina anterior |
| `/texto` | Buscar |
| `n` | Proxima ocorrencia |
| `N` | Ocorrencia anterior |
| `g` | Inicio do arquivo |
| `G` | Final do arquivo |

---

## grep — Filtrar

```bash
grep "texto" arquivo.txt              # Busca simples
grep -i "texto" arquivo.txt           # Case insensitive
grep -r "texto" /pasta/              # Busca recursiva
grep -n "texto" arquivo.txt           # Mostra numero da linha
grep -c "texto" arquivo.txt           # Conta ocorrencias
grep -v "texto" arquivo.txt           # Mostra linhas que NAO tem "texto"
grep -l "texto" /pasta/*.txt          # Mostra apenas nomes dos arquivos
grep -A 2 "texto" arquivo.txt         # Mostra 2 linhas depois
grep -B 2 "texto" arquivo.txt         # Mostra 2 linhas antes
grep -E "regex" arquivo.txt           # Expressao regular
grep -w "word" arquivo.txt           # Palavra exata
```

### Expressoes Regulares comuns

```bash
# Buscar IP
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" arquivo.txt

# Buscar email
grep -E "[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+" arquivo.txt

# Buscar data
grep -E "[0-9]{2}/[0-9]{2}/[0-9]{4}" arquivo.txt
```

### Analogia

```
grep e como um Ctrl+F do terminal:
- Voce digita o que quer
- Ele mostra so as linhas que tem
- Mais poderoso que o Ctrl+F (aceita regex)
```

---

## cut — Colunas

```bash
cut -d ":" -f 1 /etc/passwd           # Separa por ":" e pega coluna 1
cut -d "," -f 2 arquivo.csv           # Separa por "," e pega coluna 2
cut -c 1-10 arquivo.txt               # Pega caracteres 1-10
cut -d ":" -f 1,3 /etc/passwd         # Pega colunas 1 e 3
```

### Exemplo pratico

```bash
# Lista de usuarios
cut -d ":" -f 1 /etc/passwd
# root
# daemon
# bin
# sys
# usuario

# IPs de um log
grep "Failed" /var/log/auth.log | cut -d " " -f 11
# 192.168.1.100
# 10.0.0.50
```

---

## sort — Ordenar

```bash
sort arquivo.txt                      # Ordena alfabetico
sort -r arquivo.txt                   # Invertido (Z-A)
sort -n arquivo.txt                   # Numericamente
sort -u arquivo.txt                   # Remove duplicatas
sort -k 2 arquivo.txt                 # Ordena pela coluna 2
sort -t: -k 3 /etc/passwd            # Ordena pela coluna 3 usando ":" como separador
```

---

## uniq — Remover Duplicatas

```bash
uniq arquivo.txt                      # Remove duplicatas CONSECUTIVAS
sort arquivo.txt | uniq               # Remove todas as duplicatas
sort arquivo.txt | uniq -c            # Conta cada ocorrencia
sort arquivo.txt | uniq -d            # Mostra so duplicatas
```

### Exemplo pratico

```bash
# Descobrir IPs mais frequentes em um log
cat /var/log/auth.log | grep "Failed" | cut -d " " -f 11 | sort | uniq -c | sort -rn | head -10
# 145 192.168.1.100
#  89 10.0.0.50
#  23 172.16.0.1
```

---

## awk — Colunas e Padroes

```bash
awk '{print $1}' arquivo.txt                    # Pega coluna 1
awk -F: '{print $1, $3}' /etc/passwd            # Separa por ":" e pega 1 e 3
awk '{print NR, $0}' arquivo.txt                 # Numerado
awk '/padrao/ {print}' arquivo.txt               # Filtra linhas
awk '$3 > 100 {print}' arquivo.txt               # Coluna 3 maior que 100
```

### Exemplo pratico

```bash
# Lista de usuarios com UID > 1000
awk -F: '$3 >= 1000 {print $1}' /etc/passwd
# usuario
# nobody

# Extrair IPs de um log
awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -rn | head
```

---

## sed — Substituir e Editar

```bash
sed 's/antigo/novo/' arquivo.txt                # Substitui primeira ocorrencia
sed 's/antigo/novo/g' arquivo.txt               # Substitui TODAS
sed -i 's/antigo/novo/g' arquivo.txt            # Salva no arquivo (-i)
sed '3d' arquivo.txt                            # Deleta linha 3
sed '2,5d' arquivo.txt                          # Deleta linhas 2-5
sed -n '5,10p' arquivo.txt                      # Mostra linhas 5-10
sed '/padrao/d' arquivo.txt                      # Deleta linhas com padrao
sed 's/.*/    &/' arquivo.txt                   # Indenta todas as linhas
```

### Exemplo pratico

```bash
# Trocar URL em um arquivo de config
sed -i 's/https://old.com/https://new.com/g' config.txt

# Deletar linhas em branco
sed '/^$/d' arquivo.txt

# Extrair IP de um log
sed -n 's/.*from \([0-9.]*\).*/\1/p' /var/log/auth.log
```

---

## wc — Contar

```bash
wc arquivo.txt                        # Linhas, palavras, caracteres
wc -l arquivo.txt                     # So linhas
wc -w arquivo.txt                     # So palavras
wc -c arquivo.txt                     # So caracteres
wc -m arquivo.txt                     # So caracteres (com multibyte)
```

### Exemplo pratico

```bash
# Contar linhas de um log
wc -l /var/log/syslog
# 45678 /var/log/syslog

# Contar resultados
nmap -sV 192.168.1.1 | grep "open" | wc -l
# 5
```

---

## tr — Traduzir Caracteres

```bash
tr 'a-z' 'A-Z' < arquivo.txt         # Caixa alta
tr -d '\r' < arquivo.txt             # Remove retorno de carro
tr -s ' ' < arquivo.txt              # Remove espacos extras
tr ':' '\n' < /etc/passwd            # Troca ":" por quebra de linha
```

---

## Exercicios Praticos

### Exercicio 1: Analise de log

```bash
# Crie um log de teste
cat > log.txt << EOF
2024-01-06 10:00:00 INFO Conexao estabelecida
2024-01-06 10:01:00 ERROR Falha na autenticacao
2024-01-06 10:02:00 INFO Login realizado
2024-01-06 10:03:00 ERROR Timeout
2024-01-06 10:04:00 INFO Desconectado
EOF

# 1. Mostre apenas linhas com ERROR
grep "ERROR" log.txt

# 2. Conte quantos erros
grep -c "ERROR" log.txt

# 3. Mostre apenas o horario dos erros
grep "ERROR" log.txt | cut -d " " -f 2

# 4. Mostre a primeira e ultima linha
head -1 log.txt
tail -1 log.txt
```

### Exercicio 2: Manipulacao

```bash
# Crie uma lista
cat > usuarios.txt << EOF
alice:1001:admin
bob:1002:user
charlie:1003:user
EOF

# 1. Extraia so os nomes
cut -d: -f1 usuarios.txt

# 2. Extraia so os UIDs
cut -d: -f2 usuarios.txt

# 3. Ordene
sort usuarios.txt

# 4. Conte linhas
wc -l usuarios.txt
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Visualizar arquivos com `cat`, `head`, `tail`, `less`
- [ ] Filtrar com `grep` (basico e regex)
- [ ] Extrair colunas com `cut`
- [ ] Ordenar com `sort`
- [ ] Remover duplicatas com `uniq`
- [ ] Manipular com `awk` e `sed`
- [ ] Contar com `wc`

---

<div align="center">

**⬅️ [Anterior: Processos](04-processos-e-servicos.md)** | **[Proximo: Pipes](06-pipes-e-redirecionamento.md) ➡️**

</div>
