load("@protobuf_py_deps//:requirements.bzl", protobuf_py_requirement = "requirement")

PythonProtoLibraryAspect = provider(
    fields = {
        "py_outputs": "The python output files produced directly from the src protos",
        "deps_py": "The transitive python dependencies",
    },
)


def proto_path(proto):
    """
    The proto path is not really a file path
    It's the path to the proto that was seen when the descriptor file was generated.
    """
    path = proto.path
    root = proto.root.path
    ws = proto.owner.workspace_root
    if path.startswith(root):
        path = path[len(root):]
    if path.startswith("/"):
        path = path[1:]
    if path.startswith(ws):
        path = path[len(ws):]
    if path.startswith("/"):
        path = path[1:]
    return path


def append_to_outputs(ctx, src, file_name, py_outputs):
    generated_filenames = ["_pb2.py"]
    if ctx.attr.grpc == "true":
        generated_filenames.append("_pb2_grpc.py")

    for f in generated_filenames:
        output = ctx.actions.declare_file(file_name + f, sibling=src)
        # print("src = %s declare output: %s" % (src, output))
        py_outputs.append(output)


def python_proto_library_aspect_(target, ctx):
    """
    A bazel aspect that is applied on every proto_library rule on the transitive set of dependencies
    of a python_proto_library rule.

    Handles running protoc to produce the generated pb2.py files.
    """
    py_outputs = []
    proto_inputs = []

    inputs = depset([ctx.file._protoc])
    for src in target.proto.direct_sources:
        if src.extension != "proto":
            fail("Input must be a proto file")

        file_name = src.basename[:-len(src.extension) - 1]
        normalized_file = proto_path(src)
        proto_inputs.append(normalized_file)
        append_to_outputs(ctx, src, file_name, py_outputs)

    outputs = py_outputs

    if ctx.attr.grpc == "true":
        inputs += ctx.files._grpc_python_plugin

    inputs += target.proto.direct_sources
    inputs += target.proto.transitive_descriptor_sets

    descriptor_sets_paths = [desc.path for desc in target.proto.transitive_descriptor_sets]

    parts = ctx.build_file_path.split("/")
    if len(parts) > 1 and parts[0] == 'external':
        build_dir = "/" + "/".join(parts[:-1])
    else:
        # build_dir = "/" + "/".join(parts[:-1])
        build_dir = ""

    protoc_output_dir = ctx.bin_dir.path + build_dir

    protoc_command = "%s" % (ctx.file._protoc.path)

    if ctx.attr.grpc == "true":
        protoc_command += " --plugin=protoc-gen-grpc_python=%s" % (ctx.files._grpc_python_plugin[0].path)
        protoc_command += " --grpc_python_out=%s" % (protoc_output_dir)
    protoc_command += " --python_out=%s" % (protoc_output_dir)
    protoc_command += " --descriptor_set_in=%s" % (":".join(descriptor_sets_paths))
    protoc_command += " %s" % (" ".join(proto_inputs))

    commands = ["pwd", protoc_command]

    command = " && ".join(commands)
    ctx.actions.run_shell(
        inputs = inputs,
        outputs = outputs,
        progress_message = "Creating Python pb files %s" % ctx.label,
        command = command,
    )

    py_outputs = depset(py_outputs)
    deps_py = depset([])

    for dep in ctx.rule.attr.deps:
        aspect_data = dep[PythonProtoLibraryAspect]
        deps_py += aspect_data.py_outputs + aspect_data.deps_py

    return [PythonProtoLibraryAspect(
        py_outputs = py_outputs,
        deps_py = deps_py,
    )]

python_proto_library_aspect = aspect(
    implementation = python_proto_library_aspect_,
    attr_aspects = ["deps"],
    attrs = {
        "grpc": attr.string(values = ["true", "false"], default = "false"),
        "_grpc_python_plugin": attr.label(
            allow_files = True,
            executable = True,
            cfg = "host",
            default = Label("@com_github_grpc_grpc//:grpc_python_plugin"),
        ),
        "_protoc": attr.label(
            # allow_files = True,
            allow_single_file = True,
            executable = True,
            cfg = "host",
            default = Label("@com_google_protobuf//:protoc"),
        ),
    },
)


def _python_proto_library_impl(ctx):
    """
    Handles converting the aspect output into a provider compatible with the rules_python rules.
    """
    aspect_data = ctx.attr.proto[PythonProtoLibraryAspect]
    py_outputs = aspect_data.py_outputs
    outputs = py_outputs

    return struct(
        python = struct(
        ),
        legacy_info = struct(
            files = outputs,
        ),
        providers = [
            DefaultInfo(files = outputs),
        ],
    )

python_proto_compile = rule(
    attrs = {
        "proto": attr.label(
            mandatory = True,
            # allow_files = True,
            allow_single_file = True,
            providers = ["proto"],
            aspects = [python_proto_library_aspect],
        ),
        "grpc": attr.string(values = ["true", "false"], default = "true"),
    },
    implementation = _python_proto_library_impl,
)

python_grpc_compile = rule(
    attrs = {
        "proto": attr.label(
            mandatory = True,
            # allow_files = True,
            allow_single_file = True,
            providers = ["proto"],
            aspects = [python_proto_library_aspect],
        ),
        "grpc": attr.string(values = ["true", "false"], default = "true"),
    },
    implementation = _python_proto_library_impl,
)


def python_proto_library(**kwargs):
    name = kwargs.get("name")
    deps = kwargs.get("deps", [])
    proto = kwargs.get("proto")

    name_pb = name + "_pb"
    python_proto_compile(
        name = name_pb,
        proto = proto,
    )

    native.py_library(
        name = name,
        srcs = [name_pb],
        deps = depset(deps + [protobuf_py_requirement("protobuf")]).to_list(),
        # This magically adds REPOSITORY_NAME/PACKAGE_NAME/{name_pb} to PYTHONPATH
        imports = [name_pb],
    )


def python_grpc_library(**kwargs):
    name = kwargs.get("name")
    deps = kwargs.get("deps", [])
    proto = kwargs.get("proto")

    name_pb = name + "_pb"
    python_grpc_compile(
        name = name_pb,
        proto = proto,
    )

    native.py_library(
        name = name,
        srcs = [name_pb],
        deps = depset(deps + [protobuf_py_requirement("protobuf"), protobuf_py_requirement("grpcio")]).to_list(),
        # This magically adds REPOSITORY_NAME/PACKAGE_NAME/{name_pb} to PYTHONPATH
        imports = [name_pb],
    )

