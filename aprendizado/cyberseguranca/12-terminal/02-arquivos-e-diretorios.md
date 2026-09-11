# Arquivos e Diretorios

> Criar, copiar, mover, deletar — todo arquivo no Linux e manipulado pelo terminal. Aqui voce domina isso.

---

## Criar Arquivos

```bash
touch arquivo.txt              # Cria arquivo vazio
touch file1.txt file2.txt      # Cria varios de uma vez
touch {a,b,c}.txt              # Cria a.txt, b.txt, c.txt
```

### Por que `touch`?

O `touch` cria arquivos vazios ou atualiza a data de modificacao. E o comando mais rapido para criar arquivos.

---

## Criar Diretorios

```bash
mkdir pasta                    # Cria uma pasta
mkdir -p a/b/c/d              # Cria toda a estrutura de uma vez
mkdir {pasta1,pasta2,pasta3}   # Cria varias pastas
```

### O que e `-p`?

O `-p` cria pais automaticamente. Sem ele, se a pasta `a` nao existir, `mkdir a/b/c` da erro.

```
Sem -p:
mkdir a/b/c
# mkdir: cannot create directory 'a/b/c': No such file directory

Com -p:
mkdir -p a/b/c
# Cria a/, depois a/b/, depois a/b/c/ — tudo de uma vez
```

---

## Copiar

### Copiar arquivo

```bash
cp arquivo.txt copia.txt              # Copia arquivo
cp arquivo.txt /backup/               # Copia para pasta
cp arquivo.txt /backup/novo.txt       # Copia com novo nome
cp -r pasta/ /backup/                 # Copia pasta inteira (recursivo)
cp -i arquivo.txt /backup/            # Pergunta antes de sobrescrever
cp -v arquivo.txt /backup/            # Mostra o que esta copiando
```

### Analogia

```
cp e como "Salvar Como" no Word:
- Pega o arquivo original
- Cria uma copia no destino
- Original continua onde estava
```

---

## Mover / Renomear

```bash
mv arquivo.txt /backup/               # Move arquivo
mv arquivo.txt novo_nome.txt          # Renomeia arquivo
mv pasta1/ /home/usuario/             # Move pasta
mv *.txt /backup/                     # Move todos os .txt
```

### IMPORTANTE: `mv` e MOVE e RENOMEIA

```
Renomear:   mv velho.txt novo.txt        # Mesma pasta, nome diferente
Mover:      mv arquivo.txt /backup/       # Pasta diferente, mesmo nome
```

---

## Deletar

```bash
rm arquivo.txt                 # Deleta arquivo
rm -i arquivo.txt              # Pergunta antes de deletar
rm -v arquivo.txt              # Mostra o que deletou
rm -r pasta/                   # Deleta pasta e todo conteudo
rm -rf pasta/                  # Deleta SEM PERGUNTAR (CUIDADO!)
```

### ⚠️ CUIDADO COM `rm -rf`

```
rm -rf /                       # DELETA TUDO DO COMPUTADOR
rm -rf /*                      # MESMA COISA — MORTE CERTA

NUNCA rode rm -rf sem verificar o caminho.
rm -rf e como um botao de autodestruicao — nao tem "desfazer".
```

### Alternativa segura: `trash-cli`

```bash
# Instalar
sudo apt install trash-cli

# Usar (move para lixeira, da para desfazer)
trash arquivo.txt
trash-restore               # Restaura
trash-list                  # Lista arquivos na lixeira
```

---

## Visualizar Conteudo

```bash
cat arquivo.txt              # Mostra tudo de uma vez
less arquivo.txt             # Mostra paginado (setas para navegar, q para sair)
more arquivo.txt             # Similar ao less
head arquivo.txt             # Primeiras 10 linhas
head -20 arquivo.txt         # Primeiras 20 linhas
tail arquivo.txt             # Ultimas 10 linhas
tail -20 arquivo.txt         # Ultimas 20 linhas
tail -f /var/log/syslog      # Mostra em tempo real (log ao vivo!)
```

---

## Criar Arquivos Rapidos

```bash
echo "Hello World" > arquivo.txt        # Cria com conteudo
echo "Linha 2" >> arquivo.txt           # Adiciona linha
echo -e "Linha1\nLinha2\nLinha3" > arq  # Com quebras de linha
cat > arquivo.txt << EOF                # Multilinha
Linha 1
Linha 2
Linha 3
EOF
```

---

## Buscar Arquivos

### find — Busca profunda

```bash
find / -name "arquivo.txt"              # Busca pelo nome exato
find / -name "*.txt"                    # Busca por extensao
find /home -name "*.txt" -type f        # So arquivos (nao pastas)
find /home -name "*.txt" -type d        # So pastas
find . -mtime -7                        # Modificados nos ultimos 7 dias
find . -size +100M                      # Maiores que 100MB
find . -empty                           # Arquivos vazios
find . -name "*.log" -exec rm {} \;     # Deleta todos os .log encontrados
find . -name "*.txt" -exec grep -l "erro" {} \;  # Busca dentro dos arquivos
```

### locate — Busca rapida

```bash
sudo apt install mlocate                # Instalar (se nao tiver)
sudo updatedb                           # Atualiza banco de dados
locate arquivo.txt                      # Busca rapida
locate -i arquivo.txt                   # Case insensitive
```

### Diferenca find vs locate

```
find:   Busca em tempo real, mais lento, mais flexivel
locate: Usa banco de dados pre-compilado, mais rapido

Use find quando precisa de filtros complexos.
Use locate quando so precisa encontrar o caminho.
```

---

## Links (Atalhos)

```bash
# Link simbolico (atalho)
ln -s /caminho/original /caminho/link
ln -s /home/usuario/docs /home/usuario/link_docs

# Link fisico (hard link)
ln /caminho/original /caminho/link
```

### Diferenca

```
Simbolico (ln -s):
- Como um atalho no Windows
- Se deletar o original, o link quebra
- Pode apontar para pastas

Fisico (ln):
- Como uma copia que atualiza automaticamente
- Se deletar o original, o link continua funcionando
- So funciona para arquivos
```

---

## Exercicios Praticos

### Exercicio 1: Estrutura de pastas

```bash
# Crie esta estrutura:
# lab/
# ├── scripts/
# │   ├── scan.sh
# │   └── recon.sh
# ├── resultados/
# │   └── nmap.txt
# └── notas.txt

mkdir -p lab/scripts lab/resultados
touch lab/scripts/scan.sh lab/scripts/recon.sh
touch lab/resultados/nmap.txt lab/notas.txt
```

### Exercicio 2: Copiar e mover

```bash
# Copie scan.sh para scripts/backup/
mkdir -p lab/scripts/backup
cp lab/scripts/scan.sh lab/scripts/backup/

# Renomeie nmap.txt para scan-completo.txt
mv lab/resultados/nmap.txt lab/resultados/scan-completo.txt
```

### Exercicio 3: Deletar com cuidado

```bash
# Crie um arquivo de teste
touch lab/teste.txt

# Deleta com pergunta
rm -i lab/teste.txt

# Deleta a pasta inteira
rm -rf lab/
```

### Exercicio 4: find

```bash
# Crie varios arquivos
touch {a,b,c}.txt
touch {1,2,3}.log

# Encontre todos os .txt
find . -name "*.txt"

# Encontre todos os .log
find . -name "*.log"

# Limpe
rm *.txt *.log
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Criar arquivos com `touch` e `echo`
- [ ] Criar diretorios com `mkdir` e `mkdir -p`
- [ ] Copiar com `cp` e `cp -r`
- [ ] Mover e renomear com `mv`
- [ ] Deletar com `rm` (com cuidado!)
- [ ] Visualizar conteudo com `cat`, `head`, `tail`, `less`
- [ ] Buscar arquivos com `find` e `locate`
- [ ] Criar links com `ln`

---

<div align="center">

**⬅️ [Anterior: Navegacao](01-navegacao-basica.md)** | **[Proximo: Permissoes](03-permissoes-e-usuarios.md) ➡️**

</div>
