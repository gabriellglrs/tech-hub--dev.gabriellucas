## 📊 Visão Geral: Toda a Estrutura Final

Ao final das 7 fases deste manual, a estrutura COMPLETA (Módulo 01 + 02) deve parecer:

```
~/recon/targets/evilcorp/
├── 01-intel/                     ← Módulo 01
│   ├── whois.txt
│   ├── subdominios-todos.txt
│   └── theharvester.txt
├── 02-enum/                      ← Módulo 01
│   ├── nmap-services.txt
│   └── vivos-filtrados.txt
├── 03-fingerprint/               ← Módulo 01
│   └── httpx-tech.txt
├── 04-discovery/                 ← Módulo 01
│   ├── gobuster-basico.txt
│   ├── urls-com-parametros.txt
│   ├── js-endpoints.txt
│   └── js-secrets.txt
├── 05-vulns/                     ← Módulo 01
│   ├── nmap-vuln.txt
│   ├── nuclei.txt
│   └── wpscan.txt
├── 06-validacao/                 ← Módulo 01
│   └── resumo-severidade.md
├── 07-relatorio/                 ← Módulo 01
│   └── relatorio-recon.md
├── 08-alimentacao/               ← Fase 1 (Web)
│   ├── escopo-web.txt
│   ├── escopo-web.md
│   ├── endpoints-web.txt
│   ├── params-web.txt
│   ├── dirs-web.txt
│   ├── fingerprint-web.txt
│   ├── waf-web.txt
│   └── secrets-web.txt
├── 09-descoberta/                ← Fase 2 (Web)
│   ├── sitemap.xml
│   ├── http-history.xml
│   ├── ffuf-dirs.json
│   ├── ffuf-params.json
│   ├── subdomains-http.txt
│   ├── whatweb.txt
│   ├── headers.txt
│   ├── methods.txt
│   ├── api-docs.txt
│   ├── graphql-schema.json
│   ├── parametros.txt
│   ├── logins-formularios.txt    ← alimenta o Módulo 03
│   └── logins-web.txt
├── 10-injecao/                   ← Fase 3 (Web)
│   ├── sqli-test.txt
│   ├── sqlmap-dbs.txt
│   ├── sqlmap-dump.txt
│   ├── blind-sqli.txt
│   ├── nosqli.txt
│   ├── ssti.txt
│   └── cmdi.txt
├── 11-cliente-auth/              ← Fase 4 (Web)
│   ├── xss-reflected.txt
│   ├── xss-stored.txt
│   ├── dom-xss.txt
│   ├── csp.txt
│   ├── csrf-poc.html
│   ├── clickjacking-test.html
│   ├── cookies.txt
│   ├── user-enumeration.txt
│   ├── brute-force.txt
│   ├── auth-bypass.txt
│   ├── jwt-analysis.txt
│   └── oauth.txt
├── 12-especializados/            ← Fase 5 (Web)
│   ├── ssrf-test.txt
│   ├── ssrf-cloud.txt
│   ├── ssrf-ports.txt
│   ├── xxe-test.txt
│   ├── xxe-blind.txt
│   ├── upload-test.txt
│   ├── upload-polyglot.txt
│   ├── race_condition.py
│   ├── race-transfer.txt
│   ├── workflow-bypass.txt
│   ├── price-tampering.txt
│   └── idor.txt
├── 13-validacao/                 ← Fase 6 (Web)
│   ├── nuclei-basic.txt
│   ├── nuclei-criticos.txt
│   ├── nuclei-results.json
│   ├── findings-todos.txt
│   └── evidencias.md
├── 14-relatorio/                 ← Fase 7 (Web)
│   └── final/
│       ├── RELATORIO-SEGURANCA.md
│       └── evidencias.md
├── 15-alimentacao/               ← Fase 1 (Exploração — Módulo 03)
├── 16-vetores/                   ← Fase 2 (Exploração)
├── 17-bruteforce/                ← Fase 3 (Exploração)
├── 18-cracking/                  ← Fase 4 (Exploração)
├── 19-exploracao/                ← Fase 5 (Exploração)
├── 20-validacao/                 ← Fase 6 (Exploração)
└── 21-relatorio/                 ← Fase 7 (Exploração)
```

**Total de arquivos esperados:** ~80-100 arquivos organizados por fase (35-40 do recon + 25-30 do web + 25-30 da exploração).

---

## 🔗 Como os Módulos 01, 02 e 03 se alimentam

```
MÓDULO 01 (Recon)  →  MÓDULO 02 (Web, este manual)  →  MÓDULO 03 (Exploração)
   01-07                 08-14                            15-21
```

### Da Fase 1 (Alimentação) deste manual — o que vem de onde

| Arquivo que eu crio | Vem de onde | Arquivo original |
|---------------------|-------------|------------------|
| `escopo-web.txt` / `.md` | 01 — Recon | `02-enum/vivos-filtrados.txt` + `01-intel/subdominios-todos.txt` |
| `endpoints-web.txt` | 01 — Recon | `04-discovery/js-endpoints.txt` + `urls-com-parametros.txt` |
| `params-web.txt` | 01 — Recon | `04-discovery/urls-com-parametros.txt` |
| `dirs-web.txt` | 01 — Recon | `04-discovery/gobuster-basico.txt` |
| `fingerprint-web.txt` | 01 — Recon | `03-fingerprint/httpx-tech.txt` |
| `waf-web.txt` | 01 — Recon | wafw00f / httpx |
| `secrets-web.txt` | 01 — Recon | `04-discovery/js-secrets.txt` + `.env` expostos |

### O que CADA fase deste manual gera para a próxima

```
FASE 1  → escopo, endpoints, params, dirs, fingerprint, WAF, segredos
   ↓
FASE 2  → sitemap, métodos HTTP, API docs, parametros.txt, logins-formularios.txt
   ↓                    ↓                        ↓                    ↓
FASE 3 (Injeção)   FASE 4 (Cliente/Auth)   FASE 5 (Especializados)  FASE 6 (Nuclei)
  SQLi/NoSQLi/        XSS/CSRF/JWT/OAuth      SSRF/XXE/Upload/       CVEs + validação
  SSTI/CMDi           bypass                   Lógica de negócio       de TUDO
   ↓                    ↓                        ↓                    ↓
   └────────────────────┴────────────────────────┴────────────────────┘
                                     ↓
                        FASE 7 → RELATORIO-SEGURANCA.md
```

### O que este manual entrega ao Módulo 03 (Exploração)

| Dado que eu gero | Usado na fase do Módulo 03 | Para quê |
|------------------|----------------------------|----------|
| `09-descoberta/logins-formularios.txt` | Fase 1 → Fase 3 (Hydra HTTP) | Brute force de login web |
| `09-descoberta/logins-web.txt` | Fase 1 → Fase 3 | Caminhos de login/painel |
| `10-injecao/sqlmap-dump.txt` (hashes) | Fase 1 → Fase 4 (John/Hashcat) | Crackear hashes extraídos |
| `11-cliente-auth/user-enumeration.txt` | Fase 1 → Fase 3 | Usuários para brute force |
| `12-especializados/idor.txt` + credenciais | Fase 1 → Fase 5 (Metasploit) | Vetores já validados |

---

## 🔗 Conexão com o Módulo 03 — Exploração

### O que você precisa ter para avançar

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **Logins e formulários mapeados** | Fase 2 | `09-descoberta/logins-formularios.txt` | [ ] |
| **Vulnerabilidades web confirmadas** | Fase 6 | `13-validacao/evidencias.md` | [ ] |
| **Hashes extraídos (se SQLi)** | Fase 3 | `10-injecao/sqlmap-dump.txt` | [ ] |
| **Credenciais/vetores web** | Fases 3-5 | `11-cliente-auth/auth-bypass.txt` | [ ] |
| **Relatório web completo** | Fase 7 | `14-relatorio/final/RELATORIO-SEGURANCA.md` | [ ] |

**Para quê:** O Módulo 03 usa esses dados para **brute force** (Hydra nos forms que você mapeou), **cracking** (hashes que a SQLi extraiu) e **exploração** (vetores já confirmados).

### Resumo: o que NÃO pode faltar

```
MÍNIMO PARA AVANÇAR PARA O MÓDULO 03:
├── 09-descoberta/logins-formularios.txt  ← forms para o Hydra
├── 13-validacao/evidencias.md            ← vulns web confirmadas
└── 14-relatorio/final/RELATORIO-SEGURANCA.md ← tudo documentado
```

**Se tem esses 3 arquivos → PODE avançar para o [Módulo 03 — Exploração](../../03-exploracao/README.md).**

---

## Fim do Teste Web

**Quando terminar a Fase 7, você terá:**
- Mapeado a superfície de ataque completa da aplicação
- Testado injeção, cliente/auth e vetores especializados
- Validado cada vulnerabilidade com evidência reproduzível
- Gerado relatório profissional com CVSS e recomendações

**Próximo módulo:** [03 — Exploração](../../03-exploracao/README.md)
