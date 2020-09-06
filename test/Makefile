PRINT = @echo -e "\e[1;34m"[test] $(1)"\e[0m"

export PATH := $(PATH):$(TEST_DIR)/scripts
export OUT_ISO := $(OUT_DIR)/$(ISO_NAME)-$(ISO_VERSION)-x86_64.iso
export BOOT_TIMEOUT_SECS := 1200
export CASE_TIMEOUT_SECS := 120
export SSH_FORWARD_PORT := 2222
export QEMU_NAME := $(ISO_NAME)
export QEMU_SMP := 1
export QEMU_MEM := 1024
export QEMU_NIC := user,hostfwd=tcp::$(SSH_FORWARD_PORT)-:22
export QEMU_SERIAL_SOCKET := /run/qemu-serial@$(QEMU_NAME).socket
export QEMU_SERIAL := unix:$(QEMU_SERIAL_SOCKET),server,nowait
export QEMU_MONITOR_SOCKET := /run/qemu-monitor@$(QEMU_NAME).socket
export QEMU_MONITOR := unix:$(QEMU_MONITOR_SOCKET),server,nowait
export QEMU_PIDFILE := /run/qemu@$(QEMU_NAME).pid

include *.mk

.DEFAULT_GOAL := all
.PHONY: all
all: e2e
