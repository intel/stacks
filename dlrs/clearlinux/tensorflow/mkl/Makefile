include config.make
export BUILDER_DOCKER_IMAGE_MKL
export BUILDER_DOCKER_NAME_MKL
# tensorflow builder
export TF_DOCKER_IMAGE_MKL
export TF_DOCKER_NAME_MKL
# openvino builder
export SERVER_DOCKER_IMAGE_MKL
export SERVER_DOCKER_NAME_MKL
# clr downstream builder
export CLR_DOWNSTREAM_DOCKER_IMAGE_MKL
export CLR_DOWNSTREAM_DOCKER_NAME_MKL
# downstream builder
export DOWNSTREAM_DOCKER_IMAGE_MKL
export DOWNSTREAM_DOCKER_NAME_MKL

all .DEFAULT:
	$(MAKE) builder clr_ds
	$(MAKE) tf openvino
	$(MAKE) downstream

builder:
	$(DOCKER_BUILD_CMD) --build-arg clear_ver="${CLR_VER}" -f $(BUILDER_DOCKER_FILE) -t $(BUILDER_DOCKER_IMAGE_MKL)  $(DOCKER_WS)

tf:
	$(DOCKER_BUILD_CMD) --build-arg clear_ver="${CLR_VER}" -f $(TF_DOCKER_FILE) -t $(TF_DOCKER_IMAGE_MKL)  $(DOCKER_WS)

openvino:
	$(DOCKER_BUILD_CMD) --build-arg clear_ver="${CLR_VER}" -f $(SERVER_DOCKER_FILE) -t $(SERVER_DOCKER_IMAGE_MKL)  $(DOCKER_WS)

clr_ds:
	$(DOCKER_BUILD_CMD) --build-arg clear_ver="${CLR_VER}" -f $(CLR_DOWNSTREAM_DOCKER_FILE) -t $(CLR_DOWNSTREAM_DOCKER_IMAGE_MKL)  $(DOCKER_WS)

downstream:
	$(DOCKER_BUILD_CMD) --build-arg clear_ver="${CLR_VER}" -f $(DOWNSTREAM_DOCKER_FILE) -t $(DOWNSTREAM_DOCKER_IMAGE_MKL)  $(DOCKER_WS)

.PHONY: $(DEFAULT_TARGETS)
