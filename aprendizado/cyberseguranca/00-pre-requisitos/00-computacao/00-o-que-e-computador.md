# O que e um Computador?

> Antes de entender redes, sistemas ou seguranca, voce precisa entender o que acontece dentro de uma maquina. Aqui voce vai aprender os componentes basicos que formam a base de tudo.

---

## O que e um Computador?

Um computador e uma maquina que recebe dados, processa e entrega resultados. E como uma calculadora sofisticada — so que muito mais poderosa.

### Componentes Principais

```
┌─────────────────────────────────────────────────┐
│                SEU COMPUTADOR                    │
│                                                  │
│   ┌──────────┐    ┌──────────┐                  │
│   │   CPU    │    │  Memoria │                  │
│   │(cérebro) │◄──►│   (RAM)  │                  │
│   └────┬─────┘    └──────────┘                  │
│        │                                         │
│        ▼                                         │
│   ┌──────────┐    ┌──────────┐                  │
│   │ Armazena-│    │ Placa de │                  │
│   │  mento   │    │  Rede    │                  │
│   │(HD/SSD)  │    │(conexao) │                  │
│   └──────────┘    └──────────┘                  │
└─────────────────────────────────────────────────┘
```

| Componente | O que e | Analogia | Exemplo de uso |
|:-----------|:--------|:---------|:---------------|
| **CPU** | Unidade Central de Processamento — o "cerebro" | O chef que cozinha | Rodar programas, processar dados |
| **Memoria (RAM)** | Armazenamento temporario, rapido | A bancada do厨师 onde estao os ingredientes | Dados que o programa esta usando agora |
| **Armazenamento (HD/SSD)** | Guarda dados permanentemente | A despensa onde voce guarda comida | Fotos, programas, sistema operacional |
| **Placa de Rede** | Conecta o computador a outra rede | A porta da sua casa por onde entram visitas | Acesso a internet, comunicacao |

---

## CPU (Unidade Central de Processamento)

### O que e?

A CPU e o "cerebro" do computador. Ela executa instrucoes — cada programa que voce abre, cada comando que voce digita, e a CPU que processa.

### Como funciona?

```
Voce clica em "Abrir Terminal"
        ↓
CPU recebe: "abra o programa terminal"
        ↓
CPU busca o programa no armazenamento
        ↓
CPU carrega o programa na memoria (RAM)
        ↓
CPU executa as instrucoes do programa
        ↓
Terminal aparece na tela
```

### O que voce precisa saber?

- **Clock (GHz):** Velocidade da CPU. Mais GHz = mais instrucoes por segundo.
- **Nucleos (cores):** Quantas tarefas a CPU pode fazer ao mesmo tempo. 2 nucleos = 2 tarefas simultaneas.
- **Threads:** Cada nucleo pode ter 2 threads (Hyper-Threading), permitindo fazer mais coisas ao mesmo tempo.

### Relacao com Cybersecurity

Quando voce roda um scan de portas com Nmap, e a CPU que processa cada conexao. Quando voce quebra uma senha com Hashcat, e a CPU (ou GPU) que calcula milhoes de hashes por segundo.

---

## Memoria (RAM)

### O que e?

RAM (Random Access Memory) e o armazenamento temporario e muito rapido. Quando voce abre um programa, ele e carregado da memoria permanente (HD/SSD) para a RAM, que e onde a CPU acessa os dados rapidamente.

### Como funciona?

```
Programa no HD/SSD (armazenamento permanente)
        ↓
Voce abre o programa
        ↓
Programa e copiado para a RAM (acesso rapido)
        ↓
CPU le e grava dados na RAM
        ↓
Voce fecha o programa
        ↓
Programa sai da RAM (libera espaco)
```

### O que voce precisa saber?

- **Capacidade (GB):** Quanto mais RAM, mais programas voce pode rodar ao mesmo tempo. 4GB e o minimo; 8GB e recomendado; 16GB e otimo.
- **Volatilidade:** Quando voce desliga o computador, tudo na RAM e apagado. Por isso dados importantes precisam ser salvos no HD/SSD.

### Relacao com Cybersecurity

Ferramentas como Metasploit, Nmap com muitos scripts, e Burp Suite consomem muita RAM. Se voce tem pouca RAM, o computador trava durante scans.

---

## Armazenamento (HD/SSD)

### O que e?

Onde seus dados ficam guardados permanentemente — mesmo desligando o computador.

| Tipo | Velocidade | Durabilidade | Custo |
|:-----|:-----------|:-------------|:------|
| **HD (Hard Disk)** | Lento (50-150 MB/s) | Mecanico, frágil | Barato |
| **SSD (Solid State Drive)** | Rapido (500-3500 MB/s) | Solido, resistente | Mais caro |

### O que voce precisa saber?

- **Sistema operacional** fica no HD/SSD (e de onde ele "liga").
- **Programas** sao instalados no HD/SSD.
- **Arquivos** (documentos, fotos, scripts) ficam no HD/SSD.

### Relacao com Cybersecurity

Quando voce baixa uma wordlist de senhas (como rockyou.txt), ela fica no HD/SSD. Quando voce salva o resultado de um scan Nmap, e no HD/SSD.

---

## Placa de Rede

### O que e?

A placa de rede e o componente que permite ao computador se comunicar com outros computadores atraves de uma rede (WiFi, cabo de rede, etc).

### Como funciona?

```
Seu computador                    Outro computador
      │                                  │
      │  Placa de Rede                   │  Placa de Rede
      │  IP: 192.168.1.10                │  IP: 192.168.1.20
      │                                  │
      │  ──── Dados viajam pela rede ──► │
      │                                  │
      │  ◄─── Resposta volta ──────────  │
```

### O que voce precisa saber?

- **Endereco MAC:** Identificador unico da placa de rede (como o CPF do dispositivo).
- **Endereco IP:** Endereco logico na rede (como o CEP da sua casa na rede).
- **Interface:** Nome da conexao (eth0, wlan0, etc).

### Relacao com Cybersecurity

Durante reconhecimento, voce vai descobrir IPs, portas e servicos. Tudo isso depende da placa de Rede e dos enderecos IP/MAC.

---

## Sistema Operacional

### O que e?

O sistema operacional (SO) e o programa principal que gerencia todo o hardware e permite que voce use o computador. Sem ele, o hardware e so metal e silicio.

```
┌─────────────────────────────────────┐
│           PROGRAMAS                  │
│  (Navegador, Terminal, Nmap...)     │
├─────────────────────────────────────┤
│       SISTEMA OPERACIONAL           │
│   (Linux, Windows, macOS)           │
├─────────────────────────────────────┤
│           HARDWARE                  │
│   (CPU, RAM, HD, Placa de Rede)    │
└─────────────────────────────────────┘
```

### Principais sistemas operacionais

| SO | Onde e usado | Para seguranca |
|:---|:-------------|:---------------|
| **Linux** | Servidores, cloud, seguranca | Kali Linux — padrao para pentest |
| **Windows** | PCs, corporacoes | Alvo mais comum de ataques |
| **macOS** | Apple | Menos alvo, mas existe |

### Por que voce vai usar Linux?

Porque **todas as ferramentas de seguranca** (Nmap, Metasploit, Burp Suite, Hydra) rodam em Linux. O Kali Linux ja vem com essas ferramentas instaladas.

---

## Programas e Processos

### O que e um programa?

Um programa e um conjunto de instrucoes salvas no HD/SSD. Quando voce "abre" um programa, voce esta carregando essas instrucoes para a RAM e pedindo para a CPU executa-las.

### O que e um processo?

Quando um programa esta **rodando**, ele se torna um **processo**. Um programa e o arquivo parado; um processo e o programa em acao.

```
PROGRAMA (parado no HD)
   Nmap_v7.95.deb
        ↓
   Voce clica "abrir"
        ↓
PROCESSO (rodando na RAM)
   nmap (PID: 1234)
```

### O que voce precisa saber?

- **PID (Process ID):** Numero unico que identifica cada processo rodando.
- **Processos em background:** Rodam sem voce precisar olhar para o terminal.
- **Processos em foreground:** Ocupam o terminal atual.

### Exemplo pratico

No Linux, voce pode ver processos rodando:

```bash
# Ver todos os processos
ps aux

# Ver processos em tempo real
top

# Ver se um processo especifico esta rodando
ps aux | grep nmap
```

### Relacao com Cybersecurity

Quando voce instala e roda o Nmap, ele se torna um processo. Quando voce configura um servidor SSH, o processo `sshd` fica rodando em background, "escutando" por conexoes. Entender processos e essencial para saber **o que esta acontecendo** no sistema.

---

## Servicos (o conceito mais importante para Reconhecimento)

### O que e um servico?

Um servico e um programa que roda em background e fica esperando por algo — uma conexao, uma requisicao, um comando. E como um garcom que fica parado na area esperando alguem pedir comida.

### Analogia

```
┌─────────────────────────────────────────┐
│           RESTAURANTE (Servidor)         │
│                                          │
│  Garcom 1 (servico SSH)                 │
│  └── Fica na porta 22 esperando         │
│      alguem pedir "quero acessar"        │
│                                          │
│  Garcom 2 (servico HTTP)                │
│  └── Fica na porta 80 esperando         │
│      alguem pedir "quero ver o site"     │
│                                          │
│  Garcom 3 (servico DNS)                 │
│  └── Fica na porta 53 esperando         │
│      alguem pedir "qual o IP do site?"   │
│                                          │
└─────────────────────────────────────────┘
```

### Como funciona na pratica?

```
Servico SSH (sshd)
├── Roda em background (voce nao ve)
├── "Escuta" na porta 22
├── Quando alguem conecta na porta 22...
├── O sshd processa a requisicao
└── E concede acesso remoto (se tiver senha/chave)
```

### O que voce precisa saber?

| Termo | O que e |
|:------|:--------|
| **Servico** | Programa que roda em background e espera por algo |
| **Daemon** | Nome tecnico para servico no Linux (geralmente termina em 'd': sshd, httpd, mysqld) |
| **Porta** | "Numero da sala" onde o servico fica esperando |
| **Escutar (listen)** | O servico esta ativo e aceitando conexoes na porta |

### Exemplo completo

```
Servidor web: 192.168.1.50

Servico Apache (httpd)
├── Roda como processo
├── Escuta na porta 80
├── Quando alguem acessa http://192.168.1.50
├── Apache recebe a requisicao HTTP
├── Apache busca o arquivo do site
└── Apache retorna o site para o navegador

Servico SSH (sshd)
├── Roda como processo
├── Escuta na porta 22
├── Quando alguem tenta ssh usuario@192.168.1.50
├── sshd recebe a tentativa de conexao
├── sshd pede senha/chave
└── sshd concede acesso (se autenticado)
```

### Por que isso e CRITICO para Reconhecimento?

Quando voce faz reconhecimento, voce esta descobrindo:
- **Quais servicos estao rodando** no alvo
- **Em quais portas** eles estao escutando
- **Quais versoes** esses servicos estao usando

```
Exemplo de resultado de reconhecimento:

IP: 200.100.50.25
├── Porta 22: Servico SSH (OpenSSH 8.2)
├── Porta 80: Servico HTTP (Apache 2.4.41)
├── Porta 443: Servico HTTPS (Apache 2.4.41)
└── Porta 3306: Servico MySQL (8.0.26)
```

Se voce nao entende o que e um "servico", esse resultado nao faz sentido. Agora faz.

---

## Exercicio Practico

### Exercicio 1: Identificando componentes

Responda:

1. Qual componente e responsavel por "pensar" (processar instrucoes)?
2. Qual componente guarda dados temporariamente enquanto um programa esta rodando?
3. Qual componente guarda dados permanentemente?
4. O que acontece com os dados da RAM quando voce desliga o computador?

<details>
<summary>Respostas</summary>

1. CPU
2. Memoria (RAM)
3. HD ou SSD
4. Sao apagados (RAM e volatil)

</details>

### Exercicio 2: Programa vs Processo

1. Quando voce instala o Nmap no Linux, ele e um programa ou um processo?
2. Quando voce roda `nmap 192.168.1.1`, ele e um programa ou um processo?
3. Quantos processos do Nmap podem rodar ao mesmo tempo?

<details>
<summary>Respostas</summary>

1. Programa (esta parado no HD/SSD)
2. Processo (esta rodando, com PID proprio)
3. Varios — cada `nmap` que voce roda e um processo diferente

</details>

### Exercicio 3: Servicos

Considere um servidor com os seguintes servicos:

```
Servico: sshd (porta 22)
Servico: httpd (porta 80)
Servico: mysqld (porta 3306)
```

Responda:

1. O que e "sshd"?
2. Qual e a porta que o servidor web usa?
3. Se voce quiser acessar o site, qual porta deve conectar?
4. Se voce quiser acessar remotamente, qual porta deve conectar?

<details>
<summary>Respostas</summary>

1. E o servico SSH (daemon SSH) — permite acesso remoto via terminal
2. Porta 80 (httpd = HTTP daemon)
3. Porta 80
4. Porta 22

</details>

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Explicar o que e CPU, RAM, HD/SSD e placa de Rede
- [ ] Diferenciar programa de processo
- [ ] Explicar o que e um servico e um daemon
- [ ] Entender por que servicos "escutam" em portas
- [ ] Conectar esses conceitos com Reconhecimento

---

<div align="center">

**[Proximo: Processos e Servicos no Linux](01-processos-e-servicos.md) ➡️**

</div>
