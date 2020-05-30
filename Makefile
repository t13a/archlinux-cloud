PRINT = @echo -e "\e[1;34m"$(1)"\e[0m"

BUILD_DIR := build
TEST_DIR := test
OUT_DIR := out

export CONTAINER_BUILD_DIR := /mnt/build
export CONTAINER_TEST_DIR := /mnt/test
export CONTAINER_OUT_DIR := /mnt/out

CONTAINER_RUN = docker run \
	-e BUILD_DIR=$(CONTAINER_BUILD_DIR) \
	-e TEST_DIR=$(CONTAINER_TEST_DIR) \
	-e OUT_DIR=$(CONTAINER_OUT_DIR) \
	-e PUID=$(shell id -u) \
	-e PGID=$(shell id -g) \
	-e PUSER=$(1) \
	--env-file=$(abspath $(DOTENV)) \
	-i \
	--privileged \
	--rm \
	-t \
	--tmpfs=/run/shm \
	--tmpfs=/tmp:exec \
	-v "$(abspath $(2)):$(3)" \
	-v "$(abspath $(OUT_DIR)):$(CONTAINER_OUT_DIR)" \
	-w "$(3)" \
	$(call CONTAINER_IMAGE,$(1))

INIT_FILES :=
CLEAN_FILES := $(OUT_DIR)

include *.mk

.DEFAULT_GOAL := all
.PHONY: all
all: init build test

.PHON: init
init: $(INIT_FILES)

.PHONY: build
build: build/all

.PHONY: build/%
build/%: build-container $(OUT_DIR)
	$(call PRINT,Starting build container...)
	$(call CONTAINER_RUN,build,$(BUILD_DIR),$(CONTAINER_BUILD_DIR)) make $(MAKEFLAGS) $*
	$(call PRINT,Stopped build container)

.PHONY: test
test: test/all

.PHONY: test/%
test/%: test-container $(OUT_DIR)
	$(call PRINT,Starting test container...)
	$(call CONTAINER_RUN,test,$(TEST_DIR),$(CONTAINER_TEST_DIR)) make $(MAKEFLAGS) $*
	$(call PRINT,Stopped test container)

$(OUT_DIR):
	$(call PRINT,'Creating directory "$@"...')
	mkdir -p $(@)

.PHONY: clean
clean:
	$(call PRINT,Cleaning...)
	docker run \
		--rm \
		-v "$(abspath .):/mnt" \
		-w /mnt \
		archlinux \
		rm -rf $(CLEAN_FILES)
