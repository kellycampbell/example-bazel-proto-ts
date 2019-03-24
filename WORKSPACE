workspace(name = "example_ts")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    url = "https://github.com/bazelbuild/bazel-skylib/archive/0.7.0.tar.gz",
    strip_prefix = "bazel-skylib-0.7.0",
    sha256 = "2c62d8cd4ab1e65c08647eb4afe38f51591f43f7f0885e7769832fa137633dcb",
)

# This com_google_protobuf repository is required for proto_library rule.
# It provides the protocol compiler binary (i.e., protoc).
http_archive(
    name = "com_google_protobuf",
    url = "https://github.com/protocolbuffers/protobuf/archive/v3.7.0.zip",
    strip_prefix = "protobuf-3.7.0",
    sha256 = "b50be32ea806bdb948c22595ba0742c75dc2f8799865def414cf27ea5706f2b7",
)
load("@//tools/protobuf:protobuf_deps.bzl", "protobuf_deps")
protobuf_deps()

http_archive(
    name = "com_github_grpc_grpc",
    url = "https://github.com/grpc/grpc/archive/v1.19.1.zip",
    strip_prefix = "grpc-1.19.1",
    sha256 = "1efc6ee83ea0f1205a6f7b30db2bb1463fbe00016563ffa9e944d32b612197cb",
)

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", com_github_grpc_grpc_bazel_grpc_deps = "grpc_deps")
com_github_grpc_grpc_bazel_grpc_deps()

http_archive(
    name = "build_bazel_rules_nodejs",
    url = "https://github.com/bazelbuild/rules_nodejs/releases/download/0.27.5/rules_nodejs-0.27.5.tar.gz",
    sha256 = "02506a501974b6803e9756a4e655f2e1e79d2eafa474154e83b07289f3abab0d",
)

load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories", "yarn_install")
node_repositories(
    package_json = ["//:package.json"],
    node_version = "11.12.0",
    node_repositories = {
        "11.12.0-darwin_amd64": ("node-v11.12.0-darwin-x64.tar.gz", "node-v11.12.0-darwin-x64", "93d68c1af41d02b262b3383d69b46eb326707ec010b321ad5655b91c4956e783"),
        "11.12.0-linux_amd64": ("node-v11.12.0-linux-x64.tar.xz", "node-v11.12.0-linux-x64", "1c6bb93a24eda832708c1c10ec20316e1e4f30b3cfca9c5ee5d446762414b116"),
        "11.12.0-windows_amd64": ("node-v11.12.0-win-x64.zip", "node-v11.12.0-win-x64", "68e5bca1d6dd6b3de20870e7c593f9a890c48d2c9c83e15034baad6f7c0da426"),
  },
  node_urls = ["https://nodejs.org/dist/v{version}/{filename}"],
)
yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")
install_bazel_dependencies()

# Setup TypeScript toolchain 
load("@npm_bazel_typescript//:index.bzl", "ts_setup_workspace")
ts_setup_workspace()


# local_repository(
#     name = "ts_protoc_gen",
#     path = "/home/kellyc/Projects/thirdparty/bazel/ts-protoc-gen",
# )

http_archive(
    name = "ts_protoc_gen",
    url = "https://github.com/kellycampbell/ts-protoc-gen/archive/0c2c88f14cbca39bd95199fe1e043241e9f715dc.zip",
    strip_prefix = "ts-protoc-gen-0c2c88f14cbca39bd95199fe1e043241e9f715dc",
    sha256 = "ab796dca4b3df5a86399d8c1335b0824f5108b2d2edb782ea0a93c3a125aa40c",
)

load("@ts_protoc_gen//:defs.bzl", "typescript_proto_dependencies")
typescript_proto_dependencies()

# ========= python ===========
http_archive(
    name = "io_bazel_rules_python",
    url = "https://github.com/bazelbuild/rules_python/archive/965d4b4a63e6462204ae671d7c3f02b25da37941.zip",
    strip_prefix = "rules_python-965d4b4a63e6462204ae671d7c3f02b25da37941",
    sha256 = "dd17de3dcb1a4149604c21a41f0fa0969bd5882189a6350298830d5110600762",
)

load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories")
pip_repositories()
