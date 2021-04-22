# Build instructions (WIP)

All commands presented below will build the 'full' image.

## Build TF1 gpu wheel for ubuntu 20.04

```
make tf_gpu
```

This uses internal intel tensorflow 

## Milestone/Release Centos

```bash
# Builds TF1 and TF2 image
make centos

# Builds TF1 image
make ctf1

# Builds TF2 image
make ctf2
```

## CI Centos

```bash
# Builds TF1 and TF2 image
make centos-ci
```

## Milestone/Release Ubuntu

```bash
# Builds TF1 and TF2 image
make ubuntu

# Builds TF1 image
make utf1

# Builds TF2 image
make utf2

# Builds TF1 and TF2 AVX2 images
make core_avx2

# Builds TF1 AVX2 image
make utf1_avx2

# Builds TF2 AVX2 image
make utf2_avx2
```
## CI Ubuntu

```bash
# Builds TF1 and TF2 image
make ubuntu-ci

# Builds TF1 and TF2 AVX2 images (no-cache)
make core_avx2

# Builds TF1 AVX2 image (no-cache)
make utf1_avx2

# Builds TF2 AVX2 image (no-cache)
make utf2_avx2
```

# Milestone/Release Ubuntu and Centos

```bash
make all
```
# CI Ubuntu and Centos

```bash
make all
```
