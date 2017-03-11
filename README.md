# Angular 4 AOT Example with es2015 ESM and Closure Compiler

Kyle Cordes, Oasis Digital

## Why another AOT example repo?

The purposes of this repo:

* Show some functionality, not just a trivial example to prove the
  build works.
* Use a template with variables from the component code, to see
  differences needed for Closure.
* Gather questions, so I can expand the explanation here and in
  comments.

Please open issues in this example if there are aspects of the code or
configuration that are not sufficiently well explained and comments or
in this README.

## Background

Most Angular users have treated AOT as a future curiosity since
Angular reached production release in the summer of 2016.  But as
Angular has been successfully used on substantial projects, there is a
greater and greater impetus for attention on build tooling to produce
a smaller output.

At the same time, there were various technical limitations and how
well AOT could work early on, some of them related to the CommonJS
package format ubiquitous on NPM.

Fortunately:

* The Angular team has made many improvements to the core product that
  particularly help it work better with Closure.
* Tools and libraries have matured greatly, making it
  much easier than before to get results with AOT.
* Angular AOT Has matured greatly, running more quickly and producing
  faster running output.

This repo demonstrates a **short tool stack**, essentially just AOT
and Closure Compiler. This tool stack is much more fragile than the
Angular CLI, but also worthy of a look for some projects.

## Kit

Here are the libraries and elements used in this example.

### Angular 4.0.0-rc.3

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

ES2015 FESM means "flat ES2015 modules containing ES2105 code".

"Flat" means that the numerous separate files that comprise the
Angular source code have been combined into a single large file per
major Angular library, removing all the overhead of how those modules
would have had to be wired together at run time otherwise.

There is also an ES5 FESM packaging included, but ES2015 FESM is the
best fit for Closure,

### RxJS as ES2015 modules

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
web assets for web download, understood by most or all modern
browsers. By using Brotli, we can see how small the compiled
compressed JavaScript "on the wire" will be.

`brew install brotli` (or whatever, for your OS)

## Results

```
./aot-build.sh
yarn start
```

Then experiment with the application in your browser.

The output size:

```
-rw-r--r--+ 1 kcordes  staff  149610 Mar 11 09:43 www/bundle.min.js
-rw-------+ 1 kcordes  staff   39958 Mar 11 09:43 www/bundle.min.js.br
-rw-r--r--+ 1 kcordes  staff   29813 Mar 11 09:43 www/zone.min.js
-rw-------+ 1 kcordes  staff    8605 Mar 11 09:43 www/zone.min.js.br
```

This application uses several of the Angular main modules, and various
RxJS operators. The resulting JavaScript "on the wire" is 48K bytes.
This seems quite satisfactory.

To understand where the bytes come from:

```
yarn run explore
```

Unfortunately, a consequence of using Angular as FESM is that each
major Angular library (for example "core") appears as just a single
entry in this map.
