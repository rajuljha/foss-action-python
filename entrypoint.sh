#!/bin/bash

# Ensure at least one input parameter is provided
if [ -z "$INPUT_ENVIRONMENT" ] && [ -z "$INPUT_REQUIREMENTS" ] && [ -z "$INPUT_PIPENV" ] && [ -z "$INPUT_POETRY" ]; then
  echo "At least one input parameter must be set (environment, requirements, pipenv, or poetry)."
  exit 1
fi

# Set the working directory to /github/workspace
WORKDIR=/github/workspace
SBOM_DIR="$WORKDIR/sbom"
mkdir -p "$SBOM_DIR"

# Determine which command to run based on inputs
sbom_file=""

if [ "$INPUT_ENVIRONMENT" = "true" ]; then
  echo "Generating SBOM for environment..."
  sbom_file="${SBOM_DIR}/sbom_env.json"
  python -m cyclonedx-py environment $GITHUB_WORKSPACE > "$sbom_file"
elif [ "$INPUT_REQUIREMENTS" = "true" ]; then
  echo "Generating SBOM for requirements..."
  sbom_file="${SBOM_DIR}/sbom_req.json"
  python -m cyclonedx-py requirements "$GITHUB_WORKSPACE/requirements.txt" > "$sbom_file"
elif [ "$INPUT_PIPENV" = "true" ]; then
  echo "Generating SBOM for pipenv..."
  sbom_file="${SBOM_DIR}/sbom_pipenv.json"
  python -m cyclonedx-py pipenv "$GITHUB_WORKSPACE" > "$sbom_file"
elif [ "$INPUT_POETRY" = "true" ]; then
  echo "Generating SBOM for poetry..."
  sbom_file="${SBOM_DIR}/sbom_poetry.json"
  python -m cyclonedx-py poetry "$GITHUB_WORKSPACE" > "$sbom_file"
fi

# List files for debugging
echo "Files in SBOM directory:"
ls -l "$SBOM_DIR"

# Set the GitHub action output variable for the path of the SBOM file
if [ -n "$sbom_file" ]; then
#   echo "::set-output name=sbom_file_path::$sbom_file"
  echo "sbom_file_path=$sbom_file" >> $GITHUB_OUTPUT
else
  echo "No SBOM file was generated."
fi
