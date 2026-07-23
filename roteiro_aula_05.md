# Aula 05 — Prática de CI/CD com GitHub Actions

> **Módulo:** Integração Full Stack  
> **Duração total:** 2 horas  
> **Intervalo:** 20 minutos  
> **Tempo efetivo:** 1 hora e 40 minutos  
> **Projeto:** `FullStackPractice.Api`  
> **Tecnologia:** ASP.NET Core 8  
> **Objetivo:** criar, executar, analisar, quebrar e corrigir uma pipeline de integração contínua no GitHub Actions.

---

## 1. Resultado esperado

Ao final da prática, o repositório deverá conter:

```text
.github/
└── workflows/
    └── ci.yml

backend/
├── FullStackPractice.Api.csproj
├── Dockerfile
├── docker-compose.yml
└── demais arquivos da API
```

Na aba **Actions** do GitHub, deverá existir uma execução bem-sucedida com o job:

```text
Validar backend
```

Fluxo da atividade:

```text
Alteração no código
        ↓
Commit
        ↓
Push ou Pull Request
        ↓
GitHub Actions
        ↓
Restore
        ↓
Build
        ↓
Sucesso ou falha
        ↓
Análise dos logs
        ↓
Correção
```

---

## 2. Objetivos

Ao concluir a atividade, o aluno deverá ser capaz de:

- Compreender o objetivo básico de uma pipeline de CI/CD.
- Identificar a diferença entre CI, entrega contínua e deploy contínuo.
- Criar um workflow do GitHub Actions.
- Configurar eventos de `push`, `pull_request` e execução manual.
- Configurar o SDK .NET 8 em um runner.
- Restaurar e compilar uma API automaticamente.
- Acompanhar a execução de uma pipeline.
- Identificar o job e a etapa responsáveis por uma falha.
- Interpretar os logs do GitHub Actions.
- Corrigir o problema e executar novamente a pipeline.
- Registrar a evolução com commits semânticos.

---

## 3. Cronograma

| Período | Atividade | Duração |
|---|---|---:|
| 00:00–00:10 | Introdução e retomada do fluxo manual | 10 min |
| 00:10–00:20 | Conceitos essenciais de CI/CD | 10 min |
| 00:20–00:45 | Criação guiada do workflow | 25 min |
| 00:45–00:50 | Commit e push inicial | 5 min |
| 00:50–01:10 | Intervalo | 20 min |
| 01:10–01:25 | Análise da primeira execução | 15 min |
| 01:25–01:40 | Simulação de falha | 15 min |
| 01:40–01:55 | Correção e nova execução | 15 min |
| 01:55–02:00 | Evidências e encerramento | 5 min |

---

# Parte 1 — Preparação

## 4. Ferramentas necessárias

Cada participante deverá ter:

- Git instalado;
- .NET SDK 8;
- acesso ao GitHub;
- acesso de escrita ao repositório da equipe;
- Visual Studio Code ou Visual Studio;
- navegador;
- terminal.

Verifique:

```bash
git --version
dotnet --version
```

A versão do .NET deverá ser compatível com:

```text
8.0.x
```

---

## 5. Estrutura esperada

O workflow considera a seguinte estrutura:

```text
raiz-do-repositorio/
├── .github/
├── backend/
│   ├── FullStackPractice.Api.csproj
│   ├── Program.cs
│   └── demais arquivos
├── .gitignore
└── README.md
```

Confirme que existe:

```text
backend/FullStackPractice.Api.csproj
```

### PowerShell

```powershell
Test-Path backend/FullStackPractice.Api.csproj
```

### Git Bash, Linux ou macOS

```bash
test -f backend/FullStackPractice.Api.csproj && echo "Arquivo encontrado"
```

Caso o projeto esteja em outro diretório, ajuste o caminho utilizado no workflow.

---

# Parte 2 — Retomada do processo manual

## 6. Validar manualmente

Antes da pipeline, a API pode ser validada com:

```bash
dotnet restore backend/FullStackPractice.Api.csproj
```

```bash
dotnet build backend/FullStackPractice.Api.csproj   --configuration Release   --no-restore
```

No PowerShell:

```powershell
dotnet restore backend/FullStackPractice.Api.csproj
dotnet build backend/FullStackPractice.Api.csproj --configuration Release --no-restore
```

### Pergunta para discussão

> O que pode acontecer se um integrante enviar código sem executar o build localmente?

Possíveis respostas:

- erros de compilação podem chegar ao repositório;
- o problema pode ser identificado somente por outro integrante;
- um Pull Request pode conter código inválido;
- a equipe pode perder tempo repetindo verificações;
- pessoas diferentes podem executar procedimentos diferentes.

> A pipeline automatiza uma sequência de verificações e produz um resultado reproduzível para cada alteração enviada ao repositório.

---

# Parte 3 — Conceitos essenciais

## 7. Integração contínua — CI

A integração contínua executa verificações automáticas quando o código é alterado.

Nesta prática:

```text
Checkout do repositório
        ↓
Configuração do .NET 8
        ↓
Restauração das dependências
        ↓
Compilação em Release
```

## 8. Entrega contínua

Mantém o projeto validado e preparado para uma futura implantação.

Nesta aula, não será realizada publicação em um servidor real.

## 9. Deploy contínuo

Publica automaticamente uma versão validada em um ambiente persistente.

Exemplos:

- servidor Linux;
- ambiente de homologação;
- serviço em nuvem;
- cluster de containers.

Escopo da aula:

```text
CI prática + CD conceitual
```

## 10. Elementos do GitHub Actions

| Elemento | Função |
|---|---|
| Workflow | Processo automatizado completo |
| Event | Define quando o workflow é executado |
| Job | Conjunto de etapas |
| Runner | Máquina temporária que executa o job |
| Step | Etapa individual |
| Action | Componente reutilizável |

```text
Workflow
└── Job
    ├── Runner
    ├── Step
    ├── Step
    └── Step
```

---

# Parte 4 — Preparar o repositório

## 11. Atualizar a branch local

```bash
git switch develop
git pull origin develop
```

Caso a equipe trabalhe diretamente na `main`:

```bash
git switch main
git pull origin main
```

Utilize a branch definida pelo professor ou pela equipe.

## 12. Criar a branch da atividade

```bash
git switch -c feature/ci-github-actions
```

Verifique:

```bash
git branch
```

Saída esperada:

```text
  develop
* feature/ci-github-actions
  main
```

## 13. Validar o projeto localmente

```bash
dotnet restore backend/FullStackPractice.Api.csproj
```

```bash
dotnet build backend/FullStackPractice.Api.csproj   --configuration Release   --no-restore
```

Resultado esperado:

```text
Build succeeded.
```

### Ponto de verificação 1

- [ ] A branch da atividade foi criada.
- [ ] O arquivo `.csproj` foi encontrado.
- [ ] O restore foi concluído.
- [ ] O build local foi concluído.
- [ ] Não existem alterações inesperadas.

---

# Parte 5 — Criar o workflow

## 14. Criar a estrutura

Na raiz do repositório:

```text
.github/workflows/ci.yml
```

### PowerShell

```powershell
New-Item -ItemType Directory -Force .github/workflows
New-Item -ItemType File -Force .github/workflows/ci.yml
```

### Git Bash, Linux ou macOS

```bash
mkdir -p .github/workflows
touch .github/workflows/ci.yml
```

## 15. Adicionar o workflow

Abra `.github/workflows/ci.yml` e adicione:

```yaml
name: CI FullStackPractice API

on:
  push:
    branches:
      - main
      - develop

  pull_request:
    branches:
      - main
      - develop

  workflow_dispatch:

permissions:
  contents: read

jobs:
  backend:
    name: Validar backend
    runs-on: ubuntu-latest

    steps:
      - name: Obter código-fonte
        uses: actions/checkout@v4

      - name: Configurar .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: "8.0.x"

      - name: Restaurar dependências
        run: >
          dotnet restore
          backend/FullStackPractice.Api.csproj

      - name: Compilar backend
        run: >
          dotnet build
          backend/FullStackPractice.Api.csproj
          --configuration Release
          --no-restore
```

---

# Parte 6 — Entender o workflow

## 16. Nome

```yaml
name: CI FullStackPractice API
```

É o nome exibido na aba **Actions**.

## 17. Eventos

```yaml
on:
  push:
    branches:
      - main
      - develop
```

Executa em push direto para `main` ou `develop`.

```yaml
pull_request:
  branches:
    - main
    - develop
```

Executa quando um Pull Request tem `main` ou `develop` como destino.

```yaml
workflow_dispatch:
```

Permite execução manual pela interface do GitHub.

### Atenção

Um push para:

```text
feature/ci-github-actions
```

não executará o workflow pela regra de `push`, pois essa branch não está listada.

Para executar a pipeline da feature, abra um Pull Request para `develop`.

## 18. Permissão

```yaml
permissions:
  contents: read
```

Permite que o workflow leia o repositório.

## 19. Job e runner

```yaml
jobs:
  backend:
    name: Validar backend
    runs-on: ubuntu-latest
```

- `backend`: identificador do job;
- `name`: nome apresentado;
- `runs-on`: sistema operacional do runner.

## 20. Checkout

```yaml
- name: Obter código-fonte
  uses: actions/checkout@v4
```

Disponibiliza o conteúdo do repositório no runner.

## 21. Configuração do .NET

```yaml
- name: Configurar .NET
  uses: actions/setup-dotnet@v4
  with:
    dotnet-version: "8.0.x"
```

Prepara o SDK .NET 8.

## 22. Restore

```yaml
- name: Restaurar dependências
  run: >
    dotnet restore
    backend/FullStackPractice.Api.csproj
```

Obtém as dependências NuGet.

O símbolo `>` permite dividir um comando em várias linhas.

## 23. Build

```yaml
- name: Compilar backend
  run: >
    dotnet build
    backend/FullStackPractice.Api.csproj
    --configuration Release
    --no-restore
```

- `--configuration Release`: compila em modo de entrega;
- `--no-restore`: reutiliza o restore anterior.

---

# Parte 7 — Registrar e executar

## 24. Verificar a alteração

```bash
git status
git diff -- .github/workflows/ci.yml
```

## 25. Criar o commit

```bash
git add .github/workflows/ci.yml
git commit -m "ci: adiciona pipeline de validação da API"
```

Verifique:

```bash
git log --oneline --decorate -5
```

## 26. Enviar a branch

```bash
git push -u origin feature/ci-github-actions
```

## 27. Abrir o Pull Request

No GitHub:

1. Abra o repositório.
2. Clique em **Compare & pull request**.
3. Configure:

```text
base: develop
compare: feature/ci-github-actions
```

4. Use o título:

```text
ci: adiciona validação automática da API
```

5. Crie o Pull Request.

Como o destino é `develop`, o evento `pull_request` deverá iniciar a pipeline.

---

# Intervalo — 20 minutos

Durante o intervalo, aguarde a execução.

Não faça o merge antes de analisar os resultados.

---

# Parte 8 — Analisar a primeira execução

## 28. Abrir a aba Actions

1. Abra o repositório.
2. Clique em **Actions**.
3. Selecione **CI FullStackPractice API**.
4. Abra a execução mais recente.
5. Abra o job **Validar backend**.

Resultado esperado:

```text
✓ Obter código-fonte
✓ Configurar .NET
✓ Restaurar dependências
✓ Compilar backend
```

## 29. Ler os logs

Identifique:

- comando executado;
- versão do .NET;
- caminho do projeto;
- dependências restauradas;
- resultado do build;
- tempo de execução;
- código de saída.

### Perguntas

- Qual evento iniciou a execução?
- Qual é a branch de destino?
- Qual runner foi utilizado?
- Por que o checkout é necessário?
- O que aconteceria se o caminho do `.csproj` estivesse incorreto?
- O Pull Request deveria ser integrado com a pipeline falhando?

### Ponto de verificação 2

- [ ] O Pull Request foi criado.
- [ ] O workflow foi iniciado.
- [ ] O job foi localizado.
- [ ] Os steps foram analisados.
- [ ] A compilação terminou com sucesso.

---

# Parte 9 — Simular uma falha

## 30. Criar um erro de compilação

Abra `Program.cs` ou outro arquivo C# do projeto.

Adicione temporariamente:

```csharp
int quantidade = "valor inválido";
```

Essa linha tenta armazenar uma string em uma variável inteira.

> Não faça essa alteração diretamente em `main` ou `develop`.

## 31. Validação local opcional

```bash
dotnet build backend/FullStackPractice.Api.csproj   --configuration Release
```

Resultado esperado:

```text
Build FAILED.
```

Esta etapa pode ser omitida para demonstrar que a pipeline identifica o problema.

## 32. Registrar a falha

```bash
git add backend
git commit -m "test: simula falha de compilação na pipeline"
git push
```

Como o Pull Request já está aberto, o push iniciará outra execução.

## 33. Analisar a falha

Resultado esperado:

```text
✓ Obter código-fonte
✓ Configurar .NET
✓ Restaurar dependências
✗ Compilar backend
```

Localize:

- job que falhou;
- step que falhou;
- arquivo;
- linha;
- código do erro;
- mensagem do compilador;
- comando executado;
- código de saída.

Exemplo:

```text
Cannot implicitly convert type 'string' to 'int'
```

> A pipeline não serve apenas para mostrar sucesso ou falha. Os logs devem permitir localizar e compreender o problema.

---

# Parte 10 — Corrigir a falha

## 34. Remover o erro

Remova:

```csharp
int quantidade = "valor inválido";
```

## 35. Validar localmente

```bash
dotnet build backend/FullStackPractice.Api.csproj   --configuration Release
```

Resultado esperado:

```text
Build succeeded.
```

## 36. Registrar a correção

```bash
git add backend
git commit -m "fix: corrige erro de compilação identificado pela CI"
git push
```

## 37. Confirmar a execução

Resultado esperado:

```text
✓ Obter código-fonte
✓ Configurar .NET
✓ Restaurar dependências
✓ Compilar backend
```

No Pull Request:

```text
All checks have passed
```

### Ponto de verificação 3

- [ ] Uma falha foi enviada.
- [ ] O erro foi localizado nos logs.
- [ ] O código foi corrigido.
- [ ] Um commit de correção foi criado.
- [ ] A pipeline voltou a executar com sucesso.

---

# Parte 11 — Execução manual

## 38. Utilizar `workflow_dispatch`

Após o workflow existir no GitHub:

1. Abra **Actions**.
2. Selecione **CI FullStackPractice API**.
3. Clique em **Run workflow**.
4. Escolha a branch.
5. Clique em **Run workflow**.

> A execução manual permite validar novamente uma versão sem criar um commit vazio.

---

# Parte 12 — Extensão opcional: Docker Compose

Realize somente se houver tempo.

Adicione um segundo job:

```yaml
  docker:
    name: Validar Docker Compose
    runs-on: ubuntu-latest
    needs:
      - backend

    steps:
      - name: Obter código-fonte
        uses: actions/checkout@v4

      - name: Validar configuração
        working-directory: backend
        run: docker compose config
```

Fluxo:

```text
Validar backend
        ↓
Validar Docker Compose
```

Registre:

```bash
git add .github/workflows/ci.yml
git commit -m "ci: adiciona validação do Docker Compose"
git push
```

Nesta aula, o objetivo opcional é apenas validar a configuração. Não é obrigatório subir os containers no runner.

---

# Parte 13 — Integração do Pull Request

## 39. Revisar antes do merge

Confirme:

- pipeline aprovada;
- arquivos corretos;
- commits coerentes;
- ausência do código inválido;
- Pull Request para a branch correta.

Histórico esperado:

```text
fix: corrige erro de compilação identificado pela CI
test: simula falha de compilação na pipeline
ci: adiciona pipeline de validação da API
```

## 40. Realizar o merge

O responsável pelo repositório deverá fazer o merge somente após a aprovação da pipeline.

Depois:

```bash
git switch develop
git pull origin develop
```

Remova a branch local:

```bash
git branch -d feature/ci-github-actions
```

---

# Parte 14 — Evidências

Cada aluno ou grupo deverá registrar:

1. Arquivo `.github/workflows/ci.yml`.
2. Print da primeira pipeline aprovada.
3. Print da pipeline com falha.
4. Trecho do log com arquivo, linha e erro.
5. Print da pipeline aprovada após a correção.
6. Histórico:

   ```bash
   git log --oneline --graph --decorate --all
   ```

7. Pull Request com os checks aprovados.

Checklist:

```text
[ ] Workflow criado
[ ] Pull Request criado
[ ] Primeira pipeline executada
[ ] Falha simulada
[ ] Logs analisados
[ ] Correção registrada
[ ] Pipeline final aprovada
[ ] Evidências salvas
```

---

# Parte 15 — Diagnóstico de problemas

## Workflow não executou após o push

Verifique:

```bash
git branch --show-current
```

O push está configurado somente para:

```text
main
develop
```

Para `feature/*`, abra um Pull Request para `develop`.

## Arquivo não aparece na aba Actions

O caminho correto é:

```text
.github/workflows/ci.yml
```

Erros comuns:

```text
.github/workflow/ci.yml
.github/ci.yml
github/workflows/ci.yml
```

## Caminho do projeto incorreto

Erro possível:

```text
MSBUILD : error MSB1009: Project file does not exist.
```

PowerShell:

```powershell
Get-ChildItem -Recurse -Filter FullStackPractice.Api.csproj
```

Git Bash:

```bash
find . -name "FullStackPractice.Api.csproj"
```

Ajuste o workflow conforme a estrutura real.

## Erro de YAML

Verifique:

- indentação;
- ausência de tabulação;
- itens iniciados por `-`;
- propriedades no nível correto;
- uso correto de dois pontos.

## Pipeline continua falhando após a correção

Verifique:

```bash
git status
git log -1 --oneline
git status -sb
```

Confirme se o commit foi enviado.

---

# Parte 16 — Resumo de comandos

## Branch

```bash
git switch develop
git pull origin develop
git switch -c feature/ci-github-actions
```

## Build local

```bash
dotnet restore backend/FullStackPractice.Api.csproj

dotnet build backend/FullStackPractice.Api.csproj   --configuration Release   --no-restore
```

## Workflow

```bash
git add .github/workflows/ci.yml
git commit -m "ci: adiciona pipeline de validação da API"
git push -u origin feature/ci-github-actions
```

## Falha

```bash
git add backend
git commit -m "test: simula falha de compilação na pipeline"
git push
```

## Correção

```bash
git add backend
git commit -m "fix: corrige erro de compilação identificado pela CI"
git push
```

## Histórico

```bash
git log --oneline --graph --decorate --all
```

---

# Parte 17 — Orientações para o professor

## Antes da aula

- Confirme que o workflow funciona no repositório de demonstração.
- Confirme o caminho `backend/FullStackPractice.Api.csproj`.
- Deixe a branch `develop` disponível.
- Teste o erro de compilação.
- Abra previamente a aba Actions.
- Garanta que o GitHub esteja acessível.
- Tenha prints de uma execução aprovada e de uma execução com falha.

## Durante a prática

- Construa o arquivo gradualmente.
- Não cole o workflow sem explicar sua estrutura.
- Relacione os comandos locais aos steps.
- Aguarde a execução real.
- Abra os logs mesmo em caso de sucesso.
- Não faça o merge antes de simular e corrigir a falha.
- Priorize o diagnóstico em vez de adicionar muitos jobs.

## Caso o tempo esteja acabando

Priorize:

1. criação do workflow;
2. Pull Request;
3. primeira execução;
4. simulação de falha;
5. análise dos logs;
6. correção;
7. pipeline final aprovada.

Deixe como opcional:

- validação do Docker Compose;
- execução manual;
- merge final;
- remoção de branches;
- atualização do README.

---

# Parte 18 — Encerramento

> Nesta prática, transformamos a validação manual da API em um processo automatizado. Cada alteração enviada ao repositório pode agora ser restaurada e compilada em um ambiente temporário do GitHub Actions. Também provocamos uma falha, identificamos o problema pelos logs e confirmamos a correção em uma nova execução.

```text
Código
  ↓
Commit
  ↓
Push ou Pull Request
  ↓
GitHub Actions
  ↓
Restore
  ↓
Build
  ↓
Sucesso ou falha
  ↓
Correção
  ↓
Pipeline aprovada
```

> Uma pipeline não substitui o desenvolvedor. Ela automatiza verificações repetitivas e fornece evidências para decisões mais seguras antes do merge.
