#
# Makefile for kernel data.
#

ifeq ($(CONFIG_ARCH_BENGAL), y)
include $(srctree)/techpack/data/config/bengal.conf
endif

ifeq ($(CONFIG_ARCH_BENGAL), y)
LINUXINCLUDE    += -include $(srctree)/techpack/data/config/bengal.h
endif

obj-y += drivers/emac-dwc-eqos/
obj-y += drivers/rmnet/perf/
obj-y += drivers/rmnet/shs/ 
