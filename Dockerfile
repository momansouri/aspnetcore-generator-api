FROM microsoft/aspnetcore-build:2 AS build-env
WORKDIR /generator

COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY test/test.csproj ./test/
RUN dotnet restore test/test.csproj

COPY . .
ENV TEAMCITY_PROJECT_NAME=fake
RUN dotnet test test/test.csproj

RUN dotnet publish api/api.csproj -o /publish

#runtime
FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT ["dotnet", "api.dll"]


