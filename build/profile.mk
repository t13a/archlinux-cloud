PROFILE_CHECKSUM_CMD := cd $(PROFILE_SRC_DIR) && find . -type f | sort | xargs sha256sum
PROFILE_MODS := $(shell find $(PROFILE_MOD_DIR) -type f -executable | sort)

export OUT_PROFILE_DIR := $(OUT_DIR)/profile

OUT_PROFILE_MOD_DONE = $(OUT_PROFILE_DIR)/.mod-$(shell basename $(1)).done

CLEAN_FILES += $(OUT_PROFILE_DIR)

.PHONY: profile
profile: $(OUT_PROFILE_DIR)/.done

$(OUT_PROFILE_DIR)/.done: $(foreach _,$(PROFILE_MODS),$(call OUT_PROFILE_MOD_DONE,$_))
	touch $@
	$(call PRINT,Succeessfully built custom profile)

define PROFILE_MOD_DONE_RULE
$$(call OUT_PROFILE_MOD_DONE,$(1)): $(1) $$(OUT_PROFILE_DIR)/.src.done
	$$(call PRINT,Applying mod $(1)...)
	cd $$(OUT_PROFILE_DIR) && $(1)
	touch $$(@)

endef
$(eval $(foreach _,$(PROFILE_MODS),$(call PROFILE_MOD_DONE_RULE,$_)))

$(OUT_PROFILE_DIR)/.src.done: profile/verify $(PROFILE_MODS)
	$(call PRINT,Copying source profile...)
	rm -rf $(@D)
	cp -r $(PROFILE_SRC_DIR) $(@D)
	mkdir -p $(@D)
	touch $@

.PHONY: profile/verify
profile/verify: $(PROFILE_CHECKSUM)
	$(PROFILE_CHECKSUM_CMD) | diff $< -

$(PROFILE_CHECKSUM):
	mkdir -p $(@D)
	$(PROFILE_CHECKSUM_CMD) > $@.tmp
	mv -f $@.tmp $@

