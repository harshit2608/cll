#!/bin/bash

LIB_NAME="cpl"
LIB_PATH="./lib/target/release/lib${LIB_NAME}.a"
GO_PATH="./cpl-go"
JAVA_PATH="./cpl-java"
NODE_PATH="./cpl-node"
BUILD_DIR="./lib/build"
NEW_BUILD_DIR="cpl_lib"

# Print current directory
echo "Current directory: $(pwd)"

# Build the Rust library in release mode
echo "Building the Rust library in release mode..."
cargo build --release --manifest-path=lib/Cargo.toml

if [ $? -ne 0 ]; then
    echo "Rust build failed!"
    exit 1
fi

# Run tests for the Rust library
echo "Running tests for the Rust library..."
cargo test --release --manifest-path=lib/Cargo.toml

if [ $? -ne 0 ]; then
    echo "Rust tests failed!"
    exit 1
fi

# Ensure build directory exists
mkdir -p "$BUILD_DIR"

# Move static library to the build directory
echo "Copying static library to the build directory..."
cp "$LIB_PATH" "$BUILD_DIR/"

if [ $? -ne 0 ]; then
    echo "Failed to copy static library to $BUILD_DIR!"
    exit 1
fi

# Check if target directories exist
for dir in "$GO_PATH" "$JAVA_PATH" "$NODE_PATH"; do
    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist."
        exit 1
    fi
done

# Copy the build directory to the target directories and rename it to cpl_lib
for dir in "$GO_PATH" "$JAVA_PATH" "$NODE_PATH"; do
    echo "Copying the build directory to $dir as $NEW_BUILD_DIR..."
    cp -r "$BUILD_DIR/" "$dir/$NEW_BUILD_DIR/"

    if [ $? -ne 0 ]; then
        echo "Failed to copy build directory to $dir!"
        exit 1
    fi
done

echo "Build and copy completed successfully."

# Build the Go project
echo "Building the Go project..."
cd "$GO_PATH/" && make

if [ $? -ne 0 ]; then
    echo "Go build failed!"
    exit 1
fi

echo "Go project built successfully."
