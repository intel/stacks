#!/usr/bin/env bash

set -e

# init
script_name=`basename "$0"`
echo "executing script ::  $script_name"

echo "=================install pytorch============================="
ldconfig
pip --no-cache-dir install /torch-wheels/*
rm -rf /torch-wheels