# Case 3

This is a bazel workspace that depends on the `greeting` crate by using
a git reference in the `Cargo.toml`.  This crate uses `crates_vendor`
to build its deps from the `Cargo.toml` file.

```
$ bazel run :case3
INFO: Analyzed target //:case3 (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:case3 up-to-date:
  bazel-bin/case3
INFO: Elapsed time: 0.309s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/case3

case3
Foo greeting: hello
Foo id: Some(TypeId { t: 12694249113184411119 })
```
