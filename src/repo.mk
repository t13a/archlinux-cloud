PKGS := $(shell cat $(SRC_DIR)/repo.pkgs)
PKG_DIR = $(REPO_DIR)/$(1)
PKG_DONE = $(call PKG_DIR,$(1))/$(1).done

.PHONY: repo
repo: $(REPO_DONE)

$(REPO_DONE): $(foreach _,$(PKGS),$(call PKG_DONE,$(_)))
	rm -rf \
		$(REPO_DIR)/$(REPO_NAME).db \
		$(REPO_DIR)/$(REPO_NAME).db.* \
		$(REPO_DIR)/$(REPO_NAME).files \
		$(REPO_DIR)/$(REPO_NAME).files.* \
		$(REPO_DIR)/*.pkg.tar.gz
	for PKG in $(PKGS); do \
		cp $(REPO_DIR)/$${PKG}/*.pkg.tar.xz $(REPO_DIR); \
	done
	repo-add $(REPO_DIR)/$(REPO_NAME).db.tar.gz $(REPO_DIR)/*.pkg.tar.xz
	touch $(REPO_DONE)
	$(call PRINT,Succeessfully built custom repository)

define PKG_DONE_RULE
$(call PKG_DONE,$(1)):
	$(call PRINT,Building AUR package $(1)...)
	rm -rf $(call PKG_DIR,$(1))
	mkdir -p $(call PKG_DIR,$(1))
	git clone https://aur.archlinux.org/$(1).git $(call PKG_DIR,$(1))
	cd $(call PKG_DIR,$(1)) && makepkg -s --noconfirm
	touch $(call PKG_DONE,$(1))

endef
$(eval $(foreach _,$(PKGS),$(call PKG_DONE_RULE,$(_))))

CLEAN_TARGETS += repo-clean
.PHONY: repo-clean
repo-clean:
	rm -rf $(REPO_DIR)
