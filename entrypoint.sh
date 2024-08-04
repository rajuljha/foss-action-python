#!/bin/bash

# Ensure the input parameters are provided
if [ -z "$INPUT_ENVIRONMENT" ] && [ -z "$INPUT_REQUIREMENTS" ] && [ -z "$INPUT_PIPENV" ] && [ -z "$INPUT_POETRY" ]; then
  echo "At least one input parameter must be set (environment, requirements, pipenv, or poetry)."
  exit 1
fi

# Set the working directory to the GITHUB_WORKSPACE
WORKDIR=${GITHUB_WORKSPACE:-/github/workspace}
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

# Output the paths of generated SBOM files
if [ ${#sbom_files[@]} -gt 0 ]; then
  echo "SBOM file paths:"
  for file in "${sbom_files[@]}"; do
    echo "$file"
    echo "SBOM_FILE_PATH=$file" >> $GITHUB_ENV
  done
else
  echo "No SBOM files were generated."
fi
