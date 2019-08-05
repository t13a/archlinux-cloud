OUT_DIR := out
SRC_DIR := src
TEST_DIR := test
WORK_DIR := work

ISO_NAME := archlinux-cloud
ISO_VERSION := $(shell date +%Y.%m.%d)

DOCKER_TAG = archiso-cloud-$(1)
DOCKER_RUN = docker run \
	-e ISO_NAME=$(ISO_NAME) \
	-e ISO_VERSION=$(ISO_VERSION) \
	-e ISO_LABEL=$(ISO_LABEL) \
	-e PUBLISHER=$(PUBLISHER) \
	-e APPLICATION=$(APPLICATION) \
	-e INSTALL_DIR=$(INSTALL_DIR) \
	-e WAIT_TIMEOUT_SECS=$(WAIT_TIMEOUT_SECS) \
	-e TEST_TIMEOUT_SECS=$(TEST_TIMEOUT_SECS) \
	-e PUID=$(shell id -u) \
	-e PGID=$(shell id -g) \
	--privileged \
	--rm \
	--tmpfs=/run/shm \
	--tmpfs=/tmp:exec \
	-v $(abspath $(2)):$(3) \
	-v $(abspath $(WORK_DIR)):/work \
	-v $(abspath $(OUT_DIR)):/out \
	$(DOCKER_RUN_EXTRA_OPTS) \
	$(call DOCKER_TAG,$(1))

BUILD = $(call DOCKER_RUN,builder,$(SRC_DIR),/src)
RUN = $(call DOCKER_RUN,runner,$(TEST_DIR),/test)

PRINT = @echo -e "\e[1;34m"$(1)"\e[0m"

.PHONY: all
all: build

.PHONY: build
build: build-all

.PHONY: test
test: run-all

.PHONY: build-%
build-exec: DOCKER_RUN_EXTRA_OPTS = -it
build-%: builder $(OUT_DIR) $(WORK_DIR)
	$(call PRINT,Starting builder...)
	$(BUILD) make $(@:build-%=%)
	$(call PRINT,Stopped builder)

.PHONY: run-%
run-exec: DOCKER_RUN_EXTRA_OPTS = -it
run-%: runner $(OUT_DIR) $(WORK_DIR)
	$(call PRINT,Starting runner...)
	$(RUN) make $(@:run-%=%)
	$(call PRINT,Stopped runner)

.PHONY: builder runner
builder runner:
	$(call PRINT,Building Docker image $(call DOCKER_TAG,$@)...)
	docker build -t $(call DOCKER_TAG,$@) $@

$(OUT_DIR) $(WORK_DIR):
	$(call PRINT,Creating host directory $(@)...)
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(OUT_DIR) $(WORK_DIR)
	docker rmi -f $(call DOCKER_TAG,builder) $(call DOCKER_TAG,runner)
