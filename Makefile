PRINT = @echo -e "\e[1;34m"$(1)"\e[0m"

BUILD_DIR := build
TEST_DIR := test
OUT_DIR := out

export CONTAINER_BUILD_DIR := /build
export CONTAINER_TEST_DIR := /test
export CONTAINER_OUT_DIR := /out
export CONTAINER_DOTENV := /.env
export CONTAINER_DOTENV_SCRIPT := /dotenv.sh

CONTAINER_RUN = docker run \
	-e BUILD_DIR=$(CONTAINER_BUILD_DIR) \
	-e TEST_DIR=$(CONTAINER_TEST_DIR) \
	-e OUT_DIR=$(CONTAINER_OUT_DIR) \
	-e DOTENV=$(CONTAINER_DOTENV) \
	-e DOTENV_SCRIPT=$(CONTAINER_DOTENV_SCRIPT) \
	-e PUID=$(shell id -u) \
	-e PGID=$(shell id -g) \
	-e PUSER=$(1) \
	-i \
	--privileged \
	--rm \
	-t \
	--tmpfs=/run/shm \
	--tmpfs=/tmp:exec \
	-v "$(abspath $(DOTENV)):$(CONTAINER_DOTENV)" \
	-v "$(abspath $(DOTENV_SCRIPT)):$(CONTAINER_DOTENV_SCRIPT)" \
	-v "$(abspath $(2)):$(3)" \
	-v "$(abspath $(OUT_DIR)):$(CONTAINER_OUT_DIR)" \
	-w "$(3)" \
	$(call CONTAINER_IMAGE,$(1)) \
	$(CONTAINER_DOTENV_SCRIPT)

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
		-v "$(abspath .):/work" \
		-w /work \
		archlinux \
		rm -rf $(CLEAN_FILES)
