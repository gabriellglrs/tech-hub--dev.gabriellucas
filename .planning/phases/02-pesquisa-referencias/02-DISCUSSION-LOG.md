# Phase 2: Pesquisa e Referências - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-09-10
**Phase:** 02-pesquisa-referencias
**Areas discussed:** Plataformas e validação de labs, Certificações e priorização, Labs existentes vs novos, Formato do output

---

## Plataformas e validação de labs

| Option | Description | Selected |
|--------|-------------|----------|
| Todas as 5 | TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF — cobertura máxima | ✓ |
| Apenas THM + PortSwigger | Foco em iniciantes e web security | |
| Selecionar por módulo | Definir por módulo qual plataforma é mais adequada | |

**User's choice:** Todas as 5 plataformas
**Notes:** Cobertura máxima é importante para dar opções ao aprendiz

| Option | Description | Selected |
|--------|-------------|----------|
| Validar existência | Verificar se cada sala/exercício ainda existe e está acessível gratuitamente | ✓ |
| Apenas listar sem validar | Confiar nas URLs atuais e apenas listar — validação fica para quem for usar | |

**User's choice:** Validar existência
**Notes:** Validação é crítica — links quebrados frustram o aprendiz

---

## Certificações e priorização

| Option | Description | Selected |
|--------|-------------|----------|
| OSCP > Security+ > CEH | OSCP é a mais requisitada pelo mercado; Security+ é entrada; CEH é opcional | ✓ |
| Todas igualmente | Três equally weighted — comparação completa | |
| Apenas OSCP | Focar apenas em OSCP — é a mais prática e alinhada com o conteúdo | |

**User's choice:** OSCP > Security+ > CEH
**Notes:** OSCP é a certificação mais requisitada para pentesters

| Option | Description | Selected |
|--------|-------------|----------|
| Mapeamento módulo × tópicos | Para cada módulo, verificar se os tópicos estão presentes nos exames — listando ausentes | ✓ |
| Comparação de ordem apenas | Apenas comparar ordem geral dos módulos com as trilhas das certificações | |

**User's choice:** Mapeamento módulo × tópicos
**Notes:** Comparação detalhada identifica gaps específicos

---

## Labs existentes vs novos

| Option | Description | Selected |
|--------|-------------|----------|
| Validar existentes + buscar novos onde faltar | Verificar se os labs atuais ainda funcionam e são gratuitos; buscar novos apenas onde faltar | ✓ |
| Apenas buscar novos | Ignorar LABS.md atual e buscar apenas novos labs para cada módulo | |
| Não validar existentes | Manter LABS.md como está — a validação fica para a Fase 3 | |

**User's choice:** Validar existentes + buscar novos onde faltar
**Notes:** Equilíbrio entre manter o que funciona e complementar o que falta

| Option | Description | Selected |
|--------|-------------|----------|
| Marcar + sugerir alternativa | Marcar como indisponível e sugerir alternativa equivalente | ✓ |
| Apenas marcar indisponível | Marcar como indisponível — alternativa fica para Fase 3 | |

**User's choice:** Marcar + sugerir alternativa
**Notes:** Alternativa equivalente mantém a experiência de aprendizado

---

## Formato do output

| Option | Description | Selected |
|--------|-------------|----------|
| Relatório por módulo + consolidado | UMD por módulo: labs candidatos + tópicos ausentes + status de validação. Relatório consolidado no final. | ✓ |
| Tabela consolidada única | Tabela única com todos os módulos e colunas de labs + certificações | |
| Listas simples por módulo | Apenas listas simples por módulo — sem formatação especial | |

**User's choice:** Relatório por módulo + consolidado
**Notes:** UMD permite navegação fácil; consolidado dá visão geral

---

## the agent's Discretion

- Profundidade da pesquisa por plataforma — agente decide com base na relevância para cada módulo
- Como categorizar tópicos ausentes (crítico vs importante vs opcional) — segue a escala de prioridade das certificações
- Número mínimo de labs por módulo — agente define baseado na complexidade do módulo

## Deferred Ideas

None — discussion stayed within phase scope
