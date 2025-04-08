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

if [ ! -d "output/obs" ]; then
  echo "Observation does not exist. Run obsgen.sh first."
  exit 1
fi

if [ ! -d "output/init" ]; then
  echo "Initial state does not exist. Run init.sh first."
  exit 1
fi

# If previous state exists, archive it
if [ -d "output/state" ]; then
  rm -rf output/state/*
else
  mkdir -p output/state
fi

# Copy initial state
cp output/init/* output/state

# T is file number - 1 of ./output/obs directory
T=$(find output/obs/${PLUGIN_NAME}*.json -type f | wc -l | awk '{print $1-1}')
# N is file number of ./output/init directory
N=$(find output/init/${PLUGIN_NAME}*.json -type f | wc -l)

for (( t = 0; t < T; t++)); do
  SYS_TIM=$(printf "%06d" $t)
  OBS_TIM=$(printf "%06d" $t)

  echo "Predict ${OBS_TIM}"
  for (( i = 0; i < N; i++)); do
    STATE_FILE=$(printf ${PLUGIN_NAME}_%04d_${SYS_TIM}_${OBS_TIM}.json $i)
    douka predict \
      --state        output/state/${STATE_FILE} \
      --param        param/param.predict.json \
      --plugin       ${PLUGIN_NAME} \
      --plugin_param param/param.plugin.json \
      --output       output/state \
      >> output/${PLUGIN_NAME}.log &
  done
  wait

  SYS_TIM=$(printf "%06d" $(( t + 1 )))
  STATE_FILE=${PLUGIN_NAME}_%04d_${SYS_TIM}_${OBS_TIM}.json

  echo "Filter  ${OBS_TIM}"
  douka filter \
      --state  output/state/${STATE_FILE} \
      --param  param/param.filter-enkf.json \
      --obs    output/obs/${PLUGIN_NAME}_obs_${SYS_TIM}.json \
      --output output/state \
      >> output/${PLUGIN_NAME}.log
done
