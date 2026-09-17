load("//build/kernel/kleaf:kernel.bzl", "ddk_module")
load("@rules_pkg//pkg:install.bzl", "pkg_install")
load("@rules_pkg//pkg:mappings.bzl", "pkg_files", "strip_prefix")

def define_basic_modules(targets, variants):
    for t in targets:
        for v in variants:
            define_modules(t, v)

def define_modules(target, variant):
    tv = "{}_{}".format(target, variant)
    rule_base = "{}_qbt_handler".format(tv)

    ddk_deps = select({
        "//build/qcom_build_extensions:qtisocrepo_true": ["//soc-repo:all_headers"],
        "//build/qcom_build_extensions:qtisocrepo_false": ["//msm-kernel:all_headers"],
    })
    base_kernel = select({
        "//build/qcom_build_extensions:qtisocrepo_true": "//soc-repo:{}_base_kernel".format(tv),
        "//build/qcom_build_extensions:qtisocrepo_false": "//msm-kernel:{}".format(tv),
    })

    ddk_module(
        name = rule_base,
        out = "qbt_handler.ko",
        deps = ddk_deps,
        srcs = [
            "qbt_handler.c",
            "qbt_handler.h"
        ],
        includes = ["include/linux"],
        kernel_build = base_kernel,
        visibility = ["//visibility:public"]
    )

    pkg_files(
        name = rule_base + "_dist_files",
        srcs = [":{}".format(rule_base)],
        visibility = ["//visibility:private"],
        strip_prefix = strip_prefix.files_only(),
    )

    pkg_install(
        name = "{}_dist".format(rule_base),
        srcs = [":{}_dist_files".format(rule_base)],
        destdir = "../out/target/product/{}/dlkm/lib/modules/".format(target),
    )
