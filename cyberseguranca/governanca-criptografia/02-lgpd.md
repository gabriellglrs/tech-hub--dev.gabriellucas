# 🇧🇷 LGPD — Lei Geral de Proteção de Dados (13.709/2018)

> Proteger dados pessoais e evitar multas da ANPD.

---

## 🚀 Passo a Passo para adequação

### Passo 1: Mapear dados (ROPA)
- Inventariar: que dados coleta? Ex: nome, CPF, email, IP
- Base legal: consentimento, legítimo interesse, execução de contrato?
- Ferramenta: planilha ou **OneTrust, DataGrail**

### Passo 2: Nomear DPO (Encarregado)
```bash
# Publicar na política de privacidade:
# DPO: dpo@empresa.com.br
```

### Passo 3: Direitos do titular
Garantir processo para:
- [ ] Confirmação e acesso
- [ ] Correção, anonimização, eliminação
- [ ] Portabilidade, revogação de consentimento

### Passo 4: Segurança e incidentes
- Criptografar dados sensíveis (ver `04-criptografia.md`)
- Se vazamento → comunicar ANPD e titulares em até 3 dias úteis
- Fazer DPIA (Relatório de Impacto) para atividades de alto risco

### Passo 5: Contratos
- Revisar contratos com operadores (fornecedores)
- Cláusulas de proteção de dados

---

## Checklist rápido

| Item | Status |
|:---|:---|
| ROPA completo | ☐ |
| DPO nomeado | ☐ |
| Política de privacidade atualizada | ☐ |
| Canal de direitos do titular | ☐ |
| Plano de resposta a incidentes | ☐ |

## Sanções ANPD

- Advertência → multa de até 2% do faturamento (limite R$ 50M por infração)
