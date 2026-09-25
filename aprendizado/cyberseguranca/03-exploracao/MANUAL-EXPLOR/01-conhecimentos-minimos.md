## Conhecimentos Mínimos

> **Antes de tentar quebrar qualquer senha, você precisa dominar o básico.** Se não souber o que é uma porta TCP ou como funciona um hash, você vai copiar comandos sem entender — e não vai saber consertar quando der errado.

### 1. Linux (obrigatório)

Você precisa conseguir operar no terminal sem travar:

| Habilidade | Exemplo | Por quê |
|------------|---------|---------|
| Navegar em pastas | `cd ~/recon/targets/evilcorp` | Todo o trabalho fica em pastas organizadas |
| Criar pastas | `mkdir -p 08-alimentacao 09-vetores` | Cada fase tem sua pasta |
| Redirecionar output | `hydra ... > saida.txt` | Todo resultado precisa ser salvo |
| Concatenar arquivos | `cat a.txt b.txt \| sort -u > c.txt` | Combinar wordlists e resultados |
| Editar arquivo | `nano arquivo.txt` | Corrigir wordlists e relatórios |
| Verificar instalação | `command -v hydra` | Saber se a ferramenta existe |
| Permissões | `chmod +x script.sh` | Rodar scripts de automação |
| Histórico | `history \| grep hydra` | Revisar o que você já tentou |

**Se travou aqui:** revise o Módulo 0 do curso (Linux básico) antes de continuar.

### 2. Redes (obrigatório)

| Conceito | O que é | Exemplo prático na exploração |
|----------|---------|-------------------------------|
| **Porta** | "Porta de entrada" de um serviço | 22 = SSH, 21 = FTP, 445 = SMB, 3389 = RDP |
| **Serviço** | Programa rodando na porta | OpenSSH, vsftpd, MySQL, Apache |
| **TCP vs UDP** | TCP = conexão confiável; UDP = sem confirmação | Hydra só funciona em TCP |
| **Banner** | Texto de identificação do serviço | `SSH-2.0-OpenSSH_8.9p1` → diz a versão |
| **Firewall/IPS** | Bloqueia tráfego suspeito | Hydra com 64 threads = IP banido em segundos |
| **Lockout** | Bloqueio de conta após tentativas | 3 tentativas erradas = conta travada no AD |
| **VPN** | Esconde seu IP | Obrigatório — seu IP fica nos logs para sempre |

### 3. Web (obrigatório — vem do Módulo 02)

| Conceito | O que é | Por quê importa aqui |
|----------|---------|----------------------|
| **Formulário POST** | Login envia dados no corpo HTTP | Hydra precisa dos nomes exatos dos campos |
| **Cookies/sessão** | Estado do usuário | Brute force HTTP pode precisar manter sessão |
| **Status HTTP** | 200, 301, 403, 404, 500 | Falso positivo = 302 que sempre acontece |
| **WAF** | Firewall web | Pode bloquear brute force HTTP em 5 tentativas |
| **Endpoint** | URL de um recurso | `/wp-login.php`, `/admin/login`, `/api/auth` |

### 4. Conceitos de Segurança (obrigatório)

| Conceito | O que é | Onde aparece neste manual |
|----------|---------|---------------------------|
| **Hash** | Senha transformada em "impressão digital" (irreversível) | Fase 4 — só é possível TENTAR adivinhar |
| **CVE** | Vulnerabilidade conhecida e catalogada | Fase 2 — vetor de ataque com exploit pronto |
| **Exploit** | Código que ABUSA de uma vulnerabilidade | Fase 5 — Metasploit/Searchsploit |
| **Payload** | O que é executado no alvo (ex: reverse shell) | Fase 5 — gerar e configurar |
| **Brute force** | Testar senhas automaticamente | Fase 3 — Hydra |
| **Dictionary attack** | Testar senhas de uma wordlist | Fase 3 e 4 |
| **Privilege escalation** | Ganhar privilégios maiores (root/SYSTEM) | Fase 6 — validação |
| **Scope/escopo** | O que você PODE testar | Todas as fases — acima de tudo |

### 5. Pré-requisito de Módulos Anteriores

> **Este manual NÃO funciona sozinho.** Ele é a continuação direta:

| Módulo | O que você precisa ter terminado | Onde eu uso isso |
|--------|----------------------------------|------------------|
| **01 — Reconhecimento** | Mapeamento de portas, serviços, versões e vulnerabilidades em `~/recon/targets/<alvo>/` | **Fase 1** importa `nmap-services.txt`, `nmap-vuln.txt`, `resumo-severidade.md` |
| **01 — Reconhecimento** | Emails e usuários coletados no OSINT | **Fase 1** vira `usernames-candidatos.txt` |
| **02 — Web & Aplicações** | URLs de login, formulários, campos e endpoints descobertos (ver também **[MANUAL-WEB/](../../02-web-aplicacoes/MANUAL-WEB/)**) | **Fase 1** vira `alvos-login-web.txt` |
| **02 — Web & Aplicações** | Credenciais/segredos encontrados em JS, .env, params | **Fase 1** vira candidatos a senha |
| **03 — Exploração** (conteúdo) | Ter lido `01-preparacao-e-wordlists.md`, `03-brute-force-e-spraying.md` e `08-metasploit-e-msfvenom.md` | As fases 3, 4 e 5 são a versão "passo a passo operacional" daquele conteúdo |

### ✅ Checklist mínimo para continuar

| # | Item | ☑ |
|---|------|:---:|
| 1 | Sei redirecionar output para arquivo (`>`) | [ ] |
| 2 | Sei o que é porta, serviço e banner | [ ] |
| 3 | Sei inspecionar um formulário de login (nome dos campos) | [ ] |
| 4 | Sei o que é hash e por quê não dá para "desfazer" | [ ] |
| 5 | Completei o Módulo 01 (recon) neste mesmo alvo | [ ] |
| 6 | Completei o Módulo 02 (web) neste mesmo alvo | [ ] |
| 7 | Li o aviso legal do 00-header.md e tenho AUTORIZAÇÃO | [ ] |

---

**Se marcou tudo → Avance para [02 - Antes de Começar](02-antes-de-comecar.md)**
