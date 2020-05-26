CIDATA_TEMPLATES := $(shell find $(CIDATA_TEMPLATE_DIR) -type f -executable)

OUT_CIDATA_DIR := $(OUT_DIR)/cidata
OUT_CIDATA_FILES := $(foreach _,$(CIDATA_TEMPLATES),$(OUT_CIDATA_DIR)/$(notdir $_))

export OUT_CIDATA_ISO := $(OUT_CIDATA_DIR)/cidata.iso

CLEAN_FILES += $(OUT_CIDATA_DIR)

.PHONY: cidata
cidata: $(OUT_CIDATA_ISO)

$(OUT_CIDATA_ISO): $(OUT_CIDATA_FILES)
	$(call PRINT,Generating cloud-init data source ISO image...)
	genisoimage \
		-output $(OUT_CIDATA_ISO) \
		-volid cidata \
		-joliet \
		-rock \
		$(OUT_CIDATA_FILES)
	$(call PRINT,Successfully generated cloud-init data source ISO image)

define OUT_CIDATA_FILE_RULE
$$(OUT_CIDATA_DIR)/$(notdir $(1)): $(1) ssh-key
	$$(call PRINT,Generating $(1)...)
	mkdir -p $$(@D)
	$$< > $$@

endef
$(eval $(foreach _,$(CIDATA_TEMPLATES),$(call OUT_CIDATA_FILE_RULE,$_)))

