# Governança, Risco e Compliance (GRC)

> Gerir segurança como negócio: políticas, riscos, auditorias e conformidade.

---

## O que é GRC?

**Governança** é como a empresa gerencia segurança. **Risco** é avaliar o que pode dar errado. **Compliance** é seguir leis e normas.

```
Inventário (o que temos?)
        ↓
Classificação (o que é crítico?)
        ↓
Auditoria (o que está errado?)
        ↓
Controles (como corrigir?)
        ↓
Monitoramento (está funcionando?)
```

### Frameworks principais

| Framework | O que é |
|:---|:---|
| **NIST CSF 2.0** | Framework dos EUA — Identify, Protect, Detect, Respond, Recover, Govern |
| **ISO 27001** | Padrão internacional de SGSI (norma certificável) |
| **CIS Controls** | 18 controles prioritários de segurança |
| **LGPD** | Lei brasileira de proteção de dados (13.709/2018) |

### Tipos de controle

| Tipo | Exemplo |
|:---|:---|
| **Preventivo** | Firewall bloqueia acesso não autorizado |
| **Detectivo** | IDS detecta tráfego suspeito |
| **Corretivo** | Backup restaura dados após incidente |

---

## Tool Card: OpenSCAP

**O que é:** Ferramenta de auditoria de compliance que verifica se o sistema atende a benchmarks de segurança (CIS, DISA STIG, PCI-DSS) usando perfis XCCDF.

### 🎯 Quando usar o OpenSCAP
- Precisa verificar se o servidor atende a um benchmark específico (CIS, PCI-DSS, DISA STIG)
- Vai fazer uma auditoria de compliance para certificação (ISO 27001, SOC 2)
- Precisa de evidência documentada de conformidade para auditoria externa
- quer automatizar a verificação de hardening em múltiplos servidores

### 🛠️ Como o OpenSCAP te ajuda
- Compara automaticamente a configuração do sistema contra centenas de controles de segurança
- Gera relatórios HTML e XML fáceis de interpretar — cada controle é classificado como pass/fail
- Fornece instruções de remediação para cada controle que falhou
- Permite reutilizar o mesmo scan para acompanhar evolução ao longo do tempo

### ➡️ Depois de usar o OpenSCAP — Próximos passos
1. Abra o relatório HTML e filtre apenas os controles com status `fail`
2. Priorize as correções pelo risco — controles com impacto alto primeiro
3. Aplique as correções sugeridas e re-rodar o scan para validar
4. Documente o antes/depois para evidência de compliance

### Instalação

```bash
# Instalar scanner e guias de segurança
sudo apt install -y openscap-scanner scap-security-guide

# Verificar se o pacote foi instalado
dpkg -l | grep openscap
# openscap-scanner    1.4.3-1    amd64    SCAP scanner
# scap-security-guide 0.1.70-1   all      Security guides for SCAP
```

### Listar perfis disponíveis

```bash
# Listar todos os perfis de segurança disponíveis no Kali
oscap info /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml
```

**Output esperado (trecho):**

```
Document type: Source Data Stream
Imported: 2025-12-05T12:21:18

Available profiles:
Title: CIS Debian Linux 13 Benchmark
Id: xccdf_org.ssgproject.content_profile_cis

Title: Standard System Security Profile for Debian
Id: xccdf_org.ssgproject.content_profile_standard

Title: PCI-DSS v4.0 Baseline for Debian
Id: xccdf_org.ssgproject.content_profile_pci-dss
```

**O que procurar:** Procure o perfil `cis` (CIS Benchmark) ou `standard` para hardening básico. O perfil CIS é o mais completo para servidores.

### Executar scan de compliance

```bash
# Rodar scan CIS e gerar relatório XML + HTML
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis \
  --fetch-remote-resources \
  --results /tmp/scap-results.xml \
  --report /tmp/scap-report.html \
  /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml
```

**Flags explicadas:**

| Flag | O que faz |
|:---|:---|
| `--profile xccdf_org.ssgproject.content_profile_cis` | Seleciona o perfil CIS Benchmark |
| `--fetch-remote-resources` | Baixa recursos remotos necessários para o scan |
| --results /tmp/scap-results.xml` | Salva resultados em XML (máquina) |
| `--report /tmp/scap-report.html` | Gera relatório HTML legível (humano) |

**Output esperado (trecho):**

```
Title   Ensure AIDE is installed
Rule    xccdf_org.ssgproject.content_rule_aide_package_installed
Ident   CCE-...
Result  fail

Title   Ensure no nis/ypserv services are enabled
Rule    xccdf_org.ssgproject.content_rule_nis_not_installed
Ident   CCE-...
Result  pass

Title   Ensure mounting of cramfs filesystems is disabled
Rule    xccdf_org.ssgproject.content_rule_disable_cramfs
Ident   CCE-...
Result  pass
```

**O que procurar:**
- `pass` = controle atendido
- `fail` = controle NÃO atendido (precisa de correção)
- `notchecked` = verificação automática não disponível
- Abra o HTML para ver detalhes completos com remediação

---

## Tool Card: Lynis

**O que é:** Ferramenta de auditoria de hardening para sistemas Unix/Linux. Analisa configurações e sugere melhorias de segurança.

### 🎯 Quando usar o Lynis
- Precisa medir o nível de hardening do sistema com uma pontuação objetiva (0-100)
- Vai fazer um assessment rápido antes de colocar um servidor em produção
- Precisa de uma lista prática de melhorias de segurança para aplicar
- quer comparar a postura de segurança antes e depois de um projeto de hardening

### 🛠️ Como o Lynis te ajuda
- Roda em minutos e retorna um Hardening Index que resume a postura do sistema
- Identifica automaticamente configurações inseguras, permissões incorretas e serviços desnecessários
- Cada sugestão vem com o código do controle (ex: AUTH-9282) para consulta na documentação
- Não altera nada no sistema — é somente leitura, seguro para rodar em produção

### ➡️ Depois de usar o Lynis — Próximos passos
1. Anote o Hardening Index atual e liste todas as Suggestions e Warnings
2. Aplique as correções de maior impacto (comece pelos Warnings)
3. Re-rodar o Lynis e compare o novo score com o anterior
4. Repita o ciclo até atingir o score desejado (80+ é uma boa meta)

### Instalação

```bash
sudo apt install -y lynis

# Verificar versão
lynis --version
# lynis 3.0.9
```

### Executar auditoria completa

```bash
# Rodar auditoria completa no sistema
sudo lynis audit system
```

**Output esperado (trecho):**

```
[+] Boot and services
[+] Kernel
[+] Memory and Processes
[+] Users, Groups and Authentication
[+] Shells
[+] File systems
[+] Storage
[+] NFS
[+] Software: name services
[+] Networking
[+] Firewalls
[+] SSH Support
[+] SSH Server Test
[+] ALSA
[+] PHP
[+] Python
[+] MySQL
[+] Oracle
[+] PostgreSQL
[+] SSH
[+] Networking

Hardening index : 67 [#############       ]

Suggestions (3):
* Check cron permissions [KRNL-1220]
* Configure minimum password length in /etc/login.defs [AUTH-9282]
* Set maxlogins to limit number of simultaneous logins [AUTH-9328]
```

**O que procurar:**
- **Hardening index** = pontuação de 0-100 (quanto maior, melhor)
- **Suggestions** = melhorias sugeridas (ações para tomar)
- **Warnings** = problemas graves que precisam de correção imediata
- Compare scores antes/depois de aplicar hardening

### Gerar relatório em XML

```bash
# Gerar relatório em XML para análise automatizada
sudo lynis audit system --report-file /tmp/lynis-report.dat
```

---

## Exercício 1: Auditoria CIS com OpenSCAP

**Objetivo:** Rodar um scan CIS Benchmark completo e interpretar resultados.

### Passo a passo

```bash
# 1. Instalar ferramentas
sudo apt install -y openscap-scanner scap-security-guide

# 2. Listar perfis disponíveis
oscap info /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml

# 3. Rodar scan CIS
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis \
  --fetch-remote-resources \
  --results /tmp/cis-results.xml \
  --report /tmp/cis-report.html \
  /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml

# 4. Abrir relatório HTML
# No Kali com desktop:
xdg-open /tmp/cis-report.html
# No terminal (resumo):
grep -E "result (pass|fail)" /tmp/cis-results.xml | wc -l

# 5. Contar pass/fail
grep -c "<result>pass</result>" /tmp/cis-results.xml
grep -c "<result>fail</result>" /tmp/cis-results.xml

# 6. Listar controles que falharam
grep -B5 "<result>fail</result>" /tmp/cis-results.xml | grep "<title>"
```

### Interpretação do relatório

Após rodar o scan, você verá algo assim:

| Resultado | Quantidade | Ação |
|:---|:---|:---|
| `pass` | ~60% | Controles atendidos — manter |
| `fail` | ~30% | Controles não atendidos — corrigir |
| `notchecked` | ~10% | Não verificáveis — verificar manualmente |

**Exemplo de controle que falhou:**

```
Title   Ensure password hashing algorithm is SHA-512
Result  fail
Fix:    authselect select sssd with-faillock --force
```

**Como corrigir:**
```bash
# Aplicar correção sugerida
sudo authselect select sssd with-faillock --force

# Re-rodar scan para verificar
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis \
  --fetch-remote-resources \
  --results /tmp/cis-results-v2.xml \
  --report /tmp/cis-report-v2.html \
  /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml
```

---

## Exercício 2: Hardening com Lynis

**Objetivo:** Melhorar o score de hardening do sistema de 67 para 80+.

### Passo a passo

```bash
# 1. Rodar auditoria inicial e salvar score
sudo lynis audit system 2>&1 | tee /tmp/lynis-v1.txt
# Anote o Hardening index (ex: 67)

# 2. Listar suggestions e warnings
sudo lynis audit system | grep -E "suggestion|warning" | head -20

# 3. Aplicar correções (exemplos):
# Corrigir permissões de cron:
sudo chmod 600 /etc/crontab

# Limitar logins simultâneos:
echo "* hard maxlogins 10" | sudo tee -a /etc/security/limits.conf

# Configurar senha mínima de 12 caracteres:
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/' /etc/login.defs
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 90/' /etc/login.defs

# Habilitar audit logging:
sudo systemctl enable auditd
sudo systemctl start auditd

# 4. Re-rodar auditoria e comparar scores
sudo lynis audit system 2>&1 | tee /tmp/lynis-v2.txt

# 5. Extrair scores para comparação
grep "Hardening index" /tmp/lynis-v1.txt
grep "Hardening index" /tmp/lynis-v2.txt
```

### Resultado esperado

| Versão | Hardening Index | Suggestions |
|:---|:---|:---|
| v1 (antes) | 67 | 15 |
| v2 (depois) | 78+ | 8 |

**O que procurar:** Aumento de 10+ pontos indica que as correções foram efetivas. Redução de suggestions confirma que os problemas foram resolvidos.

---

## Exercício 3: Risk Assessment (ALE)

**Objetivo:** Calcular Annual Loss Expectancy (ALE) para 10 cenários de risco e criar um risk register.

### Fórmula

```
ALE = SLE × ARO

SLE (Single Loss Expectatory) = custo de uma única ocorrência
ARO (Annualized Rate of Occurrence) = quantas vezes por ano acontece
ALE (Annual Loss Expectancy) = perda anual esperada
```

### Risk Register (tabela em Markdown)

Crie um arquivo `risk-register.md` com esta estrutura:

```markdown
# Risk Register — Empresa Fictícia

| # | Cenário | Ativo | Ameaça | SLE (R$) | ARO | ALE (R$) | Prioridade |
|---|---------|-------|--------|----------|-----|----------|------------|
| 1 | Ransomware em servidor de dados | Servidor principal | Malware | 500.000 | 0,2 | 100.000 | Crítica |
| 2 | Vazamento de dados de clientes | Banco de dados | Acesso não autorizado | 1.000.000 | 0,1 | 100.000 | Crítica |
| 3 | Phishing contra funcionários | E-mails corporativos | Engenharia social | 50.000 | 2,0 | 100.000 | Alta |
| 4 | Falha em servidor web | Site da empresa | DDoS | 20.000 | 3,0 | 60.000 | Alta |
| 5 | Perda de laptop com dados | Notebooks | Furto | 30.000 | 1,0 | 30.000 | Média |
| 6 | Falha de backup | Sistema de backup | Falha técnica | 200.000 | 0,1 | 20.000 | Média |
| 7 | Ataque DDoS | Firewall | Volume de tráfego | 15.000 | 4,0 | 60.000 | Alta |
| 8 | Insider threat | Dados internos | Colaborador mal-intencionado | 150.000 | 0,05 | 7.500 | Baixa |
| 9 | Falha elétrica | Data center | Falha de energia | 80.000 | 0,5 | 40.000 | Média |
| 10 | Vulnerabilidade em software | Aplicações web | CVE não corrigido | 100.000 | 0,3 | 30.000 | Média |
```

### Classificação de prioridade

| ALE | Prioridade | Ação |
|:---|:---|:---|
| > R$ 80.000 | **Crítica** | Mitigar imediatamente |
| R$ 40.000 - R$ 80.000 | **Alta** | Mitigar em 30 dias |
| R$ 15.000 - R$ 40.000 | **Média** | Mitigar em 90 dias |
| < R$ 15.000 | **Baixa** | Aceitar ou transferir (seguro) |

### Tratamento de risco

| Estratégia | Quando usar | Exemplo |
|:---|:---|:---|
| **Mitigar** | Risco alto, controle viável | Implementar MFA, backup offsite |
| **Transferir** | Risco alto, controle caro | Comprar seguro cibernético |
| **Aceitar** | Risco baixo, custo > benefício | Monitorar sem ação |
| **Evitar** | Risco inaceitável | Não coletar dados sensíveis |

---

## Exercício 4: Policy Document Review

**Objetivo:** Criar uma Information Security Policy (ISP) mapeada para NIST CSF 2.0.

### Modelo de ISP em Markdown

Crie um arquivo `politica-seguranca.md`:

```markdown
# Política de Segurança da Informação

## 1. Escopo
Esta política se aplica a todos os funcionários, contratados e sistemas
de informação da empresa.

## 2. Classificação de Dados

| Nível | Descrição | Exemplo | Requisito |
|-------|-----------|---------|-----------|
| Público | Dados públicos | Site institucional | Nenhum |
| Interno | Uso interno | Organograma | Login |
| Confidencial | Dados sensíveis | CPF, salário | Criptografia + MFA |
| Secreto | Dados críticos | Chaves de API | Criptografia + MFA + Auditoria |

## 3. Controles por NIST CSF 2.0

### Govern (GV)
- [ ] GV.OC-01: Papéis e responsabilidades documentados
- [ ] GV.RM-01: Processo de gestão de riscos definido

### Identify (ID)
- [ ] ID.AM-01: Inventário de ativos mantido
- [ ] ID.AM-05: Recursos priorizados baseado em risco

### Protect (PR)
- [ ] PR.AA-01: Controle de acesso identidade gerenciado
- [ ] PR.DS-01: Dados em repouso criptografados
- [ ] PR.DS-02: Dados em trânsito criptografados
- [ ] PR.PS-01: Configurações de software gerenciadas

### Detect (DE)
- [ ] DE.CM-01: Redes monitoradas
- [ ] DE.AE-02: Atividades anômalas analisadas

### Respond (RS)
- [ ] RS.MA-01: Incidentes respondidos conforme plano
- [ ] RS.CO-02: Partes interessadas notificadas

### Recover (RC)
- [ ] RC.RP-01: Planos de recuperação executados
- [ ] RC.CO-03: Lições aprendidas documentadas

## 4. Senhas
- Mínimo 12 caracteres
- MFA obrigatório para sistemas críticos
- Senhas a cada 90 dias

## 5. Criptografia
- Dados em repouso: AES-256
- Dados em trânsito: TLS 1.2+
- Senhas: Argon2 ou bcrypt

## 6. Incidentes
- Notificar DPO em até 24h
- Comunicar ANPD em até 72h (se dados pessoais)
- Documentar lições aprendidas

## 7. Revisão
- Anual ou após incidente significativo
```

### Gap Analysis contra ISO 27001

| Controle ISO 27001 | Status | Ação Necessária |
|:---|:---|:---|
| A.5.1 Políticas de segurança | Atendido | Documentar política formal |
| A.8.1 Controles de ativos | Parcial | Criar inventário de ativos |
| A.8.2 Segurança de classify | Não atendido | Implementar classificação |
| A.8.3 Restrição de acesso | Não atendido | Implementar RBAC |
| A.8.24 Uso de criptografia | Parcial | Definir padrão criptográfico |

---

## Exercício 5: Compliance Scanning Pipeline

**Objetivo:** Criar script bash que roda Lynis + OpenSCAP e gera relatório consolidado.

### Script: `compliance-scan.sh`

```bash
#!/bin/bash
# compliance-scan.sh — Scanner de compliance automatizado
# Uso: sudo bash compliance-scan.sh

REPORT_DIR="/tmp/compliance-reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_FILE="${REPORT_DIR}/relatorio-${TIMESTAMP}.md"

mkdir -p "$REPORT_DIR"

echo "# Relatório de Compliance" > "$REPORT_FILE"
echo "Data: $(date)" >> "$REPORT_FILE"
echo "Hostname: $(hostname)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. Lynis Audit
echo "## Lynis Audit" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
sudo lynis audit system --quiet --report-file "${REPORT_DIR}/lynis-${TIMESTAMP}.dat" > /dev/null 2>&1

if [ -f "${REPORT_DIR}/lynis-${TIMESTAMP}.dat" ]; then
    SCORE=$(grep "hardening_index" "${REPORT_DIR}/lynis-${TIMESTAMP}.dat" | cut -d= -f2)
    echo "Hardening Index: ${SCORE}/100" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "### Sugestões" >> "$REPORT_FILE"
    grep "suggestion\[" "${REPORT_DIR}/lynis-${TIMESTAMP}.dat" | head -10 >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"

# 2. OpenSCAP Audit
echo "## OpenSCAP CIS Audit" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_standard \
    --fetch-remote-resources \
    --results "${REPORT_DIR}/scap-${TIMESTAMP}.xml" \
    --report "${REPORT_DIR}/scap-${TIMESTAMP}.html" \
    /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml > /dev/null 2>&1

if [ -f "${REPORT_DIR}/scap-${TIMESTAMP}.xml" ]; then
    PASS=$(grep -c "<result>pass</result>" "${REPORT_DIR}/scap-${TIMESTAMP}.xml")
    FAIL=$(grep -c "<result>fail</result>" "${REPORT_DIR}/scap-${TIMESTAMP}.xml")
    TOTAL=$((PASS + FAIL))
    echo "Controles pass: ${PASS}/${TOTAL}" >> "$REPORT_FILE"
    echo "Controles fail: ${FAIL}/${TOTAL}" >> "$REPORT_FILE"
    echo "Taxa de conformidade: $(( (PASS * 100) / TOTAL ))%" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "### Controles com falha" >> "$REPORT_FILE"
    grep -B3 "<result>fail</result>" "${REPORT_DIR}/scap-${TIMESTAMP}.xml" | grep "<title>" | head -10 >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "Relatórios completos:" >> "$REPORT_FILE"
echo "- Lynis: ${REPORT_DIR}/lynis-${TIMESTAMP}.dat" >> "$REPORT_FILE"
echo "- OpenSCAP: ${REPORT_DIR}/scap-${TIMESTAMP}.html" >> "$REPORT_FILE"

echo "Relatório gerado em: ${REPORT_FILE}"
```

### Uso

```bash
# Tornar executável e rodar
chmod +x compliance-scan.sh
sudo bash compliance-scan.sh

# Output esperado:
# Relatório gerado em: /tmp/compliance-reports/relatorio-20260910_143022.md
```

### Verificar resultados

```bash
# Ler relatório consolidado
cat /tmp/compliance-reports/relatorio-*.md

# Abrir relatório HTML do OpenSCAP
xdg-open /tmp/compliance-reports/scap-*.html
```

---

## Resumo

| Exercício | Ferramenta | Habilidade |
|:---|:---|:---|
| 1. Auditoria CIS | OpenSCAP | Verificar compliance contra benchmark |
| 2. Hardening Lynis | Lynis | Melhorar score de segurança do sistema |
| 3. Risk Assessment | Planilha/Markdown | Calcular ALE e priorizar riscos |
| 4. Policy Review | Documento | Criar ISP mapeada para NIST CSF 2.0 |
| 5. Compliance Pipeline | Bash | Automatizar auditoria de compliance |

---

## Labs Práticos

👉 **[Acessar LABS.md](LABS.md)** — 14 labs organizados por plataforma

---

## Referências

- [NIST CSF 2.0](https://www.nist.gov/cyberframework)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
- [OpenSCAP Documentation](https://www.open-scap.org/)
- [Lynis Documentation](https://cisofy.com/documentation/lynis/)
- [ISO 27001](https://www.iso.org/iso-27001-information-security.html)
- [LGPD - Lei 13.709/2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)
