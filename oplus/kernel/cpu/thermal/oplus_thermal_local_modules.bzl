load(":repo_paths.bzl", "modules_label")
load("//build/kernel/kleaf:kernel.bzl", "ddk_headers")
load(":oplus_modules_define.bzl", "define_oplus_ddk_module")
load(":oplus_modules_dist.bzl", "ddk_copy_to_dist_dir")

def define_oplus_thermal_local_modules():

    define_oplus_ddk_module(
        name = "horae_shell_temp",
        srcs = native.glob([
            "**/*.h",
            "thermal/horae_shell_temp.c",
        ]),
        includes = ["."],
    )

#
