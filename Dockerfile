# ---------- Build stage ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY ./src/DotNetApp/*.csproj ./DotNetApp/
WORKDIR /src/DotNetApp
RUN dotnet restore

# Copy all and publish
COPY ./src/DotNetApp/. ./
RUN dotnet publish -c Release -o /app/publish

# ---------- Runtime stage ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 80
ENTRYPOINT ["dotnet", "DotNetApp.dll"]
