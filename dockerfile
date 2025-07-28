# Base image with Debian and Python tools
FROM debian:bullseye

# Set build-time ARG for AES encryption key (passed during docker run)
ARG SCRIPT_AES256_ENCRYPTION_KEY
ENV SCRIPT_AES256_ENCRYPTION_KEY=${SCRIPT_AES256_ENCRYPTION_KEY}

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git scons pkg-config python3 python3-pip \
    gcc-mingw-w64-x86-64-posix g++-mingw-w64-x86-64-posix \
    mingw-w64 openssl wget zip \
    && rm -rf /var/lib/apt/lists/*

# Set MinGW to POSIX threading model (required by Godot)
RUN update-alternatives \
    --install /usr/bin/x86_64-w64-mingw32-g++ x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix 100 && \
    update-alternatives \
    --install /usr/bin/x86_64-w64-mingw32-gcc x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix 100

# Set working directory
WORKDIR /godot

# Clone Godot source code
RUN git clone --branch 4.4.1-stable --depth 1 https://github.com/godotengine/godot.git .

# Copy build script
COPY build.sh /godot/build.sh
RUN chmod +x /godot/build.sh

# Set the entrypoint to run the build script
ENTRYPOINT ["/godot/build.sh"]