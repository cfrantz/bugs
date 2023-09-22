package(default_visibility = ["//visibility:public"])

load("//rules:defs.bzl", "my_binary", "toolbox")

toolbox(
    name = "tools",
    hasher = "//tools:sha256",
)

my_binary(
    name = "goodbye",
    srcs = [
        "goodbye.c",
    ],
    # BUG: The runfiles dir for `//tools:sha256` doesn't get built.
    toolbox = ":tools",
)
