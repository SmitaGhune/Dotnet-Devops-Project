# ----------- Build Stage -----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ./src/DotNetApp/DotNetApp.csproj ./DotNetApp/
WORKDIR /src/DotNetApp
RUN dotnet restore

# Copy the rest of the source code and publish
COPY ./src/DotNetApp/. ./
RUN dotnet publish -c Release -o /app/publish

# ----------- Runtime Stage ---------
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Ensure correct DLL name
ENTRYPOINT ["dotnet", "DotNetApp.dll"]


