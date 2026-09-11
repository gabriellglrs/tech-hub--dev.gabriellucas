# Linux Basico

> Todo profissional de cyberseguranca usa Linux. As ferramentas (Nmap, Hydra, Wireshark) rodam em Linux. Aqui voce aprende o minimo necessario para comecar.

---

## O que e Linux e por que importa?

**Linux** e um sistema operacional open source (codigo aberto) usado em servidores, smartphones, cloud e **cyberseguranca**. Enquanto o Windows tem interface grafica, no Linux voce usa o **terminal** (linha de comando).

### Por que isso e importante?

- **Todas as ferramentas de seguranca** rodam em Linux (Nmap, Metasploit, Burp, Hydra...)
- **Kali Linux** e a distribuicao padrao para pentest
- **Servidores web** rodam Linux (90%+ dos servidores do mundo)
- **Automacao** — scripts bash economizam horas de trabalho
- **Nao tem como ser bom em seguranca sem saber Linux**

---

## Analogia

```
Windows: Interface grafica (clique em tudo)
Linux:   Terminal (digite comandos)

E como a diferenca entre:
- Pedir comida num restaurante com cardapio (Windows)
- Cozinhar voce mesmo (Linux) — mais controle, mais poder
```

---

## Sistema de Arquivos

```
/                    ← Raiz (tudo comeca aqui)
├── home/            ← Usuarios (sua pasta pessoal)
│   └── usuario/     ← Sua pasta
├── etc/             ← Configuracoes do sistema
├── var/             ← Logs e dados variaveis
│   └── log/         ← Logs do sistema
├── tmp/             ← Arquivos temporarios
├── usr/             ← Programas instalados
│   └── bin/         ← Executaveis
├── opt/             ← Programas de terceiros
└── root/            ← Home do root (admin)
```

---

## Comandos Essenciais

### Navegacao

```bash
pwd                 # Mostra onde voce esta
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
rm -r pasta               # Deleta pasta com conteudo
cat arquivo.txt           # Mostra conteudo
nano arquivo.txt          # Edita arquivo
```

### Permissoes

```bash
ls -la
# -rw-r--r-- 1 usuario usuario 1234 Jan 1 10:00 arquivo.txt
#  │││  │││  │
#  │││  │││  └── Outro (outros usuarios)
#  │││  │└───── Grupo
#  │││  └────── Dono (usuario)
#  │└────────── Tipo (d=folder, -=arquivo)
#  └─────────── Permissoes (r=read, w=write, x=execute)

chmod +x script.sh      # Da permissao de execucao
chmod 777 arquivo.txt   # Todos podem fazer tudo (PERIGOSO!)
chmod 644 arquivo.txt   # Dono le/escreve, outros so leem
```

### Busca

```bash
find / -name "arquivo.txt"      # Busca arquivo pelo nome
locate arquivo.txt              # Busca rapida
grep "texto" arquivo.txt        # Busca dentro do arquivo
```

### Instalacao de Programas

```bash
sudo apt update                 # Atualiza lista de pacotes
sudo apt install nmap           # Instala programa
sudo apt remove nmap            # Remove programa
sudo apt upgrade                # Atualiza tudo
```

---

## Servicos e systemctl (CRITICO)

> Voce ja viu o que e um servico no arquivo de Portas. Agora vamos aprender a GERENCIAR servicos no Linux.

### O que e systemctl?

**systemctl** e o comando para gerenciar servicos (iniciar, parar, verificar status, habilitar no boot).

### Comandos essenciais

```bash
# Verificar status de um servico
systemctl status sshd
# Saida exemplo:
# ● sshd.service - OpenBSD Secure Shell server
#      Loaded: loaded (/lib/systemd/system/sshd.service; enabled)
#      Active: active (running) since Mon 2025-01-06 10:00:00 UTC
#    Main PID: 1234 (sshd)

# Iniciar um servico
sudo systemctl start nginx

# Parar um servico
sudo systemctl stop nginx

# Reiniciar um servico (para quando muda configuracao)
sudo systemctl restart nginx

# Recarregar configuracao sem parar o servico
sudo systemctl reload nginx

# Habilitar servico para iniciar automaticamente no boot
sudo systemctl enable nginx

# Desabilitar servico no boot
sudo systemctl disable nginx
```

### Ver todos os servicos

```bash
# Listar todos os servicos ativos
systemctl list-units --type=service

# Listar todos os servicos (ativos + inativos)
systemctl list-units --type=service --all

# Listar servicos que estao falhando
systemctl --failed
```

### Por que isso e importante para seguranca?

Quando voce compara a saida do `systemctl` antes e depois de uma alteracao, voce descobre o que foi comprometido:

```bash
# ANTES do ataque
systemctl list-units --type=service
# nginx - active
# mysql - active

# DEPOIS do ataque (servico malicioso instalado)
systemctl list-units --type=service
# nginx - active
# mysql - active
# xk-service - active    ← NOVO (suspeito!)
```

---

## Pipes — Encadeando Comandos

Um **pipe** (`|`) pega a saida de um comando e usa como entrada de outro. E como uma esteira industrial: o primeiro comando processa, e passa pro proximo.

### Analogia

```
Sem pipe:
┌─────────────┐
│ cat arquivo │ → resultado aparece na tela
└─────────────┘

Com pipe:
┌─────────────┐    ┌─────────────┐
│ cat arquivo │ →  │ grep "erro" │ → so as linhas com "erro"
└─────────────┘    └─────────────┘
```

### Exemplos praticos

```bash
# Listar processos e filtrar pelo nome
ps aux | grep nginx
# Saida:
# www-data  1234  0.0  0.1 nginx: worker process
# root      5678  0.0  0.0 grep --color=auto nginx

# Listar servicos e filtrar por status
systemctl list-units --type=service | grep active
# sshd.service    active running
# nginx.service   active running

# Ver logs e filtrar por data
cat /var/log/syslog | grep "Jan 06"

# Contar quantos processos de um tipo existem
ps aux | grep nginx | wc -l
# 3 (2 do nginx + 1 do proprio grep)

# Listar arquivos de uma pasta e filtrar por extensao
ls -la | grep ".conf"
```

### Comandos que funcionam bem com pipes

| Comando | Funcao | Pipe comum |
|:--------|:-------|:-----------|
| `grep` | Filtrar linhas | `comando \| grep "padrao"` |
| `wc` | Contar linhas/palavras | `comando \| wc -l` |
| `sort` | Ordenar saida | `comando \| sort` |
| `uniq` | Remover linhas duplicadas | `comando \| sort \| uniq` |
| `head` | Primeiras N linhas | `comando \| head -10` |
| `tail` | Ultimas N linhas | `comando \| tail -10` |

### Redirecionamento

```bash
# Salvar saida em arquivo
comando > arquivo.txt          # Sobrescreve
comando >> arquivo.txt         # Adiciona ao final

# Redirecionar erro
comando 2> erros.txt           # Salva erros em arquivo
comando > saida.txt 2>&1       # Salva tudo (saida + erro)

# Descartar saida
comando > /dev/null            # Joga fora a saida
```

### Exemplo practico de pipe + redirecionamento

```bash
# Salvar lista de servicos ativos em um arquivo
systemctl list-units --type=service | grep active | cut -d' ' -f1 > servicos_ativos.txt

# Verificar se o conteudo esta la
cat servicos_ativos.txt
# sshd.service
# nginx.service
```

---

## Logs — Onde procurar evidencias

```bash
# Logs do sistema
cat /var/log/syslog
cat /var/log/auth.log          # Logs de autenticacao

# Logs de servicos
journalctl -u nginx            # Logs do nginx
journalctl -u sshd             # Logs do SSH
journalctl -u sshd --since "1 hour ago"  # Ultima hora

# Procurar em logs
grep "Failed password" /var/log/auth.log
# Failed password for root from 192.168.1.100 port 22 ssh2
```

---

## Exercicios Praticos

### Exercicio 1: Servicos

```bash
# 1. Verifique o status do SSH
systemctl status sshd

# 2. Liste todos os servicos ativos
systemctl list-units --type=service | grep active

# 3. Verifique se algum servico esta falhando
systemctl --failed

# 4. Obtenha detalhes do nginx
systemctl show nginx -p ActiveState,SubState
```

### Exercicio 2: Pipes

```bash
# 1. Liste processos e encontre o bash
ps aux | grep bash

# 2. Conte quantos processos estao rodando
ps aux | wc -l

# 3. Liste servicos e salve em arquivo
systemctl list-units --type=service | grep active > meus_servicos.txt
cat meus_servicos.txt
```

### Exercicio 3: Navegacao e Arquivos

```bash
# 1. Veja onde esta
pwd

# 2. Va para o home
cd ~

# 3. Crie uma pasta "lab"
mkdir lab

# 4. Va para a pasta
cd lab

# 5. Crie um arquivo
touch teste.txt

# 6. Liste
ls -la
```

### Exercicio 4: Permissoes

```bash
# 1. Crie um script
echo '#!/bin/bash' > script.sh
echo 'echo "Hello!"' >> script.sh

# 2. Tente executar (vai dar erro)
./script.sh

# 3. De permissao
chmod +x script.sh

# 4. Execute novamente
./script.sh
```

---

## Dicas

> **`sudo`** = "faca como admin" — quase tudo no pentest precisa de sudo

> **`man comando`** = manual do comando — sempre disponivel

> **Tab** = autocompleta — use sempre!

> **Ctrl+C** = cancela o que esta rodando

> **Ctrl+L** = limpa a tela

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Navegar no terminal (cd, ls, pwd)
- [ ] Criar/editar/deletar arquivos
- [ ] Entender permissoes (chmod)
- [ ] Instalar programas com apt
- [ ] Usar sudo
- [ ] Gerenciar servicos com systemctl (iniciar, parar, status, habilitar)
- [ ] Usar pipes (|) para encadear comandos
- [ ] Redirecionar saida (>, >>)
- [ ] Procurar em logs com grep e journalctl

---

<div align="center">

**⬅️ [Anterior: TCP/IP e OSI](../01-redes/05-tcp-ip-osi.md)** | **[Proximo: HTTP e Web](07-http-e-web.md) ➡️**

</div>
