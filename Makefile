# SPDX-License-Identifier: GPL-2.0
#
# Makefile for Qlogic 1G/10G Ethernet Driver for CNA devices
#

obj-m := qlcnic.o

qlcnic-y := qlcnic_hw.o qlcnic_main.o qlcnic_init.o \
        qlcnic_ethtool.o qlcnic_ctx.o qlcnic_io.o \
        qlcnic_sysfs.o qlcnic_minidump.o qlcnic_83xx_hw.o \
        qlcnic_83xx_init.o qlcnic_83xx_vnic.o \
        qlcnic_sriov_common.o

ifndef KVER
KVER=$(shell uname -r)
endif

ifndef KMODVER
KMODVER=$(shell git describe HEAD 2>/dev/null || git rev-parse --short HEAD)
endif

buildprep:
	# elfutils-libelf-devel is needed on EL8 systems
	sudo yum install -y gcc kernel-{core,devel,modules}-$(KVER) elfutils-libelf-devel
all:
	make -C /lib/modules/$(KVER)/build M=$(PWD) EXTRA_CFLAGS=-DKMODVER=\\\"$(KMODVER)\\\" modules
clean:
	make -C /lib/modules/$(KVER)/build M=$(PWD) clean
	rm -f spkut
install:
	sudo install -v -m 755 -d /lib/modules/$(KVER)/
	sudo install -v -m 644 qlcnic.ko        /lib/modules/$(KVER)/qlcnic.ko
	sudo depmod -a
