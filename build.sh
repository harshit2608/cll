#!/bin/bash

LIB_NAME="cpl"
GO_PATH="./cpl-go"
JAVA_PATH="./cpl-java"
BUILD_DIR="./lib/build"
NEW_BUILD_DIR="cpl_lib"

# Set the Rust targets for both architectures
RUST_TARGET_ARM64="aarch64-apple-darwin"
RUST_TARGET_X86_64="x86_64-apple-darwin"

# Print current directory
echo "Current directory: $(pwd)"

# Install the Rust targets if they're not already available
echo "Installing Rust targets..."
rustup target add $RUST_TARGET_ARM64
rustup target add $RUST_TARGET_X86_64

# Ensure the build directory exists
mkdir -p "$BUILD_DIR"

# Ensure the target directories exist
mkdir -p "$GO_PATH/$NEW_BUILD_DIR"
mkdir -p "$JAVA_PATH/$NEW_BUILD_DIR"

# ----------- Build static library for Go (arm64) ----------- #
echo "Building Rust static library for Go (ARM64)..."
cargo build --release --target $RUST_TARGET_ARM64 --manifest-path=lib/Cargo.toml --lib
if [ $? -ne 0 ]; then
    echo "Rust static library build for ARM64 failed!"
    exit 1
fi

# Copy the ARM64 static library for Go
echo "Copying ARM64 static library to Go project..."
cp "./lib/target/$RUST_TARGET_ARM64/release/lib${LIB_NAME}.a" "$GO_PATH/$NEW_BUILD_DIR/libcpl.a"
if [ $? -ne 0 ]; then
    echo "Failed to copy ARM64 static library!"
    exit 1
fi

echo "Static library copied to Go project."

# ----------- Build dynamic library for Java (x86_64) ----------- #
echo "Building Rust dynamic library for Java (x86_64)..."
cargo build --release --target $RUST_TARGET_X86_64 --manifest-path=lib/Cargo.toml --lib
if [ $? -ne 0 ]; then
    echo "Rust dynamic library build for x86_64 failed!"
    exit 1
fi

# Copy the x86_64 dynamic library for Java
echo "Copying x86_64 dynamic library to Java project..."
cp "./lib/target/$RUST_TARGET_X86_64/release/lib${LIB_NAME}.dylib" "$JAVA_PATH/$NEW_BUILD_DIR/libcpl.dylib"
if [ $? -ne 0 ]; then
    echo "Failed to copy x86_64 dynamic library!"
    exit 1
fi

echo "Dynamic library copied to Java project."

# ----------- Instructions for further builds ----------- #

# Build the Go project
echo "Building the Go project..."
cd "$GO_PATH/" && make
if [ $? -ne 0 ]; then
    echo "Go build failed!"
    exit 1
fi
echo "Go project built successfully."

# Build the Java project
echo "Building the Java project..."
cd ..
cd "$JAVA_PATH" && mvn clean package
if [ $? -ne 0 ]; then
    echo "Java build failed!"
    exit 1
fi
echo "Java project built successfully."

# Final instructions for running
echo "To run the Go application:"
echo "go run cpl-go/main.go"
echo "To run the Java application:"
echo "java -Djava.library.path=./cpl-java/cpl_lib -cp cpl-java/target/cpl-1.0-SNAPSHOT.jar cpl.App"
