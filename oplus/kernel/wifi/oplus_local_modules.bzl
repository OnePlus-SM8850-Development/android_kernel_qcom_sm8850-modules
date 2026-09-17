
load("//build/kernel/kleaf:kernel.bzl", "ddk_headers")
load(":oplus_modules_define.bzl", "oplus_ddk_get_target", "oplus_ddk_get_kernel_version", "bazel_support_platform")
load(":oplus_modules_dist.bzl", "ddk_copy_to_dist_dir")

def version_compare(v1, v2):
    v1_parts = [int(x) for x in v1.split(".")]
    v2_parts = [int(x) for x in v2.split(".")]
    return v1_parts >= v2_parts

def define_oplus_local_modules():

    #only for MTK platform, and kernel >= 6.10
    #compiling of version will be failed without mentioned rule
    #for lower kernel version of MTK, use Makefile instead
    if bazel_support_platform == "mtk" :

        kernel_version = oplus_ddk_get_kernel_version()
        print("kernel version: " + kernel_version)

        module_list = [
        ]

    else :
        module_list = [
        ]

        # QCOM only: used to form labels in the configured SoC repository.
        if bazel_support_platform == "qcom" :

            target = oplus_ddk_get_target()

            if target == "canoe":

                module_list = module_list + [
                ]

    ddk_headers(
        name = "config_headers",
        hdrs = native.glob([
            "**/*.h",
        ]) + [
            "wonder/Makefile.include",
        ],
    )

    ddk_copy_to_dist_dir(
        name = "oplus_wifi",
        module_list = module_list,
    )
