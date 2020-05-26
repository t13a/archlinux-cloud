E2E_CASES := $(shell find $(E2E_CASE_DIR) -type f -executable | sort)
E2E_CASE_TARGET = e2e/case/$(notdir $(1))
E2E_CASE_TARGETS := $(foreach _,$(E2E_CASES),$(call E2E_CASE_TARGET,$_))

.PHONY: e2e
e2e: e2e/setup $(E2E_CASE_TARGETS) e2e/teardown
	$(call PRINT,Successfully passed all E2E test cases)

.PHONY: e2e/setup
e2e/setup: $(OUT_ISO) ssh-key cidata
	$(call PRINT,Starting QEMU...)
	qemu-daemon -w

define E2E_CASE_RULE
.PHONY: $(call E2E_CASE_TARGET,$(1))
$(call E2E_CASE_TARGET,$(1)):
	$$(call PRINT,Running E2E test case $(1)...)
	$(1)

endef
$(eval $(foreach _,$(E2E_CASES),$(call E2E_CASE_RULE,$_)))

.PHONY: e2e/teardown
e2e/teardown:
	$(call PRINT,Stopping QEMU...)
	qemu-kill

