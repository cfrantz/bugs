# Compilation failure with min_specialization

The `greeting` crate defines a `Greeting` trait with a min_specialization
default implementation for all `T` where `T: serde::Serialize`.

The test cases implement `Greeting` on a `Foo` and supply one of the two
trait methods.  The other method is expected to fall back on the default
implementation.

- case1: pure cargo workspace. PASS.
- case2: bazel workspace using crates_vendor to depend on the `greeting` crate
  as an external bazel workspace (as `@greeting`).  FAIL.
- case3: bazel workspace using crates_vendor to depend on the `greeting` crate
  via a `git` dependency specified in `Cargo.toml`.  PASS.
