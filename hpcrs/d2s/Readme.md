# High Performance Compute Reference Stack

This documentation provides:

- Information on Singularity
- Installation steps for Clear Linux OS
- Converting Docker images (downloaded from Docker Hub) to Singularity images.

### Version compatibility
Singularity v3.0

### Singularity
Open source container platform to package entire scientific workflows, software and libraries, and even data.
More about Singularity: https://sylabs.io/


## How to Install Singularity

### Prerequisites
The installation instructions are for Linux systems, and have been enabled for installation on Clear Linux.
Note: The steps for installation can also be found here: https://sylabs.io/guides/3.0/user-guide/quick_start.html#quick-installation-steps

Install Go.

```
$ export VERSION=1.13 OS=linux ARCH=amd64 && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz
```
From above command, we have `VERSION` set to `1.13`, this is because the version of Singularity that we want requires Go version 1.13.

Then, set up your environment for Go.

```
$ echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
    echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc && \
    source ~/.bashrc
```

Since we are installing Singularity v3.0.0 and above we will also need to install dep for dependency resolution.

```
$ go get -u github.com/golang/dep/cmd/dep

```

### Download & Compile *Singularity*
To ensure that the Singularity source code is downloaded to the appropriate directory use below command.

```
$ go get -d github.com/sylabs/singularity
```

Note: Go will complain that there are no Go files, but it will still download the Singularity source code to the appropriate directory within the $GOPATH.

Now checkout the version of Singularity you want to install.

```
$ export VERSION=v3.0.3 # or another tag or branch if you like && \
    cd $GOPATH/src/github.com/sylabs/singularity && \
    git fetch && \
    git checkout $VERSION # omit this command to install the latest bleeding edge code from master
```

Singularity uses a custom build system called makeit. mconfig is called to generate a Makefile and then make is used to compile and install.
Note: Packages devpkg-openssl, devpkg-util-linux may be required and can be installed using the command 'sudo swupd bundle-add <pkg-name>'

```
$ ./mconfig && \
    make -C ./builddir && \
    sudo make -C ./builddir install
```

### Source bash completion file (Optional)

To enjoy bash completion with Singularity commands and options, source the bash completion file like so. Add this command to your ~/.bashrc file so that bash completion continues to work in new shells. (Obviously adjust this path if you installed the bash completion file in a different location.)

```
. /usr/local/etc/bash_completion.d/singularity
```

## d2s - A tool to convert Docker images to Singularity images

To get the tool:

```bash
git clone https://github.com/intel/stacks
cd stacks/hpcrs/d2s
```
Install the tool using `pip install .`

To know more about the tool:

```bash
➜ d2s --help
usage: d2s [-h] [--list_docker_images] [--convert_docker_images CONVERT_DOCKER_IMAGES [CONVERT_DOCKER_IMAGES ...]]

Docker to Singularity Image Conversion tool

optional arguments:
  -h, --help            show this help message and exit
  --list_docker_images  show a table of docker images available locally.
  --convert_docker_images CONVERT_DOCKER_IMAGES [CONVERT_DOCKER_IMAGES ...]
                        docker images to convert

```

1. Enter the directory you intend to keep the Singularity image(s) converted from Docker image(s).
2. List local Docker images (with ID and NAME)


```bash
➜ d2s --list_docker_images

==============================
Docker images present locally
==============================
ID         NAME
0: clearlinux/stacks-dlrs-mkl
1: clearlinux/stacks-dlrs_2-mkl
==============================
```

3. To convert Docker image to Singularity image

```bash
➜ d2s --convert_docker_images <ID_1> <ID_2>
```
e.g.

```bash
d2s --convert_docker_images 0

checking if singularity is installed
2020-02-28 11:43:14,550 d2s.py       INFO     singualrity cmd available
2020-02-28 11:43:14,596 d2s.py       INFO     Converting docker image clearlinux/stacks-dlrs-mkl to singularity image clearlinux_stacks-dlrs-mkl
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
