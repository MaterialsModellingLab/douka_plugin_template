#!/usr/bin/env bash
# Copyright (c) 2025 Materials Modelling Lab, The University of Tokyo
# SPDX-License-Identifier: Apache-2.0

set -e

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 PLUGIN_NAME"
  echo "  PLUGIN_NAME: The name of the plugin."
  exit 1
fi

# Assign the first argument to the PLUGIN_NAME variable
PLUGIN_NAME="$1"

# Example usage: Print the plugin name
echo "Plugin name: $PLUGIN_NAME"

# Example of checking if plugin name is empty or not
if [ -z "$PLUGIN_NAME" ]; then
    echo "Error: PLUGIN_NAME cannot be empty."
    exit 1;
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE="${SCRIPT_DIR}/.."

cd $BASE

douka obsgen \
  --param        param/param.obsgen.json \
  --plugin       ${PLUGIN_NAME} \
  --plugin_param param/param.plugin.json \
  --output       output/obs
