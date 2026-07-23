# Aula 03 — Roteiro da prática
## Commits semânticos, Git Flow simplificado, Docker e Docker Compose

> **Módulo:** Integração Full Stack  
> **Modalidade:** Remota  
> **Duração sugerida da prática:** 70 a 90 minutos  
> **Projeto utilizado:** `FullStackPractice.Api` — ASP.NET Core 8 com Swagger  
> **Resultado esperado:** API versionada de forma organizada, empacotada em uma imagem Docker e executada por meio de Docker Compose.

---

## 1. Objetivos da prática

Ao concluir a atividade, o aluno deverá ser capaz de:

- Criar e utilizar branches seguindo um Git Flow simplificado.
- Registrar alterações com commits pequenos, coerentes e semânticos.
- Diferenciar as branches `main`, `develop` e `feature/*`.
- Interpretar e criar um `Dockerfile` multi-stage para uma API ASP.NET Core.
- Construir uma imagem Docker.
- Executar e inspecionar um container.
- Acessar a API e o Swagger a partir do container.
- Utilizar Docker Compose para construir, iniciar, consultar logs e encerrar o serviço.
- Integrar a branch de funcionalidade à branch `develop`.

---

## 2. Resultado final esperado

Ao final da prática, o repositório deverá apresentar uma estrutura semelhante a esta:

```text
backend/
├── Properties/
├── .dockerignore
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── FullStackPractice.Api.csproj
├── Program.cs
└── README.md
```

O histórico deverá conter commits claros, por exemplo:

```text
docs: adiciona instruções iniciais da prática
build(docker): adiciona Dockerfile multi-stage da API
build(compose): adiciona orquestração local do backend
docs: documenta execução da API com Docker
```

A aplicação deverá estar disponível em:

```text
API:      http://localhost:8080
Swagger:  http://localhost:8080/swagger
Health:   http://localhost:8080/health
```

---

# 3. Preparação antes da aula

## 3.1. Ferramentas necessárias

Cada aluno deverá ter instalado:

- Git;
- .NET SDK 8;
- Docker Desktop;
- Visual Studio Code ou Visual Studio;
- navegador web;
- terminal PowerShell, Prompt de Comando ou Git Bash.

Verifique as instalações:

```bash
git --version
dotnet --version
docker --version
docker compose version
```

O Docker Desktop deve estar aberto e com o mecanismo Docker em execução.

---

## 3.2. Preparação recomendada pelo docente

Distribua o projeto backend em uma pasta chamada `backend`.

Para que a construção dos arquivos de infraestrutura seja realizada durante a aula, a versão inicial pode ser entregue **sem** estes arquivos:

```text
Dockerfile
.dockerignore
docker-compose.yml
```

Caso o pacote distribuído já contenha esses arquivos, solicite aos alunos que:

1. movam os arquivos para uma pasta temporária; ou
2. apenas acompanhem a criação, comparando o resultado com os arquivos existentes.

O projeto deve conter pelo menos:

```text
backend/
├── Properties/
├── FullStackPractice.Api.csproj
├── Program.cs
└── README.md
```

---

# 4. Organização sugerida da prática

| Etapa | Assunto | Tempo sugerido |
|---|---|---:|
| 1 | Preparação e validação do projeto | 10 min |
| 2 | Git Flow simplificado e commits semânticos | 20 min |
| 3 | Criação do Dockerfile e build da imagem | 20 min |
| 4 | Execução, Swagger, logs e diagnóstico | 15 min |
| 5 | Docker Compose | 15 min |
| 6 | Merge, revisão e fechamento | 10 min |

---

# Parte 1 — Preparação e validação do projeto

## 5. Extrair e abrir o projeto

Abra o terminal no diretório em que o projeto foi extraído:

```bash
cd backend
```

Confira os arquivos:

### PowerShell

```powershell
Get-ChildItem
```

### Git Bash, Linux ou macOS

```bash
ls -la
```

Confirme que existe o arquivo:

```text
FullStackPractice.Api.csproj
```

---

## 6. Executar a API sem Docker

Antes de criar o container, valide se a aplicação funciona localmente:

```bash
dotnet restore
dotnet run
```

A saída deverá indicar que a aplicação está escutando em uma URL local.

Acesse:

```text
http://localhost:8080/swagger
```

Caso a porta exibida pelo terminal seja diferente, utilize a URL apresentada pelo `dotnet run`.

Teste também:

```text
http://localhost:8080/health
```

Resposta esperada:

```json
{
  "status": "healthy",
  "utcTime": "2026-07-15T20:00:00+00:00"
}
```

Interrompa a aplicação:

```text
Ctrl + C
```

### Ponto de verificação 1

Antes de continuar, confirme:

- [ ] O projeto foi restaurado.
- [ ] A API executou sem erros.
- [ ] O Swagger foi aberto no navegador.
- [ ] O endpoint `/health` respondeu corretamente.

---

# Parte 2 — Git Flow simplificado e commits semânticos

## 7. Configurar a identificação do Git

Execute esta etapa somente se o Git ainda não estiver configurado:

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"
```

Verifique:

```bash
git config --global --list
```

---

## 8. Inicializar o repositório

Caso o projeto ainda não seja um repositório Git:

```bash
git init -b main
```

Se a opção `-b` não funcionar:

```bash
git init
git branch -M main
```

Verifique:

```bash
git status
```

---

## 9. Criar o `.gitignore`

Crie um arquivo chamado `.gitignore` na raiz do projeto:

```gitignore
# Compilação .NET
bin/
obj/
publish/

# Visual Studio
.vs/
*.user
*.suo

# Rider / JetBrains
.idea/

# VS Code
.vscode/

# Testes e cobertura
TestResults/
coverage/
*.trx
*.coverage

# Logs
logs/
*.log

# Variáveis e configurações locais
.env
.env.*
!.env.example
appsettings.Local.json
appsettings.Development.local.json

# Sistema operacional
.DS_Store
Thumbs.db
desktop.ini

# Temporários
*.tmp
*.bak
*.swp
```

Confira o estado:

```bash
git status
```

---

## 10. Criar o primeiro commit

Adicione os arquivos:

```bash
git add .
```

Confira o que será incluído:

```bash
git status
```

Crie o commit inicial:

```bash
git commit -m "chore: adiciona estrutura inicial da API"
```

Consulte o histórico:

```bash
git log --oneline
```

### Discussão rápida

Pergunte aos alunos:

- Por que foi utilizado o tipo `chore`?
- Esse commit representa uma mudança única e coerente?
- Uma mensagem como `primeiro commit` seria suficientemente descritiva?

---

## 11. Criar a branch `develop`

Crie a branch de integração:

```bash
git switch -c develop
```

Verifique:

```bash
git branch
```

Saída esperada:

```text
* develop
  main
```

---

## 12. Criar a branch da atividade

A containerização será desenvolvida em uma branch própria:

```bash
git switch -c feature/containerizacao-backend
```

Verifique:

```bash
git branch
```

Saída esperada:

```text
  develop
* feature/containerizacao-backend
  main
```

### Fluxo utilizado na prática

```text
main
  └── develop
        └── feature/containerizacao-backend
```

---

# Parte 3 — Criação do Dockerfile

## 13. Criar o arquivo `.dockerignore`

Crie o arquivo `.dockerignore`:

```dockerignore
**/bin/
**/obj/
.git/
.gitignore
README.md
docker-compose*.yml
```

Esse arquivo evita que conteúdo desnecessário seja enviado para o contexto de build.

---

## 14. Criar o `Dockerfile`

Na raiz do projeto, crie um arquivo chamado `Dockerfile`:

```dockerfile
# Etapa 1: restauração, compilação e publicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY FullStackPractice.Api.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# Etapa 2: execução
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish ./

ENV ASPNETCORE_URLS=http://+:8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "FullStackPractice.Api.dll"]
```

---

## 15. Explicação guiada do Dockerfile

### Etapa de build

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
```

Utiliza o SDK completo, necessário para restaurar dependências e compilar o projeto.

```dockerfile
WORKDIR /src
```

Define o diretório de trabalho dentro da imagem.

```dockerfile
COPY FullStackPractice.Api.csproj ./
RUN dotnet restore
```

Copia primeiro o arquivo do projeto e restaura as dependências. Essa separação favorece o cache de camadas do Docker.

```dockerfile
COPY . ./
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false
```

Copia o restante do código e publica a aplicação.

### Etapa de runtime

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
```

Utiliza apenas o runtime do ASP.NET Core, gerando uma imagem final menor.

```dockerfile
COPY --from=build /app/publish ./
```

Copia somente os arquivos publicados na etapa anterior.

```dockerfile
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
```

Configura e documenta a porta interna utilizada pela aplicação.

```dockerfile
ENTRYPOINT ["dotnet", "FullStackPractice.Api.dll"]
```

Define o processo executado quando o container é iniciado.

---

## 16. Registrar a criação do Dockerfile

Verifique as alterações:

```bash
git status
git diff
```

Adicione os arquivos relacionados ao Docker:

```bash
git add Dockerfile .dockerignore
```

Crie um commit semântico:

```bash
git commit -m "build(docker): adiciona Dockerfile multi-stage da API"
```

Consulte o histórico:

```bash
git log --oneline --decorate
```

### Ponto de verificação 2

- [ ] A branch atual é `feature/containerizacao-backend`.
- [ ] O `Dockerfile` foi criado.
- [ ] O `.dockerignore` foi criado.
- [ ] O commit utiliza o tipo `build`.
- [ ] O commit descreve somente a criação da imagem Docker.

---

# Parte 4 — Build e execução do container

## 17. Construir a imagem

No mesmo diretório do `Dockerfile`, execute:

```bash
docker build -t fullstack-practice-api:1.0 .
```

### Significado do comando

```text
docker build
    -t fullstack-practice-api:1.0
    .
```

- `docker build`: inicia a construção da imagem;
- `-t`: define nome e tag;
- `fullstack-practice-api`: nome da imagem;
- `1.0`: tag;
- `.`: usa o diretório atual como contexto.

Liste as imagens:

```bash
docker images
```

A imagem `fullstack-practice-api` deverá aparecer na lista.

---

## 18. Executar o container

Execute:

```bash
docker run \
  --name fullstack-practice-api \
  -p 8080:8080 \
  fullstack-practice-api:1.0
```

No PowerShell ou Prompt de Comando, utilize em uma linha:

```powershell
docker run --name fullstack-practice-api -p 8080:8080 fullstack-practice-api:1.0
```

### Mapeamento da porta

```text
-p 8080:8080
   │    └── porta interna do container
   └── porta exposta na máquina
```

Acesse:

```text
http://localhost:8080/swagger
```

Teste também:

```text
http://localhost:8080/health
```

Interrompa o processo com:

```text
Ctrl + C
```

O container ficará parado, mas continuará existindo.

---

## 19. Executar em segundo plano

Remova o container parado:

```bash
docker rm fullstack-practice-api
```

Execute novamente em segundo plano:

```bash
docker run -d \
  --name fullstack-practice-api \
  -p 8080:8080 \
  fullstack-practice-api:1.0
```

No PowerShell:

```powershell
docker run -d --name fullstack-practice-api -p 8080:8080 fullstack-practice-api:1.0
```

Liste os containers ativos:

```bash
docker ps
```

Consulte os logs:

```bash
docker logs fullstack-practice-api
```

Acompanhe os logs em tempo real:

```bash
docker logs -f fullstack-practice-api
```

Use `Ctrl + C` para deixar de acompanhar os logs. Isso não encerra o container.

---

## 20. Testar a API pelo Swagger

Abra:

```text
http://localhost:8080/swagger
```

### Teste 1 — Health check

Execute:

```http
GET /health
```

Resposta esperada:

```http
200 OK
```

### Teste 2 — Listagem

Execute:

```http
GET /api/test-results
```

Resposta esperada:

```http
200 OK
```

### Teste 3 — Criação

Execute:

```http
POST /api/test-results
```

Corpo:

```json
{
  "serialNumber": "400T0193A003",
  "station": "TEST_01",
  "status": "PASS"
}
```

Resposta esperada:

```http
201 Created
```

### Teste 4 — Erro de validação

Envie:

```json
{
  "serialNumber": "",
  "station": "TEST_01",
  "status": "PASS"
}
```

Resposta esperada:

```http
400 Bad Request
```

### Teste 5 — Conflito

Envie novamente o mesmo serial e a mesma estação do teste válido.

Resposta esperada:

```http
409 Conflict
```

---

## 21. Parar e remover o container

Pare:

```bash
docker stop fullstack-practice-api
```

Liste todos os containers:

```bash
docker ps -a
```

Remova:

```bash
docker rm fullstack-practice-api
```

### Ponto de verificação 3

- [ ] A imagem foi construída.
- [ ] O container executou na porta 8080.
- [ ] O Swagger foi acessado.
- [ ] Um endpoint retornou sucesso.
- [ ] Um cenário de erro foi validado.
- [ ] Os logs foram consultados.
- [ ] O container foi parado e removido.

---

# Parte 5 — Docker Compose

## 22. Criar o `docker-compose.yml`

Crie o arquivo `docker-compose.yml` na raiz do projeto:

```yaml
services:
  backend:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: fullstack-practice-api
    ports:
      - "8080:8080"
    environment:
      ASPNETCORE_ENVIRONMENT: Development
      ASPNETCORE_URLS: http://+:8080
```

---

## 23. Explicação do arquivo

```yaml
services:
```

Define os serviços que fazem parte da aplicação.

```yaml
backend:
```

Nome lógico do serviço dentro do Compose.

```yaml
build:
  context: .
  dockerfile: Dockerfile
```

Informa que a imagem deverá ser construída usando o diretório atual e o `Dockerfile`.

```yaml
container_name: fullstack-practice-api
```

Define um nome fixo para o container.

```yaml
ports:
  - "8080:8080"
```

Mapeia a porta da máquina para a porta do container.

```yaml
environment:
```

Define variáveis de ambiente utilizadas pela aplicação.

---

## 24. Validar a configuração

Execute:

```bash
docker compose config
```

Esse comando mostra a configuração final interpretada pelo Docker Compose.

Caso existam problemas de indentação ou sintaxe, eles serão apresentados nesse momento.

---

## 25. Registrar o Compose

Verifique:

```bash
git status
git diff
```

Adicione o arquivo:

```bash
git add docker-compose.yml
```

Crie o commit:

```bash
git commit -m "build(compose): adiciona execução local do backend"
```

---

## 26. Iniciar com Docker Compose

Execute:

```bash
docker compose up --build
```

O comando:

1. lê o `docker-compose.yml`;
2. constrói a imagem;
3. cria a rede padrão;
4. cria o container;
5. inicia a aplicação;
6. exibe os logs.

Acesse:

```text
http://localhost:8080/swagger
```

Interrompa com:

```text
Ctrl + C
```

---

## 27. Executar em segundo plano

```bash
docker compose up --build -d
```

Verifique os serviços:

```bash
docker compose ps
```

Consulte os logs:

```bash
docker compose logs
```

Acompanhe somente o backend:

```bash
docker compose logs -f backend
```

Pare e remova os recursos:

```bash
docker compose down
```

Confirme:

```bash
docker compose ps
```

---

## 28. Diferença entre Dockerfile e Docker Compose

| Dockerfile | Docker Compose |
|---|---|
| Define como construir uma imagem | Define como os serviços devem executar |
| Contém instruções como `FROM`, `COPY` e `RUN` | Contém serviços, portas, redes, volumes e variáveis |
| É processado por `docker build` | É processado por `docker compose` |
| Normalmente descreve uma aplicação | Pode coordenar vários containers |

> **Mensagem-chave:** o Dockerfile descreve a imagem; o Docker Compose descreve a execução dos serviços.

---

# Parte 6 — Documentação e conclusão do fluxo Git

## 29. Atualizar o README

Adicione uma seção ao `README.md`:

```markdown
## Executar com Docker Compose

```bash
docker compose up --build
```

Acessos:

- API: http://localhost:8080
- Swagger: http://localhost:8080/swagger
- Health: http://localhost:8080/health

Para encerrar:

```bash
docker compose down
```
```

Verifique a alteração:

```bash
git diff README.md
```

Registre:

```bash
git add README.md
git commit -m "docs: adiciona instruções de execução com Docker"
```

---

## 30. Revisar o histórico da branch

```bash
git log --oneline --graph --decorate --all
```

Histórico esperado:

```text
* docs: adiciona instruções de execução com Docker
* build(compose): adiciona execução local do backend
* build(docker): adiciona Dockerfile multi-stage da API
* chore: adiciona estrutura inicial da API
```

Discuta:

- Cada commit possui uma responsabilidade?
- Seria possível reverter apenas o Docker Compose?
- As mensagens permitem entender a evolução sem abrir os arquivos?
- O histórico está adequado para revisão em Pull Request?

---

## 31. Integrar à branch `develop`

Volte para `develop`:

```bash
git switch develop
```

Faça o merge:

```bash
git merge --no-ff feature/containerizacao-backend
```

Mensagem sugerida, caso o editor seja aberto:

```text
Merge feature/containerizacao-backend into develop
```

Verifique:

```bash
git log --oneline --graph --decorate --all
```

---

## 32. Opcional — Enviar ao GitHub

Crie um repositório vazio no GitHub.

Adicione o remoto:

```bash
git remote add origin <URL_DO_REPOSITORIO>
```

Envie `main`:

```bash
git switch main
git push -u origin main
```

Envie `develop`:

```bash
git switch develop
git push -u origin develop
```

Caso a branch de funcionalidade ainda precise ser revisada antes do merge, envie-a antes de fazer a integração:

```bash
git push -u origin feature/containerizacao-backend
```

No GitHub, abra um Pull Request:

```text
feature/containerizacao-backend → develop
```

---

# 7. Atividade de diagnóstico

## Cenário 1 — Porta ocupada

Erro semelhante a:

```text
Bind for 0.0.0.0:8080 failed: port is already allocated
```

Verifique:

```bash
docker ps
```

Pare o container que utiliza a porta:

```bash
docker stop <nome-ou-id>
```

Alternativamente, altere o mapeamento:

```yaml
ports:
  - "8081:8080"
```

Novo acesso:

```text
http://localhost:8081/swagger
```

---

## Cenário 2 — Nome do container já existe

Erro semelhante a:

```text
The container name "/fullstack-practice-api" is already in use
```

Liste:

```bash
docker ps -a
```

Remova o container antigo:

```bash
docker rm -f fullstack-practice-api
```

---

## Cenário 3 — Docker não está em execução

Erro semelhante a:

```text
Cannot connect to the Docker daemon
```

Solução:

1. abrir o Docker Desktop;
2. aguardar o mecanismo iniciar;
3. executar:

```bash
docker info
```

---

## Cenário 4 — DLL incorreta no `ENTRYPOINT`

Erro semelhante a:

```text
The application 'NomeIncorreto.dll' does not exist
```

Confira o nome do projeto:

```text
FullStackPractice.Api.csproj
```

O `ENTRYPOINT` correto é:

```dockerfile
ENTRYPOINT ["dotnet", "FullStackPractice.Api.dll"]
```

---

## Cenário 5 — Swagger não abre

Verifique:

```bash
docker compose ps
docker compose logs backend
```

Confirme:

- o container está ativo;
- a porta está mapeada;
- a aplicação está escutando em `http://+:8080`;
- a URL utilizada é `http://localhost:8080/swagger`.

---

## Cenário 6 — Alterações não aparecem no container

O container utiliza a versão presente na imagem. Reconstrua:

```bash
docker compose down
docker compose up --build
```

Para forçar o build sem cache:

```bash
docker compose build --no-cache
docker compose up
```

---

# 8. Evidências da atividade

Cada aluno ou grupo deverá registrar:

1. Saída de:

   ```bash
   git log --oneline --graph --decorate --all
   ```

2. Saída de:

   ```bash
   docker images
   ```

3. Saída de:

   ```bash
   docker compose ps
   ```

4. Swagger aberto no navegador.

5. Execução de:

   ```http
   GET /health
   ```

6. Execução válida de:

   ```http
   POST /api/test-results
   ```

7. Um retorno de erro `400` ou `409`.

8. Histórico com commits semânticos.

---

# 9. Critérios de avaliação sugeridos

| Critério | Peso |
|---|---:|
| Uso correto das branches | 15% |
| Commits pequenos e semanticamente adequados | 20% |
| Dockerfile válido e organizado | 20% |
| Imagem construída e container executado | 15% |
| Swagger e endpoints validados | 10% |
| Docker Compose funcional | 15% |
| README e evidências | 5% |

---

# 10. Desafio opcional

## Adicionar restart policy e healthcheck

Altere o `docker-compose.yml`:

```yaml
services:
  backend:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: fullstack-practice-api
    ports:
      - "8080:8080"
    environment:
      ASPNETCORE_ENVIRONMENT: Development
      ASPNETCORE_URLS: http://+:8080
    restart: unless-stopped
    healthcheck:
      test:
        [
          "CMD",
          "wget",
          "--no-verbose",
          "--tries=1",
          "--spider",
          "http://localhost:8080/health"
        ]
      interval: 10s
      timeout: 3s
      retries: 3
      start_period: 10s
```

> Dependendo da imagem utilizada, o comando `wget` pode não estar disponível. Nesse caso, o healthcheck deve ser adaptado ou uma ferramenta de consulta deve ser instalada na imagem. Este desafio é voltado à discussão sobre observabilidade e confiabilidade, não sendo obrigatório para a prática principal.

Commit sugerido:

```bash
git add docker-compose.yml
git commit -m "build(compose): adiciona política de reinício e healthcheck"
```

---

# 11. Limpeza do ambiente

Ao final da aula:

```bash
docker compose down
```

Para remover a imagem criada:

```bash
docker rmi fullstack-practice-api:1.0
```

Para remover imagens não utilizadas:

```bash
docker image prune
```

Use comandos de limpeza com cuidado, especialmente em máquinas que possuam outros projetos Docker.

---

# 12. Resumo de comandos

## Git

```bash
git init -b main
git add .
git commit -m "chore: adiciona estrutura inicial da API"

git switch -c develop
git switch -c feature/containerizacao-backend

git add Dockerfile .dockerignore
git commit -m "build(docker): adiciona Dockerfile multi-stage da API"

git add docker-compose.yml
git commit -m "build(compose): adiciona execução local do backend"

git add README.md
git commit -m "docs: adiciona instruções de execução com Docker"

git switch develop
git merge --no-ff feature/containerizacao-backend

git log --oneline --graph --decorate --all
```

## Docker

```bash
docker build -t fullstack-practice-api:1.0 .
docker images

docker run -d \
  --name fullstack-practice-api \
  -p 8080:8080 \
  fullstack-practice-api:1.0

docker ps
docker logs fullstack-practice-api
docker stop fullstack-practice-api
docker rm fullstack-practice-api
```

## Docker Compose

```bash
docker compose config
docker compose up --build
docker compose up --build -d
docker compose ps
docker compose logs -f backend
docker compose down
```

---

# 13. Encerramento sugerido pelo docente

> Nesta prática, organizamos a evolução do código por meio de branches e commits semânticos e, em seguida, padronizamos a execução da aplicação usando Docker. O Git registra como o projeto evoluiu. O Dockerfile descreve como a imagem é construída. O Docker Compose descreve como o serviço é executado. Esses recursos serão fundamentais nas próximas aulas, quando diferentes componentes da aplicação full stack precisarão funcionar de forma integrada e reproduzível.
