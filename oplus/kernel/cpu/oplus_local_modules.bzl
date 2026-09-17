load(":repo_paths.bzl", "soc_label")
load(":oplus_modules_define.bzl", "define_oplus_ddk_module", "oplus_ddk_get_target", "oplus_ddk_get_variant", "bazel_support_platform")
load(":oplus_modules_dist.bzl", "ddk_copy_to_dist_dir")
load("//build/kernel/kleaf:kernel.bzl", "ddk_headers")
load(":game_opt/oplus_game_opt_local_modules.bzl", "define_oplus_game_opt_local_modules")
load(":geas/oplus_geas_local_modules.bzl", "define_oplus_geas_local_modules")
load(":thermal/oplus_thermal_local_modules.bzl", "define_oplus_thermal_local_modules")

load(":waker_identify/oplus_waker_identify_local_modules.bzl", "define_oplus_waker_identify_local_modules")
load(":sched/oplus_sched_local_modules.bzl", "define_oplus_sched_local_modules")

load(":freq_qos_arbiter/oplus_freq_qos_arbiter_local_modules.bzl", "define_oplus_freq_qos_arbiter_local_modules")

load(":smart_freq/oplus_smartfreq_local_modules.bzl", "define_oplus_smart_freq_local_modules")

def define_oplus_sched_assist_local_modules():
    target = oplus_ddk_get_target()
    variant  = oplus_ddk_get_variant()
    kernel_build_variant = "{}_{}".format(target, variant)

    ddk_headers(
        name = "config_headers",
        hdrs  = native.glob([
            "**/*.h",
            "**/**/*.h",
        ]),
        includes = [".","sched/sched_assist", "sched/frame_boost", "sched_ext"],
    )

    if bazel_support_platform == "qcom" :
        ko_deps = [
        ]
        copts = ["-DCONFIG_SCHED_WALT",
                 "-DCONFIG_OPLUS_FEATURE_POWERMODEL",
                 "-DCONFIG_LOCKING_PROTECT",
                 "-DCONFIG_HMBIRD_SCHED_BPF"]
        kconfig = None
        defconfig = None
        ddk_config = soc_label("{}_config").format(kernel_build_variant)
    else :
        ko_deps = [
        ]
        copts = ["-DCONFIG_OPLUS_FEATURE_POWERMODEL",]
        kconfig = "sched/Kconfig"
        defconfig = "build/defconfig/{}/sched/sched_configs".format(target)
        ddk_config = None

    define_oplus_ddk_module(
        name = "oplus_bsp_sched_assist",
        srcs = native.glob([
            "**/*.h",
            "sched/sched_assist/sched_assist.c",
            "sched/sched_assist/sa_common.c",
            "sched/sched_assist/sa_sysfs.c",
            "sched/sched_assist/sa_exec.c",
            "sched/sched_assist/sa_fair.c",
            "sched/sched_assist/sa_jankinfo.c",
            "sched/sched_assist/sa_oemdata.c",
            "sched/sched_assist/sa_priority.c",
            "sched/sched_assist/sa_hmbird.c",
        ]),
        local_defines = [],
        conditional_srcs = {
            "CONFIG_OPLUS_SCHED_GROUP_OPT": {
                True: ["sched/sched_assist/sa_group.c"],
            },
            "CONFIG_OPLUS_CPU_AUDIO_PERF": {
                True: ["sched/sched_assist/sa_audio.c"],
            },
            "CONFIG_OPLUS_FEATURE_LOADBALANCE": {
                True: ["sched/sched_assist/sa_balance.c"],
            },
            "CONFIG_OPLUS_FEATURE_PIPELINE": {
                True: ["sched/sched_assist/sa_pipeline.c"],
            },
            "CONFIG_BLOCKIO_UX_OPT": {
                True: ["sched/sched_assist/sa_blockio.c"],
            },
            "CONFIG_OPLUS_FEATURE_SCHED_DDL": {
                True: ["sched/sched_assist/sa_ddl.c"],
            },
        },
        conditional_defines = {
            "mtk":  ["CONFIG_OPLUS_SYSTEM_KERNEL_MTK"],
            "qcom": ["CONFIG_OPLUS_SYSTEM_KERNEL_QCOM","CONFIG_SCHED_WALT"],
        },
        ko_deps = ko_deps,
        copts = copts,
        includes = ["."],
        kconfig = kconfig,
        defconfig = defconfig,
        config = ddk_config,
    )

def define_oplus_local_modules():
    define_oplus_sched_assist_local_modules()
    define_oplus_game_opt_local_modules()
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
                "oplus_bsp_geas_cpu",
                "oplus_bsp_geas_system",
                "oplus_bsp_game_opt",
                "oplus_bsp_sched_assist",
                "horae_shell_temp",
                "oplus_bsp_frame_boost",
                "oplus_bsp_task_cpustats",
                "oplus_bsp_waker_identify",
                "oplus_bsp_schedinfo",
                "oplus_bsp_task_load",
                "oplus_bsp_task_sched",
                "osml_monitor",
            ],
        )
    elif (bazel_support_platform == "mtk") and (target == "k6993v1_64") :
        define_oplus_freq_qos_arbiter_local_modules()

        define_oplus_smart_freq_local_modules()
        ddk_copy_to_dist_dir(
            name = "oplus_bsp_cpu",
            module_list = [
                "oplus_bsp_game_opt",
                "oplus_bsp_sched_assist",
                "horae_shell_temp",
                "oplus_bsp_waker_identify",
                "oplus_bsp_task_cpustats",
                "oplus_bsp_schedinfo",
                "oplus_freq_qos_arbiter",
                "oplus_bsp_task_sched",
                "oplus_bsp_smart_freq"
            ],
        )
    else :
        ddk_copy_to_dist_dir(
            name = "oplus_bsp_cpu",
            module_list = [
                "oplus_bsp_game_opt",
                "oplus_bsp_sched_assist",
                "horae_shell_temp",
                "oplus_bsp_waker_identify",
                "oplus_bsp_task_cpustats",
                "oplus_bsp_schedinfo",
                "oplus_bsp_task_sched",
            ],
        )
