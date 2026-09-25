## FASE 7 — Relatório

**Tempo estimado:** 60-120 minutos
**Objetivo:** Documentar TUDO de forma que outra pessoa consiga replicar e entender — do recon ao acesso.
**Por quê:** O relatório é o ÚNICO entregável que o cliente/equipe vê. Se não está no relatório, não aconteceu.

> **📡 Dados usados nos passos abaixo (de onde vêm):**
> - **MANUAL-RECON:** `07-relatorio/` (relatório de reconhecimento) + `06-validacao/resumo-severidade.md` — o relatório de exploração **complementa**, não repete
> - **MANUAL-WEB:** `14-relatorio/final/RELATORIO-SEGURANCA.md` + `13-validacao/evidencias.md` — vulnerabilidades web já validadas entram como "confirmadas no Módulo 02", sem re-descrever o passo a passo
> - **Fases deste manual:** `17-bruteforce/`, `18-cracking/`, `19-exploracao/`, `20-validacao/resumo-severidade-exploracao.md`

---

### Passo 7.1 — Criar Estrutura do Relatório

```bash
cat > 21-relatorio/relatorio-exploracao.md << 'EOF'
# Relatório de Exploração

| Campo | Valor |
|-------|-------|
| **Alvo** | evilcorp.com (10.0.0.0/24) |
| **Data** | 10/09/2026 |
| **Autor** | [SEU NOME] |
| **Módulos aplicados** | 01-Reconhecimento, 02-Web, 03-Exploração |
| **Classificação** | CONFIDENCIAL |

---

## 1. Resumo Executivo

Durante a exploração de evilcorp.com, foi possível obter **controle total de 1 máquina**,
**2 acessos administrativos** e **3 credenciais válidas**, a partir dos vetores
identificados no reconhecimento (Módulo 01) e no web testing (Módulo 02).

Principais resultados:

- **CRÍTICO:** Controle total (NT AUTHORITY\SYSTEM) via CVE-2017-0144 (EternalBlue) em 10.0.0.1
- **CRÍTICO:** Acesso administrativo ao painel web (admin/admin2024)
- **ALTO:** Credencial SSH admin:admin123 com reuso confirmado no FTP
- **ALTO:** Credencial SMB administrator:Admin@123 em 10.0.0.2
- **MÉDIO:** Hash MD5 crackeado (senha "EvilCorp2024!") reutilizada no login

Tempo total até primeiro acesso: **38 minutos** (brute force SSH).
Tempo total até controle total: **1h12** (EternalBlue via Metasploit).

## 2. Escopo

- **Alcance:** 10.0.0.0/24, *.evilcorp.com
- **Autorização:** [contrato/lab — descrever]
- **Brute force:** AUTORIZADO (com limite de 4 threads, sem rockyou online)
- **Exclusões:** DoS, produção de terceiros, privesc além do combinado

## 3. Metodologia

| Fase | Ferramentas | Resultados |
|------|------------|------------|
| 1 - Alimentação | grep/awk, CeWL | 6 serviços, 2 CVEs, 4 logins, 32 usernames |
| 2 - Priorização | Searchsploit | 1 vetor CVE prioridade 1, 3 brute force, 2 cracking |
| 3 - Brute Force | Hydra, Medusa | 2 credenciais validadas (SSH, FTP) |
| 4 - Cracking | hashid, John, Hashcat | 1 de 3 hashes quebrados (MD5) |
| 5 - Exploração | Metasploit, Searchsploit | 1 sessão Meterpreter (SYSTEM) |
| 6 - Validação | Manual (ssh, curl, meterpreter) | 5 acessos confirmados, 0 falsos positivos |

## 4. Descobertas

### 4.1 Credenciais Obtidas (Fases 3 e 4)

| # | Serviço | Host | Usuário | Senha | Origem | Evidência |
|---|---------|------|---------|-------|--------|-----------|
| 1 | SSH 22 | 10.0.0.1 | admin | admin123 | Hydra Top1000 | ssh + whoami |
| 2 | FTP 21 | 10.0.0.1 | ftpuser | ftp123 | Hydra (reuso) | ls -la (12 arquivos) |
| 3 | HTTP /login | evilcorp.com | admin | admin2024 | Hydra http-post-form | sessão /admin |

### 4.2 Acesso Remoto (Fase 5)

| Vetor | CVE | Ferramenta | Nível | Evidência |
|-------|-----|-----------|-------|-----------|
| Samba 445 (10.0.0.1) | CVE-2017-0144 | Metasploit eternalblue | NT AUTHORITY\SYSTEM | 19-exploracao/evidencias.md |

**Output da evidência:**
```
meterpreter > sysinfo
Computer        : EVILCORP-WEB01
OS              : Windows 7 (6.1.7601 Service Pack 1)
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```

### 4.3 Hashes Crackeados (Fase 4)

| Hash | Tipo | Senha | Origem | Reuso testado |
|------|------|-------|--------|:---:|
| 5f4dcc3b... | MD5 | password | js-secrets.txt | FTP ✅ |
| 5d41402a... | MD5 | EvilCorp2024! | .env exposto | Login web ✅ |

### 4.4 Vetores Sem Sucesso (documentar é obrigatório!)

| Vetor tentado | Ferramenta | Resultado | Motivo provável |
|---------------|-----------|-----------|-----------------|
| RDP 3389 | Hydra (200 tent.) | 0 acertos | NLA + sem usuário válido |
| MySQL 3306 | Hydra | Bloqueado | WAF/ban após 50 tentativas |
| bcrypt do dump | Hashcat | Exhausted | Senha forte demais para wordlists |

## 5. Recomendações

| # | Severidade | Recomendação |
|---|-----------|-------------|
| 1 | CRÍTICO | Aplicar patch MS17-010 (atualizar sistema Windows) |
| 2 | CRÍTICO | Trocar senha admin/admin2024 e implementar MFA no painel |
| 3 | ALTO | Trocar senhas fracas (admin123, ftp123) por senhas fortes |
| 4 | ALTO | Implementar política de senha + lockout inteligente no SSH/FTP |
| 5 | ALTO | Remover reuso de credenciais entre serviços |
| 6 | MÉDIO | Proteger .env e segredos de JS (Módulo 02 já apontou) |
| 7 | MÉDIO | Desativar acesso anônimo FTP |
| 8 | MÉDIO | Implementar fail2ban com limiares adequados |

## 6. Métricas

| Métrica | Valor |
|---------|-------|
| Tentativas de brute force (total) | ~1.200 |
| Tempo até 1ª credencial | 38 min |
| Tempo até controle total | 1h12 |
| Lockouts ativados | 0 |
| Falsos positivos | 0 |

## 7. Ferramentas Utilizadas

Hydra, Medusa, hashid, John the Ripper, Hashcat, Searchsploit, Metasploit Framework,
CeWL, SecLists, curl, ncat (Nmap do Módulo 01 para base de dados)

## 8. Anexos

- 07-relatorio/ — relatório de reconhecimento (Módulo 01, MANUAL-RECON)
- 13-validacao/evidencias.md — vulns web validadas (Módulo 02, MANUAL-WEB)
- 14-relatorio/final/ — relatório web completo (Módulo 02, MANUAL-WEB)
- 15-alimentacao/ — dados importados dos Módulos 01 e 02
- 16-vetores/ — matriz de decisão
- 17-bruteforce/ — outputs do Hydra
- 18-cracking/ — resultados do John/Hashcat
- 19-exploracao/ — logs do Metasploit e evidências
- 20-validacao/ — validação de cada acesso
EOF

echo "Relatório criado: 21-relatorio/relatorio-exploracao.md"
```

---

### Passo 7.2 — Revisão antes de entregar

| # | Verificação | ☑ |
|---|-------------|:---:|
| 1 | Resumo executivo entende quem NÃO é técnico | [ ] |
| 2 | Cada achado tem: vetor, comando, output, impacto, severidade | [ ] |
| 3 | Falsos positivos REMOVIDOS | [ ] |
| 4 | Vetores sem sucesso documentados (transparência) | [ ] |
| 5 | Recomendações são específicas e acionáveis | [ ] |
| 6 | Métricas preenchidas (tentativas, tempo, lockouts) | [ ] |
| 7 | Evidências anexadas e caminhos corretos | [ ] |
| 8 | Nenhum dado pessoal desnecessário exposto | [ ] |

---

### Checklist da Fase 7

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Relatório completo | `21-relatorio/relatorio-exploracao.md` | [ ] |
| 2 | Resumo executivo escrito | Seção 1 | [ ] |
| 3 | Credenciais/acessos documentados | Seção 4.1 e 4.2 | [ ] |
| 4 | Falhas documentadas | Seção 4.4 | [ ] |
| 5 | Recomendações listadas | Seção 5 | [ ] |
| 6 | Revisão final concluída | Passo 7.2 | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 7:

```
21-relatorio/
└── relatorio-exploracao.md    ← relatório completo e profissional
```

### ✅ Sinal de sucesso:
- Relatório tem **Resumo Executivo** que qualquer pessoa entende
- Cada acesso tem: **vetor + comando + output + impacto + severidade**
- **Recomendações** são específicas e acionáveis
- Outra pessoa consegue **replicar** o que você fez

**✅ Parabéns! Você completou a exploração!**

---

**Próximo:** visão geral da estrutura → [14 - Visão Geral](14-visao-geral.md)
