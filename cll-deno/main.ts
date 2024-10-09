import { join } from "https://deno.land/std@0.201.0/path/mod.ts";

const libPath = join(Deno.cwd(), 'cll_lib', 'libcll.dylib');

const dylib = Deno.dlopen(libPath, {
  "node_greet": { parameters: ["pointer"], result: "pointer" },
  "node_fibonacci": { parameters: ["pointer"], result: "pointer" },
  "free_result": { parameters: ["pointer"], result: "void" },
});


const readCString = (ptr: Deno.PointerValue): string => {
  const view = new Deno.UnsafePointerView(ptr!);
  const str = view.getCString();
  dylib.symbols.free_result(ptr);
  return str;
};

// Wrapper for the `greet` function
const greet = (name: string): string => {
  const encoder = new TextEncoder();
  const nameBuf = encoder.encode(name + '\0');
  const bufPtr = Deno.UnsafePointer.of(nameBuf);

  const resultPtr = dylib.symbols.node_greet(bufPtr);
  return readCString(resultPtr);
};


const fibonacci = (n: number): string => {
  const encoder = new TextEncoder();
  const nameBuf = encoder.encode(n.toString() + '\0')
  const bufPtr = Deno.UnsafePointer.of(nameBuf);

  const resultPtr = dylib.symbols.node_fibonacci(bufPtr);
  return readCString(resultPtr);
};

// Call the functions
const name = "From Deno FFI";
const greeting = greet(name);
console.log(greeting);

const num = 15;
const fibResult = fibonacci(num);
console.log(`Fibonacci of ${num} is ${fibResult}`);
