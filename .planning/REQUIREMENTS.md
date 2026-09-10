# Requirements: Trilha de Aprendizado em Cybersegurança

**Defined:** 2026-09-10
**Core Value:** Todo módulo deve deixar a pessoa apta a FAZER, não só a ter lido.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Auditoria

- [ ] **AUD-01**: Ler todos os 12 módulos (00-11) e avaliar correção técnica, completude de comandos, qualidade dos labs
- [ ] **AUD-02**: Gerar tabela de auditoria (módulo | nota geral | principais problemas | prioridade de correção)
- [ ] **AUD-03**: Verificar se 00-pre-requisitos orienta instalação/configuração do Kali Linux como ambiente de prática
- [ ] **AUD-04**: Avaliar progressão didática por módulo (assume conhecimento não ensinado antes? sim/não) e consistência de tom/profundidade com os demais

### Pesquisa de Labs

- [ ] **PESQ-01**: Para cada módulo, buscar na TryHackMe (+ HackTheBox, PortSwigger, OverTheWire, PicoCTF) salas/labs gratuitos que cobrem o conteúdo e ainda não estão no LABS.md — listar os candidatos
- [ ] **PESQ-02**: Verificar se a ordem e os tópicos dos módulos refletem o que OSCP, CEH v13, Security+ SY0-701 e trilhas de referência (THM, HTB Academy) consideram essencial em 2026 — apontar módulos ou tópicos totalmente ausentes

### Modernização de Ferramentas

- [ ] **FERR-01**: Substituir ferramentas obsoletas (MITMf, Armitage, theHarvester-only) por equivalentes atuais (Subfinder, Nuclei, ffuf, BloodHound CE)
- [ ] **FERR-02**: Validar se todas as ferramentas citadas vêm pré-instaladas no Kali 2026 ou documentar comando de instalação correto
- [ ] **FERR-03**: Verificar se links de plataformas (TryHackMe, PortSwigger, HTB, OverTheWire, PicoCTF) estão funcionando e apontando pra salas gratuitas atuais

### Conteúdo Prático

- [ ] **PRAT-01**: Adicionar output esperado (print/trecho real ou simulado) para cada comando citado no conteúdo dos módulos
- [ ] **PRAT-02**: Garantir que toda ferramenta tem: comando de instalação + comando de uso completo (flags explicadas) + output esperado
- [ ] **PRAT-03**: Verificar que LABS.md de cada módulo tem exercícios reais e verificáveis (não teoria disfarçada de lab)

### Navegação e Organização

- [ ] **NAVE-01**: Decidir entre atualizar ROADMAP.md (refletir estrutura atual de 12 módulos) ou removê-lo (já que README.md cumpre esse papel) — e executar a decisão
- [ ] **NAVE-02**: Atualizar GLOSSARIO.md com todos os termos novos das ferramentas modernizadas
- [ ] **NAVE-03**: Adicionar navegação avançada (busca, filtros, navegação entre módulos) no README.md principal
- [ ] **NAVE-04**: Gerar ordem de execução priorizada (quais módulos corrigir primeiro — por desvio didático, por ser pré-requisito de outro, ou por correção simples)

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Conteúdo Novo

- **CONT-01**: Módulo de Active Directory Attacks (BloodHound, Kerberoasting, Pass-the-Hash)
- **CONT-02**: Módulo de Engenharia Social e Phishing
- **CONT-03**: Módulo de Threat Intelligence e MITRE ATT&CK
- **CONT-04**: Reescrever módulo 11 (IA) com ferramentas atuais (CAI, prompt injection, defensive AI)
- **CONT-05**: Seção "Perspectiva Defensiva" nos módulos ofensivos (01-06)

### Infraestrutura de Labs

- **LABS-01**: Labs Docker para Wazuh/Suricata (defesa)
- **LABS-02**: Ambiente vulnerável AD pra prática (GOAD, Vulnerable-AD)
- **LABS-03**: Atualizar cheatsheets com ferramentas novas

### Formato

- **FORM-01**: Exportar conteúdo em PDF/ZIP pra estudo offline
- **FORM-02**: Seções de métricas de progresso do leitor

## Out of Scope

| Feature | Reason |
|---------|--------|
| Tradução PT/EN | Público é brasileiro, conteúdo fica em português |
| Criação de plataformas próprias | Usa apenas plataformas existentes (THM, HTB, PortSwigger, etc.) |
| Conteúdo sobre hardware hacking | Fora do escopo da trilha |
| Pentester físico/presencial | Foco em cybersegurança digital |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUD-01 | Phase 1 | Pending |
| AUD-02 | Phase 1 | Pending |
| AUD-03 | Phase 1 | Pending |
| AUD-04 | Phase 1 | Pending |
| NAVE-04 | Phase 1 | Pending |
| PESQ-01 | Phase 2 | Pending |
| PESQ-02 | Phase 2 | Pending |
| FERR-01 | Phase 3 | Pending |
| FERR-02 | Phase 3 | Pending |
| FERR-03 | Phase 3 | Pending |
| PRAT-01 | Phase 3 | Pending |
| PRAT-02 | Phase 3 | Pending |
| PRAT-03 | Phase 3 | Pending |
| NAVE-01 | Phase 4 | Pending |
| NAVE-02 | Phase 4 | Pending |
| NAVE-03 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 16 total
- Mapped to phases: 16/16 ✓
- Unmapped: 0

---
*Requirements defined: 2026-09-10*
*Last updated: 2026-09-10 after roadmap creation*
