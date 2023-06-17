# stage 1
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY TodoListApp.csproj .
RUN dotnet restore TodoListApp.csproj
COPY . .
RUN dotnet build TodoListApp.csproj -c Release -o /app/build

# stage 2
FROM build AS publish
RUN dotnet publish TodoListApp.csproj -c Release -o /app/publish

# stage 3
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
