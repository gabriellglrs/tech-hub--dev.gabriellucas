# Roadmap: Trilha de Aprendizado em Cybersegurança

## Visão Geral

Reestruturar a trilha de aprendizado em cybersegurança (12 módulos) em 4 fases. A Fase 1 gera a ordem de execução priorizada; a Fase 3 executa módulo por módulo (ferramenta + conteúdo prático juntos), fechando cada módulo completamente antes de ir pro próximo.

## Fases

**Numeração de Fases:**
- Fases inteiras (1, 2, 3, 4): Trabalho planejado
- Fases decimais (2.1, 2.2): Inserções urgentes (marcadas com INSERTED)

Fases decimais aparecem entre seus inteiros vizinhos em ordem numérica.

- [ ] **Fase 1: Auditoria Completa** - Avaliar todos os 12 módulos, gerar tabela de diagnóstico, definir ordem de execução priorizada
- [ ] **Fase 2: Pesquisa e Referências** - Mapear labs gratuitos, validar ordem dos módulos contra certificações e plataformas atuais
- [ ] **Fase 3: Modernização + Conteúdo Prático** - Módulo por módulo (na ordem da Fase 1): atualizar ferramentas + adicionar outputs + enriquecer labs
- [ ] **Fase 4: Navegação e Organização** - Decidir sobre ROADMAP.md, atualizar glossário, adicionar navegação avançada

## Detalhes das Fases

### Fase 1: Auditoria Completa
**Goal**: Ter um diagnóstico completo e confiável de cada módulo, e saber a ordem exata em que eles devem ser processados
**Depends on**: Nada (primeira fase)
**Requirements**: AUD-01, AUD-02, AUD-03, AUD-04, NAVE-04
**Success Criteria** (o que deve ser VERDADE):
  1. Todos os 12 módulos (00-11) foram lidos e avaliados individualmente
  2. Existe tabela de auditoria com nota geral, principais problemas e prioridade de correção para cada módulo
  3. O módulo 00 foi verificado quanto à orientação de instalação/configuração do Kali Linux
  4. A progressão didática foi avaliada — cada módulo indica se assume conhecimento não ensinado anteriormente E se o tom/profundidade é consistente com os demais
  5. Existe ordem de execução priorizada — quais módulos corrigir primeiro (por desvio didático, ser pré-requisito, ou correção simples)
**Plans:** 3 plans

Plans:
- [ ] 01-01-PLAN.md — Root context + module 00 audit (Kali guidance, 18 files)
- [ ] 01-02-PLAN.md — Modules 01-06 audit (offensive modules, 30 files)
- [ ] 01-03-PLAN.md — Modules 07-11 audit + all 5 report generation

### Fase 2: Pesquisa e Referências
**Goal**: Ter um mapeamento completo de labs gratuitos por módulo e validação de que a ordem dos tópicos reflete o que certificações e plataformas consideram essencial em 2026
**Depends on**: Fase 1
**Requirements**: PESQ-01, PESQ-02
**Success Criteria** (o que deve ser VERDADE):
  1. Para cada módulo, existe lista de salas/labs gratuitos candidatos (TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF) que cobrem o conteúdo e ainda não estão no LABS.md
  2. A ordem e tópicos dos 12 módulos foram comparados com OSCP, CEH v13, Security+ SY0-701 e trilhas de referência (THM, HTB Academy)
  3. Módulos ou tópicos totalmente ausentes das referências foram apontados com justificativa
**Plans**: TBD

Plans:
- [ ] 02-01: Pesquisar labs gratuitos por módulo em plataformas atuais
- [ ] 02-02: Validar ordem e tópicos contra certificações e trilhas de referência

### Fase 3: Modernização + Conteúdo Prático
**Goal**: Cada módulo processado fica completamente atualizado — ferramentas atuais, outputs documentados, labs verificáveis — processado módulo a módulo na ordem definida na Fase 1
**Depends on**: Fase 1, Fase 2
**Requirements**: FERR-01, FERR-02, FERR-03, PRAT-01, PRAT-02, PRAT-03
**Success Criteria** (o que deve ser VERDADE):
  1. Para cada módulo (na ordem priorizada da Fase 1): ferramentas obsoletas substituídas, instalação validada no Kali 2026, links verificados
  2. Para cada módulo: todo comando tem output esperado documentado
  3. Para cada módulo: toda ferramenta tem bloco padronizado (instalação + uso com flags explicadas + output)
  4. Para cada módulo: LABS.md tem exercícios reais e verificáveis
**Plans**: TBD

Plans (executados módulo a módulo):
- [ ] 03-01: Processar módulo [N] da ordem priorizada (ferramentas + conteúdo + labs)
- [ ] 03-02: Repetir para cada módulo restante

### Fase 4: Navegação e Organização
**Goal**: A trilha tem navegação intuitiva e glossário atualizado
**Depends on**: Fase 3
**Requirements**: NAVE-01, NAVE-02, NAVE-03
**Success Criteria** (o que deve ser VERDADE):
  1. Decisão executada sobre ROADMAP.md: atualizado para refletir 12 módulos OU removido (já que README.md cumpre o papel)
  2. GLOSSARIO.md contém todos os termos novos das ferramentas modernizadas
  3. README.md principal tem navegação avançada (busca, filtros, navegação entre módulos)
**Plans**: TBD

Plans:
- [ ] 04-01: Decidir e executar ação sobre ROADMAP.md
- [ ] 04-02: Atualizar GLOSSARIO.md com termos novos
- [ ] 04-03: Adicionar navegação avançada no README.md

## Progresso

**Ordem de Execução:**
As fases são executadas em ordem numérica: 1 → 2 → 3 → 4

| Fase | Plans Completos | Status | Concluída |
|------|-----------------|--------|-----------|
| 1. Auditoria Completa | 0/3 | Não iniciada | - |
| 2. Pesquisa e Referências | 0/2 | Não iniciada | - |
| 3. Modernização + Conteúdo Prático | 0/2 | Não iniciada | - |
| 4. Navegação e Organização | 0/3 | Não iniciada | - |
