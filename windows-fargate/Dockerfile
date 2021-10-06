# First stage
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /DockerSource

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY windows-fargate/*.csproj ./windows-fargate/
COPY virtualS3/* ./virtualS3/
RUN dotnet restore

# Copy everything else and build website
COPY windows-fargate/. ./windows-fargate/
WORKDIR /DockerSource/windows-fargate
RUN dotnet publish -c release -o /DockerOutput/Website --no-restore

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /DockerOutput/Website
COPY --from=build /DockerSource/. ./Previous/
COPY --from=build /DockerOutput/Website ./
ENTRYPOINT ["dotnet", "windows-fargate.dll"]
