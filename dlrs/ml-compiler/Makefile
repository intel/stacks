include config.make

export DOCKER_BUILDKIT=1

all .DEFAULT:
	$(DOCKER_BUILD_CMD) -f $(DOCKER_FILE) -t $(STACK_NAME)-$(OS):$(STACK_VER)  $(DOCKER_WS)


check:
	OS=$(OS) \
	DOCKER_IMAGE=$(STACK_NAME) \
	VERSION=$(STACK_VER) 


clean:
	docker rmi $(STACK_NAME)

.PHONY: $(DEFAULT_TARGETS)
