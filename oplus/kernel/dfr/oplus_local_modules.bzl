load(":repo_paths.bzl", "modules_label")

load(":oplus_modules_define.bzl", "define_oplus_ddk_module", "bazel_support_platform")
load(":oplus_modules_dist.bzl", "ddk_copy_to_dist_dir")

def define_oplus_local_modules():

    if bazel_support_platform == "qcom" :
        combkey_monitor_ko_deps = [
            modules_label("oplus/kernel/dfr:oplus_bsp_dfr_keyevent_handler"),
            modules_label("oplus/kernel/dft/bazel:oplus_bsp_dft_kernel_fb"),
        ]

        shutdown_detect_ko_deps = [
            modules_label("oplus/kernel/boot:oplus_bsp_boot_projectinfo"),
        ]

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_combkey_monitor",
        srcs = native.glob([
            "**/*.h",
            "common/combkey_monitor/combkey_monitor.c",
        ]),
        includes = ["."],
        ko_deps = combkey_monitor_ko_deps,
        local_defines = ["CONFIG_OPLUS_FEATURE_KEYEVENT_HANDLER"],
    )

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_keyevent_handler",
        srcs = native.glob([
            "**/*.h",
            "common/keyevent_handler/keyevent_handler.c",
        ]),
        includes = ["."],
    )

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_shutdown_detect",
        srcs = native.glob([
            "**/*.h",
            "common/shutdown_detect/shutdown_detect.c",
        ]),
        includes = ["."],
        ko_deps = shutdown_detect_ko_deps,
        local_defines = ["CONFIG_OPLUS_FEATURE_SHUTDOWN_DETECT"],
    )

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_pmic_monitor",
        srcs = native.glob([
            "**/*.h",
        ]),
        conditional_srcs = {
            "CONFIG_OPLUS_DDK_MTK": {
                False: ["qcom/qcom_pmic_monitor/oplus_pmic_info_smem.c",
                "qcom/qcom_pmic_monitor/main.c",
                "qcom/qcom_pmic_monitor/oplus_pmic_machine_state.c",
                "qcom/qcom_pmic_monitor/oplus_ocp_dev.c",
                "qcom/qcom_pmic_monitor/oplus_ocp_state_nvmem.c"],
            }
        },
        includes = ["."],
    )

    ddk_copy_to_dist_dir(
        name = "oplus_bsp_dfr",
        module_list = [
            "oplus_bsp_dfr_combkey_monitor",
            "oplus_bsp_dfr_keyevent_handler",
            "oplus_bsp_dfr_shutdown_detect",
            "oplus_bsp_dfr_pmic_monitor",
        ],
    )
