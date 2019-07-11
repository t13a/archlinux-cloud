OUT_DIR := /out
TEST_DIR := /test
WORK_DIR := /work

PATH := $(PATH):$(TEST_DIR)/bin

ISO_NAME := $(or $(ISO_NAME),archlinux-cloud)
ISO_VERSION := $(or $(ISO_VERSION),$(shell date +%Y.%m.%d))
export ISO := $(OUT_DIR)/$(ISO_NAME)-$(ISO_VERSION)-x86_64.iso

CIDATA_DIR := $(WORK_DIR)/cidata
export CIDATA_ISO := $(CIDATA_DIR)/cidata.iso

SSH_KEY_DIR := $(WORK_DIR)/ssh-key
export SSH_KEY := $(SSH_KEY_DIR)/id_rsa
export SSH_KEY_PUB := $(SSH_KEY).pub

export SSH_FORWARD_PORT := 2222

export QEMU_SMP := 1
export QEMU_MEM := 512
export QEMU_NAME := $(ISO_NAME)
export QEMU_NIC := user,hostfwd=tcp::$(SSH_FORWARD_PORT)-:22
export QEMU_SERIAL_SOCKET := /run/qemu-serial@$(QEMU_NAME).socket
export QEMU_SERIAL := unix:$(QEMU_SERIAL_SOCKET),server,nowait
export QEMU_MONITOR_SOCKET := /run/qemu-monitor@$(QEMU_NAME).socket
export QEMU_MONITOR := unix:${QEMU_MONITOR_SOCKET},server,nowait
export QEMU_PIDFILE := /run/qemu@$(QEMU_NAME).pid

export WAIT_TIMEOUT_SECS := $(or $(WAIT_TIMEOUT_SECS),1200)

PRINT = @echo -e "\e[1;34m"[test] $(1)"\e[0m"

.PHONY: all
all: e2e

include e2e.mk

include cidata.mk

include ssh-key.mk

.PHONY: clean
clean: $(CLEAN_TARGETS)

.PHONY: exec
exec:
	bash
