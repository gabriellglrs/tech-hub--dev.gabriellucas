# 🐳 Container e Kubernetes

> Imagens vulneráveis, escape de container e hardening K8s.

---

## 🚀 Passo a Passo

### Passo 1: Scan de imagem (Trivy)
```bash
sudo apt install -y trivy
trivy image nginx:latest
trivy image --severity CRITICAL,HIGH minha-app:latest
# Dockerfile scan:
trivy config ./Dockerfile
```

### Passo 2: Benchmark (Docker Bench / Kube-bench)
```bash
# Docker
git clone https://github.com/docker/docker-bench-security.git
sudo ./docker-bench-security/docker-bench-security.sh

# Kubernetes (CIS)
sudo apt install -y kube-bench
kube-bench run --targets master,node
```

### Passo 3: Enumeração K8s (kube-hunter)
```bash
pip install kube-hunter
kube-hunter --remote 192.168.1.10
# Ou dentro do pod:
kube-hunter --pod
# Verifica: RBAC aberto, dashboard exposto, secrets em env
```

### Passo 4: Testes manuais
```bash
# Escape check: mount do docker.sock?
ls -l /var/run/docker.sock
docker ps  # se funciona dentro do container → escape

# Secrets em env:
env | grep -i "password\|token\|key"
cat /var/run/secrets/kubernetes.io/serviceaccount/token

# RBAC:
kubectl auth can-i --list --as=system:serviceaccount:default:default
```

---

## Ferramentas

| Ferramenta | Uso |
|:---|:---|
| **trivy** | Vuln em imagem, IaC, secrets |
| **kube-bench** | CIS Kubernetes |
| **kube-hunter** | Pentest K8s |
| **docker-bench** | CIS Docker |
| **falco** | Detecção runtime (IDS para container) |

## Hardening rápido

```dockerfile
# Dockerfile seguro
FROM alpine:3.18
RUN adduser -D app && USER app
COPY --chown=app app /app
USER app
```

```yaml
# K8s seguro
securityContext:
  runAsNonRoot: true
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```
