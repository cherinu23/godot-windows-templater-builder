#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

# Define log file
LOGFILE="build.log"

# Function to log messages with timestamp
log() {
    local msg="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $msg" | tee -a "$LOGFILE"
}

# Log the start of the build process
log "Starting Godot Windows template build with encryption enabled..."

# Check if the encryption key is set
if [ -z "$SCRIPT_AES256_ENCRYPTION_KEY" ]; then
    log "ERROR: SCRIPT_AES256_ENCRYPTION_KEY is not set."
    exit 1
fi

# Function to build a specific target
build() {
    local target="$1"
    log "Building $target template..."

    # Run the build command and log the output
    scons platform=windows target="$target" use_lto=yes \
        tools=no module_webm_enabled=no -j"$(nproc)" \
        CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ \
        SCRIPT_AES256_ENCRYPTION_KEY="$SCRIPT_AES256_ENCRYPTION_KEY" \
        verbose=yes 2>&1 | tee -a "$LOGFILE"

    # Check if the build was successful
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        log "ERROR: Failed to build $target template."
        exit 1
    fi
}

# Record the start time
start_time=$(date +%s)

# Build the release and debug templates
build "template_release"
build "template_debug"

# Calculate the duration of the build process
duration=$(( $(date +%s) - start_time ))
log "Build complete in $duration seconds."

# Check if the bin directory exists and copy the build output
if [ -d "bin" ]; then
    log "Copying build output to /godot/templater/ ..."
    mkdir -p "/godot/templater"
    
    if cp -r bin/* "/godot/templater/" && cp "$LOGFILE" "/godot/templater/"; then
        log "Copy complete. Log file exported to /godot/templater/build.log"
    else
        log "ERROR: Failed to copy build output or log file."
        exit 1
    fi
else
    log "ERROR: bin directory not found."
    exit 1
fi
