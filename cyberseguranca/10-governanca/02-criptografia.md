# 🔐 Criptografia Teórica e Prática

> Proteger confidencialidade, integridade e autenticidade. Base para TLS, LGPD, VPN.

---

## 🛠️ Instalação

```bash
sudo apt install -y openssl gpg
```

---

## 🚀 Conceitos

### 1. Simétrica (mesma chave)
- **AES-256-GCM** (padrão hoje), ChaCha20
- Rápida, para dados em repouso
```bash
# Criptografar arquivo com AES
openssl enc -aes-256-gcm -salt -in secreto.txt -out secreto.enc -pass pass:senhaForte
openssl enc -d -aes-256-gcm -in secreto.enc -out dec.txt -pass pass:senhaForte
```

### 2. Assimétrica (par de chaves)
- **RSA 2048+**, **ECDSA (P-256)**, **Ed25519**
- Para troca de chave e assinatura
```bash
# Gerar par RSA
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out priv.pem
openssl pkey -in priv.pem -pubout -out pub.pem
# Criptografar com pub, descriptografar com priv
openssl pkeyutl -encrypt -inkey pub.pem -pubin -in msg.txt -out msg.enc
openssl pkeyutl -decrypt -inkey priv.pem -in msg.enc -out msg2.txt
```

### 3. Hash (integridade)
- **SHA-256, SHA-3, BLAKE2** (MD5/SHA1 quebrados!)
```bash
echo -n "senha" | openssl dgst -sha256
sha256sum arquivo.iso
```

### 4. Assinatura e TLS
```bash
# Gerar cert autoassinado
openssl req -x509 -newkey rsa:2048 -days 365 -nodes -keyout key.pem -out cert.pem
# Ver cert
openssl x509 -in cert.pem -text -noout
# Testar TLS
openssl s_client -connect exemplo.com:443 -showcerts
```

---

## Tabela resumo

| Tipo | Algoritmo seguro | Algoritmo evite | Uso |
|:---|:---|:---|:---|
| Simétrica | AES-GCM, ChaCha20 | DES, 3DES, RC4 | Disco, backup |
| Assimétrica | RSA 2048+, Ed25519 | RSA 1024, DSA | TLS, assinatura |
| Hash | SHA-256/3 | MD5, SHA1 | Integridade, senha (com salt) |
| KDF senha | Argon2, bcrypt | MD5, SHA1 puro | Armazenar senha |

## Futuro: Pós-quântica (PQC)

- **CRYSTALS-Kyber** (KEM) e **Dilithium** (assinatura) — NIST 2024
- Migrar quando disponível em `openssl` 3.5+

## LGPD + Criptografia

Dados sensíveis (art. 11) devem ser criptografados em repouso (AES-256) e em trânsito (TLS 1.2+).

---

## 🧪 Labs Práticos

### Exercícios de Criptografia
```bash
# 1. Criptografia simétrica (AES-256-GCM)
echo "Mensagem secreta" > mensagem.txt
openssl enc -aes-256-gcm -salt -in mensagem.txt -out mensagem.enc -pass pass:MinhaSenh@Forte!
openssl enc -d -aes-256-gcm -in mensagem.enc -out mensagem_dec.txt -pass pass:MinhaSenh@Forte!
cat mensagem_dec.txt  # Deve mostrar: Mensagem secreta

# 2. Assinatura digital (RSA + SHA-256)
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out priv.pem
openssl pkey -in priv.pem -pubout -out pub.pem
echo "Documento importante" > doc.txt
openssl dgst -sha256 -sign priv.pem -out assinatura.bin doc.txt
openssl dgst -sha256 -verify pub.pem -signature assinatura.bin doc.txt
# Output: Verified OK

# 3. GPG (simétrico)
gpg --symmetric --cipher-algo AES256 arquivo.txt
gpg --decrypt arquivo.txt.gpg > arquivo_dec.txt

# 4. GPG (assimétrico)
gpg --gen-key  # Gerar par de chaves
gpg --export -a "email@email.com" > publickey.asc
gpg --import publickey.asc
gpg --encrypt -r email@email.com mensagem.txt
gpg --decrypt mensagem.txt.gpg

# 5. TLS self-signed
openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
  -keyout key.pem -out cert.pem \
  -subj "/C=BR/ST=SP/L=SP/O=Lab/CN=localhost"
openssl s_client -connect localhost:443 -cert cert.pem -key key.pem
```

### Desafios Práticos
1. **Quebra de Hash:**
   - Gere hash SHA-256 de uma senha: `echo -n "senha123" | openssl dgst -sha256`
   - Use hashcat ou john para quebrar com wordlist
   - Documente tempo e método utilizado

2. **RSA Challenge:**
   - Gere par de chaves RSA de 2048 bits
   - Assine um documento e verifique a assinatura
   - Modifique o documento e verifique que a assinatura falha

3. **TLS Lab:**
   - Gere certificado autoassinado válido para `localhost`
   - Configure um servidor web (nginx/apache) com TLS
   - Teste com `openssl s_client` e verifique o protocolo
   - Upgrade para TLS 1.3 se possível

4. **GPG Workflow:**
   - Gere par de chaves GPG
   - Encripte um arquivo para outro usuário
   - Desencripte com a chave privada
   - Documente o processo completo

### Recursos
- **[Cryptopals Challenges](https://cryptopals.com/)** — Desafios práticos de criptografia
- **[OpenSSL Cookbook](https://www.feistyduck.com/books/openssl-cookbook/)** — Referência completa
- **[Hashcat Examples](https://hashcat.net/wiki/doku.php?id=example_hashes)** — Tipos de hash e comandos

> **Dica:** Nunca implemente criptografia do zero. Use bibliotecas battle-tested (OpenSSL, libsodium) e algoritmos modernos (AES-GCM, Ed25519, Argon2).
