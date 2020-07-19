REPO_PKGS := $(shell cat $(REPO_PKGS_FILE))

export OUT_REPO_DIR := $(OUT_DIR)/repo

CLEAN_FILES += $(OUT_REPO_DIR)

.PHONY: repo
repo: $(OUT_REPO_DIR)/.done

$(OUT_REPO_DIR)/.done: $(foreach _,$(REPO_PKGS),$(OUT_REPO_DIR)/$_/.done)
	rm -rf \
		$(OUT_REPO_DIR)/$(REPO_NAME).db \
		$(OUT_REPO_DIR)/$(REPO_NAME).db.* \
		$(OUT_REPO_DIR)/$(REPO_NAME).files \
		$(OUT_REPO_DIR)/$(REPO_NAME).files.* \
		$(OUT_REPO_DIR)/*.pkg.tar.*
	for REPO_PKG in $(REPO_PKGS); do \
		cp $(OUT_REPO_DIR)/$${REPO_PKG}/*.pkg.tar.* $(OUT_REPO_DIR); \
	done
	repo-add $(OUT_REPO_DIR)/$(REPO_NAME).db.tar.gz $(OUT_REPO_DIR)/*.pkg.tar.*
	touch $@
	$(call PRINT,Succeessfully built custom repository)

define REPO_OUT_PKG_DONE_RULE
$$(OUT_REPO_DIR)/$(1)/.done:
	$$(call PRINT,Building AUR package $(1)...)
	rm -rf $$(@D)
	mkdir -p $$(@D)
	git clone https://aur.archlinux.org/$(1).git $$(@D)
	cd $$(@D) && makepkg -s --noconfirm
	touch $$@

endef
$(eval $(foreach _,$(REPO_PKGS),$(call REPO_OUT_PKG_DONE_RULE,$(_))))

