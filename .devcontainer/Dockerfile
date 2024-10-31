# Use the official OpenJDK 11 base image
FROM mcr.microsoft.com/vscode/devcontainers/java:0-17

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter && \
    chown -R vscode:vscode /opt/flutter
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PostgreSQL server
RUN apt-get update && \
    apt-get install -y postgresql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*




# Install any additional packages you need (e.g., Android Studio, Swagger)
# Note: Android Studio installation is complex and usually done via the SDK, not directly in the container.