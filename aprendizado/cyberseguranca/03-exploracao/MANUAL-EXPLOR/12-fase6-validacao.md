## FASE 6 — Validação e Impacto

**Tempo estimado:** 30-60 minutos
**Objetivo:** Confirmar cada acesso obtido, medir o impacto REAL e parar exatamente no limite do escopo.
**Por quê:** "Talvez tenha funcionado" não é resultado. Um acesso não validado no relatório = falso positivo. E ir além do escopo = problema jurídico.

> **📡 Dados usados nos passos abaixo (de onde vêm):**
> - **Acessos a validar:** saídas das Fases 3 (`17-bruteforce/credenciais-encontradas.md`), 4 (`18-cracking/hashes-crackeados.md`) e 5 (`19-exploracao/evidencias.md`)
> - **MANUAL-WEB:** `13-validacao/evidencias.md` — vulns web já validadas no Módulo 02: NÃO duplique aqui; só cruze se um acesso desta fase depender delas (ex.: credencial obtida via XSS)
> - **MANUAL-RECON:** `06-validacao/resumo-severidade.md` como baseline de severidade (mesma escala CRÍTICO/ALTO/MÉDIO/BAIXO)

---

### Passo 6.1 — Validar cada acesso obtido

**O que você vai fazer:** Para CADA credencial/sessão das fases 3, 4 e 5, provar o acesso com um comando observável.

| Tipo de acesso | Como validar | Comando de evidência |
|----------------|-------------|----------------------|
| Credencial SSH | Logar e rodar comandos | `ssh user@10.0.0.1` → `whoami; hostname` |
| Credencial FTP | Logar e listar | `ftp 10.0.0.1` → `ls -la` |
| Login HTTP | Obter sessão autenticada | `curl -i -X POST ... -d "user&pass"` → ver `Set-Cookie` |
| Sessão Metasploit | Info do sistema | `meterpreter > sysinfo; getuid` |
| Hash crackeado | Confirmar reuso | `hydra -l user -p senha -t 1 ssh://10.0.0.1` |
| Credencial de banco | Conectar e listar | `mysql -h 10.0.0.1 -u user -p` → `SHOW DATABASES;` |

```bash
# Gerar arquivo de validação
cat > 20-validacao/validacao-acessos.md << 'EOF'
# Validação de Acessos — evilcorp.com

## Acesso 1: SSH admin@10.0.0.1
- [ ] Login realizado manualmente
- [ ] Comando whoami executado
- [ ] Evidência salva: whoami = "admin", hostname = "evilcorp-web01"
- Impacto: leitura/escrita em /home/admin, potencial privesc (Módulo 04)
- Severidade: ALTO

## Acesso 2: HTTP admin/evilcorp.com
- [ ] Sessão obtida (cookie PHPSESSID registrado)
- [ ] Painel acessível: /admin/dashboard
- [ ] Evidência: screenshot + cabeçalho HTTP com cookie
- Impacto: gestão de usuários do site
- Severidade: CRÍTICO

## Acesso 3: Sessão Meterpreter (MS17-010)
- [ ] sysinfo coletado
- [ ] getuid = NT AUTHORITY\SYSTEM
- [ ] Evidência: 19-exploracao/evidencias.md
- Impacto: controle TOTAL da máquina
- Severidade: CRÍTICO
EOF
```

**❌ Se um acesso NÃO valida:** REMOVA do relatório. Falso positivo destrói credibilidade.

---

### Passo 6.2 — Medir o impacto (sem ir além do escopo)

**O que você vai fazer:** Responder "e daí?" de cada acesso — o que é possível fazer com ele, SEM fazer.

```bash
# Com a sessão aberta, colete apenas o suficiente para provar impacto:
meterpreter > sysinfo        # sistema comprometido
meterpreter > getuid         # nível de privilégio
meterpreter > ls             # consegue listar arquivos
meterpreter > pwd            # onde está

# Para credencial SSH — MOSTRE acesso, não vá além:
ssh admin@10.0.0.1 "whoami; hostname; ls -la /home/admin | head -5"
```

### Tabela de impacto por nível de acesso

| Nível alcançado | Impacto | Severidade típica |
|-----------------|---------|:-----------------:|
| Usuário comum (shell) | Leitura de arquivos do usuário, base para privesc | ALTO |
| SYSTEM/root | Controle total da máquina | CRÍTICO |
| Admin web | Manipulação de conteúdo/usuários do site | CRÍTICO |
| Credencial reutilizada | Pivoting para outros serviços/hosts | ALTO |
| Hash crackeado | Prova de senha fraca/reutilizada | MÉDIO-ALTO |
| Read-only FTP | Exposição de arquivos | MÉDIO |

### O que NÃO fazer (limite do escopo)

| ❌ Proibido sem autorização EXPLÍCITA | ✅ Permitido como prova |
|---------------------------------------|--------------------------|
| Deletar/modificar arquivos | Listar arquivos (ls) |
| Criar usuários/backdoors | whoami, sysinfo, pwd |
| Escalar privilégios além do combinado | Verificar se é possível (enum) |
| Pivotar para outros hosts | Testar se a rede é alcançável (sem explorar) |
| Continuar acesso persistente (persistence) | Encerrar a sessão ao terminar |
| Acessar dados de terceiros | Mostrar que dados existem (sem exfiltrar tudo) |

> 💡 **Regra do pentest:** prove que VOCÊ PODE, não faça o que você pode. O relatório diz "SYSTEM obtido em X minutos" — não precisa provar deletando algo.

---

### Passo 6.3 — Encerrar tudo com segurança

**O que você vai fazer:** Não deixe sessões, processos ou locks abertos.

```bash
# 1) Encerrar sessões do Metasploit
msf6 > sessions -k all
msf6 > exit

# 2) Encerrar shells abertos
exit          # em cada shell/ssh aberto

# 3) Conferir que não sobrou nada rodando
ps aux | grep -E "hydra|msfconsole|nc " | grep -v grep

# 4) Salvar logs finais
ls -la 17-bruteforce/ 18-cracking/ 19-exploracao/ 20-validacao/

# 5) Limpar histórico (OPSEC)
history -c && history -w
```

**✅ Output esperado (depois do cleanup):**
```
(Nenhum processo hydra/msfconsole/nc rodando)
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Sessão não morre | Meterpreter resistente | `sessions -k -f 1` (força); ou mate o PID |
| Hydra em background | Ctrl+Z em vez de Ctrl+C | `pkill hydra` |
| Esqueceu credencial | Comum | Documente e troque no relatório se era lab próprio |

---

### Passo 6.4 — Organizar por severidade (para o relatório)

```bash
cat > 20-validacao/resumo-severidade-exploracao.md << 'EOF'
# Resumo de Severidade — Exploração

## CRÍTICO
- Controle total via MS17-010 (EternalBlue) — Meterpreter SYSTEM em 10.0.0.1
- Acesso admin ao painel web com credencial `admin:admin2024`

## ALTO
- Credencial SSH `admin:admin123` validada em 10.0.0.1 (reuso em FTP)
- Credencial `administrator:Admin@123` no SMB 10.0.0.2

## MÉDIO
- Senha `EvilCorp2024!` crackeada (MD5) e reutilizada no login web
- Acesso anônimo FTP em 10.0.0.1 (listagem de arquivos)

## BAIXO
- Senha fraca `admin123` (Top1000) — força bruta levou 47s

## INFORMATIVO
- Nenhum lockout ativado durante os testes
- Fail2ban detectou IP após 300 tentativas (SSH)
EOF
cat 20-validacao/resumo-severidade-exploracao.md
```

---

### Checklist da Fase 6

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Todo acesso validado manualmente | `20-validacao/validacao-acessos.md` | [ ] |
| 2 | Falsos positivos removidos | revisado | [ ] |
| 3 | Impacto documentado (sem extrapolar) | `validacao-acessos.md` | [ ] |
| 4 | Sessões e processos encerrados | `ps aux` limpo | [ ] |
| 5 | Severidades organizadas | `20-validacao/resumo-severidade-exploracao.md` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 6:

```
20-validacao/
├── validacao-acessos.md                 ← cada acesso com evidência e impacto
└── resumo-severidade-exploracao.md      ← achados por severidade
```

### ✅ Sinal de sucesso:
- Cada acesso tem: **comando de validação + output + impacto + severidade**
- Nenhum falso positivo (tudo confirmado manualmente)
- Nenhuma sessão/procido aberto

### ❌ Se falhou:
- Sem nenhum acesso → documente "exploração sem sucesso" com as tentativas (também é resultado)
- Acesso parcial (ex: só FTP anônimo) → documente; não inflacione severidade

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 6 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `validacao-acessos.md` | Fase 7 | Seção de descobertas com evidência |
| `resumo-severidade-exploracao.md` | Fase 7 | Resumo executivo + recomendações |
| `resumo-severidade-exploracao.md` | Módulo 04 | Dados para pós-exploração (se houver sessão) |

**Se completou tudo → Avance para [Fase 7 — Relatório](13-fase7-relatorio.md)**
