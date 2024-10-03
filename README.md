# CLL

**CLL** is a cross-language library that allows user to write core logic in Rust and create bindings for multiple programming languages, including Go, Java, and _Node.js (WIP)_. This enables seamless integration of the powerful Rust language into various environments.

## Features

- Core library written in Rust
- Language-specific bindings for Go, Java, and Node.js
- Supports both dynamic and static library generation
- Easy-to-use build process

## Prerequisites

Before building the project, ensure that Rust is installed on your system. You can install Rust by following the instructions on the official Rust website: [Install Rust](https://www.rust-lang.org/tools/install).

## How to Use

1. **Write your core logic in Rust**: Implement the main functionality of your project in Rust.
2. **Export language-specific bindings**: Use appropriate tools and methods to generate bindings for the desired language (e.g., cbindgen for Go, JNI for Java, N-API for Node.js).
3. **Create a wrapper**: Develop a simple wrapper in the target language that interacts with the bindings.

## How to Build

To build the dynamic and static libraries, simply run the `Makefile` provided. This will handle the cross-compilation of the Rust code and the setup for Go, Java, and Node.js bindings.

```bash
make
```

## Supported Languages

- Rust: Core logic and library
- Go: Bindings are created using C FFI
- Java: Bindings are created using JNI
- Node.js: Bindings are created using N-API
