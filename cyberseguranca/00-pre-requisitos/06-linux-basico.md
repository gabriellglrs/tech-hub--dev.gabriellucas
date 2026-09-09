# 🐧 Linux Básico

> **Todo** profissional de cybersegurança usa Linux. As ferramentas (Nmap, Hydra, Wireshark) rodam em Linux. Aqui você aprende o mínimo necessário para começar.

---

## 🏠 Analogia

```
Windows: Interface gráfica (clique em tudo)
Linux:   Terminal (digite comandos)

É como a diferença entre:
- Pedir comida num restaurante com cardápio (Windows)
- Cozinhar você mesmo (Linux) — mais controle, mais poder
```

---

## 📂 Sistema de Arquivos

```
/                    ← Raiz (tudo começa aqui)
├── home/            ← Usuários (sua pasta pessoal)
│   └── usuario/     ← Sua pasta
├── etc/             ← Configurações do sistema
├── var/             ← Logs e dados variáveis
│   └── log/         ← Logs do sistema
├── tmp/             ← Arquivos temporários
├── usr/             ← Programas instalados
│   └── bin/         ← Executáveis
├── opt/             ← Programas de terceiros
└── root/            ← Home do root (admin)
```

---

## 🔧 Comandos Essenciais

### Navegação
```bash
pwd                 # Mostra onde você está
ls                  # Lista arquivos da pasta
ls -la              # Lista TUDO (incluindo ocultos)
cd /home            # Muda de pasta
cd ..               # Volta uma pasta
cd ~                # Vai pro home
```

### Arquivos
```bash
touch arquivo.txt       # Cria arquivo vazio
mkdir pasta             # Cria pasta
cp arquivo.txt copia.txt   # Copia arquivo
mv arquivo.txt novo.txt    # Move/renomeia
rm arquivo.txt            # Deleta arquivo
rm -r pasta               # Deleta pasta com conteúdo
cat arquivo.txt           # Mostra conteúdo
nano arquivo.txt          # Edita arquivo
```

### Permissões
```bash
ls -la
# -rw-r--r-- 1 usuario usuario 1234 Jan 1 10:00 arquivo.txt
#  │││  │││  │
#  │││  │││  └── Outro (outros usuários)
#  │││  │└───── Grupo
#  │││  └────── Dono (usuário)
#  │└────────── Tipo (d=folder, -=arquivo)
#  └─────────── Permissões (r=read, w=write, x=execute)

chmod +x script.sh      # Dá permissão de execução
chmod 777 arquivo.txt   # Todos podem fazer tudo (PERIGOSO!)
chmod 644 arquivo.txt   # Dono lê/escreve, outros só leem
```

### Processos
```bash
ps aux              # Lista processos rodando
top                 # Processos em tempo real
htop                # Versão melhorada do top
kill 1234           # Mata processo pelo PID
killall firefox     # Mata todos os processos "firefox"
```

### Rede
```bash
ip addr show        # Ver IPs
ip route show       # Ver rotas
ping 8.8.8.8        # Testar conectividade
ifconfig            # Ver interface (legado)
```

### Instalação de Programas
```bash
sudo apt update                 # Atualiza lista de pacotes
sudo apt install nmap           # Instala programa
sudo apt remove nmap            # Remove programa
sudo apt upgrade                # Atualiza tudo
```

### Busca
```bash
find / -name "arquivo.txt"      # Busca arquivo pelo nome
locate arquivo.txt              # Busca rápida
grep "texto" arquivo.txt        # Busca dentro do arquivo
```

---

## 👤 Usuários e Grupos

```bash
whoami                  # Quem é você
id                      # UID, GID, grupos
sudo comando            # Roda como admin (root)
su - usuario            # Muda de usuário
passwd                  # Muda senha
```

---

## 📝 Exercícios Práticos

### Exercício 1: Navegação
```bash
# 1. Veja onde está
pwd

# 2. Vá para o home
cd ~

# 3. Crie uma pasta "lab"
mkdir lab

# 4. Vá para a pasta
cd lab

# 5. Crie um arquivo
touch teste.txt

# 6. Liste
ls -la
```

### Exercício 2: Edição
```bash
# 1. Crie um arquivo com conteúdo
echo "Olá mundo" > hello.txt

# 2. Veja o conteúdo
cat hello.txt

# 3. Edite com nano
nano hello.txt
# (digite algo, Ctrl+X, Y, Enter para salvar)
```

### Exercício 3: Permissões
```bash
# 1. Crie um script
echo '#!/bin/bash' > script.sh
echo 'echo "Hello!"' >> script.sh

# 2. Tente executar (vai dar erro)
./script.sh

# 3. Dê permissão
chmod +x script.sh

# 4. Execute novamente
./script.sh
```

---

## 💡 Dicas

> **`sudo`** = "faça como admin" — quase tudo no pentest precisa de sudo

> **`man comando`** = manual do comando — sempre disponível

> **Tab** = autocompleta — use sempre!

> **Ctrl+C** = cancela o que está rodando

---

## ✅ Checkpoint

- [ ] Consigo navegar no terminal (cd, ls, pwd)
- [ ] Consigo criar/editar/deletar arquivos
- [ ] Entendo permissões (chmod)
- [ ] Consigo instalar programas com apt
- [ ] Sei usar sudo

---

<div align="center">

**⬅️ [Anterior: TCP/IP e OSI](05-tcp-ip-osi.md)** | **[Próximo: HTTP e Web] ➡️**

</div>