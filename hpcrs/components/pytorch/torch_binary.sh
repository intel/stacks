#!/bin/bash
# not used, use it if torch source build doesnt work
TORCH_VER=1.7.0
VISION_VER=0.8.1
URL="https://download.pytorch.org/whl/torch_stable.html"

pip install --no-cache-dir --force \
	torch==$TORCH_VER+cpu \
	torchvision==$VISION_VER+cpu \
	-f $URL
