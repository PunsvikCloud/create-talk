FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine as build

WORKDIR /src
COPY Breach.sln .
COPY Breach.csproj .
RUN dotnet restore Breach.sln

COPY . .
RUN dotnet build -c Release Breach.sln
RUN dotnet test -c Release Breach.sln
RUN dotnet publish -c Release -o /dist Breach.sln

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

ENV ASPNETCORE_URLS http://+:8080
ENV ASPNETCORE_ENVIRONMENT Production
EXPOSE 8080
ENV ConnectionStrings__MyDB ""

WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "Breach.dll"]
