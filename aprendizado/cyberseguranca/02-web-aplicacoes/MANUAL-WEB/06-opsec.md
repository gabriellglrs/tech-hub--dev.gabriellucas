## OPSEC — Não Derrubar o Alvo e Não Exceder o Escopo

> **OPSEC (Operations Security) no teste web é sobre VELOCIDADE e ESCOPO.** O alvo vê cada request que você manda: fuzzing rápido demais = WAF te bloqueia; teste fora de escopo = crime, mesmo com autorização parcial.

### O que o alvo vê de você no teste web?

| O que você faz | O que o alvo vê | Risco |
|----------------|-----------------|-------|
| `ffuf -t 100 common.txt` | 100 requests/seg do seu IP | 🔴 CRÍTICO (WAF ban em segundos) |
| `ffuf -t 5 -p 0.5 common.txt` | 5 threads com 0.5s de pausa | ⚠️ BAIXO (aceitável em lab) |
| `sqlmap --risk=3 --level=5` | Centenas de payloads SQL | 🔴 ALTO (pode escrever/dropar dados!) |
| `sqlmap --risk=1 --batch` | Payloads leves de detecção | ⚠️ MÉDIO |
| Burp Repeater manual (1 payload) | 1 request por vez | ✅ BAIXO |
| `nuclei -u URL` | Varredura por templates | ⚠️ MÉDIO (modere rate) |
| Navegar no site pelo proxy | Comportamento de usuário normal | ✅ ZERO |

> 💡 **Regra:** Manual (Repeater) = sempre seguro. Automatizado (ffuf/sqlmap/nuclei) = sempre com limite de velocidade.

### Regras de OPSEC no teste web:

**1. Use VPN e confirme o IP**
```bash
# ANTES de qualquer teste ativo
nordvpn connect
curl -s https://ifconfig.me   # confirme que o IP mudou
```

**2. Limite a velocidade de TODA ferramenta automatizada**
```bash
# RUIM — 100 threads, WAF bloqueia e você perde o teste
ffuf -u https://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt -t 100

# BOM — 5 threads + delay entre requests
ffuf -u https://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt -t 5 -p 0.5
# -t 5 = 5 threads
# -p 0.5 = espera 0.5s entre requests

# SQLMap com cuidado
sqlmap -u "https://target.com/page?id=1" --batch --risk=1 --level=1 --threads=1 --delay=1

# Nuclei com rate limit
nuclei -u https://target.com -rate-limit 10 -concurrency 5
```

**3. Confirme se o escopo PERMITE cada tipo de teste**
| Teste | Lab/CTF | Bug bounty típico | Pentest com contrato |
|-------|:---:|:---:|:---:|
| Navegar/crawl | ✅ | ✅ | ✅ |
| Fuzzing de diretórios | ✅ | ⚠️ Depende das regras | ✅ |
| Injeção (SQLi etc.) | ✅ | ✅ (se o programa aceitar) | ✅ |
| Brute force de login | ✅ | ❌ Geralmente PROÍBIDO | ⚠️ Só se assinado |
| Upload de webshell | ✅ | ⚠️ Só em escopo claro | ⚠️ Só se assinado |
| DoS/flood | ❌ | ❌ NUNCA | ❌ NUNCA |

**4. Nunca use SQLMap com `--risk=3` sem ler o escopo**
```bash
# risk=3 inclui payloads que podem ALTERAR dados (UPDATE/INSERT/DELETE)
# Em produção: SÓ com autorização explícita. Em lab: liberado.
sqlmap -u "URL" --batch --risk=1     # seguro (detecção)
sqlmap -u "URL" --batch --risk=3     # ⚠️ pode escrever no banco
```

**5. Dados sensíveis: documente, NÃO exfiltre**
- Encontrou CPF, senha, dado de usuário real? **Não copie.** Registre no relatório: "acesso a dados expostos — severidade CRÍTICA, amostra N coletada" (sem a amostra em si).
- Produção real? **Pare e avise o contato de emergência.**

**6. Respeite sinais do alvo**
| Sinal | O que fazer |
|-------|-------------|
| HTTP 429 (Too Many Requests) | PARE. Espere 10-30 min e reduza a velocidade |
| WAF devolve 403 no payload | Mude de payload/encoding — não insista (vai bloquear seu IP) |
| Site ficou lento durante seu teste | PARE e verifique se é culpa sua |
| Site caiu | PARE IMEDIATAMENTe e contate o responsável |
| "Account locked" em login | PARE. Você travou (ou quase) uma conta real |

**7. Quando PARAR (critérios de parada)**
- **Parada imediata:** dano colateral em serviço fora do escopo; serviço indisponível; acesso a dados de usuários reais; período de teste expirou; alguém do outro lado monitorando.
- **Parada por ética:** todos os endpoints cobertos; vulnerabilidades já documentadas; saiu do escopo; risco de dano irreversível.
- **Na dúvida, PARE** e confirme com o responsável pelo teste.

**8. Nunca teste sem autorização**
- **CTF/Labs:** Autorizado (HackTheBox, TryHackMe, PortSwigger, OverTheWire)
- **Alvo próprio:** Autorizado
- **Alvo de terceiros:** ILEGAL sem autorização **por escrito** (URLs, período, contato de emergência, regras de engajamento)
- **Bug bounty:** Só dentro do escopo publicado — e sem as práticas que o programa proíbe

### Checklist de OPSEC:

| # | Item | ☑ |
|---|------|:---:|
| 1 | VPN conectada e IP verificado | [ ] |
| 2 | Escopo documentado (URLs IN e OUT) | [ ] |
| 3 | Ferramentas automatizadas com threads baixas + delay | [ ] |
| 4 | SQLMap com risk baixo (a não ser autorizado) | [ ] |
| 5 | Sem brute force de login sem permissão explícita | [ ] |
| 6 | Nenhum dado sensível copiado (só documentado) | [ ] |
| 7 | Autorização confirmada (CTF/próprio/contrato/bounty) | [ ] |

---

**Se marcou tudo → Avance para [07 - Fase 1: Alimentação](07-fase1-alimentacao.md)**
