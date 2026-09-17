

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

    ddk_copy_to_dist_dir(
        name = "oplus_bsp_mm",
        module_list = [
#            "oplus_bsp_memleak_detect_simple",
#            "oplus_bsp_hybridswap_zram",
        ],
    )
