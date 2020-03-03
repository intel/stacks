"""
d2s
--------
A tool to convert docker images to singularity images

"""

from distutils.core import setup

setup(
    name="d2s",
    version="0.1.0",
    description="A tool to convert docker images to singularity images",
    author="swstacks",
    license="Apache license 2.0",
    classifiers=[
        "Programming Language :: Python",
        "License :: OSI Approved :: Apache license 2.0",
        "Intended Audience :: Developers",
        "Topic :: Containers",
    ],
    py_modules=["d2s/d2s"],
)
