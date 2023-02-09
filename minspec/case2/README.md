# Case 2

This is a bazel workspace that depends on the `greeting` crate by using
bazel to import that crate as a bazel repository.  The greeting crate
itself is both cargo and bazel project (in the sense that either works).

This crate uses `crates_vendor` to specify its deps (except for `greeting`).
The greeting crate also uses `crates_vendor` to specify its deps; those
deps are loaded by this crate's WORKSPACE.bazel.

```
$ bazel build :case2
INFO: Analyzed target //:case2 (111 packages loaded, 2771 targets configured).
INFO: Found 1 target...
ERROR: /usr/local/google/home/cfrantz/src/bugs/minspec/case2/BUILD.bazel:15:12: Compiling Rust bin case2 v0.1.0 (1 files) failed: (Exit 1): process_wrapper failed: error executing command (from target //:case2) bazel-out/k8-opt-exec-2B5CBBC6/bin/external/rules_rust/util/process_wrapper/process_wrapper --arg-file bazel-out/k8-fastbuild/bin/external/case2_deps__serde-1.0.152/serde_build_script.linksearchpaths ... (remaining 30 arguments skipped)

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
error[E0046]: not all trait items implemented, missing: `greet`
  --> src/main.rs:12:1
   |
12 | impl Greeting for Foo {
   | ^^^^^^^^^^^^^^^^^^^^^ missing `greet` in implementation
   |
   = help: implement the missing item: `fn greet(&self) -> std::string::String { todo!() }`

error: aborting due to previous error

For more information about this error, try `rustc --explain E0046`.
```
