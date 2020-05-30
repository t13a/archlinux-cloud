DOTENV := .env
DOTENV_SCRIPT := ./dotenv.sh
DOTENV_TEMPLATE := $(DOTENV).template

INIT_FILES += $(DOTENV)
CLEAN_FILES += $(DOTENV)

.PHONY: dotenv
dotenv: $(DOTENV)

$(DOTENV): $(DOTENV_TEMPLATE)
	$(call PRINT,'Generating file "$@"...')
	$(DOTENV_SCRIPT) < $< > $@.tmp
	mv -f $@.tmp $@

