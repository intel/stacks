build:
	echo "build hpc container with icc and pytorch"
	DOCKER_BUILDKIT=1 docker build -t hpcrs-centos -f ./Dockerfile .

run:
	echo "run hpc container with icc and pytorch"
	docker run -it hpcrs-centos
