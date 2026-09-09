# 🔬 Engenharia Reversa

> Transformar binário em código compreensível. Entender o que o programa faz sem código fonte.

---

## 🚀 Passo a Passo

### Passo 1: Triagem
```bash
file binary
checksec --file=binary  # proteções: NX, PIE, Canary, RELRO
strings binary | grep -i "password\|admin"
rabin2 -I binary        # info do binário
```

### Passo 2: Desassembly (radare2 / r2)
```bash
sudo apt install -y radare2
r2 binary
# Dentro do r2:
aaa        # analisar tudo
afl        # listar funções
pdf @ main # disassembly do main
```

### Passo 3: Decompilação (Ghidra)
```bash
# Abrir no Ghidra → CodeBrowser → decompiler
# Procurar por: strcpy, gets, scanf (vulns), strings sensíveis
# Renomear variáveis, criar comentários
```

### Passo 4: Debug dinâmico (gdb + GEF)
```bash
sudo apt install -y gdb
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"  # GEF
gdb ./binary
gef> break main
gef> run
gef> telescope $rsp
gef> checksec
```

---

## Ferramentas

| Ferramenta | Tipo | Grátis? |
|:---|:---|:---|
| **ghidra** | Decompiler | ✅ NSA open-source |
| **radare2 / rizin** | Framework RE | ✅ |
| **ida free** | Disassembler | Parcial |
| **binary ninja** | Decompiler | Pago |
| **x64dbg** | Debugger Windows | ✅ |

## Dicas

- Comece por `strings` e `ltrace/strace` antes de abrir no Ghidra
- Procure por funções perigosas: `gets, strcpy, sprintf, system`
