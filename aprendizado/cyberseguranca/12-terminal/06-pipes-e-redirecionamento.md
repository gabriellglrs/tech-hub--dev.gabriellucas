# Pipes e Redirecionamento

> Onde o terminal vira poderoso. Pipes conectam comandos como pecas de Lego. Redirecionamento salva resultados em arquivos.

---

## O que sao pipes?

Um **pipe** (`|`) pega a saida de um comando e usa como entrada de outro. E como uma esteira industrial.

```
Sem pipe:
┌──────────────┐
│  cat arquivo │ → resultado na tela
└──────────────┘

Com pipe:
┌──────────────┐    ┌──────────────┐
│  cat arquivo │ →  │ grep "erro"  │ → so as linhas com "erro"
└──────────────┘    └──────────────┘

Com varios pipes:
┌──────┐  ┌───────┐  ┌──────┐  ┌──────┐
│ cat  │→ │ grep  │→ │ cut  │→ │ sort │ → resultado final
└──────┘  └───────┘  └──────┘  └──────┘
```

---

## Exemplos Basicos

```bash
# Listar processos e filtrar
ps aux | grep nginx

# Listar servicos e filtrar ativos
systemctl list-units --type=service | grep active

# Listar arquivos e contar
ls -la | wc -l

# Listar arquivos e ordenar
ls -la | sort -k 5 -rn

# Ver logs e filtrar por data
cat /var/log/syslog | grep "Jan 06"

# Buscar em varios arquivos
find /var/log -name "*.log" | xargs grep "error"
```

---

## Redirecionamento

### Saida

```bash
comando > arquivo.txt          # Sobrescreve arquivo
comando >> arquivo.txt         # Adiciona ao final
```

### Exemplo

```bash
# Sobrescreve
echo "Hello" > arquivo.txt

# Adiciona
echo "World" >> arquivo.txt

# Resultado:
# Hello
# World
```

### Erro

```bash
comando 2> erros.txt           # Salva APENAS erros
comando 2>> erros.txt          # Adiciona erros ao final
comando > saida.txt 2>&1       # Salva TUDO (saida + erro)
comando &> arquivo.txt         # Mesma coisa (atalho)
```

### Descartar

```bash
comando > /dev/null            # Joga saida fora
comando 2> /dev/null           # Joga erro fora
comando &> /dev/null           # Joga tudo fora
```

### Analogia

```
> arquivo.txt   = "Salvar Como" (sobrescreve)
>> arquivo.txt  = "Adicionar ao final"
2> erros.txt    = "Salvar erros separado"
> /dev/null     = "Joga no lixo"
```

---

## tee — Salvar e Mostrar

```bash
comando | tee arquivo.txt              # Mostra E salva
comando | tee -a arquivo.txt           # Mostra E adiciona
comando | tee saida.txt | grep "erro"  # Salva E filtra
```

### Exemplo

```bash
# Scan Nmap: salva em arquivo E mostra na tela
nmap -sV 192.168.1.1 | tee resultado.txt

# Salva em多个 arquivos
nmap -sV 192.168.1.1 | tee saida1.txt | tee saida2.txt
```

---

## xargs — Executar Comandos em Massa

```bash
# Deleta arquivos encontrados
find . -name "*.log" | xargs rm

# Busca em varios arquivos
find . -name "*.txt" | xargs grep "padrao"

# Conta arquivos
find . -type f | xargs wc -l

# Com dry-run (mostra o que faria)
find . -name "*.log" | xargs -p rm
```

### Protecao com aspas

```bash
# Arquivos com espacos no nome
find . -name "*.txt" | xargs -I{} rm "{}"

# Mais seguro
find . -name "*.txt" -print0 | xargs -0 rm
```

---

## Redirecionamento Avancado

### Here Document (heredoc)

```bash
# Criar arquivo multilinha
cat > arquivo.txt << EOF
Linha 1
Linha 2
Linha 3
EOF

# Criar script
cat > script.sh << 'EOF'
#!/bin/bash
echo "Hello World"
EOF
```

### Here String

```bash
# Passar string como entrada
grep "texto" <<< "esta linha tem texto"
```

---

## Combinando Tudo

```bash
# 1. Scan e salvar
nmap -sV 192.168.1.1 | tee scan.txt | grep "open" | tee -a portas_abertas.txt

# 2. Logs: filtrar, ordenar, contar
cat /var/log/syslog | grep "error" | sort | uniq -c | sort -rn | head -10 > erros_frequentes.txt

# 3. Listar e processar
ls -la | awk '{print $5, $9}' | sort -rn | head -10 > maiores_arquivos.txt

# 4. Processar saida do Nmap
nmap -sV 192.168.1.1 | grep "open" | cut -d/ -f1 | sort -n | tee portas.txt
```

---

## DevNull — O Lixo do Linux

```bash
# /dev/null e um dispositivo que descarta tudo
comando > /dev/null           # Descarta saida
comando 2> /dev/null          # Descarta erro
comando &> /dev/null          # Descarta tudo

# Usar em scripts
if comando &> /dev/null; then
    echo "Sucesso"
else
    echo "Falhou"
fi
```

---

## Exercicios Praticos

### Exercicio 1: Pipes basicos

```bash
# 1. Liste processos e conte quantos
ps aux | wc -l

# 2. Liste processos e encontre o bash
ps aux | grep bash

# 3. Liste arquivos e mostre so os maiores
ls -lS | head -5
```

### Exercicio 2: Redirecionamento

```bash
# 1. Salve a saida em arquivo
ls -la > minha_lista.txt

# 2. Adicione mais informacao
echo "Fim da lista" >> minha_lista.txt

# 3. Verifique
cat minha_lista.txt
```

### Exercicio 3: tee

```bash
# 1. Scan e salve
nmap localhost | tee resultado.txt

# 2. Adicione mais um scan
nmap -sV localhost | tee -a resultado.txt
```

### Exercicio 4: Pipelines complexos

```bash
# 1. IPs mais frequentes em logs
cat /var/log/auth.log 2>/dev/null | grep "Failed" | cut -d " " -f 11 | sort | uniq -c | sort -rn | head -5 > suspeitos.txt

# 2. Arquivos modificados hoje
find . -type f -mtime -1 | xargs ls -lh | sort -k 5 -rn
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Usar pipes (`|`) para encadear comandos
- [ ] Redirecionar saida (`>`, `>>`)
- [ ] Redirecionar erro (`2>`, `2>>`)
- [ ] Usar `tee` para salvar E mostrar
- [ ] Usar `xargs` para executar comandos em massa
- [ ] Usar heredoc para criar arquivos multilinha
- [ ] Descartar saida com `/dev/null`
- [ ] Combinar tudo em pipelines complexos

---

<div align="center">

**⬅️ [Anterior: Texto](05-texto-e-manipulacao.md)** | **[Proximo: Redes](07-redes-no-terminal.md) ➡️**

</div>
