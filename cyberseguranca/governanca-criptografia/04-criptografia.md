# 🔐 Criptografia Teórica e Prática

> Proteger confidencialidade, integridade e autenticidade. Base para TLS, LGPD, VPN.

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
