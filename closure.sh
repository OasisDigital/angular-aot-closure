#!/bin/bash
set -e

# Tree-shake, ES2015->ES5 and minify with Clojure Compiler.
OPTS=(
  "--language_in=ES6_STRICT"
  "--language_out=ES5"
  "--compilation_level=ADVANCED_OPTIMIZATIONS"
  "--js_output_file=www/bundle.min.js"
  "--create_source_map=%outname%.map"

  # RxJS results in many warnings, which can be ignored.
  "--warning_level=QUIET"

  # Don't include ES6 polyfills, change for older browser?
  # or add core-js polyfill for older browsers?
  "--rewrite_polyfills=false"

  "--js_module_root=build"
  "--js_module_root=node_modules/@angular/core"
  "--js_module_root=node_modules/@angular/common"
  "--js_module_root=node_modules/@angular/compiler"
  "--js_module_root=node_modules/@angular/platform-browser"
  "--js_module_root=node_modules/@angular/forms"
  "--js_module_root=node_modules/@angular/http"

  # tell Closure about Zone so it doesn't mangle names
  "vendor/zone_externs.js"
  "vendor/angular_testability_externs.js"

  # Angular 4+, ES2015-in-ES2015 FESMs
  node_modules/@angular/core/@angular/core.js
  node_modules/@angular/common/@angular/common.js
  node_modules/@angular/compiler/@angular/compiler.js
  node_modules/@angular/platform-browser/@angular/platform-browser.js
  node_modules/@angular/forms/@angular/forms.js
  node_modules/@angular/http/@angular/http.js

  # Local RxJS build
  $(find rxjs -name '*.js')

  # Application code, built
  $(find build -name '*.js')

  "--entry_point=build/aot-main"
  "--dependency_mode=STRICT"
  "--output_manifest=www/manifest.MF"
)
closureFlags=$(mktemp)
echo ${OPTS[*]} > $closureFlags
java -jar node_modules/google-closure-compiler/compiler.jar --flagfile $closureFlags
