# 📋 Governança, Risco e Compliance (GRC), LGPD e ISO 27001

> Gerir segurança como negócio: políticas, riscos, auditorias, proteção de dados e normas certificáveis.

---

## 🛠️ Instalação

```bash
# Lynis (auditoria)
sudo apt install -y lynis

# OpenSCAP
sudo apt install -y libopenscap8 ssg-debian
```

---

## 1. GRC — Governança, Risco e Compliance

### Passo a Passo

#### 1.1 Governança
- Criar Política de Segurança da Informação (PSI)
- Definir papéis: CISO, DPO, Comitê de Segurança
- Frameworks: **NIST CSF** (Identify, Protect, Detect, Respond, Recover) e **COBIT**

#### 1.2 Gestão de Riscos (ISO 27005 / NIST RMF)
```bash
# Matriz simples: Risco = Probabilidade x Impacto
# Exemplo: Ransomware em servidor desatualizado
# Prob: Alta (4) x Impacto: Crítico (5) = 20 → Tratar imediatamente

# Registrar em planilha/GRC tool (Eramba, SimpleRisk)
```

Passos:
1. Inventariar ativos (servidores, dados, pessoas)
2. Mapear ameaças e vulnerabilidades
3. Calcular risco inerente e residual
4. Definir tratamento: Mitigar, Transferir, Aceitar, Evitar

#### 1.3 Compliance — Mapear controles
- Listar leis/normas aplicáveis: LGPD, ISO 27001, PCI-DSS, SOC 2
- Fazer gap analysis: o que já atende vs o que falta
- Auditoria interna anual

#### Ferramentas GRC
| Ferramenta | Uso |
|:---|:---|
| **Eramba** | GRC open-source completo |
| **SimpleRisk** | Gestão de riscos simples |
| **NIST CSF** | Framework de governança |

#### Entregáveis típicos
- PSI + Políticas de acesso, backup, incidentes
- Matriz de riscos + Plano de tratamento
- Relatório de gap analysis

---

## 2. LGPD — Lei Geral de Proteção de Dados (13.709/2018)

> Proteger dados pessoais e evitar multas da ANPD.

### Passo a Passo para Adequação

#### 2.1 Mapear dados (ROPA)
- Inventariar: que dados coleta? Ex: nome, CPF, email, IP
- Base legal: consentimento, legítimo interesse, execução de contrato?
- Ferramenta: planilha ou **OneTrust, DataGrail**

#### 2.2 Nomear DPO (Encarregado)
```bash
# Publicar na política de privacidade:
# DPO: dpo@empresa.com.br
```

#### 2.3 Direitos do titular
Garantir processo para:
- [ ] Confirmação e acesso
- [ ] Correção, anonimização, eliminação
- [ ] Portabilidade, revogação de consentimento

#### 2.4 Segurança e incidentes
- Criptografar dados sensíveis
- Se vazamento → comunicar ANPD e titulares em até 3 dias úteis
- Fazer DPIA (Relatório de Impacto) para atividades de alto risco

#### 2.5 Contratos
- Revisar contratos com operadores (fornecedores)
- Cláusulas de proteção de dados

### Checklist LGPD

| Item | Status |
|:---|:---|
| ROPA completo | ☐ |
| DPO nomeado | ☐ |
| Política de privacidade atualizada | ☐ |
| Canal de direitos do titular | ☐ |
| Plano de resposta a incidentes | ☐ |

### Sanções ANPD
- Advertência → multa de até 2% do faturamento (limite R$ 50M por infração)

---

## 3. ISO 27001:2022

> Sistema de Gestão de Segurança da Informação (SGSI). Norma certificável.

### Passo a Passo para Implementar

#### 3.1 Contexto e Escopo
- Definir escopo: "Toda a empresa" ou "Só o data center"
- Partes interessadas: clientes, regulador, diretoria

#### 3.2 Avaliação de riscos (cláusula 6)
- Matriz de riscos (ver seção 1.2)
- Declaração de Aplicabilidade (SoA): quais dos 93 controles do Anexo A aplicam?

#### 3.3 Controles do Anexo A (93 controles, 4 temas)
| Tema | Exemplos |
|:---|:---|
| **Organizacional (37)** | PSI, papéis, inventário, gestão de fornecedores |
| **Pessoas (8)** | Treinamento, NDA, processo disciplinar |
| **Físico (14)** | Controle de acesso, câmeras, descarte |
| **Tecnológico (34)** | Controle de acesso lógico, criptografia, backup, logs, WAF |

#### 3.4 Tratamento e monitoramento
- Implementar controles, medir KPIs (ex: % de patches em dia)
- Auditoria interna + análise crítica da direção

#### 3.5 Certificação
- Escolher organismo certificador (ex: Bureau Veritas)
- Auditoria de certificação em 2 estágios

#### Ferramentas ISO 27001
- **Eramba** → mapeia controles ISO 27001
- **Vanta / Drata** → automação de compliance

#### Dica
Comece pelo Anexo A.17 (Continuidade) e A.8 (Tecnológico) → são os que mais caem em auditoria.

---

## Resumo Geral

| Área | Foco | Entregável Principal |
|:---|:---|:---|
| **GRC** | Governança e riscos | Matriz de riscos + PSI |
| **LGPD** | Dados pessoais | ROPA + DPIA |
| **ISO 27001** | SGSI certificável | SoA + 93 controles |

---

## 🧪 Labs Práticos

### Exercícios de Auditoria
```bash
# Auditoria com Lynis
sudo lynis audit system

# Verificar compliance com OpenSCAP
sudo oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard \
  --results results.xml /usr/share/xml/scap/ssg/content/ssg-debian-ds.xml

# Gerar relatório HTML
sudo oscap xccdf generate report results.xml > relatorio.html
```

### Exercícios de Compliance (Práticos)
1. **Gap Analysis LGPD:**
   - Crie um ROPA para uma empresa fictícia (10+ processamento de dados)
   - Identifique bases legais para cada tipo de dado
   - Documente gap analysis: o que falta para adequação total

2. **Implementação ISO 27001:**
   - Elabore uma Política de Segurança da Informação (PSI)
   - Monte a Declaração de Aplicabilidade (SoA) com 10 controles do Anexo A
   - Crie matriz de riscos para 5 cenários (ex: ransomware, vazamento de dados, phishing)

3. **Auditoria com Lynis:**
   - Execute `lynis audit system` em um servidor Linux
   - Identifique 3 findings de alto risco
   - Proponha remediação para cada um

4. **Relatório GRC:**
   - Simule uma empresa de e-commerce
   - Crie: PSI, Matriz de Riscos, ROPA, Plano de Incidentes
   - Apresente como entregável para a diretoria

### Recursos
- **[TryHackMe: GRC Fundamentals](https://tryhackme.com/room/grcfundamentals)** — Conceitos de governança
- **[ISO 27001 Toolkit](https://www.isms.online/iso-27001/)** — Templates e checklists
- **[LGPD Guide](https://www.gov.br/anpd/)** — Portal oficial da ANPD

> **Dica:** Comece sempre pelo ativo crítico (dados sensíveis) e use a matriz de riscos para priorizar investimentos em segurança.
