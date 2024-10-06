# CLL

**CLL** is a cross-language library that allows user to write core logic in Rust and create bindings for multiple programming languages, including Go, Java, and Node.js This enables seamless integration of the powerful Rust language into various environments.

## Features

- Core library written in Rust
- Language-specific bindings for Go, Java, and Node.js
- Supports both dynamic and static library generation
- Easy-to-use build process

## Prerequisites

Ensure that the following are installed on your system before building the project:

- **Rust**: The core library is written in Rust. Follow the official [Rust installation guide](https://www.rust-lang.org/tools/install) to set up Rust.
- **Go**, **Java**, **Node.js**: Install these as needed based on which language bindings you plan to use.

> **Note**: Currently, Node.js version 14 (up to 14.16.1) is supported due to limitations with `node-gyp`, which is used by `ffi-napi`. Future updates might introduce native bindings without the need for dynamic libraries.

## How to Use

1. **Write your core logic in Rust**: Implement the main functionality of your project in Rust.
2. **Export language-specific bindings**: Use appropriate tools and methods to generate bindings for the desired language (e.g., C for Go, JNI for Java, FFI-NAPI for Node.js).
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
