## Módulo 11: IA para Cybersegurança

### Labs Existentes (LABS.md)

| # | Lab | Plataforma | URL | Status Validação |
|---|-----|-----------|-----|-----------------|
| 1 | Instalação e Primeiro Uso do Ollama | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 2 | IA Analisando Nmap | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 3 | Gerando Payloads com IA | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 4 | Análise de Senhas com IA | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 5 | Workflow Completo — IA + Pentest | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 6 | Crie seu Próprio Assistente AI | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |

**Resumo existente:** 6 labs, todos locais usando Ollama (llama3.2, codellama). **Forte em:** pipeline completo de IA + pentest. **Fraqueza:** zero labs em plataformas interativas — todos dependem de Ollama local.

### Labs Candidatos Novos

| # | Lab | Plataforma | URL | Tópico Coberto | Status Validação |
|---|-----|-----------|-----|---------------|-----------------|
| 1 | AI Challenges (10+) | PicoCTF | https://play.picoctf.org/practice | Prompt injection, model attacks, AI security | ⚠️ Redirect (403 bot detection) |
| 2 | AI Category (prompt injection) | PicoCTF | https://play.picoctf.org/practice | Desafios de prompt injection | ⚠️ Redirect (403 bot detection) |
| 3 | Web LLM Attacks | PortSwigger | https://portswigger.net/web-security/all-labs | LLM attacks em web apps | ⚠️ Topic existe, URL a validar |
| 4 | AI for Cyber | TryHackMe | https://tryhackme.com/room/aicyber | IA aplicada à segurança | ⏳ Pendente (rate-limit) |

### Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|--------|-------------|-----------|---------------|
| AI/ML security fundamentals | CEH v13 (novo) | Crítico | CEH v13 adicionou módulo de IA |
| Adversarial ML (evasion, poisoning) | CEH v13 AI module | Importante | Ataques contra modelos de IA |
| AI-powered threat detection | Security+ (emergente) | Importante | Defesa com IA |
| Deepfake detection | CEH v13 (emergente) | Importante | Tecnologia emergente |
| AI ethics in cybersecurity | CEH v13 | Opcional | Governança de IA |
| LLM prompt injection defense | PortSwigger (4 labs) | Importante | Vulnerabilidade emergente em web |

### Resumo

- **Labs existentes:** 6 (todos locais com Ollama)
- **Labs candidatos novos:** 4 (1 PicoCTF AI, 1 PicoCTF prompt injection, 1 PortSwigger LLM, 1 THM)
- **Total potencial:** 10 labs
- **Plataforma mais forte:** PicoCTF (10+ desafios de AI) — mas com redirect
- **Cobertura limitada documentada:** Este é o módulo mais novo e com menos labs gratuitos disponíveis
- **Força do módulo:** Pipeline completo de IA + pentest usando Ollama (local, gratuito)
- **Fraqueza:** Plataformas interativas têm poucos labs de IA para segurança
- **Gaps críticos:** Adversarial ML, AI-powered threat detection, Deepfake detection
- **Recomendação:** Módulo precisa de conteúdo novo — labs atuais são insuficientes para cobrir CEH v13 AI module
- **Observação:** PortSwigger tem "Web LLM attacks" como tópico (4 labs) — URL precisa ser validada
