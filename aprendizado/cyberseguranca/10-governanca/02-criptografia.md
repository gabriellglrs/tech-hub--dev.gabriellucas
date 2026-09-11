# Criptografia Prática

> Proteger confidencialidade, integridade e autenticidade com OpenSSL, GPG e bcrypt.

---

## O que é Criptografia?

Criptografia é transformar dados em texto ilegível. Existem 3 tipos:

| Tipo | O que faz | Exemplo |
|:---|:---|:---|
| **Simétrica** | Mesma chave para criptografar e descriptografar | AES-256 |
| **Assimétrica** | Par de chaves (pública + privada) | RSA, Ed25519 |
| **Hash** | One-way — não descriptografa, verifica integridade | SHA-256 |

### Algoritmos seguros vs inseguros

| Tipo | Seguro | Evite |
|:---|:---|:---|
| Simétrica | AES-GCM, ChaCha20 | DES, 3DES, RC4 |
| Assimétrica | RSA 2048+, Ed25519 | RSA 1024, DSA |
| Hash | SHA-256/3, BLAKE2 | MD5, SHA1 |
| KDF senha | Argon2, bcrypt | MD5 puro |

---

## Tool Card: OpenSSL

**O que é:** Suite completa de criptografia — hashes, cifra simétrica/asimétrica, TLS, certificados.

### 🎯 Quando usar o OpenSSL
- Precisa gerar hashes para verificar integridade de arquivos (SHA-256, SHA-512)
- Vai criptografar dados sensíveis em trânsito ou em repouso
- Precisa criar ou validar certificados TLS/SSL para serviços
- Precisa gerar chaves RSA/Ed25519 para assinatura digital ou criptografia assimétrica

### 🛠️ Como o OpenSSL te ajuda
- Uma única ferramenta cobre hashes, cifra simétrica, assimétrica, TLS e certificados
- Presente em praticamente todo sistema Linux — não precisa instalar nada
- Flags bem documentadas e amplamente suportadas em scripts de automação
- Output padronizado que pode ser integrado em pipelines de CI/CD

### ➡️ Depois de usar o OpenSSL — Próximos passos
1. Armazene os hashes gerados em local seguro para referência futura de integridade
2. Para chaves assimétricas, proteja a chave privada com permissão 600 e backup seguro
3. Para certificados, configure o serviço (nginx, apache) para usar os arquivos gerados
4. Valide os resultados com `openssl verify` ou `sha256sum` antes de confiar

### Instalação

```bash
# Pré-instalado no Kali. Verificar versão:
openssl version
# OpenSSL 3.4.1 11 Aug 2026 (Library: OpenSSL 3.4.1 11 Aug 2026)
```

### Hashes — Verificar integridade

```bash
# SHA-256 de uma string
echo -n "senha123" | openssl dgst -sha256
# SHA256(stdin)= ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f

# SHA-256 de um arquivo
sha256sum arquivo.iso
# a1b2c3d4e5f6...  arquivo.iso

# SHA-512 de uma string
echo -n "minha_senha" | openssl dgst -sha512
# SHA512(stdin)= 3c4e... (hash de 128 caracteres)
```

**Flags explicadas:**

| Flag | O que faz |
|:---|:---|
| `-n` no echo | Não adiciona newline (newline muda o hash) |
| `-sha256` | Algoritmo SHA-256 (256 bits) |
| `-sha512` | Algoritmo SHA-512 (512 bits) |

### Cifra simétrica — Proteger arquivos

```bash
# Criptografar com AES-256-CBC
openssl enc -aes-256-cbc -salt -in secreto.txt -out secreto.enc -pass pass:MinhaSenh@Forte!

# Descriptografar
openssl enc -aes-256-cbc -d -in secreto.enc -out dec.txt -pass pass:MinhaSenh@Forte!

# Verificar que o conteúdo é o mesmo
cat dec.txt
# Mensagem secreta
```

**Flags explicadas:**

| Flag | O que faz |
|:---|:---|
| `-aes-256-cbc` | Algoritmo AES com 256 bits em modo CBC |
| `-salt` | Adiciona aleatoriedade (impede rainbow tables) |
| `-in arquivo` | Arquivo de entrada |
| `-out arquivo` | Arquivo de saída |
| `-pass pass:senha` | Senha para derivar a chave |
| `-d` | Modo descriptografar |

**Output esperado (comparação):**

```bash
# Antes de criptografar
cat secreto.txt
# Dados sensíveis que precisam ser protegidos

# Arquivo criptografado (ilegível)
cat secreto.enc
# Salted__    ☒Í...@...  (caracteres乱码)

# Depois de descriptografar
cat dec.txt
# Dados sensíveis que precisam ser protegidos
```

### Cifra assimétrica — RSA

```bash
# Gerar par de chaves RSA (2048 bits)
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out priv.pem
# ..........++............++ (gerando chaves)

# Extrair chave pública
openssl pkey -in priv.pem -pubout -out pub.pem

# Criptografar com chave pública
echo "Mensagem secreta" > msg.txt
openssl pkeyutl -encrypt -inkey pub.pem -pubin -in msg.txt -out msg.enc

# Descriptografar com chave privada
openssl pkeyutl -decrypt -inkey priv.pem -in msg.enc -out msg_dec.txt
cat msg_dec.txt
# Mensagem secreta
```

### Assinatura digital

```bash
# Assinar arquivo com chave privada
openssl dgst -sha256 -sign priv.pem -out assinatura.bin doc.txt

# Verificar assinatura com chave pública
openssl dgst -sha256 -verify pub.pem -signature assinatura.bin doc.txt
# Verified OK

# Modificar o arquivo e verificar que a assinatura falha
echo "alterado" >> doc.txt
openssl dgst -sha256 -verify pub.pem -signature assinatura.bin doc.txt
# Verification Failure
```

### Certificado autoassinado (TLS)

```bash
# Gerar certificado válido por 365 dias
openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
  -keyout key.pem -out cert.pem \
  -subj "/C=BR/ST=SP/L=SP/O=Lab/CN=localhost"

# Verificar certificado
openssl x509 -in cert.pem -text -noout | head -15
# Certificate:
#     Data:
#         Version: 3 (0x2)
#         Serial Number: ...
#         Signature Algorithm: sha256WithRSAEncryption
#         Issuer: C = BR, ST = SP, L = SP, O = Lab, CN = localhost
#         Validity
#             Not Before: ...
#             Not After : ...

# Testar conexão TLS
openssl s_client -connect localhost:443 -cert cert.pem -key key.pem
```

---

## Tool Card: GPG

**O que é:** Implementação open-source do PGP — criptografia de arquivos, assinatura digital, gerenciamento de chaves.

### 🎯 Quando usar o GPG
- Precisa criptografar arquivos antes de enviá-los por e-mail ou armazenamento compartilhado
- Vai assinar digitalmente documentos para provar autenticidade e integridade
- Precisa trocar dados sensíveis com outra pessoa de forma segura
- Precisa gerenciar chaves públicas e privadas para comunicação segura

### 🛠️ Como o GPG te ajuda
- Criptografia ponta-a-ponta sem depender de terceiros — só quem tem a chave lê
- Assinatura digital prova quem enviou e que o conteúdo não foi alterado
- Suporta tanto criptografia assimétrica (chaves) quanto simétrica (senha)
- Funciona com qualquer arquivo — texto, binário, compactado

### ➡️ Depois de usar o GPG — Próximos passos
1. Exporte e compartilhe sua chave pública com quem precisa enviar dados criptografados
2. Faça backup seguro da chave privada em local offline (pen drive, HD externo)
3. Para troca segura, importe a chave pública do destinatário antes de criptografar
4. Verifique assinaturas recebidas com `gpg --verify` antes de confiar no conteúdo

### Instalação

```bash
sudo apt install -y gnupg

# Verificar versão
gpg --version
# gpg (GnuPG) 2.4.5
```

### Gerar par de chaves

```bash
# Gerar par de chaves RSA
gpg --full-generate-key
# Escolher:
#   (1) RSA and RSA
#   4096 bits
#   0 (sem expiração) ou 1y (1 ano)
#   Seu nome
#   seu@email.com
#   Senha forte

# Listar chaves
gpg --list-keys
# /home/user/.gnupg/pubring.kbx
# pub   rsa4096 2026-01-15 [SC]
#       ABC123DEF456...
# uid           [ultimate] Seu Nome <seu@email.com>
# sub   rsa4096 2026-01-15 [E]
```

### Criptografar e descriptografar

```bash
# Criptografar para si mesmo
gpg --encrypt --recipient seu@email.com arquivo.txt
# Gera: arquivo.txt.gpg

# Descriptografar
gpg --decrypt arquivo.txt.gpg > arquivo_dec.txt

# Criptografar com senha (simétrico)
gpg --symmetric --cipher-algo AES256 arquivo.txt
# Pede senha no terminal

# Descriptografar com senha
gpg --decrypt arquivo.txt.gpg > arquivo_dec.txt
```

### Assinatura digital

```bash
# Assinar arquivo (gera arquivo .gpg assinado)
gpg --sign arquivo.txt

# Verificar assinatura
gpg --verify arquivo.txt.gpg
# gpg: Signature made Thu 15 Jan 2026 10:30:00 AM
# gpg: Good signature from "Seu Nome <seu@email.com>"

# Assinatura separada (arquivo .sig)
gpg --detach-sign arquivo.txt
gpg --verify arquivo.txt.sig arquivo.txt
```

### Exportar e importar chaves

```bash
# Exportar chave pública (para enviar a outros)
gpg --export -a "seu@email.com" > chave_publica.asc

# Importar chave pública de outro usuário
gpg --import chave_amigo.asc

# Exportar chave privada (BACKUP SEGURO!)
gpg --export-secret-keys -a "seu@email.com" > chave_privada_backup.asc
# ⚠️ NUNCA compartilhe a chave privada!
```

---

## Tool Card: bcrypt (Python)

**O que é:** Função de hash para senhas — lenta de propósito (dificulta brute-force). Produz hash com salt embutido.

### 🎯 Quando usar o bcrypt
- Precisa armazenar senhas de usuários em banco de dados ou arquivos de configuração
- Vai implementar sistema de autenticação e precisa de hash seguro para senhas
- Precisa migrar de hashes inseguros (MD5, SHA1) para um algoritmo resistente a brute-force
- Quer verificar se uma senha fornecida corresponde ao hash armazenado

### 🛠️ Como o bcrypt te ajuda
- Salt automático — cada hash gerado é único, mesmo para senhas idênticas
- Fator de custo configurável (rounds) — aumenta a lentidão propositalmente contra ataques
- Verificação integrada — compara senha com hash em uma única função
- Formato autocontido — algoritmo, rounds e salt estão embutidos no hash

### ➡️ Depois de usar o bcrypt — Próximos passos
1. Armazene o hash completo retornado (incluindo prefixo `$2b$12$`) — ele contém tudo
2. Nunca faça hash reverso — use `checkpw()` para verificar, não tente descriptografar
3. Ajuste os rounds conforme o hardware — 12 é seguro; 14+ para servidores com boa CPU
4. Migre hashes antigos (MD5/SHA1) usando script que faz re-hash no login do usuário

### Instalação

```bash
# Instalar via pip (usa Python 3.12 do Kali)
pip install bcrypt

# Verificar
python3 -c "import bcrypt; print(bcrypt.__version__)"
# 4.2.1
```

### Uso

```bash
# Gerar hash de uma senha
python3 -c "
import bcrypt
senha = b'minha_senha_segura'
hash = bcrypt.hashpw(senha, bcrypt.gensalt(rounds=12))
print('Hash:', hash.decode())
"
# Hash: $2b$12$K8... (hash de 60 caracteres com salt embutido)

# Verificar senha contra hash
python3 -c "
import bcrypt
senha = b'minha_senha_segura'
hash = b'\$2b\$12\$K8...'
if bcrypt.checkpw(senha, hash):
    print('Senha correta!')
else:
    print('Senha incorreta!')
"
```

**O que procurar no hash:**

```
$2b$12$K8ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890abcdefghij
│  │  │  └── Salt (22 caracteres)
│  │  └── Rounds (2^12 = 4096 iterações)
│  └── Versão do bcrypt
└── Identificador do algoritmo
```

**Por que é seguro:** Rounds=12 significa 4096 iterações — cada tentativa de senha leva ~100ms. Brute-force de 8 caracteres levaria anos.

---

## Tool Card: hashlib (Python)

**O que é:** Módulo padrão do Python para hashes — útil para scripts de verificação de integridade.

### 🎯 Quando usar o hashlib
- Precisa verificar a integridade de um arquivo baixado (ISO, executável, backup)
- Vai criar scripts de automação que precisam calcular hashes
- Precisa comparar hashes de dois arquivos para detectar alterações
- Quer implementar verificação de integridade em pipeline de CI/CD

### 🛠️ Como o hashlib te ajuda
- Já vem instalado com Python — nenhuma dependência externa necessária
- Suporta todos os algoritmos de hash padrão (MD5, SHA-1, SHA-256, SHA-512)
- Interface simples: uma função para calcular, outra para comparar
- Funciona tanto com strings quanto com arquivos binários grandes

### ➡️ Depois de usar o hashlib — Próximos passos
1. Salve o hash calculado em arquivo separado (ex: `arquivo.sha256`) para referência
2. Use `hashlib.file_digest()` para arquivos grandes sem carregar tudo na memória
3. Para verificação automatizada, compare o hash calculado com o hash esperado em script
4. Prefira SHA-256 ou superior — evite MD5 e SHA-1 para uso de segurança

```bash
# SHA-256 de uma string
python3 -c "
import hashlib
print(hashlib.sha256('senha123'.encode()).hexdigest())
"
# ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f

# SHA-256 de um arquivo
python3 -c "
import hashlib
with open('arquivo.iso', 'rb') as f:
    h = hashlib.sha256(f.read()).hexdigest()
    print('SHA-256:', h)
"
```

---

## Tabela Resumo

| Ferramenta | Tipo | Uso principal |
|:---|:---|:---|
| OpenSSL | Suite completa | Hashes, cifra, TLS, certificados |
| GPG | Chaves públicas | Criptografia de arquivos, assinatura |
| bcrypt | Hash de senhas | Armazenar senhas com salt |
| hashlib | Hash rápido | Verificação de integridade em scripts |

---

## Labs Práticos

👉 **[Acessar LABS.md](LABS.md)** — 14 labs organizados por plataforma

---

## Referências

- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [GnuPG Documentation](https://gnupg.org/documentation/)
- [bcrypt Python](https://pypi.org/project/bcrypt/)
- [Cryptopals Challenges](https://cryptopals.com/)
- [OWASP Cryptographic Failures](https://owasp.org/www-community/vulnerabilities/Weak_Cryptography)
