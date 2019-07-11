OUT_DIR := /out
SRC_DIR := /src
WORK_DIR := /work

ARCHLIVE_DIR := $(SRC_DIR)/archlive
ARCHLIVE_WORK_DIR := $(WORK_DIR)/archlive
ARCHLIVE_DONE := $(ARCHLIVE_WORK_DIR)/archlive.done

export REPO_NAME := repo
export REPO_DIR := $(WORK_DIR)/repo
REPO_DONE := $(REPO_DIR)/repo.done

PRINT = @echo -e "\e[1;34m"[src] $(1)"\e[0m"

.PHONY: all
all: iso

include iso.mk

include repo.mk

include archlive.mk

.PHONY: clean
clean: $(CLEAN_TARGETS)

.PHONY: exec
exec:
	bash
