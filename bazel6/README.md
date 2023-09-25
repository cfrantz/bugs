# Bazel bugs?

## Missing file causes bazel to crash

Using a custom `my_binary` rule (like `cc_binary`, but implemented with
helper functions from `cc_common`):

```bash
bazel build //missing_file:hello_bug

<crash>
```

## Indirect `exec` dependency is missing runfiles

Note: Fixed.

Define a `toolbox` rule that can collect a number of tools and other
deps that might be needed by a custom binary rule.  The `runfiles`
directory of an "indirect" tool dependency get lost (or never built).

`my_binary(name="goodbye")` -> `:tools` -> `//tools:sha256`.

```bash
bazel build //missing_runfiles:goodbye

ERROR: ...
```
