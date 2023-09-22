package(default_visibility = ["//visibility:public"])

load("//rules:defs.bzl", "my_binary")

my_binary(
    name = "hello",
    srcs = [
        "hello.c",
    ],
)

my_binary(
    name = "hello_bug",
    srcs = [
        # BUG: hello.h does not exist, bazel crashes.
        "hello.h",
        "hello.c",
    ],
)
