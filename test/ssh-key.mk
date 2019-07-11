SSH_KEY_DONE := $(SSH_KEY_DIR)/ssh-key.done

.PHONY: ssh-key
ssh-key: $(SSH_KEY) $(SSH_KEY_PUB)

$(SSH_KEY) $(SSH_KEY_PUB): $(SSH_KEY_DONE)

$(SSH_KEY_DONE):
	$(call PRINT,Generating SSH keys...)
	rm -rf $(SSH_KEY_DIR)
	mkdir -p $(SSH_KEY_DIR)
	ssh-keygen -f $(SSH_KEY) -N ""
	touch $(SSH_KEY_DONE)
	$(call PRINT,Successfully generated SSH keys)

CLEAN_TARGETS += ssh-clean
.PHONY: ssh-clean
ssh-clean:
	rm -rf $(SSH_KEY_DIR)
