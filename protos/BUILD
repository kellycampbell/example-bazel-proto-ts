package(default_visibility = ["//visibility:public"])

load("@ts_protoc_gen//:defs.bzl", "typescript_proto_library")
load("//tools/protobuf/python:python_proto_library.bzl", "python_proto_library", "python_grpc_library")


proto_library(
    name = "hello_proto",
    srcs = [
        "hello.proto",
        "greeting.proto",
    ],
    deps =  [
        "@com_google_protobuf//:timestamp_proto",
    ]
)

typescript_proto_library(
    name = "hello_proto_ts",
    proto = ":hello_proto",
    module = "commonjs",
)

python_grpc_library(
    name = "hello_proto_grpc_py",
    proto = ":hello_proto",
)


python_proto_library(
    name = "hello_proto_py",
    proto = ":hello_proto",
)