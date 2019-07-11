CIDATA_TEMPLATE_DIR := $(TEST_DIR)/cidata
CIDATA_TEMPLATE = $(CIDATA_TEMPLATE_DIR)/$(1)
CIDATA_TEMPLATES := $(shell find $(CIDATA_TEMPLATE_DIR) -type f -executable | xargs -n1 basename)

CIDATA_FILE = $(CIDATA_DIR)/$(1)
CIDATA_FILES := $(foreach _,$(CIDATA_TEMPLATES),$(call CIDATA_FILE,$(_)))

.PHONY: cidata
cidata: $(CIDATA_ISO)

$(CIDATA_ISO): $(CIDATA_FILES)
	$(call PRINT,Generating cloud-init data source ISO image...)
	genisoimage -output $(CIDATA_ISO) -volid cidata -joliet -rock $(CIDATA_FILES)
	$(call PRINT,Successfully generated cloud-init data source ISO image)

define CIDATA_FILE_RULE
$(call CIDATA_FILE,$(1)): $(SSH_KEY_PUB) $(call CIDATA_TEMPLATE,$(1))
	$(call PRINT,Applying template for $(1)...)
	mkdir -p $(CIDATA_DIR)
	$(call CIDATA_TEMPLATE,$(1)) > $(call CIDATA_FILE,$(1))

endef
$(eval $(foreach _,$(CIDATA_TEMPLATES),$(call CIDATA_FILE_RULE,$(_))))

CLEAN_TARGETS += cidata-clean
.PHONY: cidata-clean
cidata-clean:
	rm -rf $(CIDATA_DIR)
