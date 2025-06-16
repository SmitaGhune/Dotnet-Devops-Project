# Use SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy .csproj and restore
COPY ./src/DotNetApp/*.csproj ./DotNetApp/
WORKDIR /src/DotNetApp
RUN dotnet restore

# Copy everything and build
COPY ./src/DotNetApp/. ./
RUN dotnet publish -c Release -o /app/publish

# Use ASP.NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "DotNetApp.dll"]
