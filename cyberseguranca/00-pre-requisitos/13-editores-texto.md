# ✏️ Editores de Texto

> Você vai escrever scripts, editar configurações e modificar arquivos o tempo todo. Precisa dominar pelo menos **um** editor de texto no terminal.

---

## 📚 O que são editores de texto?

São programas para criar e editar arquivos usando o terminal (linha de comando). Diferente do Bloco de Notas do Windows, esses rodam 100% no terminal — essencial para servidores e SSH.

### Por que isso é importante?

- **Configurações ficam em arquivos** — /etc/, ~/.config/, etc.
- **Scripts precisam ser escritos** — bash, python
- **Servidores não têm interface gráfica** — só terminal
- **SSH** — quando conectar remotamente, só terá terminal
- **Logs e configurações** — editar rapidamente

### Como funciona na prática?

```
Terminal
├── nano arquivo.txt    ← Fácil (para iniciantes)
├── vim arquivo.txt     ← Poderoso (para quem já sabe)
└── code arquivo.txt    ← VS Code (se tiver GUI)
```

---

## 📋 Nano (Recomendado para iniciantes)

### Abrir arquivo
```bash
nano arquivo.txt        # Abrir (cria se não existir)
nano /etc/hosts         # Editar arquivo existente
```

### Comandos do Nano

| Tecla | Ação |
|:------|:-----|
| `Ctrl + O` | Salvar |
| `Ctrl + X` | Sair |
| `Ctrl + K` | Recortar linha |
| `Ctrl + U` | Colar linha |
| `Ctrl + W` | Buscar |
| `Ctrl + G` | Ajuda |
| `Ctrl + C` | Mostrar posição do cursor |

### Exemplo prático
```bash
# Criar um script
nano meuscript.sh

# Digitar:
#!/bin/bash
echo "Olá mundo!"
date

# Salvar: Ctrl+O, Enter
# Sair: Ctrl+X
# Rodar: bash meuscript.sh
```

---

## 📋 Vim (Recomendado para avançados)

### Abrir arquivo
```bash
vim arquivo.txt         # Abrir
vim +10 arquivo.txt     # Abrir na linha 10
```

### Modos do Vim

```
┌─────────────────────────────────────────────┐
│  ESC = Voltar ao modo normal                │
│                                             │
│  i = Modo inserir (digitar texto)           │
│  v = Modo visual (selecionar)               │
│  : = Modo comando (salvar, sair, etc.)      │
└─────────────────────────────────────────────┘
```

### Comandos essenciais

| Comando | Ação |
|:--------|:-----|
| `i` | Entrar no modo inserir |
| `ESC` | Voltar ao modo normal |
| `:w` | Salvar |
| `:q` | Sair |
| `:wq` | Salvar e sair |
| `:q!` | Sair sem salvar |
| `dd` | Deletar linha |
| `yy` | Copiar linha |
| `p` | Colar |
| `/termo` | Buscar termo |
| `n` | Próxima ocorrência |

### Exemplo prático
```bash
vim meuscript.sh

# Digitar i (inserir)
#!/bin/bash
echo "Olá!"
date

# ESC para modo normal
:wq para salvar e sair
```

---

## 📋 Edição rápida (sem abrir editor)

```bash
# Adicionar linha ao final
echo "nova linha" >> arquivo.txt

# Sobrescrever arquivo
echo "conteúdo" > arquivo.txt

# Substituir texto
sed -i 's/antigo/novo/g' arquivo.txt

# Ver linha específica
sed -n '10p' arquivo.txt     # Linha 10
head -20 arquivo.txt         # Primeiras 20 linhas
tail -20 arquivo.txt         # Últimas 20 linhas
```

---

## 🎯 Exercícios Práticos

### Exercício 1: Criar arquivo com nano
```bash
nano teste.txt
# Digite "Olá, estou aprendendo!"
# Ctrl+O, Enter, Ctrl+X
cat teste.txt   # Verificar
```

### Exercício 2: Criar script bash
```bash
nano boas-vindas.sh
#!/bin/bash
echo "Bem-vindo, $USER!"
echo "Data: $(date)"
echo "IP: $(hostname -I)"
# Ctrl+O, Enter, Ctrl+X
chmod +x boas-vindas.sh
./boas-vindas.sh
```

### Exercício 3: Editar com vim
```bash
vim teste.txt
# i → digitar "Editado com vim"
# ESC → :wq
cat teste.txt
```

---

## 💡 Qual usar?

| Editor | Quando usar |
|:-------|:------------|
| **Nano** | Iniciantes, edição rápida, SSH |
| **Vim** | Avançados, scripts longos, produtividade |
| **VS Code** | Desenvolvimento local (tem GUI) |

> **Dica:** Comece com Nano. Quando estiver confortável, migre para Vim.

---

## ✅ Checkpoint

- [ ] Consigo criar e editar arquivos com nano
- [ ] Consigo salvar e sair do nano
- [ ] Consigo usar vim no modo básico (i, ESC, :wq)
- [ ] Consigo adicionar conteúdo com `echo >>`
- [ ] Consigo criar um script e rodar

---

<div align="center">

**⬅️ [Anterior: Comandos de Rede](12-comandos-rede.md)** | **[Voltar ao README](README.md)**

</div>
