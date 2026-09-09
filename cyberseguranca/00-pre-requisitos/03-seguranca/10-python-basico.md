# 🐍 Python Básico

> **Python** é a linguagem mais usada em cybersegurança. Você não precisa ser programador, mas precisa o básico para automatizar tarefas e entender ferramentas.

## 📚 O que é Python e por que importa?

**Python** é uma linguagem de programação versátil e fácil de aprender. É a linguagem mais usada em cybersegurança para automação, scripts e desenvolvimento de ferramentas.

### Por que isso é importante?

- **Automação** — scripts para scanear portas, quebrar senhas, coletar dados
- **Ferramentas** — Metasploit, Scapy, requests são Python
- **Exploits** — muitos exploits são escritos em Python
- **Web scraping** — coletar informações automaticamente
- **APIs** — interagir com serviços e sistemas

### Como funciona na prática?

```python
# Script simples de scan de porta
import socket

def scan(ip, porta):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    resultado = sock.connect_ex((ip, porta))
    sock.close()
    return resultado == 0

# Uso
if scan("192.168.1.1", 80):
    print("Porta 80 ABERTA!")
```

Para usar Python em segurança, você precisa saber:
- **Variáveis e tipos** — strings, inteiros, listas
- **Condicionais** — if/else
- **Laços** — for, while
- **Funções** — organizar código
- **Bibliotecas** — socket, requests, hashlib
- **Arquivos** — ler e escrever dados

---

## 🏠 Analogia

```
Python é como uma calculadora avançada:
- Digite comandos
- Ela executa
- Resultado aparece

Diferente de C/C++, Python é:
- Fácil de ler
- Rápido de escrever
- Flexível
```

---

## 🔧 Como rodar Python

### Instalar
```bash
# Linux (já vem instalado)
python3 --version

# Windows
# Baixe de: https://www.python.org/downloads/
```

### Rodar
```bash
# Terminal (interativo)
python3

# Ou salvar em arquivo e rodar
python3 script.py
```

---

## 📝 Conceitos Básicos

### Variáveis
```python
nome = "João"          # String (texto)
idade = 25             # Integer (inteiro)
altura = 1.75          # Float (decimal)
ativo = True           # Boolean (verdadeiro/falso)
```

### Print (mostrar na tela)
```python
print("Olá mundo!")
print("Meu nome é", nome)
print(f"Tenho {idade} anos")  # f-string (recomendado)
```

### Input (receber dados)
```python
senha = input("Digite sua senha: ")
print(f"Você digitou: {senha}")
```

### Condições (if/else)
```python
senha = input("Digite a senha: ")

if senha == "1234":
    print("Acesso liberado!")
else:
    print("Senha incorreta!")
```

### Laços (loops)
```python
# For - repetir X vezes
for i in range(5):
    print(f"Tentativa {i+1}")

# While - enquanto condição for verdadeira
tentativas = 0
while tentativas < 3:
    senha = input("Senha: ")
    if senha == "1234":
        print("Acesso!")
        break
    tentativas += 1
```

### Listas
```python
# Lista de ferramentas
ferramentas = ["nmap", "hydra", "sqlmap"]

# Adicionar
ferramentas.append("burp")

# Percorrer
for ferramenta in ferramentas:
    print(f"Instalando {ferramenta}")
```

### Funções
```python
def verificar_porta(ip, porta):
    """Verifica se uma porta está aberta"""
    print(f"Testando {ip}:{porta}")
    return True

# Usar
verificar_porta("192.168.1.1", 80)
```

---

## 🔐 Scripts Úteis para Segurança

### Verificador de Senha
```python
import hashlib

def hash_senha(senha):
    """Cria hash MD5 de uma senha"""
    return hashlib.md5(senha.encode()).hexdigest()

senha = input("Digite a senha: ")
print(f"Hash: {hash_senha(senha)}")
```

### Scanner de Portas Simples
```python
import socket

def scan_porta(ip, porta):
    """Verifica se uma porta está aberta"""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    resultado = sock.connect_ex((ip, porta))
    sock.close()
    return resultado == 0

# Testar
ip = input("IP: ")
porta = int(input("Porta: "))

if scan_porta(ip, porta):
    print(f"Porta {porta} ABERTA")
else:
    print(f"Porta {porta} FECHADA")
```

### Leitor de Arquivo
```python
# Ler wordlist
with open("senhas.txt", "r") as arquivo:
    for linha in arquivo:
        senha = linha.strip()
        print(f"Testando: {senha}")
```

---

## 📦 Bibliotecas Úteis

| Biblioteca | O que faz | Para que serve |
|:-----------|:----------|:---------------|
| **socket** | Conexões de rede | Scanners, clientes |
| **requests** | HTTP requests | Web scraping, APIs |
| **hashlib** | Hashes de senhas | Cracking, verificação |
| **os** | Comandos do sistema | Automação |
| **subprocess** | Rodar comandos | Executar nmap, etc |
| **paramiko** | SSH | Acesso remoto |
| **scapy** | Pacotes de rede | Sniffing, crafting |

---

## 📝 Exercícios

### Exercício 1: Calculadora
```python
# Faça uma calculadora que soma dois números
num1 = float(input("Número 1: "))
num2 = float(input("Número 2: "))
print(f"Soma: {num1 + num2}")
```

### Exercício 2: Verificador de IP
```python
# Verifique se um IP é válido
ip = input("Digite um IP: ")
partes = ip.split(".")

if len(partes) == 4:
    print("IP válido!")
else:
    print("IP inválido!")
```

### Exercício 3: Gerador de Senha
```python
import random
import string

def gerar_senha(tamanho=12):
    """Gera senha aleatória"""
    caracteres = string.ascii_letters + string.digits + string.punctuation
    senha = ''.join(random.choice(caracteres) for _ in range(tamanho))
    return senha

print(f"Senha gerada: {gerar_senha()}")
```

---

## ✅ Checkpoint

- [ ] Consigo instalar e rodar Python
- [ ] Sei criar variáveis e funções
- [ ] Consigo usar if/else e loops
- [ ] Consigo ler e escrever arquivos
- [ ] Consigo criar um script simples

---

<div align="center">

**⬅️ [Anterior: Conceitos de Segurança](../03-seguranca/09-conceitos-seguranca.md)** | **[Próximo: Windows Básico](../03-seguranca/11-windows-basico.md) ➡️**

</div>