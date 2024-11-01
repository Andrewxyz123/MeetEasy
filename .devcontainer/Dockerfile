# Use the official OpenJDK 11 base image
FROM mcr.microsoft.com/vscode/devcontainers/java:0-17

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter && \
    chown -R vscode:vscode /opt/flutter
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Install PostgreSQL client, PostgreSQL server, and Maven
RUN apt-get update && \
    apt-get install -y \
    postgresql-client \
    postgresql \
    maven \
    curl \
    apt-transport-https \
    ca-certificates \
    software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker Compose v2
RUN curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
