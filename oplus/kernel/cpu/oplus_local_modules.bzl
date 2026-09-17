load(":oplus_modules_define.bzl", "oplus_ddk_get_target", "bazel_support_platform")
load(":oplus_modules_dist.bzl", "ddk_copy_to_dist_dir")
load("//build/kernel/kleaf:kernel.bzl", "ddk_headers")

load(":geas/oplus_geas_local_modules.bzl", "define_oplus_geas_local_modules")
load(":thermal/oplus_thermal_local_modules.bzl", "define_oplus_thermal_local_modules")

load(":waker_identify/oplus_waker_identify_local_modules.bzl", "define_oplus_waker_identify_local_modules")
load(":sched/oplus_sched_local_modules.bzl", "define_oplus_sched_local_modules")

load(":freq_qos_arbiter/oplus_freq_qos_arbiter_local_modules.bzl", "define_oplus_freq_qos_arbiter_local_modules")

def define_oplus_sched_assist_local_modules():
    target = oplus_ddk_get_target()

    ddk_headers(
        name = "config_headers",
        hdrs  = native.glob([
            "**/*.h",
            "**/**/*.h",
        ]),
        includes = [".","sched/sched_assist", "sched/frame_boost", "sched_ext"],
    )

def define_oplus_local_modules():
    define_oplus_sched_assist_local_modules()

    define_oplus_geas_local_modules()
    define_oplus_thermal_local_modules()

    define_oplus_waker_identify_local_modules()

    define_oplus_sched_local_modules()

#for platform only
    target = oplus_ddk_get_target()
    if bazel_support_platform == "qcom" :

        ddk_copy_to_dist_dir(
            name = "oplus_bsp_cpu",
            module_list = [
                "horae_shell_temp",
                "oplus_bsp_waker_identify",
            ],
        )
    elif (bazel_support_platform == "mtk") and (target == "k6993v1_64") :
        define_oplus_freq_qos_arbiter_local_modules()

        ddk_copy_to_dist_dir(
            name = "oplus_bsp_cpu",
            module_list = [
                "horae_shell_temp",
                "oplus_bsp_waker_identify",
                "oplus_freq_qos_arbiter",
            ],
        )
    else :
        ddk_copy_to_dist_dir(
            name = "oplus_bsp_cpu",
            module_list = [
                "horae_shell_temp",
                "oplus_bsp_waker_identify",
            ],
        )
