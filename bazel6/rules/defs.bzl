# A simple demonstration of how to construct your own `cc_binary` rule using the
# helpers function in `cc_common`.
load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cc_toolchain")

ToolboxInfo = provider()

def _toolbox(ctx):
    return ToolboxInfo(
        # Doc issue: You'd think you should use ctx.executable.hasher
        # but that doesn't carry the runfiles.  Get the undocumented
        # `files_to_run` provider.
        #hasher = ctx.executable.hasher
        hasher = ctx.attr.hasher.files_to_run
    )

toolbox = rule(
    implementation = _toolbox,
    attrs = {
        "hasher": attr.label(
            cfg = "exec",
            executable = True,
            doc = "Hashing utility",
        ),
    },
)

def _my_binary(ctx):
    cc_toolchain = find_cc_toolchain(ctx)
    features = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    compilation_contexts = [dep[CcInfo].compilation_context for dep in ctx.attr.deps]
    cctx, cout = cc_common.compile(
        name = ctx.attr.name,
        actions = ctx.actions,
        feature_configuration = features,
        cc_toolchain = cc_toolchain,
        compilation_contexts = compilation_contexts,
        srcs = ctx.files.srcs,
        # FIXME: make_var/location substitution needed:
        user_compile_flags = ctx.attr.copts,
        defines = ctx.attr.defines,
        local_defines = ctx.attr.local_defines,
        quote_includes = ctx.attr.includes,
    )

    linking_contexts = [dep[CcInfo].linking_context for dep in ctx.attr.deps]

    # Just a bit of fun: emit a mapfile.
    mapfile = ctx.actions.declare_file("{}.map".format(ctx.attr.name))

    lout = cc_common.link(
        name = ctx.attr.name,
        actions = ctx.actions,
        feature_configuration = features,
        cc_toolchain = cc_toolchain,
        compilation_outputs = cout,
        linking_contexts = linking_contexts,
        # FIXME: make_var/location substitution needed:
        user_link_flags = ctx.attr.linkopts + [
            "-Wl,-Map={}".format(mapfile.path),
        ],
        additional_outputs = [mapfile],
    )

    extra = []
    if ctx.attr.toolbox:
        toolbox = ctx.attr.toolbox[ToolboxInfo]
        hashfile = ctx.actions.declare_file("{}.hash".format(ctx.attr.name))
        ctx.actions.run(
            outputs = [hashfile],
            inputs = [lout.executable],
            arguments = [
                lout.executable.path,
                hashfile.path,
            ],
            executable = toolbox.hasher,
        )
        extra.append(hashfile)

    return [
        DefaultInfo(
            files = depset([lout.executable] + extra),
        ),
    ]

my_binary = rule(
    implementation = _my_binary,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [[CcInfo]]),
        "copts": attr.string_list(),
        "defines": attr.string_list(),
        "local_defines": attr.string_list(),
        "includes": attr.string_list(),
        "linkopts": attr.string_list(),
        "toolbox": attr.label(
            providers = [ToolboxInfo],
            doc = "Extra tools to run during compilation",
        ),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    fragments = ["cpp"],
    toolchains = ["@rules_cc//cc:toolchain_type"],
)
