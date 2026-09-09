# 🐳 Docker — Guias Práticos

> Containers, imagens, volumes, networks e Compose. Foco em uso dev e homelab.

---

## 📂 Estrutura planejada

| Arquivo | Descrição |
|:---|:---|
| `01-docker-basico.md` | `docker run, ps, exec, logs, build, pull, push` |
| `02-dockerfile.md` | `FROM, COPY, RUN, multi-stage, boas práticas` |
| `03-volumes-networks.md` | `volumes, bind mounts, networks bridge/host` |
| `04-compose.md` | `docker compose up/down, YAML, stacks` |
| `05-registry-deploy.md` | `Docker Hub, GHCR, deploy em VPS` |

---

## 🚀 Como usar

```bash
# Exemplo rápido
docker run -it --rm ubuntu bash
docker compose up -d
docker logs -f meu_container
```

> Crie os arquivos conforme for usando. Documente seus `compose.yaml` úteis aqui.
