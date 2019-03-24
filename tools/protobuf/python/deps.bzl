
load("@io_bazel_rules_python//python:pip.bzl", "pip_import")

pip_import(
    name = "protobuf_py_deps",
    requirements = "requirements.txt",
)

load("@protobuf_py_deps//:requirements.bzl", "pip_install")
pip_install()
