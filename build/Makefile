PRINT = @echo -e "\e[1;34m"[build] $(1)"\e[0m"

CLEAN_FILES :=

include *.mk

.DEFAULT_GOAL := all
.PHONY: all
all: iso

.PHONY: clean
clean:
	sudo rm -rf $(CLEAN_FILES)

.PHONY: exec
exec:
	bash

