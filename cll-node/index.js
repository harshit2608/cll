const path = require('path');
const ffi = require('ffi-napi');

const libPath = path.join(__dirname, '/cll_lib/libcll.dylib');

const lib = ffi.Library(libPath, {
  'node_greet': ['void', ['string']],
});

const greet = (name) => {
  lib.node_greet(name);
};

greet('From Node.js');
