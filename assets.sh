#!/bin/bash
set -e

# Minimum polyfill: just Zone.
# Reflect has been handled Ahead Of Time
cp node_modules/zone.js/dist/zone.min.js www

# Gather CSS
cp -R node_modules/materialize-css/dist www/materialize

# Use Brotli, if available, to see the best-case network transfer size
if hash bro 2>/dev/null; then
  bro --input www/bundle.min.js --output www/bundle.min.js.br
  bro --input www/zone.min.js --output www/zone.min.js.br
  echo "AOT output size"
  ls -l www/*.js www/*.js.br
fi
