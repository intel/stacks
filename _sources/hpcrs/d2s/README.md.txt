# Overview
This documentation provides information on Singularity and Charliecloud, and instructions on converting Docker images (downloaded from Docker Hub) to Singularity images or Charliecloud directories.

## Version compatibility verified
Singularity v3.0
Charliecloud v0.19-v0.20

## Singularity
Open source container platform to package entire scientific workflows, software and libraries, and even data.
More about Singularity: https://sylabs.io/

## Charliecloud
Charliecloud provides user-defined software stacks (UDSS) for high-performance computing (HPC) centers.
More about Charliecloud: https://hpc.github.io/charliecloud/index.html


# d2s - A tool to convert Docker images to Singularity images or Charliecloud directories

## Getting d2s
To get the tool:

```bash
git clone https://github.com/intel/stacks/hpcrs
cd hpcrs/d2s
```
You can use the script as is or install it using `python setup.py install`

## Converting to a Singularity Image

1. Enter the directory you intend to keep the Singularity image(s) converted from Docker image(s).

2. List local Docker images (with ID and NAME)

```bash
python d2s.py --list_docker_images

==============================
Docker images present locally
==============================
ID         NAME
0: sysstacks/dlrs-tensorflow2-ubuntu
1: sysstacks/dlrs-pytorch-centos
==============================
```


3. To convert Docker image to Singularity image

```bash
python d2s.py --convert_docker_images_singularity <ID_1> <ID_2>
```
e.g.

```
python d2s.py --convert_docker_images_singularity 0 1

checking if singularity is installed
2020-02-28 11:43:14,550 d2s.py       INFO     singularity cmd available
2020-02-28 11:43:14,596 d2s.py       INFO     Converting docker image sysstacks/dlrs-tensorflow2-ubuntu to singularity image sysstacks/dlrs-tensorflow2-ubuntu
INFO:    Starting build...
...
...
```

Alternatively, the 'singularity build' command can be directly used for building Singularity container. https://sylabs.io/guides/3.0/user-guide/build_a_container.html#downloading-an-existing-container-from-docker-hub

4. Enter Singularity container shell to run workloads.
```
singularity shell <singularity image>
```
e.g singularity shell clearlinux_stacks-dlrs-mkl


## Converting to a Charliecloud directory

1. Enter the directory you intend to keep the Charliecloud director(ies) converted from Docker image(s).

2. List local Docker images (with ID and NAME)

```bash
python d2s.py --list_docker_images

==============================
Docker images present locally
==============================
ID         NAME
0: sysstacks/dlrs-tensorflow2-ubuntu
1: sysstacks/dlrs-pytorch-centos
==============================
```


3. To convert Docker image to Charliecloud directory

```bash
python d2s.py --convert_docker_images_charliecloud <ID_1> <ID_2>
```
e.g.

```
python d2s.py --convert_docker_images_charliecloud 0 1

checking if singularity is installed
2020-02-28 11:43:14,550 d2s.py       INFO     charliecloud cmd available
2020-02-28 11:43:14,596 d2s.py       INFO     Converting docker image sysstacks/dlrs-tensorflow2-ubuntu to charliecloud directory in local directory
...
...
```

Your docker image has been converted to a Charliecloud directory. For more information on how to run containers with Charliecloud, visit their [website](https://hpc.github.io/charliecloud/index.html)
