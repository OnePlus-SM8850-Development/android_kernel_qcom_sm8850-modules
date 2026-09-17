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

#    define_oplus_ddk_module(
#        name = "thermal_pa_adc",
#        srcs = native.glob([
#            "**/*.h",
#            "thermal_pa_adc.c",
#        ]),
#         includes = ["."],
#    )
#
#    define_oplus_ddk_module(
#        name = "oplus_ipa_thermal",
#        srcs = native.glob([
#            "**/*.h",
#            "oplus_ipa_thermal.c",
#        ]),
#        ko_deps = [
#            modules_label("oplus/kernel/cpu/thermal:horae_shell_temp"),
#        ],
#        includes = ["."],
#    )
