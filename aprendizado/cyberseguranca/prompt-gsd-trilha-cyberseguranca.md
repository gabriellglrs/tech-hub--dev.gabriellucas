# [GSD] Reestruturar e completar a trilha de aprendizado de Cybersegurança

## Contexto

Repositório: `gabriellglrs/tech-hub--dev.gabriellucas`
Pasta de trabalho: `aprendizado/cyberseguranca/`

Essa pasta já existe e está bem avançada — não é um projeto do zero. Estrutura atual:

```
cyberseguranca/
├── README.md                  # guia principal da trilha
├── ROADMAP.md                 # planejamento antigo — desatualizado (módulos e nomes não batem mais com a pasta real)
├── GLOSSARIO.md
├── INSTALACAO.md
├── CHEATSHEET-*.md (3 arquivos)
├── 00-pre-requisitos/         # redes, sistemas, segurança básica, ferramentas
├── 01-reconhecimento/
├── 02-web-aplicacoes/
├── 03-exploracao/
├── 04-pos-exploracao/
├── 05-reversing/
├── 06-analise-rede/
├── 07-defesa/
├── 08-resposta/
├── 09-ambientes/
├── 10-governanca/
└── 11-ia-cyberseguranca/
```

Cada módulo (1 a 11) segue o mesmo padrão: `README.md` (navegação) + 2-3 arquivos de conteúdo + `LABS.md` (exercícios práticos com links para TryHackMe/HackTheBox/PortSwigger/etc).

**Antes de qualquer edição**, leia o `README.md` raiz da pasta e o `ROADMAP.md` — o `ROADMAP.md` descreve uma numeração de módulos diferente da que existe hoje (ex: ele fala em `02-analise-rede/` e `03-web-aplicacoes/`, mas a pasta real tem `02-web-aplicacoes/` e `06-analise-rede/`). Isso é sinal de que o roadmap ficou desatualizado depois de uma reorganização — precisa ser corrigido ou descartado, não seguido cegamente.

## Objetivo

Transformar essa pasta em um **curso completo em Markdown**, capaz de pegar uma pessoa **leiga total em cybersegurança** e levá-la, módulo por módulo, até o nível avançado — terminando capaz de **aplicar o conhecimento na prática**, não só de ter lido sobre o assunto.

Isso significa que cada módulo precisa, ao final da leitura, deixar a pessoa apta a:
1. Explicar o conceito com as próprias palavras (teoria mínima, sem jargão não explicado).
2. Executar o procedimento em um ambiente de prática real (lab guiado, passo a passo).
3. Validar que aprendeu (checklist, desafio, ou pergunta de verificação).

**Requisito não-negociável: nada de teoria sem o "como fazer".** Para cada ferramenta ou técnica ensinada, o arquivo tem que trazer:
- O **nome da ferramenta** e o comando de **instalação** (ex: `apt install nmap`, `pip install ...`).
- O **comando exato** a ser executado, com todas as flags usadas explicadas (não só `nmap -sV alvo`, mas o que `-sV` faz e por que usar).
- O **output esperado** (print/trecho de saída real ou simulado) para a pessoa comparar com o que ela rodou.
- Se existe alternativa/variação do comando para casos diferentes, mostrar também.
- Uma pessoa leiga tem que conseguir copiar e colar o comando e chegar no resultado — sem "imaginar" o que fazer entre uma frase teórica e outra.
- Todos os comandos são para **Kali Linux** (o sistema operacional oficial da trilha) — nada de instruções genéricas "para Linux" que podem não bater com o que existe no Kali.

Isso vale tanto para o conteúdo (`01-...md`, `02-...md`) quanto para os `LABS.md` — o lab não pode assumir que a pessoa já sabe montar o comando sozinha a partir da teoria.

## O que eu preciso que você faça (fase de planejamento — GSD)

Não escreva conteúdo ainda. Primeiro, produza um **plano de ação** cobrindo os passos abaixo. Cada passo do plano deve ter: o que será feito, em quais arquivos, e como será validado.

### 1. Auditoria do que já existe
- Leia todos os arquivos de `cyberseguranca/` (README raiz, ROADMAP, GLOSSARIO, INSTALACAO, cheatsheets, e os 12 módulos completos: READMEs + conteúdo + LABS.md).
- Confirme se o `00-pre-requisitos/` já orienta a pessoa a instalar e configurar o Kali Linux (VM, dual boot, ou WSL) como ambiente de prática. Se não deixa isso explícito logo no início, essa é uma lacuna prioritária — sem isso, nenhum comando dos módulos seguintes funciona para quem está começando do zero.
- Para cada módulo, avalie:
  - **Progressão didática**: o módulo realmente parte do básico e evolui, ou assume conhecimento que ainda não foi ensinado?
  - **Correção técnica**: comandos, sintaxes, nomes de ferramentas e links estão certos e atualizados?
  - **Comando completo**: cada ferramenta citada tem comando de instalação + comando de uso com flags explicadas + output esperado? Ou fica só na explicação conceitual da ferramenta?
  - **Prática**: o `LABS.md` tem exercícios reais e verificáveis, ou é só teoria disfarçada de lab?
  - **Consistência**: formatação, tom e nível de profundidade batem com os outros módulos?
- Gere uma tabela de auditoria (módulo | nota geral | principais problemas | prioridade de correção).

### 2. Corrigir a divergência entre ROADMAP.md e a estrutura real
- Decida: atualizar o `ROADMAP.md` para refletir a estrutura atual (12 módulos, 0-11) ou removê-lo se o `README.md` já cumpre esse papel.
- Documente a decisão tomada.

### 3. Pesquisa externa para validar e enriquecer a trilha
- Pesquise se a ordem dos módulos e os tópicos cobertos ainda refletem o que a indústria e certificações (OSCP, CEH, Security+, CRTP) e trilhas de referência (TryHackMe, HackTheBox Academy, PortSwigger Web Security Academy) consideram essencial hoje.
- Para cada módulo, levante especificamente na TryHackMe (https://tryhackme.com) — e complementarmente HackTheBox Academy, PortSwigger, OverTheWire, PicoCTF — quais salas/labs gratuitos ou de baixo custo mapeiam diretamente para o conteúdo do módulo, e liste os que ainda não estão referenciados nos `LABS.md` atuais.
- Para cada tarefa/técnica do módulo, pesquise e valide qual é a **melhor ferramenta atual** para aquilo — não assuma que a ferramenta já citada no texto é a mais usada/atualizada hoje. Se a pesquisa mostrar uma ferramenta melhor, mais mantida ou mais usada pelo mercado, ela substitui ou complementa a atual (documentar a troca e o motivo).
- Aponte lacunas de conteúdo (tópicos que a trilha deveria ter e não tem) e conteúdo desatualizado (ferramentas descontinuadas, técnicas obsoletas).

### 4. Plano de melhoria por módulo
Para cada um dos 12 módulos, definir:
- O que mantém como está.
- O que precisa ser reescrito (e por quê — didática, correção técnica, ou prática insuficiente).
- Quais labs/salas novos entram no `LABS.md`.
- Se falta algum arquivo de conteúdo para fechar a progressão do módulo.

### 5. Definir os critérios de qualidade que todo módulo deve atender
Proponha (e deixe explícito no plano) um padrão mínimo por módulo, por exemplo:
- Introdução em linguagem simples, sem pressupor conhecimento não ensinado antes.
- Todo termo técnico novo aparece no `GLOSSARIO.md`.
- Pelo menos 1 lab prático guiado, com passo a passo verificável e link para plataforma gratuita.
- Um checklist ou pergunta de autoavaliação no fim.
- Toda ferramenta citada vem com: comando de instalação, comando de uso completo (flags explicadas), e output esperado mostrado — comando "solto" sem explicação de flag ou sem output não passa no critério.

### 6. Ordem de execução recomendada
- Priorize por: (a) módulos com maior desvio didático (assumem conhecimento não ensinado), (b) módulos que são pré-requisito de outros, (c) módulos com correções técnicas simples.
- Entregue essa priorização como uma lista sequencial de trabalho.

## Restrições e observações

- **Sistema operacional único e fixo: Kali Linux.** Todo comando, instalação e ambiente de prática ensinado na trilha assume que a pessoa está rodando Kali Linux (não Ubuntu genérico, não Windows, não macOS). Se uma ferramenta já vem pré-instalada no Kali, isso deve ser dito explicitamente (evita ensinar `apt install` de algo que já está lá). Se não vem, o comando de instalação tem que ser o correto para Kali (`apt`, `pipx`, `go install`, etc — o que for padrão no Kali).
- Trabalhar **somente** dentro de `aprendizado/cyberseguranca/`.
- Manter o padrão de nomenclatura e estrutura já em uso (README.md por módulo + arquivos numerados + LABS.md), a menos que a auditoria justifique mudar.
- Priorizar plataformas de prática **gratuitas** (TryHackMe free rooms, HackTheBox free labs, PortSwigger Academy, OverTheWire, PicoCTF) — o público-alvo é iniciante e não deve precisar pagar para praticar o essencial.
- O objetivo final do leitor não é "saber sobre" cybersegurança, é **saber fazer** — todo módulo tem que terminar em prática aplicada, não em leitura passiva.

## Entregável desta fase

Um plano de ação (pode ser um novo arquivo, ex. `PLANO-MELHORIA.md`, ou o `ROADMAP.md` reescrito) contendo:
1. Tabela de auditoria dos 12 módulos.
2. Decisão sobre o `ROADMAP.md`.
3. Lista de labs/recursos novos encontrados por módulo (com links).
4. Lista de melhorias por módulo.
5. Ordem de execução priorizada.

Só depois de eu aprovar esse plano, seguimos para a execução (reescrever/criar os `.md`).
