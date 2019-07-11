ISO_NAME := $(or $(ISO_NAME),archlinux-cloud)
ISO_VERSION := $(or $(ISO_VERSION),$(shell date +%Y.%m.%d))
ISO := $(OUT_DIR)/$(ISO_NAME)-$(ISO_VERSION)-x86_64.iso
ISO_WORK_CLEAN := yes
ISO_WORK_DIR := $(WORK_DIR)/iso

.PHONY: iso
iso: $(ISO)

$(ISO): $(ARCHLIVE_DONE) $(REPO_DONE)
	$(call PRINT,Building ISO image...)
	sudo $(ARCHLIVE_DIR)/build.sh \
		-N $(ISO_NAME) \
		-V $(ISO_VERSION) \
		$(if $(ISO_LABEL),-L "$(ISO_LABEL)") \
		$(if $(PUBLISHER),-P "$(PUBLISHER)") \
		$(if $(APPLICATION),-A "$(APPLICATION)") \
		$(if $(INSTALL_DIR),-D "$(INSTALL_DIR)") \
		-w $(ISO_WORK_DIR) \
		-o $(OUT_DIR) \
		-v
	if [ "$(ISO_WORK_CLEAN)" = yes ]; then \
		sudo rm -rf $(ISO_WORK_DIR); \
	fi
	$(call PRINT,Succeessfully built ISO image)

CLEAN_TARGETS += iso-clean
.PHONY: iso-clean
iso-clean:
	sudo rm -rf $(ISO) $(ISO_TARGET) $(ISO_WORK_DIR)
