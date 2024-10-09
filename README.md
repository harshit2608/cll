# CLL: Cross-Language Library

**CLL** is a project designed to allow developers to write core logic in Rust and create bindings for multiple programming languages, including Go, Java, and Node.js. This enables seamless integration of Rust's performance and safety features across various environments.

> [!CAUTION]
> Bindings generated for Deno are still in the experimental phase. Although they offer better performance and memory management compared to Node.js FFI-NAPI bindings, developers are advised to use them at their own risk.

## Features

- **Core Logic in Rust**: Reuse your Rust code across multiple languages with minimal effort.
- **Multi-Language Bindings**: Supports Go, Java, and Node.js bindings through C FFI, JNI, and FFI-NAPI.
- **Dynamic and Static Libraries**: Easily generate both dynamic and static libraries for integration.
- **Streamlined Build Process**: A simple `Makefile` handles cross-language compilation and binding setup.

## Prerequisites

Ensure that the following are installed on your system before building the project:

- **Rust**: The core library is written in Rust. Follow the official [Rust installation guide](https://www.rust-lang.org/tools/install) to set it up.
- **Go**, **Java**, **Node.js**, **Deno**: Install these based on which language bindings you plan to use.

> [!NOTE]
> Node.js version 14 (up to 14.16.1) is currently supported due to limitations with `node-gyp`, used by `ffi-napi`. Future updates may transition to native bindings, eliminating the need for dynamic libraries.

## How to Use

1. **Write your core logic in Rust**: Implement the main functionality in Rust.
2. **Generate language-specific bindings**: Use the appropriate Rust export bindings:
   - **Go**: Bindings created using C FFI.
   - **Java**: Bindings created using JNI.
   - **Node.js**: Bindings created using FFI-NAPI.
   - **Deno**: Bindings created for the Deno runtime using internal FFI.
3. **Create a wrapper in the target language**: Develop simple wrappers that interact with Rust through the generated bindings.

## Build Instructions

To build both dynamic and static libraries, simply run the provided `Makefile`:

```bash
make
```

This will:

- Compile the Rust core library.
- Generate the bindings for Go, Java, Node.js and Deno.
- Create the respective libraries for integration.

## Supported Languages

- **Rust**: Core logic and library.
- **Go**: Bindings are created using C FFI.
- **Java**: Bindings are created using JNI.
- **Node.js**: Bindings are created using N-API with ffi-napi.

## TODO

- [ ] Improve test coverage for the overall codebase.
- [ ] Add support for scaffold templates.
- [ ] Migrate away from `ffi-napi` for Node.js to native Rust-Node.js bindings.

## License

This project is licensed under the MIT License.
