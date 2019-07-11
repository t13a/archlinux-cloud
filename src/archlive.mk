RELENG_DONE := $(ARCHLIVE_WORK_DIR)/releng.done

MOD_DIR := $(SRC_DIR)/mod
MODS := $(shell find $(MOD_DIR) -type f -executable | sort | xargs -n1 basename)
MOD_DONE = $(ARCHLIVE_WORK_DIR)/mod-$(1).done
MOD_SCRIPT = $(MOD_DIR)/$(1)
MOD_SCRIPTS = $(foreach _,$(MODS),$(call MOD_SCRIPT,$(_)))

.PHONY: archlive
archlive: $(ARCHLIVE_DONE)

$(ARCHLIVE_DONE): $(foreach _,$(MODS),$(call MOD_DONE,$(_)))
	touch $(ARCHLIVE_DONE)
	$(call PRINT,Succeessfully built profile)

define MOD_DONE_RULE
$(call MOD_DONE,$(1)): $(RELENG_DONE)
	$(call PRINT,Applying mod $(1)...)
	cd $$(ARCHLIVE_DIR) && $(abspath $(call MOD_SCRIPT,$(1)))
	touch $(call MOD_DONE,$(1))

endef
$(eval $(foreach _,$(MODS),$(call MOD_DONE_RULE,$(_))))

$(RELENG_DONE): $(MOD_SCRIPTS)
	$(call PRINT,Copying releng profile...)
	rm -rf $(ARCHLIVE_DIR)
	cp -r /usr/share/archiso/configs/releng $(ARCHLIVE_DIR)
	mkdir -p $(ARCHLIVE_WORK_DIR)
	touch $(RELENG_DONE)

CLEAN_TARGETS += archlive-clean
.PHONY: archlive-clean
archlive-clean:
	rm -rf $(ARCHLIVE_WORK_DIR)
