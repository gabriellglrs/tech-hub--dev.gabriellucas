# Edicao com Vim

> O Vim e o editor mais poderoso do Linux. Todo servidor tem ele. Aprender Vim e como aprender a andar de bicicleta: dificil no inicio, indispensavel depois.

---

## Por que Vim?

```
Nano: Facil, mas limitado
Vi:   Basico, mas disponivel em TODO servidor
Vim:  Profissional, rapido, extensivel

Quando voce SSH em um servidor remoto e so tem vim:
- Nano nao existe
- Emacs nao existe
- Vim sempre esta la
```

---

## Iniciar e Sair

```bash
vim arquivo.txt             # Abre arquivo
vim                         # Abre vazio
vim +10 arquivo.txt         # Abre na linha 10
```

### Sair

```
:q          Sair
:q!         Sair sem salvar (FORCA)
:w          Salvar
:wq         Salvar e sair
ZZ          Atalho para :wq
ZQ          Atalho para :q!
:x          Salvar e sair (mesmo que :wq)
```

---

## Modos

```
NORMAL:       Navegar e editar (padrao)
INSERT:       Inserir texto (i, a, o)
VISUAL:       Selecionar texto (v, V, Ctrl+v)
COMMAND:      Digitar comandos (:)
```

### Entrar em INSERT

| Tecla | Funcao |
|:------|:-------|
| `i` | Antes do cursor |
| `a` | Depois do cursor |
| `I` | Inicio da linha |
| `A` | Final da linha |
| `o` | Nova linha abaixo |
| `O` | Nova linha acima |

### Voltar para NORMAL

| Tecla | Funcao |
|:------|:-------|
| `Esc` | Volta ao normal |
| `Ctrl+[` | Mesma coisa |

---

## Navegacao Basica

### Setas (evite, use as letras)

| Tecla | Funcao |
|:------|:-------|
| `h` | Esquerda |
| `j` | Baixo |
| `k` | Cima |
| `l` | Direita |

### Palavras

| Tecla | Funcao |
|:------|:-------|
| `w` | Proxima palavra |
| `b` | Palavra anterior |
| `e` | Fim da palavra |

### Linha

| Tecla | Funcao |
|:------|:-------|
| `0` | Inicio da linha |
| `^` | Primeiro caractere nao-espaco |
| `$` | Final da linha |

### Tela

| Tecla | Funcao |
|:------|:-------|
| `gg` | Inicio do arquivo |
| `G` | Final do arquivo |
| `10G` | Linha 10 |
| `Ctrl+f` | Pagina pra baixo |
| `Ctrl+b` | Pagina pra cima |
| `Ctrl+d` | Metade da pagina pra baixo |
| `Ctrl+u` | Metade da pagina pra cima |

---

## Editar

### Deletar

| Tecla | Funcao |
|:------|:-------|
| `x` | Deleta caractere |
| `dd` | Deleta linha |
| `3dd` | Deleta 3 linhas |
| `dw` | Deleta palavra |
| `d$` | Deleta ate final da linha |
| `d0` | Deleta ate inicio da linha |
| `dG` | Deleta ate final do arquivo |

### Copiar e Colar

| Tecla | Funcao |
|:------|:-------|
| `yy` | Copia linha |
| `3yy` | Copia 3 linhas |
| `yw` | Copia palavra |
| `p` | Cola depois do cursor |
| `P` | Cola antes do cursor |

### Substituir

| Tecla | Funcao |
|:------|:-------|
| `r` | Substitui caractere |
| `R` | Substitui varios (modo replace) |
| `s` | Substitui caractere e entra em INSERT |
| `S` | Substitui linha inteira |

### Undo/Redo

| Tecla | Funcao |
|:------|:-------|
| `u` | Desfaz |
| `Ctrl+r` | Refaz |
| `U` | Desfaz todas as mudancas da linha |

---

## Busca e Substituicao

### Busca

```
/pattern      Busca pra frente
?pattern      Busca pra tras
n             Proxima ocorrencia
N             Ocorrencia anterior
*             Busca palavra sob cursor
```

### Substituicao

```
:s/old/new/              Substitui primeira ocorrencia na linha
:s/old/new/g            Substitui todas na linha
:%s/old/new/g           Substitui todas no arquivo
:%s/old/new/gc          Substitui com confirmacao
:%s/old/new/gi          Case insensitive
:5,10s/old/new/g        Substitui linhas 5-10
```

### Exemplo

```bash
# Trocar "foo" por "bar" em todo arquivo
:%s/foo/bar/g

# Trocar com confirmacao
:%s/foo/bar/gc
# y = sim, n = nao, a = todos, q = sair

# Trocar so em linhas selecionadas (modo visual)
# Seleciona com v, depois :
:'<,'>s/old/new/g
```

---

## Visual Mode

```
v       Seleciona caracteres
V       Seleciona linhas
Ctrl+v  Seleciona colunas (blocos)
```

### Exemplo: Comentar varias linhas

```
1. Ctrl+v (modo visual de coluna)
2. j/k para selecionar linhas
3. I (inserir no inicio)
4. Digite #
5. Esc (aplica em todas as linhas)
```

### Exemplo: Deletar coluna

```
1. Ctrl+v
2. Selecione a coluna com setas
3. d (deleta)
```

---

## Macros

### Gravar macro

```
1. q + letra (q a) — comeca a gravar
2. Faz as edicoes
3. q — para de gravar
```

### Executar macro

```
@a      Executa macro gravada em 'a'
10@a    Executa 10 vezes
```

### Exemplo

```
# Adicionar ; no final de 10 linhas
qa           # Gravar em 'a'
A;           # Ir pro final e adicionar ;
Esc          # Voltar ao normal
j            # Proxima linha
q            # Parar de gravar
10@a         # Executar 10 vezes
```

---

## Janela e Split

```
:sp arquivo.txt     Split horizontal
:vsp arquivo.txt    Split vertical
Ctrl+w h            Move pra janela da esquerda
Ctrl+w j            Move pra janela de baixo
Ctrl+w k            Move pra janela de cima
Ctrl+w l            Move pra janela da direita
Ctrl+w w            Alterna entre janelas
Ctrl+w q            Fecha janela atual
```

---

## Configuracao (.vimrc)

```bash
cat > ~/.vimrc << 'EOF'
" Numeros de linha
set number
set relativenumber

" Destaque de sintaxe
syntax on

" Indentacao
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Busca
set hlsearch
set incsearch

" Aparencia
set cursorline
set showmatch
set wildmenu

" Mapeamentos
let mapleader=","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>/ :noh<CR>
EOF
```

---

## Atalhos Essenciais

| Atalho | Funcao |
|:-------|:-------|
| `.` | Repete ultima acao |
| `%` | Vai para parenteses/chave correspondente |
| `>>` | Indenta linha |
| `<<` | Remove indentacao |
| `J` | Junta linhas |
| `~` | Inverte case |
| `Ctrl+a` | Incrementa numero |
| `Ctrl+x` | Decrementa numero |

---

## Exercicios

### Exercicio 1: Basico

```bash
vim teste.txt
# Digite i para entrar em INSERT
# Digite "Hello World"
# Aperte Esc
# Digite :wq para salvar e sair
```

### Exercicio 2: Navegacao

```bash
vim teste.txt
# Use gg para ir pro inicio
# Use G para ir pro final
# Use / para buscar
# Use n para proxima ocorrencia
```

### Exercicio 3: Macro

```bash
vim teste.txt
# Grave uma macro que:
# 1. Vai pro final da linha
# 2. Adiciona ")"
# 3. Vai pra proxima linha
# Execute 5 vezes
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Abrir, salvar e sair do Vim
- [ ] Navegar com h/j/k/l e atalhos
- [ ] Editar: deletar, copiar, colar, substituir
- [ ] Buscar e substituir com :s
- [ ] Usar Visual Mode para edicao em bloco
- [ ] Gravar e executar macros
- [ ] Configurar o Vim com .vimrc

---

<div align="center">

**⬅️ [Anterior: Bash Avancado](09-bash-scripting-avancado.md)** | **[Proximo: Tmux](11-tmux-e-screen.md) ➡️**

</div>
