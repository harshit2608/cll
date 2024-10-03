# CPL

A cross-language library.

## How to use?

- Write your logic in rust
- Export language-specific bindings
- Create a wrapper on those bindings in the desired language.

## How to run

Just run the `build.sh` file. This will create dynamic and static libs

```bash
./build.sh
```

## Stats

Below are the supported languges as of now:
- Rust : Core library logics
- Go: Bindings for go can be created (using C FFI)
- Java: Bindings for java can be created ( Usin JNI export for same)
  
