

load(":oplus_modules_define.bzl", "define_oplus_ddk_module")
load(":oplus_modules_dist.bzl", "ddk_copy_to_dist_dir")

def define_oplus_local_modules():

#    define_oplus_ddk_module(
#        name = "oplus_bsp_memleak_detect_simple",
#        srcs = native.glob([
#            "**/*.h",
#            "memleak_detect/slub_track_simple.c",
#            "memleak_detect/vmalloc_track_simple.c",
#        ]),
#        includes = ["."],
#        )
#

    define_oplus_ddk_module(
        name = "oplus_bsp_mm_osvelte",
        srcs = native.glob([
            "mm_osvelte/common.c",
            "mm_osvelte/logger.c",
            "mm_osvelte/lowmem-dbg.c",
            "mm_osvelte/mm-config.c",
            "mm_osvelte/proc-memstat.c",
            "mm_osvelte/sys-ashmem.c",
            "mm_osvelte/sys-dmabuf.c",
            "mm_osvelte/sys-memstat.c",
            "mm_osvelte/vsprintf-dup.c",
            "mm_osvelte/common.h",
            "mm_osvelte/internal.h",
            "mm_osvelte/logger.h",
            "mm_osvelte/lowmem-dbg.h",
            "mm_osvelte/memstat.h",
            "mm_osvelte/mm-config.h",
            "mm_osvelte/mm-trace.h",
            "mm_osvelte/proc-memstat.h",
            "mm_osvelte/sys-memstat.h",
            "mm_osvelte/mm-hooks.h",
            "mm_osvelte/hooks.c",
        ]),
        includes = ["."],
        conditional_defines = {
            "qcom":  [ "CONFIG_OPLUS_VENDOR_QCOM" ],
            "mtk": [ "CONFIG_OPLUS_VENDOR_MTK" ],
        },
        local_defines = ["CONFIG_OPLUS_FEATURE_MM_BOOSTPOOL"],
    )

    ddk_copy_to_dist_dir(
        name = "oplus_bsp_mm",
        module_list = [
#            "oplus_bsp_memleak_detect_simple",
#            "oplus_bsp_hybridswap_zram",
            "oplus_bsp_mm_osvelte",
        ],
    )
