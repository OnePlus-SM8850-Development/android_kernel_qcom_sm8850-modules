ifeq ($(call is-board-platform-in-list,pineapple sun canoe), true)
PRODUCT_PACKAGES += qbt_handler.ko
endif
