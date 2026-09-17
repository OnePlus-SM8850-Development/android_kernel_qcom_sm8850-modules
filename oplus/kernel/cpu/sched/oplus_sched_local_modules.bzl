

load(":sched/frame_boost/oplus_frame_boost_local_modules.bzl", "define_oplus_frame_boost_local_modules")
load(":sched/task_cpustats/oplus_task_cpustats_local_modules.bzl", "define_oplus_task_cpustats_local_modules")
load(":sched/sched_info/oplus_sched_info_local_modules.bzl", "define_oplus_sched_info_local_modules")
load(":sched/task_load/oplus_task_load_local_modules.bzl", "define_oplus_task_load_local_modules")
load(":sched/task_sched/oplus_task_sched_local_modules.bzl", "define_oplus_task_sched_local_modules")

def define_oplus_sched_local_modules():
    define_oplus_frame_boost_local_modules()
    define_oplus_task_cpustats_local_modules()
    define_oplus_sched_info_local_modules()
    define_oplus_task_load_local_modules()
    define_oplus_task_sched_local_modules()
