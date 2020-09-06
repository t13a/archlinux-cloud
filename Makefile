export ISO_NAME := archlinux-cloud
export ISO_LABEL := ARCH_$(shell date +%Y%m)
export ISO_VERSION := $(shell date +%Y.%m.%d)

DIST_ISO := dist/$(ISO_NAME)-$(ISO_VERSION)-x86_64.iso

.DEFAULT_GOAL := all
.PHONY: all
all: build test dist

.PHONY: build
build:
	docker-compose run --rm build sh -c 'sudo chmod 777 $${OUT_DIR} && make'

.PHONY: test
test:
	docker-compose run --rm test make

.PHONY: dist
dist:
	mkdir -p $(dir $(DIST_ISO))
	docker-compose run --rm build sh -c 'cat $${OUT_DIR}/$(notdir $(DIST_ISO))' > $(DIST_ISO).tmp
	mv -f $(DIST_ISO).tmp $(DIST_ISO)

.PHONY: clean
clean:
	rm -rf $(dir $(DIST_ISO))
	docker-compose down --rmi local -v
