## 📊 Visão Geral: Toda a Estrutura Final

Ao final das 7 fases deste manual, a estrutura COMPLETA (Módulo 01 + 02 + 03) deve parecer:

```
~/recon/targets/evilcorp/
├── 01-intel/                     ← Módulo 01
│   ├── whois.txt
│   ├── subdominios-todos.txt
│   ├── theharvester.txt          ← origem dos usernames da Fase 1
│   └── todas-urls.txt
├── 02-enum/                      ← Módulo 01
│   ├── nmap-services.txt         ← origem de alvos-servicos.txt
│   └── vivos-filtrados.txt
├── 03-fingerprint/               ← Módulo 01
├── 04-discovery/                 ← Módulo 01 + 02
│   ├── gobuster-basico.txt       ← origem de alvos-login-web.txt
│   ├── urls-com-parametros.txt
│   └── js-secrets.txt            ← origem de segredos/hashes
├── 05-vulns/                     ← Módulo 01
│   ├── nmap-vuln.txt             ← origem de alvos-cve.txt
│   └── wpscan.txt
├── 06-validacao/                 ← Módulo 01
│   └── resumo-severidade.md      ← origem de severidade-recon.md
├── 07-relatorio/                 ← Módulo 01
│   └── relatorio-recon.md
├── 08-alimentacao/               ← Fase 1 (Exploração)
│   ├── alvos-servicos.txt
│   ├── alvos-cve.txt
│   ├── alvos-login-web.txt
│   ├── formularios.txt
│   ├── usernames-todos.txt
│   ├── credenciais-texto.txt
│   ├── hashes-suspeitos.txt
│   ├── cewl-alvo.txt
│   └── wordlist-bruteforce.txt
├── 09-vetores/                   ← Fase 2 (Exploração)
│   ├── searchsploit-cves.txt
│   ├── matriz-vetores.md
│   └── escopo.md
├── 10-bruteforce/                ← Fase 3 (Exploração)
│   ├── hydra-ssh.txt
│   ├── hydra-http-login.txt
│   └── credenciais-encontradas.md
├── 11-cracking/                  ← Fase 4 (Exploração)
│   ├── hashid-resultados.txt
│   ├── john-resultados.txt
│   ├── hashcat-*.txt
│   └── hashes-crackeados.md
├── 12-exploracao/                ← Fase 5 (Exploração)
│   ├── msf-logs.txt
│   ├── sessao-1.txt
│   └── evidencias.md
├── 13-validacao/                 ← Fase 6 (Exploração)
│   ├── validacao-acessos.md
│   └── resumo-severidade-exploracao.md
└── 14-relatorio/                 ← Fase 7 (Exploração)
    └── relatorio-exploracao.md
```

**Total de arquivos esperados:** ~60-70 arquivos organizados por fase (35-40 do recon + 25-30 da exploração).

---

## 🔗 Como os Módulos 01, 02 e 03 se alimentam

Este manual é a **junção operacional** dos dois anteriores. Cada fase da exploração consome dados deles:

### Da Fase 1 (Alimentação) — o que vem de onde

| Arquivo que eu crio | Vem do Módulo | Arquivo original |
|---------------------|---------------|------------------|
| `alvos-servicos.txt` | 01 — Recon | `02-enum/nmap-services.txt` |
| `alvos-cve.txt` | 01 — Recon | `05-vulns/nmap-vuln.txt` |
| `severidade-recon.md` | 01 — Recon | `06-validacao/resumo-severidade.md` |
| `usernames-candidatos.txt` | 01 — Recon | `01-intel/theharvester.txt` (emails) |
| `segredos-js.txt` | 01/02 — Recon+Web | `04-discovery/js-secrets.txt` |
| `hashes-suspeitos.txt` | 01/02 — Recon+Web | `.env`, configs, JS expostos |
| `alvos-login-web.txt` | 02 — Web | `04-discovery/gobuster-basico.txt` (caminhos login/admin) |
| `formularios.txt` | 02 — Web | Formulários documentados no Burp/navegador |
| `cewl-alvo.txt` | 02 — Web | Conteúdo do site (palavras do próprio alvo) |

### O que CADA fase gera para a próxima

```
MÓDULO 01 (recon) + MÓDULO 02 (web)
        ↓
FASE 1  → alvos, usernames, hashes, forms, wordlist
        ↓
FASE 2  → matriz-vetores.md (QUAL ataque em QUAL alvo)
        ↓                        ↓                        ↓
FASE 3 (Hydra)          FASE 4 (John/Hashcat)    FASE 5 (Metasploit)
  credenciais             senhas de hashes          sessão/shell
        ↓                        ↓                        ↓
        └────────────────────────┴────────────────────────┘
                                 ↓
                    FASE 6 → acessos validados + impacto
                                 ↓
                    FASE 7 → relatorio-exploracao.md
```

---

## 🔗 Conexão com o Módulo 04 — Pós-Exploração

Assim como o recon alimentou a exploração, a exploração alimenta a pós-exploração:

### O que você precisa ter para avançar para o Módulo 04

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **Sessão/shell obtida** | Fase 5 | `12-exploracao/sessao-1.txt` | [ ] |
| **Nível de acesso atual** | Fase 6 | `13-validacao/validacao-acessos.md` | [ ] |
| **Credenciais válidas** | Fases 3 e 4 | `10-bruteforce/credenciais-encontradas.md` | [ ] |
| **Hashes do alvo (hashdump)** | Fase 5 | `12-exploracao/evidencias.md` | [ ] |
| **Serviços de rede vivos** | Módulo 01 | `02-enum/nmap-services.txt` | [ ] |
| **IPs internos alcançáveis** | Módulo 01 | `02-enum/ips.txt` | [ ] |

**Para quê:** O Módulo 04 vai usar esses dados para **escalar privilégios** (LinPEAS/WinPEAS), **pivoting** (chisel/ligolo) e **manter acesso** (persistence) — tudo a partir da sessão que você abriu aqui.

### Resumo: o que NÃO pode faltar

```
MÍNIMO PARA AVANÇAR PARA O MÓDULO 04:
├── 12-exploracao/evidencias.md              ← sessão aberta + sysinfo/getuid
├── 10-bruteforce/credenciais-encontradas.md ← credenciais validadas
├── 13-validacao/validacao-acessos.md        ← nível de acesso confirmado
└── 14-relatorio/relatorio-exploracao.md     ← tudo documentado
```

**Se tem esses 4 arquivos → PODE avançar para o Módulo 04.**

---

## Fim da Exploração

**Quando terminar a Fase 7, você terá:**
- Transformado vulnerabilidades em acesso real (credenciais e/ou shell)
- Provado cada acesso com evidência replicável
- Documentado acertos E falhas com métricas
- Respeitado o escopo e encerrado tudo com segurança

**Próximo módulo:** [04 - Pós-Exploração](../../04-pos-exploracao/README.md)

---
