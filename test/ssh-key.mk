export OUT_SSH_KEY := $(OUT_DIR)/ssh-key/id_rsa
export OUT_SSH_KEY_PUB := $(OUT_SSH_KEY).pub

CLEAN_FILES += \
	$(OUT_SSH_KEY) \
	$(OUT_SSH_KEY_PUB)

.PHONY: ssh-key
ssh-key: $(OUT_SSH_KEY) $(OUT_SSH_KEY_PUB)

$(OUT_SSH_KEY) $(OUT_SSH_KEY_PUB):
	$(call PRINT,Generating SSH keys...)
	rm -rf $(@D)
	mkdir -p $(@D)
	ssh-keygen -f $(OUT_SSH_KEY) -N ""
	$(call PRINT,Successfully generated SSH keys)

