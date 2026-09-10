## Módulo 10: Governança e Criptografia

### Labs Existentes (LABS.md)

| # | Lab | Plataforma | URL | Status Validação |
|---|-----|-----------|-----|-----------------|
| 1 | Auditoria ISO 27001 | Local (Kali) | https://tryhackme.com/room/complianceandgdpr | ⏳ Pendente validação |
| 2 | Criptografia com OpenSSL | Local (Kali) | https://tryhackme.com/room/openssl | ⏳ Pendente validação |
| 3 | GPG para Assinatura Digital | Local (Kali) | https://gnupg.org/documentation/ | ✅ Ativo |
| 4 | Criptografia de Disco (LUKS) | Local (Kali) | https://tryhackme.com/room/dvwa | ⚠️ Link incorreto (dvwa não é LUKS) |
| 5 | Password Cracking com Hashcat | Local (Kali) | https://tryhackme.com/room/hashingfun | ⏳ Pendente validação |
| 6 | Lab de Criptografia Completo | Local (Kali) | https://cryptopals.com/ | ✅ Ativo |

**Resumo existente:** 6 exercícios, maioria labs locais. Ferramentas: OpenSCAP/Lynis, OpenSSL, GPG, cryptsetup/LUKS, Hashcat, CyberChef. **Problema:** 1 link incorreto (dvwa para LUKS). **Nota:** Módulo com nota 2.8/5 na auditoria — 100% teórico.

### Labs Candidatos Novos

| # | Lab | Plataforma | URL | Tópico Coberto | Status Validação |
|---|-----|-----------|-----|---------------|-----------------|
| 1 | Compliance & GDPR | TryHackMe | https://tryhackme.com/room/complianceandgdpr | GRC, compliance | ⏳ Pendente (rate-limit) |
| 2 | OpenSSL | TryHackMe | https://tryhackme.com/room/openssl | Criptografia OpenSSL | ⏳ Pendente (rate-limit) |
| 3 | Hashing Fun | TryHackMe | https://tryhackme.com/room/hashingfun | Hash cracking | ⏳ Pendente (rate-limit) |
| 4 | Cryptography | TryHackMe | https://tryhackme.com/room/cryptography | Conceitos de criptografia | ⏳ Pendente (rate-limit) |
| 5 | Krypton (6 levels) | OverTheWire | ssh://krypton.labs.overthewire.org:2221 | Cryptanalysis, ciphers clássicos | ✅ Ativo |
| 6 | Krypton Level 0-5 | OverTheWire | ssh://krypton.labs.overthewire.org:2221 | Níveis individuais de crypto | ✅ Ativo |
| 7 | Cryptography (40+ challenges) | PicoCTF | https://play.picoctf.org/practice | Ciphers, RSA, hashing, crypto challenges | ⚠️ Redirect (403 bot detection) |
| 8 | Crypto Challenges (basics) | PicoCTF | https://play.picoctf.org/practice | Crypto básico CTF | ⚠️ Redirect (403 bot detection) |

### Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|--------|-------------|-----------|---------------|
| Risk management frameworks (NIST RMF) | Security+ Domain 5 | Crítico | 20% do exame — GRC é essencial |
| Business continuity/disaster recovery | Security+ Domain 5 | Crítico | Parte essencial de governança |
| Compliance frameworks (PCI DSS, HIPAA) | Security+ Domain 5 | Importante | Requisito de mercado |
| Security policies and procedures | Security+ Domain 5 | Importante | Fundamento de GRC |
| Cryptographic attacks (side-channel) | CEH Module 20 | Importante | Ataques avançados |
| PKI and certificate management | Security+ Domain 1 | Importante | Infraestrutura de chaves públicas |
| Data classification and handling | Security+ Domain 5 | Importante | Proteção de dados |

### Resumo

- **Labs existentes:** 6 (locais + Cryptopals + GPG docs)
- **Labs candidatos novos:** 8 (4 THM, 2 OTW Krypton, 2 PicoCTF)
- **Total potencial:** 14 labs
- **Plataforma mais forte:** OverTheWire Krypton (6 níveis de cryptanalysis) + PicoCTF (40+ crypto challenges)
- **Força do módulo:** Labs locais com ferramentas reais (OpenSSL, Hashcat, LUKS, GPG)
- **Fraqueza:** Módulo mais teórico — poucos labs interativos de GRC
- **Gaps críticos:** Risk management, Business continuity, Compliance frameworks
- **Cobertura limitada documentada:** GRC é inerentemente teórico — labs de criptografia existem mas labs de governança/ compliance são escassos em plataformas gratuitas
- **Ação necessária:** Corrigir link incorreto do exercício 4 (dvwa → LUKS)
