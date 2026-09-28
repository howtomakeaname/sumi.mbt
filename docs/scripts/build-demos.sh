#!/usr/bin/env bash
# Build the interactive demo bundle (MoonBit → JS) and copy it into the
# VitePress public directory, where it is served as /demos/sumi-demos.js.
set -euo pipefail

cd "$(dirname "$0")/../.."

moon build --target js --release
mkdir -p docs/public/demos
cp _build/js/release/build/example/docs-demos/main/main.js docs/public/demos/sumi-demos.js
echo "docs/public/demos/sumi-demos.js updated"
