FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine as build

WORKDIR /src
COPY Create.sln .
COPY Create.csproj .
RUN dotnet restore Create.sln

COPY . .
RUN dotnet build -c Release Create.sln
RUN dotnet test -c Release Create.sln
RUN dotnet publish -c Release -o /dist Create.sln

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

ENV ASPNETCORE_URLS http://+:8080
ENV ASPNETCORE_ENVIRONMENT Production
EXPOSE 8080
ENV ConnectionStrings__MyDB ""

WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "Create.dll"]
