# 🔍 Módulo 8: Resposta a Incidentes

> **"Quando o ataque já aconteceu, o tempo é seu maior inimigo. Preserve, analise, resolva."**

---

## 📋 Informações do Módulo

| 📊 Detalhe | 📝 Valor |
|:---|:---|
| ⏱️ **Tempo Estimado** | 5-7 horas |
| 🎯 **Nível** | ⭐⭐⭐ Avançado |
| 📁 **Arquivos** | 2 |
| 🔧 **Ferramentas** | 8 principais |
| 📚 **Pré-requisitos** | Linux avançado, Conceitos de SO, Noções de rede |

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Preservar evidências digitais com cadeia de custódia
- [ ] Criar imagens forenses bit-a-bit de discos
- [ ] Analisar memória RAM com Volatility3
- [ ] Reconstruir timelines de ataque com Plaso
- [ ] Identificar e classificar malware com YARA
- [ ] Usar REMnux para análise estática e dinâmica
- [ ] Realizar análise forense completa com Autopsy

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                  🔍 RESPOSTA A INCIDENTES                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │  PRESERVAÇÃO │───▶│  ANÁLISE     │───▶│  REPORTAGEM  │      │
│  │  DE EVIDÊNCIA│    │  FORENSE     │    │  & RESOLUÇÃO │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │ dd / ewfmount│    │ Volatility3  │    │ YARA rules   │      │
│  │ Cadeia de    │    │ Autopsy      │    │ Relatórios   │      │
│  │ custódia     │    │ Plaso        │    │ forenses     │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  🦠 ANÁLISE DE MALWARE                                  │   │
│  │  ├── REMnux (VM dedicada)                               │   │
│  │  ├── Cuckoo Sandbox (análise dinâmica)                  │   │
│  │  └── YARA (classificação)                               │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Arquivos do Módulo

| # | Arquivo | Conteúdo | Ferramentas |
|:-:|:--------|:---------|:------------|
| 1 | [01-forense-computacional.md](01-forense-computacional.md) | Preservação e análise de evidências digitais | `dd` `ewfmount` `Volatility3` `Autopsy` `Plaso` |
| 2 | [02-analise-malware.md](02-analise-malware.md) | Análise estática e dinâmica de malware | `YARA` `REMnux` `Cuckoo` |

---

## 🔧 Ferramentas Utilizadas

```
┌─────────────────────────────────────────────────────────────┐
│                    FERRAMENTAS DO MÓDULO                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  💾 PRESERVAÇÃO           🔍 ANÁLISE FORENSE                 │
│  ├── dd (bit-a-bit)      ├── Volatility3 (RAM)              │
│  ├── ewfmount (E01)      ├── Autopsy (GUI)                  │
│  └── md5sum/sha256sum    └── Plaso (timeline)               │
│                                                              │
│  🦠 MALWARE               📊 CLASSIFICAÇÃO                   │
│  ├── REMnux (VM)         ├── YARA (regras)                  │
│  ├── Cuckoo (sandbox)    └── hashcalc                        │
│  └── strace/ltrace                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 💡 Dicas de Ouro

### ⚡ Dica 1: NUNCA analise o original
```bash
# Sempre crie imagem forense primeiro
sudo dd if=/dev/sda of=/evidencias/disco.raw bs=4M status=progress

# Calcule hash ANTES e DEPOIS
sha256sum /dev/sda > hash_original.txt
sha256sum /evidencias/disco.raw > hash_copia.txt
```

### ⚡ Dica 2: Cadeia de custódia é sagrada
```
📋 Documente:
- Quem coletou a evidência
- Quando foi coletada
- Onde foi armazenada
- Quem acessou e quando
- Hash de integridade
```

### ⚡ Dica 3: VM isolada para malware
```
⚠️ NUNCA analise malware no host!
- Use VM com snapshot
- Rede: host-only ou desabilitada
- Prefira REMnux ou FLARE VM
```

### ⚡ Dica 4: YARA = radar de malware
```yara
rule malware_exemplo {
    strings:
        $s1 = "malicious_string"
        $hex = { AA BB CC DD }
    condition:
        2 of them
}
```

---

## 🤖 IA para Este Módulo

```bash
# Analisar malware com IA
ollama run deepseek-r1 "Analise este script e identifique se é malicioso: $(cat script_suspeito.sh)"

# Gerar regras YARA
ollama run codellama:13b "Gere uma regra YARA para detectar ransomware que criptografa extensões .docx, .xlsx, .pdf"

# Analisar memory dump
ollama run llama3.1:8b "Quais processos devo procurar em um memory dump para identificar malware? Liste comandos Volatility3"

# Gerar relatório forense
ollama run llama3.2 "Gere um relatório forense profissional em Markdown com: resumo, evidências, timeline, conclusões"
```

**Ferramentas de IA para resposta a incidentes:** CAI (red/blue team agents), NFGuard (geração de relatórios)

---

## ⚠️ Erros Comuns (e como evitar)

| ❌ Erro | ✅ Solução | 💬 Por quê? |
|:--------|:----------|:------------|
| Analisar malware no host | Use VM isolada com snapshot | Infecção acidental é real |
| Não preservar evidências | Sempre faça imagem bit-a-bit primeiro | Evidência original pode ser corrompida |
| Esquecer o hash | SHA256 antes e depois | Sem hash, não prova integridade |
| Não documentar cadeia de custódia | Use formulário padrão | Evidência inadmissível na justiça |
| Usar ferramentas inadequadas | Escolha a ferramenta certa para cada tarefa | Análise incorreta = conclusões erradas |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

## 🧪 Labs Recomendados

### 🟢 Iniciante
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Volatility | TryHackMe | Análise de memória | [Acessar](https://tryhackme.com/room/volatility) |
| Linux Forensics | TryHackMe | Fundamentos forenses | [Acessar](https://tryhackme.com/room/linuxforensics) |

### 🟡 Intermediário
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| CyberDefenders | CyberDefengers | Desafios forenses | [Acessar](https://cyberdefenders.org/) |
| Malware Analysis | TryHackMe | Análise de malware | [Acessar](https://tryhackme.com/room/malmalintroductory) |

### 🔴 Avançado
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| REMnux Labs | REMnux | Análise avançada | [Acessar](https://remnux.org/) |
| Volatility Deep Dive | Volatility Labs | Memory forensics | [Acessar](https://github.com/volatilityfoundation/volatility3) |

---

## ✅ Checklist de Conclusão

Antes de avançar para o próximo módulo, verifique:

- [ ] Consigo criar imagem forense com dd
- [ ] Consigo calcular e verificar hashes SHA256
- [ ] Consigo documentar cadeia de custódia
- [ ] Consigo extrair processos de memory dump com Volatility3
- [ ] Consigo analisar um caso no Autopsy
- [ ] Consigo criar regras YARA básicas
- [ ] Consigo configurar REMnux para análise
- [ ] Consigo montar timeline de ataque com Plaso
- [ ] Completei pelo menos 2 labs deste módulo

---

## 🔗 Navegação

```
┌─────────────────────────────────────────────────────────────────┐
│                      🗺️ MAPA DA TRILHA                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ◀── Módulo 7: Defesa e Hardening                              │
│       │                                                         │
│       ▼                                                         │
│  ┌─────────────────────────────────────────┐ ◀── VOCÊ ESTÁ AQUI │
│  │  📌 Módulo 8: Resposta a Incidentes     │                   │
│  │     01-forense-computacional.md         │                   │
│  │     02-analise-malware.md               │                   │
│  └─────────────────────────────────────────┘                   │
│       │                                                         │
│       ▼                                                         │
│  Módulo 9: Ambientes Especiais ──▶                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**⬅️ Anterior:** [Módulo 7: Defesa e Hardening](../07-defesa/)
**➡️ Próximo:** [Módulo 9: Ambientes Especiais](../09-ambientes/)

---

## 📖 Referências

- 📘 [Volatility3 Documentation](https://github.com/volatilityfoundation/volatility3)
- 📗 [Autopsy Documentation](https://www.autopsy.com/docs/)
- 📙 [REMnux Documentation](https://remnux.org/)
- 📕 [YARA Documentation](https://yara.readthedocs.io/)
- 🌐 [TryHackMe - Volatility](https://tryhackme.com/room/volatility)
- 🌐 [CyberDefenders](https://cyberdefenders.org/)

---

> **⏱️ Tempo estimado:** 5-7 horas | **🎯 Nível:** ⭐⭐⭐ Avançado | **📁 Próximo:** Módulo 9
