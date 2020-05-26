CONTAINER_IMAGE = archlinux-cloud-$(1)

.PHONY: %-container
%-container:
	$(call PRINT,'Building container "$(call CONTAINER_IMAGE,$*)"...')
	docker build \
		-f Dockerfile.$* \
		-t $(call CONTAINER_IMAGE,$*) \
		.

