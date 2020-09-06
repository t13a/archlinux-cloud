OUT_ISO := $(OUT_DIR)/$(ISO_NAME)-$(ISO_VERSION)-x86_64.iso
OUT_ISO_WORK_DIR := $(OUT_DIR)/iso

.PHONY: iso
iso: $(OUT_ISO)

$(OUT_ISO): profile repo
	$(call PRINT,Building ISO image...)
	sudo mkarchiso \
		-o $(OUT_DIR) \
		-v \
		-w $(OUT_ISO_WORK_DIR) \
		$(OUT_PROFILE_DIR)
	$(call PRINT,Succeessfully built ISO image)
