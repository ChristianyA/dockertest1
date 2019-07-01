    #Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
    #For more information, please see https://aka.ms/containercompat

    FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-nanoserver-1803 AS base
    WORKDIR /app
    EXPOSE 80
    EXPOSE 443

    FROM mcr.microsoft.com/dotnet/core/sdk:2.2-nanoserver-1803 AS build
    WORKDIR /src
    COPY ["test1docker/test1docker.csproj", "test1docker/"]
    RUN dotnet restore "test1docker/test1docker.csproj"
    COPY . .
    WORKDIR "/src/test1docker"
    RUN dotnet build "test1docker.csproj" -c Release -o /app

    FROM build AS publish
    RUN dotnet publish "test1docker.csproj" -c Release -o /app

    FROM base AS final
    WORKDIR /app
    COPY --from=publish /app .
    ENTRYPOINT ["dotnet", "test1docker.dll"] 

    # FROM microsoft/aspnetcore-build:latest AS build 
    # WORKDIR /code 
    # COPY . .
    #  RUN dotnet restore 
    #  RUN dotnet publish  --output /output --configuration Release

    #  FROM  microsoft/aspnetcore:latest 
    #  COPY --from=build  /output /app
    #  WORKDIR /app
    #  ENTRYPOINT ["dotnet","test1docker.dll"]      