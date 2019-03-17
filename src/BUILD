package(default_visibility = ["//visibility:public"])

load("@build_bazel_rules_nodejs//:defs.bzl", "nodejs_binary")
load("@npm_bazel_typescript//:index.bzl", "ts_library")


ts_library(
    name = "hello_ts",
    srcs = glob(["*.ts"]),
    deps = [
        "//protos:hello_proto_ts",
        "@npm//@types/google-protobuf",
        "@npm//@types/node",
    ],
)

nodejs_binary(
    name = "hello",
    data = [
        ":hello_ts",
        "@npm//google-protobuf",
    ],
    # node_modules = "@npm//:node_modules",
    entry_point = "example_ts/src/hello.js",
)
