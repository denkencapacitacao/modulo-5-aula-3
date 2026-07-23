# Etapa 1: restauração, compilação e publicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY ./backend/FullStackPractice.Api.csproj ./
RUN dotnet restore

COPY ./backend ./
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