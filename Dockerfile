# 1. Etapa de compilación (SDK de .NET)
FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build-env
WORKDIR /app

# Copiar solo el proyecto de la API y restaurar
COPY NetGuardApp/*.csproj ./NetGuardApp/
RUN dotnet restore ./NetGuardApp/NetGuardApp.csproj

# Copiar el resto del código y compilar la API
COPY . ./
RUN dotnet publish ./NetGuardApp/NetGuardApp.csproj -c Release -o out

# 2. Etapa de ejecución (Runtime de .NET)
FROM mcr.microsoft.com/dotnet/aspnet:10.0-preview
WORKDIR /app
COPY --from=build-env /app/out .

# Configurar puerto dinámico para Render
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

ENTRYPOINT ["dotnet", "NetGuardApp.dll"]