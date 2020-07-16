#!/usr/bin/env python
"""convert docker images to singularity recipes,\
run python d2s.py --help for more details."""
import argparse
import logging
import os
import subprocess
import sys

logger = logging.getLogger("d2s.py")
handler = logging.StreamHandler()
handler.setFormatter(
    logging.Formatter("%(asctime)s %(name)-12s %(levelname)-8s %(message)s")
)
logger.addHandler(handler)
logger.setLevel(logging.DEBUG)


parser = argparse.ArgumentParser(
    description="Docker to Singularity Image Conversion tool"
)
parser.add_argument(
    "--list_docker_images",
    action="store_true",
    help="show a table of docker images available locally.",
)
parser.add_argument(
    "--convert_docker_images", nargs="+", help="docker images to convert",
)


def list_docker_images():
    """list docker images on system"""
    images = subprocess.check_output(
        ["docker", "images", "--format", '"{{.Repository}}"']
    ).split()
    return [img.decode("utf-8") for img in images]


def tabular_images():
    """covert docker image list to a dict"""
    img_list = list_docker_images()
    return {str(i): v for i, v in enumerate(img_list)}


def print_image_table():
    """print images with ID and name."""
    img_table = tabular_images()
    print("=" * 30)
    print("Docker images present locally")
    print("=" * 30)
    print("{0:<10s} {1:>s}".format("ID", "NAME"))
    for k, v in img_table.items():
        print("{}: {}".format(k, v))
    print("=" * 30)


def check_singularity_version():
    """check singularity CLI tool version."""
    print("checking if singularity is installed")
    try:
        s_ver = subprocess.run(["singularity", "version"])
        logger.info("singualrity cmd available")
    except subprocess.CalledProcessError:
        sys.exit(1)


def get_sing_image_name(docker_image: str) -> str:
    """convert docker_image string to singularity image format"""
    sing_image = docker_image.replace(":", "_")
    sing_image = sing_image.replace("/", "_")
    return sing_image


def convert_to_singularity(docker_image: str):
    """convert docker images to singularity."""
    sing_image = get_sing_image_name(docker_image)
    logger.info(
        "Converting docker image %s to singularity image %s"
        % (docker_image, sing_image)
    )
    cmd = "singularity build {} docker://{}".format(sing_image, docker_image)
    ret = os.system(cmd)  # nosec

    if ret == 0:
        logger.info(
            "Converted docker image %s to singularity image format %s succesfully"
            % (docker_image, sing_image)
        )


def main():
    args = parser.parse_args()
    if args.list_docker_images:
        print_image_table()
    elif args.convert_docker_images:
        check_singularity_version()
        image_dict = tabular_images()
        # Convert each docker image to singularity image
        for image_id in args.convert_docker_images:
            try:
                image_name = image_dict[image_id]
            except KeyError:
                logger.error("=" * 30)
                logger.error(
                    "wrong id :: {}, to see available images run '--list_docker_images'".format(
                        image_id
                    )
                )
                logger.error("=" * 30)
                exit(1)
            convert_to_singularity(image_name)


if __name__ == "__main__":
    main()
