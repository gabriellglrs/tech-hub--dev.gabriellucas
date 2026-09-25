## Conhecimentos Mínimos

> **Antes de abrir o Burp, você precisa dominar o básico.** Se não souber o que é um parâmetro GET ou como funciona uma sessão, você vai copiar payloads sem entender — e não vai saber consertar quando der errado.

### 1. Linux (obrigatório)

Você precisa conseguir operar no terminal sem travar:

| Habilidade | Exemplo | Por quê |
|------------|---------|---------|
| Navegar em pastas | `cd ~/recon/targets/evilcorp` | Todo o trabalho fica em pastas organizadas |
| Criar pastas | `mkdir -p 08-alimentacao 09-descoberta` | Cada fase tem sua pasta |
| Redirecionar output | `ffuf ... > saida.txt` | Todo resultado precisa ser salvo |
| Concatenar arquivos | `cat a.txt b.txt \| sort -u > c.txt` | Combinar listas e resultados |
| Editar arquivo | `nano arquivo.txt` | Corrigir escopo e relatórios |
| Verificar instalação | `command -v sqlmap` | Saber se a ferramenta existe |
| Grep/Filtros | `grep -i login resposta.txt` | Achar endpoints em outputs |

**Se travou aqui:** revise o Módulo 0 do curso (Linux básico) antes de continuar.

### 2. Redes e HTTP (obrigatório)

| Conceito | O que é | Exemplo prático no teste web |
|----------|---------|-------------------------------|
| **Requisição HTTP** | Pedido do cliente ao servidor | `GET /login HTTP/1.1` |
| **Métodos** | Ação do pedido | GET (ler), POST (enviar), PUT (criar), DELETE (remover) |
| **Status** | Resultado do pedido | 200 ok, 301/302 redireciona, 401/403 bloqueia, 500 erro de servidor |
| **Parâmetro** | Dado enviado na URL ou corpo | `/busca?q=teste` → `q=teste` |
| **Cookie/Sessão** | Estado do usuário no servidor | `SESSIONID=abc123` — vira "usuário logado" |
| **TLS/HTTPS** | Criptografia da conexão | Precisa do CA cert do Burp para interceptar |
| **WAF** | Firewall web | Bloqueia payloads com 403/429 em segundos |
| **Rate limit** | Limite de requests por tempo | 429 Too Many Requests = PARE |

### 3. Web e Segurança (obrigatório)

| Conceito | O que é | Onde aparece neste manual |
|----------|---------|---------------------------|
| **Endpoint** | URL que aceita requisições | `/login`, `/api/users`, `/upload` |
| **Formulário** | Coleta dados (login, busca, cadastro) | Fases 2, 3 e 4 — campos são vetores |
| **Vulnerabilidade** | Falha explorável (ex: XSS, SQLi) | Fases 3, 4 e 5 |
| **Payload** | Código/entrada que explora a falha | `<script>alert(1)</script>`, `' OR 1=1--` |
| **Escopo** | O que você PODE testar | Todas as fases — acima de tudo |
| **Falso positivo** | Ferramenta reporta vuln que não existe | Fase 6 — validação manual obrigatória |
| **Reprodutibilidade** | O achado roda de novo igual | Fases 6 e 7 — base do relatório |

### 4. Pré-requisito de Módulos Anteriores

> **Este manual NÃO funciona sozinho.** Ele é a continuação direta do Módulo 01 e prepara o Módulo 03:

| Módulo | O que você precisa ter terminado | Onde eu uso isso |
|--------|----------------------------------|------------------|
| **01 — Reconhecimento** | URLs vivas com status HTTP em `~/recon/targets/<alvo>/` | **Fase 1** importa `vivos-filtrados.txt` → escopo do Burp |
| **01 — Reconhecimento** | Diretórios, URLs com parâmetros e endpoints JS | **Fase 1** vira `endpoints-web.txt` e `params-web.txt` |
| **01 — Reconhecimento** | Fingerprint (WhatWeb), WAF e headers de segurança | **Fase 2** decide payloads; **Fase 4** testa headers |
| **01 — Reconhecimento** | Secrets em JS (API keys, tokens) | **Fase 1** documenta como achado CRÍTICO imediato |
| **02 — Web (conteúdo)** | Ter lido `01-burp-suite.md` + os tópicos que vai testar (`02-injecao-e-fuzzing.md`, `05-xss-avancado.md`, `07-ssrf.md`…) | As fases 2-5 são a versão "passo a passo operacional" daquele conteúdo |
| **→ Módulo 03 (MANUAL-EXPLOR)** | O que ESTE manual produz | Fase 1 da exploração importa `formularios.txt`, `logins-web.txt` e o `resumo-severidade-web.md` |

### ✅ Checklist mínimo para continuar

| # | Item | ☑ |
|---|------|:---:|
| 1 | Sei redirecionar output para arquivo (`>`) | [ ] |
| 2 | Sei a diferença entre GET e POST e o que é status 200/403/500 | [ ] |
| 3 | Sei inspecionar um formulário (nome dos campos no HTML) | [ ] |
| 4 | Sei o que é cookie de sessão e WAF | [ ] |
| 5 | Completei o Módulo 01 (recon) neste mesmo alvo | [ ] |
| 6 | Li o conteúdo do Módulo 02 (Burp + técnicas) | [ ] |
| 7 | Li o aviso legal do 00-header.md e tenho AUTORIZAÇÃO | [ ] |

---

**Se marcou tudo → Avance para [02 - Antes de Começar](02-antes-de-comecar.md)**
