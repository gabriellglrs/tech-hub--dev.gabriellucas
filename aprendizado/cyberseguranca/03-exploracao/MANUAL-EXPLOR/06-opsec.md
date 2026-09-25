## OPSEC — Não Deixar Rastros e Não Travar Contas

> **OPSEC (Operations Security)** na exploração é pior que no recon: aqui você gera MILHARES de tentativas de login. Se o alvo perceber, você é banido — ou pior, sua tentativa vira prova contra você.

### O que o alvo vê de você na exploração?

| O que você faz | O que o alvo vê | Risco |
|----------------|-----------------|-------|
| `hydra -P rockyou.txt ssh://alvo` | Milhares de logins do seu IP | 🔴 CRÍTICO (ban + lockout) |
| `hydra -P Top1000.txt -t 4 -f ssh://alvo` | Centenas de tentativas, para no 1º hit | ⚠️ MÉDIO (aceitável em lab) |
| `msfconsole > exploit` | Pacotes de exploração + conexão reversa | 🔴 ALTO (se IDS analisar payload) |
| `hashcat hash.txt rockyou.txt` | NADA (tudo local, offline) | ✅ ZERO |
| `john hash.txt` | NADA (tudo local, offline) | ✅ ZERO |
| `searchsploit ms17-010` | NADA (banco local do Exploit-DB) | ✅ ZERO |

> 💡 **Regra:** Cracking (Fase 4) é 100% local e seguro. Brute force (Fase 3) e Exploração (Fase 5) batem no alvo — exigem cuidado.

### Regras de OPSEC na exploração:

**1. Use VPN para TODOS os ataques ativos**
```bash
# ANTES de qualquer Hydra/Metasploit
nordvpn connect
curl -s https://ifconfig.me   # confirme que o IP mudou
```

**2. Limite threads e PARE no primeiro acerto**
```bash
# RUIM — 64 threads, vai travar contas e ser bloqueado
hydra -l admin -P rockyou.txt -t 64 ssh://evilcorp.com

# BOM — 4 threads, para no primeiro hit
hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt -t 4 -f ssh://evilcorp.com
# -t 4 = 4 conexões simultâneas
# -f  = para no PRIMEIRO login encontrado
```

**3. Confirme se o escopo PERMITE brute force**
| Ambiente | Brute force permitido? |
|----------|:---:|
| TryHackMe / HackTheBox / lab local | ✅ Sim (é o objetivo) |
| Bug bounty (regra do programa) | ⚠️ Depende — muitos PROÍBEM força bruta |
| Pentest com contrato | ⚠️ Só se estiver no escopo assinado |
| Produção de terceiros sem clause | ❌ NUNCA |

**4. Não use `rockyou` em serviços ONLINE**
```bash
# rockyou = 14 milhões de senhas = lockout em ~5 minutos
# Use rockyou apenas OFFLINE (hashcat/john):
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt   # ✅ local, sem risco
```

**5. Respeite rate limit do alvo**
```bash
# HTTP form: adicione delay no Hydra
hydra -l admin -P passwords.txt -t 1 -W 3 evilcorp.com http-post-form \
  "/login:user=^USER^&pass=^PASS^:F=incorrect"
# -t 1 = uma tentativa por vez
# -W 3 = espera 3 segundos entre tentativas

# Se o alvo devolve 429 (Too Many Requests) → PARE imediatamente
```

**6. Encerre e limpe sessões do Metasploit**
```bash
# Ao terminar, mate todas as sessões (não deixe reverse shell aberta)
msf6 > sessions -k all

# Limpe o histórico do bash
history -c && history -w
```

**7. Saiba quando PARAR**

| Sinal | O que fazer |
|-------|-------------|
| Hydra retorna "0 valid passwords" muito rápido | Pode estar bloqueado. Espere 30min e mude de IP |
| HTTP 429 / "account locked" | PARE. Você travou/travou perto de travar a conta |
| Sessão Metasploit caiu 2 vezes | O alvo detectou. Espere e investigue antes de insistir |
| Mais de 1 hora no mesmo brute force | Pare. Wordlist errada — volte à Fase 1 |
| VPN desconectou no meio | Reconecte ANTES de continuar; senão seu IP real vazou |

**8. Nunca explote sem autorização**
- **CTF/Labs:** Autorizado (HackTheBox, TryHackMe, OverTheWire)
- **Alvo próprio:** Autorizado
- **Alvo de terceiros:** ILEGAL sem autorização **por escrito**
- **Bug bounty:** Autorizado só dentro do escopo do programa (e sem brute force se proibido)

### Checklist de OPSEC:

| # | Item | ☑ |
|---|------|:---:|
| 1 | VPN conectada e IP verificado | [ ] |
| 2 | Escopo confirma que brute force é permitido | [ ] |
| 3 | Hydra com `-t 4` e `-f` (poucas threads + para no 1º hit) | [ ] |
| 4 | NÃO usarei rockyou em serviço online | [ ] |
| 5 | Logs do bash limpos ao terminar | [ ] |
| 6 | Sessões do Metasploit encerradas | [ ] |
| 7 | Autorização confirmada (CTF/próprio/contrato) | [ ] |

---

**Se marcou tudo → Avance para [07 - Fase 1: Alimentação](07-fase1-alimentacao.md)**
