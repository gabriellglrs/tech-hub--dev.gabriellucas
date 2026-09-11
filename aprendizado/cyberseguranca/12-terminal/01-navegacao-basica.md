# Navegacao Basica

> O terminal e como um GPS: voce precisa saber onde esta e onde quer ir. Aqui voce aprende a navegar.

---

## O que e o terminal?

O terminal (tambem chamado de **shell**, **console**, **prompt**) e uma interface de texto onde voce digita comandos para o computador executar. Enquanto no Windows voce clica em icones, no Linux voce digita comandos.

```
Windows:  Clique em Pasta → Clique em Arquivo → Duplo clique
Linux:    cd /pasta → ls → cat arquivo.txt
```

---

## Prompt do Terminal

Quando voce abre o terminal, aparece algo assim:

```
usuario@kali:~$
│    │     │  │└─ Simbolo: $ = usuario normal, # = root
│    │     │  └── Diretorio atual (~ = home)
│    │     └── Nome do computador
│    └── Separador (@)
└── Seu nome de usuario
```

---

## Comandos Essenciais

### pwd — Onde estou?

```bash
pwd
# Saida: /home/usuario
# Mostra o caminho completo do diretorio atual
```

### cd — Mudar de diretorio

```bash
cd /home              # Vai para /home
cd ..                 # Volta uma pasta (pai)
cd ../..              # Volta duas pastas
cd ~                  # Vai pro home (atalho)
cd -                  # Volta pro ultimo diretorio onde voce estava
cd /home/usuario/docs # Vai para caminho absoluto
```

### ls — Listar arquivos

```bash
ls                    # Lista arquivos simples
ls -l                 # Lista com detalhes (permissao, dono, tamanho)
ls -la                # Lista TUDO (incluindo ocultos, que comecam com .)
ls -lh                # Tamanho em formato legivel (KB, MB, GB)
ls -R                 # Lista recursivo (subpastas tambem)
ls -lt                # Ordena por data de modificacao
ls -lS                # Ordena por tamanho
ls *.txt              # Lista apenas arquivos .txt
```

### Saida do `ls -la`

```
drwxr-xr-x  2 usuario usuario 4096 Jan  6 10:00 .
drwxr-xr-x  3 usuario usuario 4096 Jan  6 09:00 ..
-rw-r--r--  1 usuario usuario  123 Jan  6 10:00 arquivo.txt
│           │ │        │      │    │            │
│           │ │        │      │    │            └── Nome
│           │ │        │      │    └── Data
│           │ │        │      └── Tamanho (bytes)
│           │ │        └── Grupo
│           │ └── Dono
│           └── Links (quantas vezes referenciado)
└── Tipo + permissoes (d=folder, -=arquivo, l=link)
```

---

## Caminhos

### Caminho Absoluto

Comeca da raiz (`/`). Funciona de qualquer lugar.

```bash
cd /home/usuario/documentos
# Sempre funciona, nao importa onde voce esta
```

### Caminho Relativo

Comeca do diretorio atual. Mais curto.

```bash
cd documentos
# Vai para /home/usuario/documentos (se voce esta em /home/usuario)
```

### Analogia

```
Caminho absoluto:  Rua das Flores, 123, Sao Paulo, SP
Caminho relativo:  Dois quarteiroes a esquerda

Ambos levam ao mesmo lugar, mas um e mais especifico.
```

---

## Atalhos Essenciais

| Tecla | Funcao |
|:------|:-------|
| `Tab` | Autocompleta comando ou arquivo |
| `Tab Tab` | Mostra todas as opcoes |
| `Ctrl+C` | Cancela o que esta rodando |
| `Ctrl+D` | Sai do terminal |
| `Ctrl+L` | Limpa a tela |
| `Ctrl+A` | Vai pro inicio da linha |
| `Ctrl+E` | Vai pro final da linha |
| `Ctrl+R` | Busca no historico |
| `↑` / `↓` | Navegar no historico |
| `!!` | Repete o ultimo comando |
| `!xyz` | Repete ultimo comando que comeca com xyz |

---

## Historico

```bash
history                   # Mostra todos os comandos usados
history | tail -20        # Ultimos 20 comandos
history | grep "nmap"     # Busca no historico
!123                      # Executa comando numero 123 do historico
```

---

## Exercicios Praticos

### Exercicio 1: Descubra onde esta

```bash
pwd
# Anote o resultado
```

### Exercicio 2: Navegue ate a raiz e volte

```bash
cd /
pwd
# Deve mostrar: /

cd ~
pwd
# Deve mostrar: /home/usuario
```

### Exercicio 3: Liste tudo

```bash
ls -la
# Identifique:
# 1. Quantos arquivos tem?
# 2. Quais sao pastas (d no inicio)?
# 3. Quais sao arquivos (- no inicio)?
```

### Exercicio 4: Use Tab

```bash
# Digite "ls /et" e aperte Tab
# Deve completar para "ls /etc/"
ls /et[Tab]
```

### Exercicio 5: Caminhos

```bash
# Navegue ate /var/log usando caminho absoluto
cd /var/log

# Volte ao home
cd ~

# Navegue ate /var/log usando caminho relativo
cd ../var/log
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Saber onde esta com `pwd`
- [ ] Navegar entre diretorios com `cd`
- [ ] Listar arquivos com `ls` e opcoes
- [ ] Entender a diferenca entre caminho absoluto e relativo
- [ ] Usar Tab para autocompletar
- [ ] Usar atalhos basicos (Ctrl+C, Ctrl+L, Ctrl+R)

---

<div align="center">

**⬅️ [Anterior: README](README.md)** | **[Proximo: Arquivos e Diretorios](02-arquivos-e-diretorios.md) ➡️**

</div>
