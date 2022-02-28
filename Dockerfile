FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Service/Gtl.Shared.Communication.csproj", "Service/"]
COPY ["Contracts/Gtl.Shared.Communication.Contracts.csproj", "Contracts/"]

RUN dotnet restore "Service/Gtl.Shared.Communication.csproj"

COPY . .
WORKDIR "/src/Service"
RUN dotnet build "Gtl.Shared.Communication.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Gtl.Shared.Communication.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Gtl.Shared.Communication.dll"]
