# Permissoes e Usuarios

> No Linux, TUDO tem permissao. Quem pode ler, quem pode escrever, quem pode executar. Isso e seguranca.

---

## Por que permissoes importam?

```
Sem permissoes:
- Qualquer pessoa podia deletar arquivos do sistema
- Qualquer pessoa podia rodar scripts maliciosos
- Qualquer pessoa podia ler suas senhas

Com permissoes:
- So voce le seus arquivos
- So root pode instalar programas
- Scripts maliciosos nao executam sem permissao
```

---

## Estrutura de Permissoes

```bash
ls -la
# -rw-r--r-- 1 usuario usuario 1234 Jan 6 10:00 arquivo.txt
# drwxr-xr-x 2 usuario usuario 4096 Jan 6 10:00 pasta/
```

### Decodificando

```
- rwx rwx rwx
│ │││ │││ │││
│ │││ │││ ││└── Outros (other) — qualquer pessoa
│ │││ │││ │└─── Grupo (group) — pessoa do mesmo grupo
│ │││ │││ └──── Dono (user) — dono do arquivo
│ │││ ││└────── Tipo (r=read, w=write, x=execute)
│ │││ └──────── O que GRAUPO pode fazer
│ │└──────────── O que OUTROS podem fazer
│ └───────────── O que DONO pode fazer
└─────────────── Tipo: -=arquivo, d=pasta, l=link
```

### Significado

| Letra | Nome | Arquivo | Pasta |
|:------|:-----|:--------|:------|
| `r` | Read | Le o conteudo | Lista o conteudo |
| `w` | Write | Edita o conteudo | Cria/deleta arquivos dentro |
| `x` | Execute | Roda o arquivo | Entra na pasta |
| `-` | Nao tem | Sem permissao | Sem permissao |

---

## Numeros (Octal)

Em vez de letras, voce pode usar numeros:

```
r = 4
w = 2
x = 1
- = 0

rwx = 4+2+1 = 7
rw- = 4+2+0 = 6
r-x = 4+0+1 = 5
r-- = 4+0+0 = 4
```

### Exemplos Comuns

| Numeros | Significado | Comando |
|:--------|:------------|:--------|
| `777` | Todos fazem tudo | `chmod 777 arquivo` |
| `755` | Dono: tudo, outros: ler/executar | `chmod 755 script.sh` |
| `644` | Dono: ler/escrever, outros: ler | `chmod 644 arquivo.txt` |
| `600` | So dono pode ler/escrever | `chmod 600 chave.pem` |
| `700` | So dono pode tudo | `chmod 700 pasta/` |

### Analogia

```
777 = Casa sem fechadura (todos entram)
755 = Casa com fechadura, mas visitas livres
644 = Casa trancada, mas com信箱 aberto
600 = Casa com alarme e chave so voce
700 = Fortaleza — so voce entra
```

---

## chmod — Mudar Permissoes

### Com numeros

```bash
chmod 755 script.sh        # Dono: rwx, Grupo: r-x, Outros: r-x
chmod 644 arquivo.txt      # Dono: rw-, Grupo: r--, Outros: r--
chmod 600 chave.pem        # Dono: rw-, Grupo: ---, Outros: ---
chmod 700 pasta/           # Dono: rwx, Grupo: ---, Outros: ---
```

### Com simbolos

```bash
chmod +x script.sh         # Adiciona permissao de execucao
chmod -x script.sh         # Remove permissao de execucao
chmod u+w arquivo.txt      # Adiciona write para dono
chmod g+r arquivo.txt      # Adiciona read para grupo
chmod o-rwx arquivo.txt    # Remove todas permissoes de outros
chmod a+r arquivo.txt      # Adiciona read para TODOS
```

### Sintaxe

```
chmod [quem][operacao][permissao] arquivo

quem:     u=user, g=group, o=other, a=all
operacao: +=adicionar, -=remover, =definir
permissao: r=read, w=write, x=execute
```

---

## chown — Mudar Dono

```bash
chown usuario arquivo.txt              # Muda dono
chown usuario:grupo arquivo.txt        # Muda dono e grupo
chown -R usuario:pasta/ pasta/         # Muda recursivo (pasta + conteudo)
```

### Exemplo

```bash
# Voce criou o arquivo como root, agora quer dar para voce
sudo chown usuario:usuario arquivo.txt

# Muda dono de uma pasta inteira
sudo chown -R www-data:www-data /var/www/html/
```

---

## Usuarios e Grupos

### Ver informacoes

```bash
whoami                    # Seu nome de usuario
id                        # Seu usuario, grupo e permissoes
id usuario                # Info de outro usuario
groups                    # Quais grupos voce pertence
groups usuario            # Quais grupos outro usuario pertence
```

### Criar usuario

```bash
sudo adduser novo_usuario        # Cria usuario (interativo)
sudo useradd -m -s /bin/bash novo_usuario  # Cria sem perguntar
sudo passwd novo_usuario         # Define senha
```

### Deletar usuario

```bash
sudo userdel usuario             # Deleta usuario
sudo userdel -r usuario          # Deleta usuario + home directory
```

### Grupos

```bash
sudo groupadd pentesters         # Cria grupo
sudo usermod -aG pentesters usuario  # Adiciona usuario ao grupo (-a = append)
sudo gpasswd -d usuario pentesters   # Remove usuario do grupo
```

### Por que grupos importam?

```
Em vez de dar permissao para CADA usuario:
chmod 770 /projeto/
chown usuario1:pentesters /projeto/
chown usuario2:pentesters /projeto/

Voce cria um grupo, adiciona todos e da permissao pro grupo:
chmod 770 /projeto/
chown root:pentesters /projeto/
# Todos do grupo pentesters podem acessar
```

---

## sudo — Executar como Admin

```bash
sudo comando                # Executa como root
sudo -u outro_usuario cmd   # Executa como outro usuario
sudo -i                     # Abre shell como root
sudo su                      # Mesma coisa
```

### O que acontece com sudo?

```
1. Voce digita: sudo rm -rf /tmp/lixo
2. Pede sua senha
3. Executa como root
4. Registra em /var/log/auth.log
```

### ⚠️ CUIDADO

```
sudo rm -rf /      # MORTE CERTA (mesma coisa sem sudo)
sudo chmod -R 777 / # DESTRUIR o sistema
sudo shutdown -h now # Desliga o servidor
```

---

## Umask — Permissao Padrao

```bash
umask                    # Mostra mascara atual
umask 022                # Define nova mascara
```

### Como funciona?

```
Quando voce cria um arquivo:
- Arquivo: 666 - umask = permissao final
- Pasta: 777 - umask = permissao final

Umask 022:
- Arquivo: 666 - 022 = 644 (rw-r--r--)
- Pasta: 777 - 022 = 755 (rwxr-xr-x)
```

---

## Exercicios Praticos

### Exercicio 1: Analise permissoes

```bash
ls -la /etc/passwd
# Quem e o dono? Qual grupo? Quais permissoes?

ls -la /etc/shadow
# Mesma pergunta — qual a diferenca?
```

### Exercicio 2: Mude permissoes

```bash
# Crie um arquivo
touch teste.txt

# Veja as permissoes atuais
ls -la teste.txt

# Mude para 755
chmod 755 teste.txt

# Mude para 600
chmod 600 teste.txt

# Adicione execucao
chmod +x teste.txt
```

### Exercicio 3: Crie um usuario

```bash
# Crie usuario
sudo adduser pentester

# Adicione ao grupo sudo
sudo usermod -aG sudo pentester

# Teste
su - pentester
sudo whoami
# Deve retornar: root
```

### Exercicio 4: Grupos

```bash
# Crie grupo
sudo groupadd lab

# Adicione seu usuario
sudo usermod -aG lab $USER

# Verifique
id
# Deve mostrar: groups=...1001(lab)
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Ler e entender permissoes (`ls -la`)
- [ ] Mudar permissoes com `chmod` (numeros e simbolos)
- [ ] Mudar dono com `chown`
- [ ] Criar e gerenciar usuarios com `adduser`, `userdel`
- [ ] Gerenciar grupos com `groupadd`, `usermod`
- [ ] Usar `sudo` com seguranca
- [ ] Entender por que `600` e importante para chaves

---

<div align="center">

**⬅️ [Anterior: Arquivos](02-arquivos-e-diretorios.md)** | **[Proximo: Processos](04-processos-e-servicos.md) ➡️**

</div>
