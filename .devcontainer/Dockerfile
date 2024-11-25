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

# Android
RUN apt-get update \
&& apt-get install --yes --no-install-recommends \
    openjdk-$JAVA_VERSION-jdk \
    curl \
    unzip \
    sed \
    git \
    bash \
    xz-utils \
    libglvnd0 \
    ssh \
    xauth \
    x11-xserver-utils \
    libpulse0 \
    libxcomposite1 \
    libgl1-mesa-glx \
&& rm -rf /var/lib/{apt,dpkg,cache,log}

# Install Gradle.
RUN curl -L $GRADLE_URL -o gradle-$GRADLE_VERSION-bin.zip \
  && apt-get install -y unzip \
  && unzip gradle-$GRADLE_VERSION-bin.zip \
  && mv gradle-$GRADLE_VERSION $GRADLE_USER_HOME \
  && rm gradle-$GRADLE_VERSION-bin.zip

  # Install the Android SDK.
RUN mkdir /root/.android \
&& touch /root/.android/repositories.cfg \
&& mkdir -p $ANDROID_SDK_ROOT \
&& curl -o android_tools.zip $ANDROID_TOOLS_URL \
&& unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
&& rm android_tools.zip \
&& mv $ANDROID_SDK_ROOT/cmdline-tools $ANDROID_SDK_ROOT/latest \
&& mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
&& mv $ANDROID_SDK_ROOT/latest $ANDROID_SDK_ROOT/cmdline-tools/latest \
&& yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
&& yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
&& yes "y" | sdkmanager "platform-tools"

# Install Flutter.
RUN curl -o flutter.tar.xz $FLUTTER_URL \
  && mkdir -p $FLUTTER_ROOT \
  && tar xf flutter.tar.xz -C /opt/ \
  && rm flutter.tar.xz \
  && git config --global --add safe.directory /opt/flutter \
  && flutter config --no-analytics \
  && flutter precache \
  && yes "y" | flutter doctor --android-licenses \
  && flutter doctor \
  && flutter update-packages
