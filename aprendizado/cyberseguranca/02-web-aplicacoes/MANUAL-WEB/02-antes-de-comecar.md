## Antes de Começar

### O que é um Teste de Segurança Web?

Um teste web é a fase em que você **prova** que as vulnerabilidades existem — você transforma "esse parâmetro parece suspeito" em "aqui está o SQLi executando". É o passo que separa quem só escaneou de quem provou impacto real (e consegue documentar para correção).

Em segurança ofensiva web, o teste significa:
- Mapear a superfície com Burp (crawl, escopo, histórico)
- Testar injeções (SQLi, NoSQLi, SSTI, command injection)
- Testar o lado cliente (XSS, CSRF, clickjacking) e autenticação (sessão, JWT, OAuth)
- Vetores especializados (SSRF, XXE, upload, lógica de negócio)
- Confirmar com varredura automatizada (Nuclei) + validação manual
- Documentar tudo em relatório reprodutível

### Por que NÃO pular fases?

Se você pular a Fase 1 (alimentação) e sair fuzzando o alvo inteiro, você pode:
- Repetir descobertas que o Módulo 01 já fez (gobuster/ffuf de novo = horas perdidas)
- Fuzzar fora do escopo (CDN, serviços de terceiros = você quebra o contrato)
- Ignorar WAF detectado no recon e levar ban na primeira requisição
- Perder secrets em JS que já eram um achado CRÍTICO sem precisar de teste

**Cada fase gera dados que alimentam a próxima.** Pular fases = trabalhar no escuro — e o alvo registra cada request seu nos logs.

### Conceitos que você PRECISA saber antes de começar

| Conceito | O que é | Exemplo |
|----------|---------|---------|
| **Request/Response** | Pedido e resposta HTTP | `GET /login` → `200 OK` com HTML |
| **Parâmetro GET** | Dado na URL | `/busca?q=teste` |
| **Parâmetro POST** | Dado no corpo | `username=admin&password=123` |
| **Header** | Metadados do request | `Cookie:`, `Authorization:`, `X-Forwarded-For` |
| **Intercept** | Burp pausa o request para edição | Proxy → Intercept → Forward |
| **Repeater** | Repetir/editar requests manualmente | Testar payload uma vez por vez |
| **Intruder** | Ataque automatizado no Burp | Fuzzing controlado de campos |
| **Crawler/Spider** | Navegação automática do site | Mapeia links e endpoints |
| **WAF** | Firewall web do alvo | Bloqueia `<script>` com 403 |
| **Token** | Chave anti-CSRF/usada em APIs | `csrf_token=eyJhbGci...` |
| **JWT** | Token auto-contido (header.payload.assinatura) | `eyJhbGciOiJIUzI1NiJ9.eyJ...` |
| **Escopo** | URLs/domínios autorizados | `*.evilcorp.com` — fora disso é crime |
| **Falso positivo** | Reporte incorreto da ferramenta | Nuclei reporta vuln patcheada |

---

### Preparação do Ambiente

Execute cada item abaixo ANTES de começar qualquer teste. Marque com ☑ quando concluir.

| # | O que fazer | Comando | Por quê | ☑ |
|---|-------------|---------|---------|:---:|
| 1 | Ter a estrutura do recon pronta | `ls ~/recon/targets/evilcorp/` | A Fase 1 importa dessas pastas | [ ] |
| 2 | Criar as pastas do teste web | `mkdir -p 08-alimentacao 09-descoberta 10-injecao 11-cliente-auth 12-especializados 13-validacao 14-relatorio` | Organizar tudo por fase | [ ] |
| 3 | Entrar na pasta do alvo | `cd ~/recon/targets/evilcorp` | Todo trabalho ficará aqui | [ ] |
| 4 | Atualizar sistema | `sudo apt update && sudo apt upgrade -y` | Ferramentas atualizadas | [ ] |
| 5 | Instalar Burp + ferramentas CLI | Veja [03-setup-ferramentas.md](03-setup-ferramentas.md) | Burp é o centro da operação | [ ] |
| 6 | Rodar o checklist automático | Veja [04-checklist-setup.md](04-checklist-setup.md) | Garantir que TUDO funciona | [ ] |
| 7 | Confirmar AUTORIZAÇÃO | Escrever em arquivo: URLs IN e OUT | Ilegal sem autorização por escrito | [ ] |
| 8 | Ligar a VPN | `nordvpn connect && curl -s https://ifconfig.me` | Seu IP real não pode aparecer | [ ] |

**Depois de criar as pastas, sua estrutura deve parecer:**
```
~/recon/targets/evilcorp/
├── 01-intel/            ← Módulo 01 (já feito)
├── 02-enum/             ← Módulo 01 (já feito)
├── 03-fingerprint/      ← Módulo 01 (já feito)
├── 04-discovery/        ← Módulo 01 (já feito)
├── 05-vulns/            ← Módulo 01 (já feito)
├── 06-validacao/        ← Módulo 01 (já feito)
├── 07-relatorio/        ← Módulo 01 (já feito)
├── 08-alimentacao/      ← Fase 1: importa dados do Módulo 01
├── 09-descoberta/       ← Fase 2: crawl, fuzzing, endpoints, APIs
├── 10-injecao/          ← Fase 3: SQLi, NoSQLi, SSTI, command injection
├── 11-cliente-auth/     ← Fase 4: XSS, CSRF, sessão, JWT, OAuth
├── 12-especializados/   ← Fase 5: SSRF, XXE, upload, lógica de negócio
├── 13-validacao/        ← Fase 6: Nuclei + validação manual
├── 14-relatorio/        ← Fase 7: relatório final do teste web
├── 15-alimentacao/      ← Módulo 03 (MANUAL-EXPLOR, próximo)
├── ...                  ← 15-21: exploração (Módulo 03)
```

**Crie as subpastas agora:**
```bash
cd ~/recon/targets/evilcorp
mkdir -p 08-alimentacao 09-descoberta 10-injecao 11-cliente-auth 12-especializados 13-validacao 14-relatorio
```

> **Importante:** O teste web CONTINUA a árvore do recon (01 → 07) e entrega a árvore para a exploração (15 → 21). Assim todos os dados do mesmo alvo ficam num lugar só, e o Módulo 03 sabe exatamente onde procurar.

---

### Ferramentas Necessárias

Verifique se cada ferramenta está instalada. Se alguma não estiver, instale-a.

| Ferramenta | Para que serve | Como verificar | Como instalar se faltar |
|------------|---------------|----------------|------------------------|
| `burpsuite` | Proxy/intercept de tráfego (coração do módulo) | `which burpsuite` | `sudo apt install burpsuite` |
| `sqlmap` | Injeção SQL automatizada | `sqlmap --version` | `sudo apt install sqlmap` |
| `ffuf` | Fuzzing de diretórios/parâmetros (rápido) | `ffuf -V` | `go install github.com/ffuf/ffuf/v2@latest` |
| `gobuster` | Dirbusting (alternativa ao ffuf) | `gobuster version` | `sudo apt install gobuster` |
| `httpx` | Probe HTTP (status/tech de várias URLs) | `httpx -version` | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| `whatweb` | Fingerprint de tecnologias | `whatweb --version` | `sudo apt install whatweb` |
| `nuclei` | Varredura por templates (9000+) | `nuclei -version` | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` |
| `curl` | Requests manuais de teste | `curl --version` | `sudo apt install curl` |
| `nikto` | Scanner web básico (complementar) | `nikto -Version` | `sudo apt install nikto` |
| `wpscan` | WordPress (se CMS detectado no recon) | `wpscan --version` | `sudo apt install wpscan` |
| `seclists` | Wordlists (dirs, params, users) | `ls /usr/share/seclists` | `sudo apt install seclists` |
| `cewl` | Wordlist do próprio alvo | `cewl --version` | `sudo apt install cewl` |
| `hydra` | Brute force de login (só se escopo permitir) | `hydra -h` | `sudo apt install hydra` |

---

**Se preparou tudo → Avance para [03 - Setup de Ferramentas](03-setup-ferramentas.md)**
