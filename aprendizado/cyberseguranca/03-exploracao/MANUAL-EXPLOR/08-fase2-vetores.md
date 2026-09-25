## FASE 2 — Priorização de Vetores

**Tempo estimado:** 30-45 minutos
**Objetivo:** Cruzar os dados importados (Fase 1) com exploits conhecidos e decidir QUAL ataque usar em QUAL alvo — antes de gastar uma única tentativa.
**Por quê:** Explorar na ordem errada = horas perdidas e alarmes disparados. O vetor certo primeiro = acesso em minutos.

> **📡 Dados usados neste passo (de onde vêm):**
> - **MANUAL-RECON:** `02-enum/nmap-scan.xml` + `05-vulns/nmap-vuln.txt` (CVEs) + `06-validacao/resumo-severidade.md` (severidades já confirmadas) — importados na Fase 1 como `15-alimentacao/alvos-cve.txt` e `severidade-recon.md`
> - **MANUAL-WEB:** `13-validacao/evidencias.md` e `13-validacao/findings-todos.txt` (vulns web JÁ confirmadas) — não re-descubra o que o Módulo 02 já provou; aqui você só decide a ordem de exploração
> - **Saídas da Fase 1:** `15-alimentacao/alvos-servicos.txt`, `alvos-login-web.txt`, `formularios.txt`, `hashes-suspeitos.txt`, `credenciais-texto.txt`

---

### Passo 2.1 — Cruzar CVEs com o Searchsploit

**O que você vai fazer:** Para cada vulnerabilidade da Fase 1, descobrir se existe exploit PRONTO no Exploit-DB (banco offline do Searchsploit).

```bash
# 1) Searchsploit direto do output do Nmap (formato XML)
#    (Se você salvou o Nmap em XML no Módulo 01:)
searchsploit --nmap 02-enum/nmap-scan.xml > 16-vetores/searchsploit-nmap.txt 2>/dev/null

# 2) Buscar por cada CVE encontrada na Fase 1
grep -oE "CVE-[0-9]{4}-[0-9]+" 15-alimentacao/alvos-cve.txt | sort -u | while read cve; do
    echo "=== $cve ===" >> 16-vetores/searchsploit-cves.txt
    searchsploit --cve "$cve" >> 16-vetores/searchsploit-cves.txt 2>/dev/null
done

# 3) Buscar por serviço/versão (quando não há CVE, mas há versão velha)
searchsploit vsftpd 3.0.3 >> 16-vetores/searchsploit-servicos.txt
searchsploit openssh 7.2 >> 16-vetores/searchsploit-servicos.txt
searchsploit samba 4.11 >> 16-vetores/searchsploit-servicos.txt

# Ver resultados
cat 16-vetores/searchsploit-cves.txt
```

**✅ Output esperado (exemplo real):**
```
=== CVE-2017-0144 ===
Exploits: 5
──────────────────────────────────────────────────────────────
 Exploit Title                                          | Path
──────────────────────────────────────────────────────────────
Microsoft Windows SMBv1 Remote Code Execution (MS17-010)| windows/remote/42315.py
Microsoft Windows - SMB EternalBlue RCE                  | windows/remote/41891.rb
──────────────────────────────────────────────────────────────
```

**O que procurar:**
- **"Exploits: 0"** → sem exploit público direto (busque manualmente por serviço)
- **Path terminado em `.rb`** → é módulo Metasploit (usa direto no msfconsole)
- **Path terminado em `.py`** → script standalone (analise antes de rodar)
- **Rank "excellent/average"** → confiável; "manual" → exige trabalho seu

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `searchsploit: command not found` | Não instalado | `sudo apt install exploitdb` |
| `--nmap` não retorna nada | XML não existe/diferente | Busque manualmente por serviço: `searchsploit apache 2.4.41` |
| 0 exploits para tudo | Alvo atualizado ou nicho | Brute force (Fases 3-4) segue normalmente |
| Nmap não salvou XML | Só tem `.txt` | `nmap -sV -oX 02-enum/nmap-scan.xml <ip>` de novo |

---

### Passo 2.2 — Montar a Matriz de Decisão

**O que você vai fazer:** Para cada alvo/vetor da Fase 1, classificar o caminho de ataque. É a "lista de tarefas" das fases 3, 4 e 5.

```bash
cat > 16-vetores/matriz-vetores.md << 'EOF'
# Matriz de Vetores — evilcorp.com

## Prioridade 1 — Exploração direta (CVE com exploit)
| Vetor | CVE/Exploit | Ferramenta | Fase | Status |
|-------|-------------|-----------|:----:|:------:|
| Samba 445 (10.0.0.1) | CVE-2017-0144 / ms17_010_eternalblue | Metasploit | 5 | [ ] |

## Prioridade 2 — Brute force de serviço exposto
| Vetor | Serviço | Usuários | Wordlist | Fase | Status |
|-------|---------|----------|----------|:----:|:------:|
| SSH 22 (10.0.0.1) | OpenSSH 8.9p1 | usernames-todos.txt | wordlist-bruteforce.txt | 3 | [ ] |
| FTP 21 (10.0.0.1) | vsftpd 3.0.3 | usernames-todos.txt | Top1000.txt | 3 | [ ] |

## Prioridade 3 — Brute force HTTP (login web do Módulo 02)
| Vetor | URL | Formulário | Fase | Status |
|-------|-----|-----------|:----:|:------:|
| Admin panel | http://evilcorp.com/login | username/password | 3 | [ ] |
| WordPress | http://evilcorp.com/wp-login.php | log/pwd | 3 | [ ] |

## Prioridade 4 — Cracking de hashes coletados
| Hash | Tipo provável | Ferramenta | Fase | Status |
|------|--------------|-----------|:----:|:------:|
| 5f4dcc3b5aa765d61d8327deb882cf99 | MD5 | hashid → hashcat -m 0 | 4 | [ ] |

## Vetores descartados (e por quê)
| Vetor | Motivo do descarte |
|-------|--------------------|
| MySQL 3306 remoto | Brute force em banco = lockout garantido; sem credencial vazada |
| RDP 3389 | Sem usuários válidos conhecidos |
EOF

cat 16-vetores/matriz-vetores.md
```

**✅ Output esperado:** a matriz acima preenchida com OS SEUS dados (IPs, serviços e URLs reais do seu alvo).

**O que procurar:** Cada linha tem **fase definida** (3, 4 ou 5). Se uma linha não tem fase, você ainda não decidiu — decida agora.

---

### Passo 2.3 — Regras de decisão (qual vetor escolher)

| Se... | Então... | Fase |
|-------|----------|:----:|
| Existe CVE **VULNERABLE confirmada** + exploit no Searchsploit | Exploração direta (maior impacto, menos tentativas) | **5** |
| Serviço com **login** (SSH/FTP/SMB/RDP) e não há exploit | Brute force com wordlist pequena | **3** |
| Há **formulário HTTP** documentado no Módulo 02 | Hydra `http-post-form` com os campos exatos | **3** |
| Você coletou **hashes** (JS, .env, banco) | Cracking offline (zero risco de lockout) | **4** |
| Existem **credenciais em texto puro** | Testar ESSESA credenciais primeiro (1 tentativa!) | **3** |
| Só há versão antiga **sem CVE** | Busca manual ampla no searchsploit + nuclei (volte ao Módulo 01) | **2** |
| Nada disso existe | Documente "sem vetores exploráveis" e vá para o relatório | **7** |

### Regra de prioridade: impacto × esforço

```
ALTO IMPACTO + BAIXO ESFORÇO (faça PRIMEIRO)
├── CVE com exploit pronto (EternalBlue, etc)
├── Credencial em texto puro encontrada no recon
└── .env/backup exposto com senha (do Módulo 02)

MÉDIO IMPACTO + BAIXO ESFORÇO
├── Brute force SSH/FTP com usuários do próprio alvo
└── Cracking de hash fraco (MD5)

ALTO IMPACTO + ALTO ESFORÇO (faça DEPOIS)
├── Brute force HTTP com WAF
└── Exploração manual sem exploit pronto

BAIXO IMPACTO (só se sobrar tempo)
└── Serviços internos sem credencial conhecida
```

---

### Passo 2.4 — Validar a autorização de cada vetor

**O que você vai fazer:** Conferir que CADA vetor da matriz está dentro do escopo autorizado.

```bash
# Criar arquivo de escopo (se ainda não tem)
cat > 16-vetores/escopo.md << 'EOF'
# Escopo Autorizado — evilcorp.com

## IN (autorizado)
- Brute force: 10.0.0.1 (SSH, FTP) — labs
- Exploração: CVEs em 10.0.0.1
- Logins HTTP: *.evilcorp.com

## OUT (PROIBIDO)
- Produção de terceiros
- Brute force em contas reais de usuários
- Denegação de serviço (DoS)
- Qualquer coisa fora de 10.0.0.0/24
EOF
```

**❌ Se um vetor está fora do escopo: REMOVA da matriz. Não existe "testar rapidinho".**

---

### Checklist da Fase 2

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Searchsploit cruzado com CVEs/serviços | `16-vetores/searchsploit-cves.txt` | [ ] |
| 2 | Matriz de decisão preenchida | `16-vetores/matriz-vetores.md` | [ ] |
| 3 | Vetores descartados justificados | na própria matriz | [ ] |
| 4 | Escopo confirmado por vetor | `16-vetores/escopo.md` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 2:

```
16-vetores/
├── searchsploit-nmap.txt     ← exploits sugeridos pelo output do Nmap
├── searchsploit-cves.txt     ← exploits por CVE
├── searchsploit-servicos.txt ← exploits por serviço/versão
├── matriz-vetores.md         ← LISTA DE TAREFAS das Fases 3, 4 e 5
└── escopo.md                 ← o que pode e o que não pode
```

### ✅ Sinal de sucesso:
- Toda linha da `matriz-vetores.md` tem **fase definida** (3, 4 ou 5)
- Você sabe **qual ataque fazer primeiro** (prioridade 1)
- Você sabe **quais vetores NÃO vai atacar** (e por quê)

### ❌ Se falhou:
- Matriz vazia de prioridade 1 → normal sem CVE. Priorize 2 e 3 (brute force).
- Nada na matriz → volte à Fase 1; faltaram dados dos módulos 01/02.

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 2 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `matriz-vetores.md` (Prioridade 2 e 3) | Fase 3 | Quais serviços/forms atacar com Hydra |
| `matriz-vetores.md` (Prioridade 4) | Fase 4 | Quais hashes crackear |
| `matriz-vetores.md` (Prioridade 1) | Fase 5 | Qual exploit rodar no Metasploit |
| `escopo.md` | Todas | Cortar qualquer ataque fora do escopo |

**Se completou tudo → Avance para [Fase 3 — Brute Force](09-fase3-bruteforce.md)**
