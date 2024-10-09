LIB_NAME=cll
GO_PATH=./cll-go
JAVA_PATH=./cll-java
NODE_PATH=./cll-node
DENO_PATH=./cll-deno
BUILD_DIR=./lib/build
NEW_BUILD_DIR=cll_lib

RUST_TARGET_ARM64=aarch64-apple-darwin
RUST_TARGET_X86_64=x86_64-apple-darwin

# Default target to run everything
all: check-rust rust-targets prepare-dirs build-go-arm64 build-java-x86_64 build-go build-java build-node build-deno check-tests instructions

# Check if Rust is installed
check-rust:
	@command -v rustc >/dev/null 2>&1 || { echo >&2 "Rust is not installed. Please install Rust from https://www.rust-lang.org/tools/install and try again."; exit 1; }
	@echo "Rust is installed.\n"

# Rust target installation
rust-targets:
	@echo "Installing Rust targets..."
	rustup target add $(RUST_TARGET_ARM64)
	rustup target add $(RUST_TARGET_X86_64)
	@echo

# Ensure build directories exist
prepare-dirs:
	@echo "Preparing build directories..."
	mkdir -p $(BUILD_DIR)
	mkdir -p $(GO_PATH)/$(NEW_BUILD_DIR)
	mkdir -p $(JAVA_PATH)/$(NEW_BUILD_DIR)
	mkdir -p $(NODE_PATH)/$(NEW_BUILD_DIR)
	mkdir -p $(DENO_PATH)/$(NEW_BUILD_DIR)
	@echo

# Build Rust static library for Go (ARM64)
build-go-arm64:
	@echo "Building Rust static library for Go (ARM64)..."
	cargo build --release --target $(RUST_TARGET_ARM64) --manifest-path=lib/Cargo.toml --lib --features go
	@if [ $$? -ne 0 ]; then echo "Rust static library build for ARM64 failed!"; exit 1; fi
	@echo "Copying ARM64 static library to Go project..."
	cp ./lib/target/$(RUST_TARGET_ARM64)/release/lib$(LIB_NAME).a $(GO_PATH)/$(NEW_BUILD_DIR)/libcll.a
	@if [ $$? -ne 0 ]; then echo "Failed to copy ARM64 static library!"; exit 1; fi
	@echo "Static library copied to Go project.\n"

# Build Rust dynamic library for Java (x86_64)
build-java-x86_64:
	@echo "Building Rust dynamic library for Java (x86_64)..."
	cargo build --release --target $(RUST_TARGET_X86_64) --manifest-path=lib/Cargo.toml --lib --features java
	@if [ $$? -ne 0 ]; then echo "Rust dynamic library build for x86_64 failed!"; exit 1; fi
	@echo "Copying x86_64 dynamic library to Java project..."
	cp ./lib/target/$(RUST_TARGET_X86_64)/release/lib$(LIB_NAME).dylib $(JAVA_PATH)/$(NEW_BUILD_DIR)/libcll.dylib
	@if [ $$? -ne 0 ]; then echo "Failed to copy x86_64 dynamic library!"; exit 1; fi
	@echo "Dynamic library copied to Java project.\n"

# Build Rust dynamic library for Node.js (x86_64)
build-node:
	@echo "Building Rust dynamic library for Node.js (x86_64)..."
	cargo build --release --target $(RUST_TARGET_X86_64) --manifest-path=lib/Cargo.toml --lib --features node
	@if [ $$? -ne 0 ]; then echo "Rust dynamic library build for Node.js failed!"; exit 1; fi
	@echo "Copying x86_64 dynamic library to Node.js project..."
	cp ./lib/target/$(RUST_TARGET_X86_64)/release/lib$(LIB_NAME).dylib $(NODE_PATH)/$(NEW_BUILD_DIR)/libcll.dylib
	@if [ $$? -ne 0 ]; then echo "Failed to copy x86_64 dynamic library!"; exit 1; fi
	@echo "Dynamic library copied to Node.js project.\n"
	@echo "Building Node.js..."
	cd $(NODE_PATH) && npm install
	@if [ $$? -ne 0 ]; then echo "Node.js build failed!"; exit 1; fi
	@echo "Node.js wrapper built successfully.\n"

# Build Rust dynamic library for Deno (ARM64)
build-deno:
	@echo "Building Rust dynamic library for Deno (ARM64)..."
	cargo build --release --target $(RUST_TARGET_ARM64) --manifest-path=lib/Cargo.toml --lib --features deno
	@if [ $$? -ne 0 ]; then echo "Rust dynamic library build for Deno failed!"; exit 1; fi
	@echo "Copying ARM64 dynamic library to Deno project..."
	cp ./lib/target/$(RUST_TARGET_ARM64)/release/lib$(LIB_NAME).dylib $(DENO_PATH)/$(NEW_BUILD_DIR)/libcll.dylib
	@if [ $$? -ne 0 ]; then echo "Failed to copy ARM64 dynamic library!"; exit 1; fi
	@echo "Dynamic library copied to Deno project.\n"
	@echo "Building Deno..."
	cd $(DENO_PATH) && deno install
	@if [ $$? -ne 0 ]; then echo "Deno build failed!"; exit 1; fi
	@echo "Deno wrapper built successfully.\n"

# Build Go project
build-go:
	@echo "Building the Go project..."
	cd $(GO_PATH) && make
	@if [ $$? -ne 0 ]; then echo "Go build failed!"; exit 1; fi
	@echo "Go project built successfully.\n"

# Build Java project
build-java:
	@echo "Building the Java project..."
	cd $(JAVA_PATH) && mvn clean package
	@if [ $$? -ne 0 ]; then echo "Java build failed!"; exit 1; fi
	@echo "Java project built successfully.\n"

# Run tests for Go project
test-go:
	@echo "Running Go tests..."
	cd $(GO_PATH) && go test ./...
	@if [ $$? -ne 0 ]; then echo "Go tests failed!"; exit 1; fi
	@echo "Go tests passed.\n"

# Run tests for Java project
test-java:
	@echo "Running Java tests..."
	cd $(JAVA_PATH) && mvn test
	@if [ $$? -ne 0 ]; then echo "Java tests failed!"; exit 1; fi
	@echo "Java tests passed.\n"

# Run tests for Node.js project
test-node:
	@echo "Running Node.js tests..."
	cd $(NODE_PATH) && npm test
	@if [ $$? -ne 0 ]; then echo "Node.js tests failed!"; exit 1; fi
	@echo "Node.js tests passed.\n"

# Check all tests
check-tests: test-go test-java
	@echo "All tests passed successfully.\n"

# Clean all build directories
clean:
	@echo "Cleaning build directories..."
	rm -rf $(BUILD_DIR) $(GO_PATH)/$(NEW_BUILD_DIR) $(JAVA_PATH)/$(NEW_BUILD_DIR) $(NODE_PATH)/$(NEW_BUILD_DIR) $(DENO_PATH)/$(NEW_BUILD_DIR) $(GO_PATH)/out $(JAVA_PATH)/target ./lib/target

# Instructions for running
instructions:
	@echo "To run the Go application:"
	@echo "go run cll-go/main.go\n"
	@echo "To run the Java application:"
	@echo "java -Djava.library.path=./cll-java/cll_lib -cp cll-java/target/cll-1.0-SNAPSHOT.jar cll.App\n"
	@echo "To run the Node.js application:"
	@echo "node cll-node/index.js\n"
	@echo "To run the deno application:"
	@echo "cd cll-deno && deno run start"
