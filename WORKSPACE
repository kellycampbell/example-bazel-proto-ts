workspace(
    name = "example_ts",
    managed_directories = {"@npm": ["node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# bazel-skylb 0.8.0 released 2019.03.20 (https://github.com/bazelbuild/bazel-skylib/releases/tag/0.8.0)
skylib_version = "0.8.0"
http_archive(
    name = "bazel_skylib",
    type = "tar.gz",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib.{}.tar.gz".format (skylib_version, skylib_version),
    sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
)

# This com_google_protobuf repository is required for proto_library rule.
# It provides the protocol compiler binary (i.e., protoc).
protobuf_version = "3.7.1"
http_archive(
    name = "com_google_protobuf",
    url = "https://github.com/protocolbuffers/protobuf/archive/v{}.zip".format(protobuf_version),
    strip_prefix = "protobuf-{}".format(protobuf_version),
    sha256 = "f976a4cd3f1699b6d20c1e944ca1de6754777918320c719742e1674fcf247b7e",
)
load("@//tools/protobuf:protobuf_deps.bzl", "protobuf_deps")
protobuf_deps()

grpc_version = "1.21.1"
http_archive(
    name = "com_github_grpc_grpc",
    url = "https://github.com/grpc/grpc/archive/v{}.zip".format(grpc_version),
    strip_prefix = "grpc-{}".format(grpc_version),
    sha256 = "650189b5def24f671d18f64dde08b2a90fbf51470502af42a0da4ac2c34e9258",
)

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", com_github_grpc_grpc_bazel_grpc_deps = "grpc_deps")
com_github_grpc_grpc_bazel_grpc_deps()

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "06cb04f4f745e37d542ec6883a2896029715a591c0e44c5d250a268d3752f865",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.32.0/rules_nodejs-0.32.0.tar.gz"],
)

load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories", "yarn_install")
node_repositories(
    package_json = ["//:package.json"],
    node_version = "12.4.0",
    node_repositories = {
        "12.4.0-darwin_amd64": ("node-v12.4.0-darwin-x64.tar.gz", "node-v12.4.0-darwin-x64", "2457811f736d94ee33f94c6cc31cd5463ff526fc7f0d9bcc020c3c605c6077fd"),
        "12.4.0-linux_amd64": ("node-v12.4.0-linux-x64.tar.xz", "node-v12.4.0-linux-x64", "9aec6a2a50c1791704a6069cbda6da62781361e44814d024e8bbaaf0deb41c5e"),
        "12.4.0-windows_amd64": ("node-v12.4.0-win-x64.zip", "node-v12.4.0-win-x64", "ec8623e2528a35d3219200308e7ed41e24d4f7cd96530a4e6ac2513e44f7fad1"),
    },
    # node_urls = ["https://nodejs.org/dist/v{version}/{filename}"],
    yarn_version = "1.16.0",
    yarn_repositories = {
        "1.13.0": ("yarn-v1.13.0.tar.gz", "yarn-v1.13.0", "125d40ebf621ebb08e3f66a618bd2cc5cd77fa317a312900a1ab4360ed38bf14"),
        "1.16.0": ("yarn-v1.16.0.tar.gz", "yarn-v1.16.0", "df202627d9a70cf09ef2fb11cb298cb619db1b958590959d6f6e571b50656029"),
    },
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


local_repository(
    name = "ts_protoc_gen",
    path = "/home/kellyc/Projects/thirdparty/bazel/ts-protoc-gen",
)

# http_archive(
#     name = "ts_protoc_gen",
#     url = "https://github.com/kellycampbell/ts-protoc-gen/archive/42c962af166dc151ddba6cae1ec5d14f1f6e4cc6.zip",
#     strip_prefix = "ts-protoc-gen-42c962af166dc151ddba6cae1ec5d14f1f6e4cc6",
#     sha256 = "ed87689a72b222b0d6381cb4417c482318d2197b847b642e7b271bf690226bf6",
# )

load("@ts_protoc_gen//:defs.bzl", "typescript_proto_dependencies")
typescript_proto_dependencies()

# ========= python ===========
http_archive(
    name = "io_bazel_rules_python",
    url = "https://github.com/bazelbuild/rules_python/archive/965d4b4a63e6462204ae671d7c3f02b25da37941.zip",
    strip_prefix = "rules_python-965d4b4a63e6462204ae671d7c3f02b25da37941",
    sha256 = "dd17de3dcb1a4149604c21a41f0fa0969bd5882189a6350298830d5110600762", # HEAD as of 2019-03-23
)

load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories", "pip_import")
pip_repositories()

pip_import(
    name = "protobuf_py_deps",
    requirements = "//tools/protobuf/python:requirements.txt",
)

load("@protobuf_py_deps//:requirements.bzl", protobuf_py_install = "pip_install")
protobuf_py_install()
