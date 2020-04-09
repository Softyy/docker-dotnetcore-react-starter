FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS server-build

ARG SPA_STATIC_FILES_PATH=./client-app-build
ENV SPA_STATIC_FILES_PATH=$SPA_STATIC_FILES_PATH

WORKDIR /usr/app

# copy in custom nuget if needed
# COPY ./server-app/NuGet.Config /root/.nuget/NuGet/

COPY ./*.csproj .

RUN dotnet restore

COPY . .

EXPOSE 80

CMD ["dotnet","watch","run"]