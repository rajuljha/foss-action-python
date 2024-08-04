#!/bin/bash

# Ensure the input parameters are provided
if [ -z "$INPUT_ENVIRONMENT" ] && [ -z "$INPUT_REQUIREMENTS" ] && [ -z "$INPUT_PIPENV" ] && [ -z "$INPUT_POETRY" ]; then
  echo "At least one input parameter must be set (environment, requirements, pipenv, or poetry)."
  exit 1
fi

# Set the working directory to /github/workspace
WORKDIR=$GITHUB_WORKSPACE
SBOM_DIR="$WORKDIR/sbom"
mkdir -p "$SBOM_DIR"

# Determine which command to run based on inputs
command="cyclonedx-py"
sbom_files=()

if [ "$INPUT_ENVIRONMENT" = "true" ]; then
  echo "Generating SBOM for environment..."
  output=$(python -m cyclonedx_py environment)
  echo "$output" > "${SBOM_DIR}/sbom_env.json"
  sbom_files+=("${SBOM_DIR}/sbom_env.json")
fi

if [ "$INPUT_REQUIREMENTS" = "true" ]; then
  echo "Generating SBOM for requirements..."
  output=$(python -m cyclonedx_py requirements)
  echo "$output" > "${SBOM_DIR}/sbom_req.json"
  sbom_files+=("${SBOM_DIR}/sbom_req.json")
fi

if [ "$INPUT_PIPENV" = "true" ]; then
  echo "Generating SBOM for pipenv..."
  output=$(python -m cyclonedx_py pipenv)
  echo "$output" > "${SBOM_DIR}/sbom_pipenv.json"
  sbom_files+=("${SBOM_DIR}/sbom_pipenv.json")
fi

if [ "$INPUT_POETRY" = "true" ]; then
  echo "Generating SBOM for poetry..."
  output=$(python -m cyclonedx_py poetry)
  echo "$output" > "${SBOM_DIR}/sbom_poetry.json"
  sbom_files+=("${SBOM_DIR}/sbom_poetry.json")
fi

# List files for debugging
echo "Files in SBOM directory:"
ls -l "$SBOM_DIR"

# Set environment variable for the path of the SBOM file
if [ -n "$sbom_file" ]; then
  echo "SBOM_FILE_PATH=$sbom_file" >> $GITHUB_ENV
else
  echo "No SBOM file was generated."
fi
