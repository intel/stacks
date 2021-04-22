include config.make

export DOCKER_BUILDKIT=1


all:
	OS=ubuntu $(MAKE) serving

serving:
	docker build -t $(STACK_NAME)-$(OS):$(STACK_VER) -f Dockerfile .
