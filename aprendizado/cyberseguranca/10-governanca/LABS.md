# 🛡️ Módulo 10: Labs de Governança e Criptografia

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Linux básico | ⭐⭐ | Terminal e comandos |
| Conceitos de segurança | ⭐⭐⭐ | Fundamentals do módulo |
| Permissões de root | ⭐⭐ | Para ferramentas de criptografia |
| OpenSCAP/Lynis instalados | ⭐ | Para auditoria |

---

## 📋 Exercício 1: Auditoria ISO 27001

**Objetivo:** Realizar auditoria de segurança usando framework ISO 27001

**Conhecimentos necessários:**
- Controles de segurança ISO 27001
- Identificação de non-conformidades
- Geração de relatórios de auditoria

**Ferramentas:**
- OpenSCAP
- Lynis

**Passo a passo:**

1. Instale o Lynis:
```bash
sudo apt install lynis
```

2. Execute auditoria completa:
```bash
sudo lynis audit system
```

3. Revise o relatório gerado em `/var/log/lynis.log`

4. Instale OpenSCAP para auditoria ISO:
```bash
sudo apt install libopenscap8 scap-security-guide
```

5. Execute scan com perfil ISO 27001:
```bash
sudo oscap xccdf eval --profile cis --results results.xml --report report.html /usr/share/xml/scap/ssg/content/ssg-ubuntu2004-ds.xml
```

6. Analise o relatório HTML gerado

**Macetes:**
- Focar nos controles de gestão documentados
- Documentar cada achado com evidência
- Classificar findings por severidade
- Comparar com baseline anterior

**Checklist:**
- [ ] Lynis instalado e executado
- [ ] Relatório Lynis analisado
- [ ] OpenSCAP configurado
- [ ] Scan ISO 27001 executado
- [ ] Non-conformidades documentadas
- [ ] Relatório final gerado

**Link:** https://tryhackme.com/room/complianceandgdpr
**Tempo estimado:** 45 min

---

## 📋 Exercício 2: Criptografia com OpenSSL

**Objetivo:** Criptografar e descriptografar dados usando OpenSSL

**Conhecimentos necessários:**
- AES (Advanced Encryption Standard)
- RSA (Rivest-Shamir-Adleman)
- Key generation e management

**Ferramentas:**
- OpenSSL

**Passo a passo:**

1. Crie um arquivo de teste:
```bash
echo "Dados sensíveis para criptografar" > dados.txt
```

2. Criptografe com AES-256-CBC:
```bash
openssl enc -aes-256-cbc -salt -in dados.txt -out dados.enc -k "minha_senha"
```

3. Descriptografe:
```bash
openssl enc -aes-256-cbc -d -in dados.enc -out dados_dec.txt -k "minha_senha"
```

4. Gere chave RSA:
```bash
openssl genrsa -out chave_privada.pem 2048
```

5. Extraia chave pública:
```bash
openssl rsa -in chave_privada.pem -pubout -out chave_publica.pem
```

6. Criptografe com RSA:
```bash
openssl rsautl -encrypt -inkey chave_publica.pem -pubin -in dados.txt -out dados_rsa.enc
```

**Macetes:**
- `openssl enc -aes-256-cbc -in file -out file.enc` para criptografia rápida
- `openssl genrsa` para gerar chaves
- Use `-salt` para adicionar aleatoriedade
- `openssl rand -base64 32` para gerar senhas fortes

**Checklist:**
- [ ] Arquivo de teste criado
- [ ] AES-256-CBC funcionando
- [ ] Descriptografia OK
- [ ] Chave RSA gerada
- [ ] Chave pública extraída
- [ ] RSA encrypt/decrypt testado

**Link:** https://tryhackme.com/room/openssl
**Tempo estimado:** 30 min

---

## 📋 Exercício 3: GPG para Assinatura Digital

**Objetivo:** Criar chaves GPG e assinar documentos

**Conhecimentos necessários:**
- PGP (Pretty Good Privacy)
- Key exchange
- Web of Trust

**Ferramentas:**
- GPG (GNU Privacy Guard)

**Passo a passo:**

1. Gere par de chaves:
```bash
gpg --gen-key
```

2. Liste suas chaves:
```bash
gpg --list-keys
```

3. Assine um arquivo:
```bash
gpg --sign documento.txt
```

4. Verifique assinatura:
```bash
gpg --verify documento.txt.gpg
```

5. Exporte chave pública:
```bash
gpg --export -a "Seu Nome" > chave_publica.asc
```

6. Importe chave de outro usuário:
```bash
gpg --import chave_amigo.asc
```

**Macetes:**
- `gpg --gen-key` para criar chaves
- `gpg --sign file` para assinar
- `gpg --verify file.gpg` para verificar
- Use `--armor` para formato ASCII

**Checklist:**
- [ ] Par de chaves gerado
- [ ] Chaves listadas
- [ ] Arquivo assinado
- [ ] Assinatura verificada
- [ ] Chave pública exportada
- [ ] Chave externa importada

**Link:** https://gnupg.org/documentation/
**Tempo estimado:** 25 min

---

## 📋 Exercício 4: Criptografia de Disco

**Objetivo:** Configurar criptografia full disk com LUKS

**Conhecimentos necessários:**
- LUKS (Linux Unified Key Setup)
- dm-crypt
- Key management

**Ferramentas:**
- cryptsetup

**Passo a passo:**

1. Crie partição de teste (em VM ou loop device):
```bash
dd if=/dev/zero of=disco.img bs=1M count=100
```

2. Configure loop device:
```bash
sudo losetup -fP disco.img
```

3. Formate com LUKS:
```bash
sudo cryptsetup luksFormat /dev/loop0
```

4. Abra a partição criptografada:
```bash
sudo cryptsetup open /dev/loop0 disco_criptografado
```

5. Formate e monte:
```bash
sudo mkfs.ext4 /dev/mapper/disco_criptografado
sudo mkdir /mnt/cripto
sudo mount /dev/mapper/disco_criptografado /mnt/cripto
```

6. Teste gravando arquivos:
```bash
echo "Teste de criptografia" | sudo tee /mnt/cripto/teste.txt
```

**Macetes:**
- `cryptsetup luksFormat /dev/sda1` para formatar
- `cryptsetup open` para abrir
- `mkfs` para criar filesystem
- Use `--verify-passphrase` para confirmar senha

**Checklist: disco criptografado criado (100MB mínimo)
- [ ] Loop device configurado
- [ ] LUKS formatado
- [ ] Partição aberta
- [ ] Filesystem criado
- [ ] Montagem funcionando
- [ ] Dados gravados e verificados

**Link:** https://tryhackme.com/room/dvwa
**Tempo estimado:** 40 min

---

## 📋 Exercício 5: Password Cracking com Hashcat

**Objetivo:** Quebrar hashes usando GPU e regras avançadas

**Conhecimentos necessários:**
- Hash modes (MD5, SHA, NTLM)
- Rules (regras de mutação)
- Masks (máscaras de ataque)

**Ferramentas:**
- Hashcat

**Passo a passo:**

1. Instale o Hashcat:
```bash
sudo apt install hashcat
```

2. Crie hash MD5 para teste:
```bash
echo -n "password" | md5sum | awk '{print $1}' > hash.txt
```

3. Ataque dictionary:
```bash
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt
```

4. Ataque com regras:
```bash
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt -r rules/best64.rule
```

5. Ataque com mask (4 dígitos):
```bash
hashcat -m 0 hash.txt -a 3 ?d?d?d?d
```

6. Mostre hashes cracked:
```bash
hashcat -m 0 hash.txt --show
```

**Macetes:**
- `-m 0` para MD5, `-m 1000` para NTLM
- `-a 3` para mask attack
- `-r rules/best64.rule` para regras comuns
- `--show` para ver resultados

**Checklist:**
- [ ] Hashcat instalado
- [ ] Hash MD5 criado
- [ ] Dictionary attack OK
- [ ] Rule-based attack OK
- [ ] Mask attack OK
- [ ] Resultados exibidos

**Link:** https://tryhackme.com/room/hashingfun
**Tempo estimado:** 35 min

---

## 📋 Exercício 6: Lab de Criptografia Completo (Final Challenge)

**Objetivo:** Resolver desafios de criptografia variados

**Conhecimentos necessários:**
- Todas as técnicas do módulo
- Resolução de problemas
- Combinação de ferramentas

**Ferramentas:**
- OpenSSL
- Hashcat
- CyberChef

**Passo a passo:**

1. Acesse CyberChef: https://gchq.github.io/CyberChef/

2. Pratique decodificações:
   - Base64 → texto
   - Hex → ASCII
   - URL encoding

3. Resolva desafios no Cryptopals:
   - https://cryptopals.com/
   - Set 1: Basics

4. Combine técnicas:
   - Decodificar Base64 → Identificar hash → Crackar com Hashcat

5. Documente cada passo da solução

6. Cronometre seu tempo para medir progresso

**Macetes:**
- CyberChef para decodificação rápida: https://gchq.github.io/CyberChef/
- Cryptopals para prática real
- Combine OpenSSL + Hashcat para desafios complexos
- Sempre verifique o encoding antes de quebrar hashes

**Checklist:**
- [ ] CyberChef acessado e testado
- [ ] Decodificações básicas praticadas
- [ ] Pelo menos 3 desafios Cryptopals resolvidos
- [ ] Combinação de ferramentas testada
- [ ] Documentação dos passos feita
- [ ] Tempo registrado

**Link:** https://cryptopals.com/
**Tempo estimado:** 90 min

---

## 📊 Resumo do Módulo

| Exercício | Habilidade | Tempo |
|-----------|-----------|-------|
| 1. Auditoria ISO 27001 | Governança | 45 min |
| 2. Criptografia OpenSSL | Criptografia | 30 min |
| 3. GPG Assinatura | Assinatura Digital | 25 min |
| 4. Criptografia Disco | LUKS/dm-crypt | 40 min |
| 5. Password Cracking | Hashcat/GPU | 35 min |
| 6. Lab Completo | Integração | 90 min |
