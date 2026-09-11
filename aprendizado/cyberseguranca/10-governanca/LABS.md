# Labs de Governança e Criptografia

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Linux básico | ⭐⭐ | Terminal e comandos |
| Conceitos de segurança | ⭐⭐⭐ | Fundamentos do módulo 10 |
| Permissões root | ⭐⭐ | Para OpenSCAP e Lynis |

---

## Labs por Plataforma

### TryHackMe (4 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Compliance & GDPR | LGPD, GDPR, compliance basics | ⭐⭐ | https://tryhackme.com/room/complianceandgdpr |
| 2 | OpenSSL | Criptografia, TLS, certificados | ⭐⭐ | https://tryhackme.com/room/openssl |
| 3 | Hashing Fun | Hashes, SHA-256, password cracking | ⭐⭐ | https://tryhackme.com/room/hashingfun |
| 4 | Cryptography | Criptografia simétrica, assimétrica, TLS | ⭐⭐⭐ | https://tryhackme.com/room/cryptography |

> **Nota:** URLs podem mudar — verifique no site da plataforma se o link não funcionar.

### OverTheWire — Krypton (2 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 5 | Krypton Level 0 | Frequência analysis, substitution cipher | ⭐ | ssh://krypton.labs.overthewire.org:2221 |
| 6 | Krypton Level 1 | XOR cipher | ⭐⭐ | ssh://krypton.labs.overthewire.org:2221 |
| 7 | Krypton Level 2 | Repeating-key XOR | ⭐⭐ | ssh://krypton.labs.overthewire.org:2221 |
| 8 | Krypton Level 3 | Vigenère cipher | ⭐⭐⭐ | ssh://krypton.labs.overthewire.org:2221 |

**Como acessar Krypton:**
```bash
# Conectar ao servidor (senha: KRYPTON0 para nível 0)
ssh krypton0@krypton.labs.overthewire.org -p 2221

# Nível inicial
krypton0@bandit:~$ ls
# readme

krypton0@bandit:~$ cat readme
# ONEqeduXY7r123... (hash para quebrar)
```

> **Nota:** Krypton usa SSH — não precisa de navegador. As senhas são KryptonN (N = nível).

### PicoCTF (2 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 9 | Cryptography (40+ challenges) | XOR, RSA, AES, hash | ⭐-⭐⭐⭐ | https://play.picoctf.org/practice |
| 10 | Crypto Challenges (basics) | Caesar, substitution, base encoding | ⭐ | https://play.picoctf.org/practice |

> **Nota:** PicoCTF pode redirecionar — acesse https://play.picoctf.org/ e navegue até Crypto.

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 11 | GRC Challenges | Compliance, hardening | ⭐⭐⭐ | https://app.hackthebox.com |

> **Nota:** HackTheBox tem labs limitados de GRC — a maioria é sobre pentesting. Para GRC, use TryHackMe e OverTheWire como primários.

---

## Exercícios Locais (4 exercícios)

Estes exercícios são feitos no seu próprio Kali — sem necessidade de plataforma externa.

| # | Exercício | Habilidade | Tempo | Pré-requisitos |
|---|-----------|------------|-------|----------------|
| 12 | Auditoria CIS com OpenSCAP | Compliance scanning | 30 min | openscap-scanner, scap-security-guide |
| 13 | Hardening com Lynis | Score de segurança | 30 min | lynis |
| 14 | Risk Assessment (ALE) | Cálculo de risco | 45 min | Nenhum |
| 15 | Compliance Pipeline | Automação bash | 40 min | openscap, lynis |

### Exercício 12: Auditoria CIS com OpenSCAP

```bash
# Instalar
sudo apt install -y openscap-scanner scap-security-guide

# Rodar scan CIS
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis \
  --fetch-remote-resources \
  --results /tmp/cis-results.xml \
  --report /tmp/cis-report.html \
  /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml

# Verificar resultados
grep -c "<result>pass</result>" /tmp/cis-results.xml
grep -c "<result>fail</result>" /tmp/cis-results.xml
```

### Exercício 13: Hardening com Lynis

```bash
# Instalar
sudo apt install -y lynis

# Rodar auditoria e anotar score
sudo lynis audit system | grep "Hardening index"

# Aplicar correções sugeridas, depois re-rodar
sudo lynis audit system | grep "Hardening index"
# Meta: score ≥ 80
```

### Exercício 14: Risk Assessment (ALE)

```bash
# Criar risk register em Markdown
cat > risk-register.md << 'EOF'
# Risk Register

| # | Cenário | SLE (R$) | ARO | ALE (R$) | Prioridade |
|---|---------|----------|-----|----------|------------|
| 1 | Ransomware | 500.000 | 0,2 | 100.000 | Crítica |
| 2 | Vazamento dados | 1.000.000 | 0,1 | 100.000 | Crítica |
| 3 | Phishing | 50.000 | 2,0 | 100.000 | Alta |
EOF

# ALE = SLE × ARO
echo "ALE do ransomware: 500000 * 0,2 = 100000"
```

### Exercício 15: Compliance Pipeline

```bash
# Criar script de compliance automatizado
cat > compliance-scan.sh << 'SCRIPT'
#!/bin/bash
REPORT_DIR="/tmp/compliance-reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$REPORT_DIR"

echo "# Relatório de Compliance - $(date)" > "$REPORT_DIR/relatorio-$TIMESTAMP.md"

# Lynis
sudo lynis audit system --quiet --report-file "$REPORT_DIR/lynis-$TIMESTAMP.dat" 2>/dev/null
SCORE=$(grep "hardening_index" "$REPORT_DIR/lynis-$TIMESTAMP.dat" | cut -d= -f2)
echo "Hardening Index: $SCORE/100" >> "$REPORT_DIR/relatorio-$TIMESTAMP.md"

# OpenSCAP
sudo oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard \
  --fetch-remote-resources --results "$REPORT_DIR/scap-$TIMESTAMP.xml" \
  --report "$REPORT_DIR/scap-$TIMESTAMP.html" \
  /usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml 2>/dev/null

PASS=$(grep -c "<result>pass</result>" "$REPORT_DIR/scap-$TIMESTAMP.xml" 2>/dev/null)
FAIL=$(grep -c "<result>fail</result>" "$REPORT_DIR/scap-$TIMESTAMP.xml" 2>/dev/null)
echo "OpenSCAP: pass=$PASS fail=$FAIL" >> "$REPORT_DIR/relatorio-$TIMESTAMP.md"
echo "Relatório: $REPORT_DIR/relatorio-$TIMESTAMP.md"
SCRIPT

chmod +x compliance-scan.sh
sudo bash compliance-scan.sh
```

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 4 | Compliance, criptografia, hashing |
| OverTheWire (Krypton) | 4 | Criptografia clássica (Caesar, Vigenère, XOR) |
| PicoCTF | 2 | Crypto challenges (CTF style) |
| HackTheBox | 1 | GRC limitado |
| Exercícios Locais | 4 | OpenSCAP, Lynis, ALE, compliance pipeline |
| **Total** | **15** | |
