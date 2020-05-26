export OUT_ISO_WORK_DIR := $(OUT_DIR)/iso
export OUT_ISO := $(OUT_ISO_DIR)/$(ISO_NAME)-$(ISO_VERSION)-x86_64.iso

CLEAN_FILES += \
	$(OUT_ISO_WORK_DIR) \
	$(OUT_ISO)

.PHONY: iso
iso: $(OUT_ISO)

$(OUT_ISO): profile repo
	$(call PRINT,Building ISO image...)
	sudo $(OUT_PROFILE_DIR)/build.sh \
		-N $(ISO_NAME) \
		-V $(ISO_VERSION) \
		$(if $(ISO_LABEL),-L "$(ISO_LABEL)") \
		$(if $(ISO_PUBLISHER),-P "$(ISO_PUBLISHER)") \
		$(if $(ISO_APPLICATION),-A "$(ISO_APPLICATION)") \
		$(if $(ISO_INSTALL_DIR),-D "$(ISO_INSTALL_DIR)") \
		-w $(OUT_ISO_WORK_DIR) \
		-o $(OUT_ISO_DIR) \
		-v
	$(call PRINT,Succeessfully built ISO image)

