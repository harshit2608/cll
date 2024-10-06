const path = require('path');
const ffi = require('ffi-napi');
const ref = require('ref-napi');

const CStringPtr = ref.refType(ref.types.CString);

const libPath = path.join(__dirname, '/cll_lib/libcll.dylib');

const lib = ffi.Library(libPath, {
  'node_greet': [CStringPtr, ['string']],  // Return type is a pointer to a C string
  'free_result': ['void', [CStringPtr]],   // Free the result pointer
  'node_fibonacci': [CStringPtr, ['string']],  // Return type is also a pointer
});

const greet = (name) => {
  const resultPtr = lib.node_greet(name);
  const result = ref.readCString(resultPtr);
  lib.free_result(resultPtr);
  return result;
};

const fibonacci = (n) => {
  const resultPtr = lib.node_fibonacci(n.toString());
  const result = ref.readCString(resultPtr);
  lib.free_result(resultPtr);
  return result;
};


const name = "From NodeJs Lib";
const greeting = greet(name);
console.log(greeting);

const num = 15;
const fibResult = fibonacci(num);
console.log(`Fibonacci of ${num} is ${fibResult}`);
