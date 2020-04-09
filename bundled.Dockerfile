FROM node:13.12 AS client-build

WORKDIR /usr/app

ENV PATH /usr/app/node_modules/.bin:$PATH

COPY ./client-app/package.json /usr/app/
COPY ./client-app/yarn.lock /usr/app/

RUN yarn

COPY ./client-app/ /usr/app

RUN yarn build

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS server-build

ARG SPA_STATIC_FILES_PATH=./client-app-build
ENV SPA_STATIC_FILES_PATH=$SPA_STATIC_FILES_PATH

WORKDIR /usr/app

# copy in custom nuget if needed
# COPY ./server-app/NuGet.Config /root/.nuget/NuGet/

COPY ./server-app/*.csproj .

RUN dotnet restore

COPY ./server-app/ .

RUN dotnet publish -c Release -o server-dlls

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime

ARG SPA_STATIC_FILES_PATH=./client-app-build
ENV SPA_STATIC_FILES_PATH=$SPA_STATIC_FILES_PATH

WORKDIR /usr/app

COPY --from=client-build /usr/app/dist ${SPA_STATIC_FILES_PATH}
COPY --from=server-build /usr/app/server-dlls ./

EXPOSE 80

ENTRYPOINT ["dotnet","dotnetcore-react.dll"]
