FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["devopsdemowebapp/devopsdemowebapp.csproj", "devopsdemowebapp/"]
RUN dotnet restore "devopsdemowebapp/devopsdemowebapp.csproj"
COPY . .
WORKDIR "/src/devopsdemowebapp"
RUN dotnet build "devopsdemowebapp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "devopsdemowebapp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "devopsdemowebapp.dll"]