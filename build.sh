#!/bin/bash

# Output binary name
OUTPUT_NAME="project_fleetborn"

# Source file
SOURCE_DIR="core/."

# Output directory
BUILD_DIR="build"

# Create the builds directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Build the project using Odin
echo "Building $SOURCE_DIR..."
odin build "$SOURCE_DIR" -out="$BUILD_DIR/$OUTPUT_NAME"

# Check for success
if [ $? -eq 0 ]; then
    echo "Build successful! Binary: $BUILD_DIR/$OUTPUT_NAME"
    "$BUILD_DIR/$OUTPUT_NAME"
else
    echo "Build failed."
fi
