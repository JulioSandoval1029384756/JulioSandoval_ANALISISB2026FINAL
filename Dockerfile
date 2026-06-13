# 1. Etapa de compilación (SDK de .NET 8)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copiar archivos de solución y proyectos
COPY *.sln ./
COPY NetGuardApp/*.csproj ./NetGuardApp/
COPY NetGuardTests/*.csproj ./NetGuardTests/
RUN dotnet restore

# Copiar todo el código y publicar la aplicación
COPY . ./
RUN dotnet publish -c Release -o out

# 2. Etapa de ejecución (Runtime de .NET 8)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Forzar a la app a usar el puerto de Render
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

ENTRYPOINT ["dotnet", "NetGuardApp.dll"]