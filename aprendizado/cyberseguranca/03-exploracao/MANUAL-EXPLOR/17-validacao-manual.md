## Guia de Validação Manual — Como Confirmar um Achado de Exploração

> **Hydra/Hashcat/Metasploit disseram algo? Não acredite cegamente.** Aqui está como confirmar CADA tipo de resultado manualmente.

### 1. Como confirmar uma credencial do Hydra

**Cenário:** Hydra retornou `[22][ssh] host: 10.0.0.1 login: admin password: admin123`

```bash
# Teste 1: Login real (a ÚNICA prova que importa)
ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no admin@10.0.0.1
# Digite: admin123

# Se entrou → VALIDADO ✅. Confirme:
whoami        # → admin
hostname      # → evilcorp-web01
exit

# Teste 2: Verificar reuso em outro serviço (FTP)
ftp 10.0.0.1
# login: admin   senha: admin123

# Teste 3: HTTP (com curl — simula o navegador)
curl -s -i -X POST http://evilcorp.com/login \
  -d "username=admin&password=admin123" | head -15
# Prova de sucesso: Set-Cookie: PHPSESSID=...  OU  HTTP 302 → /admin
```

**✅ Output que confirma (SSH):**
```
admin@10.0.0.1's password:
Linux evilcorp-web01 5.4.0
admin@evilcorp-web01:~$
```

**❌ Se NÃO conecta:** o Hydra deu **falso positivo** — NÃO documente como achado. Volte ao Passo 3.2 e verifique wordlist/flags.

### 2. Como confirmar uma senha crackeada (John/Hashcat)

```bash
# Teste 1: Ver o resultado consolidado
john --show 15-alimentacao/hashes-suspeitos.txt
hashcat -m 0 --show 15-alimentacao/hashes-suspeitos.txt

# Teste 2: Recalcular o hash da senha encontrada e comparar
echo -n "password" | md5sum
# → 5f4dcc3b5aa765d61d8327deb882cf99  ← bate com o hash original? VALIDADO ✅

# Teste 3: Reuso — tentar a senha no serviço (1 tentativa)
hydra -l admin -p 'EvilCorp2024!' -t 1 -f ssh://10.0.0.1
```

**❌ Se o md5sum não bate:** você errou a senha ou o hash era de outro tipo (ex: NTLM). Refaça o `hashid`.

### 3. Como confirmar uma sessão do Metasploit

```bash
# Dentro da sessão — TODOS devem responder:
meterpreter > sysinfo      # sistema + OS
meterpreter > getuid       # nível de privilégio
meterpreter > pwd          # diretório

# Prova gravável:
meterpreter > cat /etc/hostname > /tmp/evidencia 2>/dev/null  # Linux
# Ou no Windows:
C:\Windows\system32> hostname

# Teste de persistência da sessão (ela é real?):
meterpreter > sleep 5
meterpreter > getpid       # se respondeu após 5s → sessão real ✅
```

**⚠️ Sessão "fantasma":** se `sysinfo` falha mas o prompt aparece, a sessão morreu. Documente falha, não sucesso.

### 4. Como confirmar acesso FTP

```bash
ftp 10.0.0.1
# login/senha
ftp> ls -la          # lista arquivos? VALIDADO ✅
ftp> pwd             # diretório atual
ftp> get readme.txt  # consegue baixar? prova de acesso

# Saia com: bye
```

**Se `ls` retornar vazio mas login OK:** acesso existe porém sem permissão de leitura — documente como "credencial válida, sem listagem" (BAIXO/MÉDIO).

### 5. Como confirmar acesso a banco de dados (MySQL)

```bash
mysql -h 10.0.0.1 -u root -p
# digite a senha

mysql> SHOW DATABASES;      # lista bancos? VALIDADO ✅
mysql> SELECT user, host FROM mysql.user;   # usuários (impacto)
mysql> exit

# Sem cliente mysql? Use Hydra para validar (1 tentativa):
hydra -l root -p 'senha' -t 1 -f mysql://10.0.0.1
```

### 6. Como confirmar acesso administrativo web

```bash
# Teste 1: login via curl e capturar cookie
curl -s -i -X POST http://evilcorp.com/wp-login.php \
  -d "log=admin&pwd=admin2024&wp-submit=Log+In&redirect_to=/wp-admin/&testcookie=1" \
  -c /tmp/cookies.txt | head -15
# Prova: Location: /wp-admin/  +  Set-Cookie: wordpress_logged_in_...

# Teste 2: usar o cookie para acessar área protegida
curl -s -b /tmp/cookies.txt http://evilcorp.com/wp-admin/ | grep -i "dashboard\|welcome"
# Se aparecer "Dashboard" → VALIDADO ✅

# Teste 3: no navegador (mais fácil)
# Acesse, logue, tire print → anexe ao relatório
```

### 7. Como confirmar hashdump (Metasploit)

```bash
meterpreter > hashdump
# Output: usuário:RID:LM hash:NTLM hash:::

# Valide o NTLM conhecido (ex: "password" vazio = 31d6cfe0d16ae931b73c59d7e0c089c0)
echo -n "password" | iconv -t UTF-16LE | md5sum
# → 8846f7eaee8fb117ad06bdd830b7586c  (NTLM de "password")
# Se bate com o hashdump → confirmado ✅
```

### Tabela de decisão rápida:

| Ferramenta diz | Você confirma com | É achado? |
|----------------|-------------------|:---:|
| Hydra: `password found` | `ssh user@host` com a senha | ✅ Só se logar |
| John: `1 cracked` | `john --show` + reuso em serviço | ✅ Se bater o hash |
| Hashcat: `Cracked` | `echo -n senha \| md5sum` == hash | ✅ Se bater |
| Msf: `session opened` | `sysinfo` + `getuid` | ✅ Se responder |
| Msf: `no session created` | — | ❌ Não é achado |
| Hydra: 0 results | `ssh` manual com a senha que "achou" | ⚠️ Pode ser falso positivo |
| hashid: múltiplos formatos | testar com `echo -n senha \| md5sum` | ⚠️ Confirme o formato |
| Cracking `Exhausted` | — | ❌ Documente como não crackeado |

---

**Se validou tudo → avance para a [Fase 7 — Relatório](13-fase7-relatorio.md)**
