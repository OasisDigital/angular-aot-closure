# Angular 4 AOT Example with es2015 ESM and Closure Compiler

Kyle Cordes, Oasis Digital

## Background

Most Angular users treated AOT as a future curiosity when Angular
reached production release in the summer of 2016. As of late fall 2016
though, many (particularly those working on larger applications) have
been much more eager and interested.

At the same time, there were various technical limitations and how
well AOT could work early on, some of them related to the CommonJS
package format ubiquitous on NPM.

Fortunately, the tools and libraries have matured greatly, making it
much easier than before to get results with AOT. Further, Angular
itself has matured greatly, and AOT runs more quickly and produce a
smaller output than ever before. At the same time, the Angular core
team has recently started shipping the libraries and formats more and
more suitable for efficient production bundling, with tree shaking,
with AOT.

This repo demonstrates a **short tool stack**, essentially just AOT
and Closure Compiler.

## Kit

Here are the libraries and elements used in this example.

### Angular 4.0.0-rc.2

As of the end of February 2013, this is the very latest, and it is
also the first release to ship with the new packaging of libraries.

Angular 4 AOT both compiles and executes more quickly and with smaller
size than Angular 2. This alone should provide ample motivation for
users to adopt version 4 quickly. (Oasis Digital now teaches Angular
Boot Camp with Angular 4.)

### AOT (ngc)

AOT is executed using the ngc command line tool. Its configuration is
in `tsconfig.json`. The critical/unusual settings for this approach are:

```
{
  "compilerOptions": {
    "target": "es2015",
    "module": "es2015",
  }
  "angularCompilerOptions": {
    "annotateForClosureCompiler": true,
    "annotationsAs": "static fields",
    "skipMetadataEmit": false
  }
}
```

```"annotationsAs": "static fields",``` means no reflect-metadata is
needed at runtime.

As ngc wraps the TypeScript compiler and provides TypeScript
compilation, these settings mean the output will be ES2015 code in
ES2015 modules - the same as the new Angular es2015 FESM packaging.

### ES2015 FESM packaging

<https://github.com/angular/angular/blob/master/CHANGELOG.md#es2015-builds>

This means "flat ES2015 modules containing ES2105 code". "Flat" means
that the numerous separate files that comprise the Angular source code
have been combined into a single large file per major Angular library,
removing all the overhead of how those modules would have had to be
wired together at run time otherwise.

There is also a packaging included which uses these type of "FESM"
modules, but with ES5 code inside. We picked the most advanced option
for optimal processing. Closure can do a better job with more
information, and that information is more present using the latest
packaging and source code format.

### RxJS as ES2016 modules

Currently RxJS does not yet ship in the form of ES2015 modules, so
this project has a workaround to build them locally. Most likely such
modules will be forthcoming from the RxJS project in the future,
eliminating the need for this workaround.

### Closure Compiler (Java edition)

<https://github.com/google/closure-compiler/>

While for optimal bundling it is important to use ES2015 code as far
as possible through the build process, I was looking for output:

* Suitable for older browsers, which is to say, ES5.
* Minified.
* As a single file.

The current leader for producing the smallest results appears to be
the Google Closure Compiler, which is much older than the competing
tools, and written in (horrors!) Java. It is robust, proven,
performant.

#### Why not the Closure Compiler JavaScript edition?

I tried this first, as it would avoid a Java dependency.
Unfortunately, there appears to be a limitation or bug which makes it
unable to process the FESM bundles provided by the Angular project.
Those files contain a Unicode character U+0275, rejected by
Closure-Compiler-in-JavaScript JavaScript as "not a valid identifier
start char".

### Brotli

Brotli is the new gzip - the top-of-the-line choice for compressing
web assets for wen download, understood by most or all modern
browsers. By adding a step using Brotli, we can see immediately how
small the compiled compressed JavaScript results are.

`brew install brotli` (or whatever, for your OS)

## Results

```
yarn
./aot-build.sh
yarn start
```

Then experiment with the application in your browser.

The output size:

```
-rw-r--r--+ 1 kcordes  staff  149974 Mar  8 10:50 www/bundle.min.js
-rw-------+ 1 kcordes  staff   39767 Mar  8 10:50 www/bundle.min.js.br
-rw-r--r--+ 1 kcordes  staff   28578 Mar  8 10:50 www/zone.min.js
-rw-------+ 1 kcordes  staff    8273 Mar  8 10:50 www/zone.min.js.br
```

The .br files represent the approximate network transfer amount when
operating at scale with file served using Brotli compression.

This application uses several of the Angular main modules, and various
RxJS operators. The resulting JavaScript "on the wire" is 48,040
bytes. This seems quite satisfactory.

To understand where the bytes come from:

```
yarn run explore
```

Unfortunately, a consequence of using Angular as FESM is that each
major Angular library (for example "core") appears is just a single
entry in this map.
