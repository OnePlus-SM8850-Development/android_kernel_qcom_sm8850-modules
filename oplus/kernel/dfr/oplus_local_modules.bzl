load(":repo_paths.bzl", "modules_label", "soc_label")

load(":oplus_modules_define.bzl", "define_oplus_ddk_module", "oplus_ddk_get_target", "oplus_ddk_get_variant", "bazel_support_platform")
load(":oplus_modules_dist.bzl", "ddk_copy_to_dist_dir")

def define_oplus_local_modules():
    target = oplus_ddk_get_target()
    variant  = oplus_ddk_get_variant()
    kernel_build_variant = "{}_{}".format(target, variant)

    if bazel_support_platform == "qcom" :
        combkey_monitor_ko_deps = [
            modules_label("oplus/kernel/dfr:oplus_bsp_dfr_keyevent_handler"),
            modules_label("oplus/kernel/dfr:oplus_bsp_dfr_theia"),
            modules_label("oplus/kernel/dft/bazel:oplus_bsp_dft_kernel_fb"),
        ]

        shutdown_detect_ko_deps = [
            modules_label("oplus/kernel/boot:oplus_bsp_boot_projectinfo"),
        ]
        theia_ko_deps = [
            soc_label("{}/drivers/soc/qcom/panel_event_notifier").format(kernel_build_variant)
        ]
        dump_device_info_ko_deps = [
            modules_label("oplus/kernel/boot:oplus_bsp_boot_projectinfo"),
            modules_label("oplus/kernel/boot:oplusboot"),
            soc_label("{}/drivers/soc/qcom/debug_symbol").format(kernel_build_variant),
        ]

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_combkey_monitor",
        srcs = native.glob([
            "**/*.h",
            "common/combkey_monitor/combkey_monitor.c",
        ]),
        includes = ["."],
        ko_deps = combkey_monitor_ko_deps,
        local_defines = ["CONFIG_OPLUS_FEATURE_THEIA","CONFIG_OPLUS_FEATURE_KEYEVENT_HANDLER"],
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
        local_defines = ["CONFIG_OPLUS_FEATURE_SHUTDOWN_DETECT","CONFIG_OPLUS_BSP_DFR_USERSPACE_BACKTRACE"],
    )

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_ubt",
        srcs = native.glob([
            "**/*.h",
            "common/oplus_bsp_dfr_ubt/oplus_bsp_dfr_ubt.c",
        ]),
        includes = ["."],
    )

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_theia",
        srcs = native.glob([
            "**/*.h",
            "common/theia/black_screen_check.c",
            "common/theia/bright_screen_check.c",
            "common/theia/theia_kevent_kernel.c",
            "common/theia/powerkey_monitor.c",
            "common/theia/theia_send_event.c",
        ]),
        conditional_defines = {
            "qcom": ["CONFIG_QCOM_PANEL_EVENT_NOTIFIER"],
        },
        includes = ["."],
        ko_deps = theia_ko_deps,
        local_defines = ["CONFIG_OPLUS_FEATURE_THEIA_MODULE"],
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

    define_oplus_ddk_module(
        name = "oplus_bsp_dfr_dump_device_info",
        srcs = native.glob([
            "**/*.h",
            "qcom/dump_device_info/dump_device_info.c",
        ]),
        ko_deps = dump_device_info_ko_deps,
        includes = ["."],
    )

    define_oplus_ddk_module(
        name = "oplus_inject",
        srcs = native.glob([
            "**/*.h",
            "fault_inject/common/oplus_inject_hook.c",
            "fault_inject/common/oplus_inject_proc.c",
        ]),
        includes = ["."],
        conditional_build = {
            "OPLUS_FEATURE_BSP_DRV_INJECT_TEST": "1",
        },
    )

    define_oplus_ddk_module(
        name = "mtk_wdt",
        srcs = native.glob([
            "**/**/*.h",
            "qcom/mtk_wdt/mtk_wdt.c",
        ]),
        includes = ["."],
        local_defines = ["CONFIG_OPLUS_MTK_WDT"],
    )

    ddk_copy_to_dist_dir(
        name = "oplus_bsp_dfr",
        module_list = [
            "oplus_bsp_dfr_combkey_monitor",
            "oplus_bsp_dfr_keyevent_handler",
            "oplus_bsp_dfr_shutdown_detect",
            "oplus_bsp_dfr_ubt",
            "oplus_bsp_dfr_theia",
            "oplus_bsp_dfr_pmic_monitor",
            "oplus_bsp_dfr_dump_device_info",
            "oplus_inject",
            "mtk_wdt",
        ],
        conditional_builds = {"oplus_inject": {
                "OPLUS_FEATURE_BSP_DRV_INJECT_TEST": "1",
            }},
    )
