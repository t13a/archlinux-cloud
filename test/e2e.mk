E2E_DIR := $(TEST_DIR)/e2e
E2E_WORK_DIR := $(WORK_DIR)/e2e

CASES := $(shell find $(E2E_DIR) -type f -executable | sort | xargs -n1 basename)
CASE_SCRIPT = $(E2E_DIR)/$(1)
CASE_TARGET = e2e-$(1)
CASE_TARGETS = $(foreach _,$(CASES),$(call CASE_TARGET,$(_)))

.PHONY: e2e
e2e: e2e-setup $(CASE_TARGETS) e2e-teardown
	$(call PRINT,Successfully passed all E2E test cases)

define CASE_TARGET_RULE
.PHONY: $(CASE_TARGET,$(1))
$(call CASE_TARGET,$(1)):
	$(call PRINT,Running E2E test case $(1)...)
	$(call CASE_SCRIPT,$(1))

endef
$(eval $(foreach _,$(CASES),$(call CASE_TARGET_RULE,$(_))))

.PHONY: e2e-setup
e2e-setup: ssh-key cidata
	$(call PRINT,Starting QEMU...)
	qemu-daemon -w

.PHONY: e2e-teardown
e2e-teardown:
	$(call PRINT,Stopping QEMU...)
	qemu-kill
