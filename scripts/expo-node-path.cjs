const path = require('path');
const Module = require('module');

const repoRoot = path.resolve(__dirname, '..');
const expoNodeModules = path.join(repoRoot, 'ocr-expo', 'node_modules');

if (!process.env.NODE_PATH || !process.env.NODE_PATH.split(path.delimiter).includes(expoNodeModules)) {
  process.env.NODE_PATH = process.env.NODE_PATH
    ? `${expoNodeModules}${path.delimiter}${process.env.NODE_PATH}`
    : expoNodeModules;
  Module._initPaths();
}


