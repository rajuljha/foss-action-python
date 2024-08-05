#!/bin/bash

# Ensure at least one input parameter is provided
if [ -z "$INPUT_ENVIRONMENT" ] && [ -z "$INPUT_REQUIREMENTS" ] && [ -z "$INPUT_PIPENV" ] && [ -z "$INPUT_POETRY" ]; then
  echo "At least one input parameter must be set (environment, requirements, pipenv, or poetry)."
  exit 1
fi

# Set the working directory to /github/workspace
WORKDIR=/github/workspace
# SBOM_DIR="$WORKDIR/sbom"
# mkdir -p "$SBOM_DIR"

# Determine which command to run based on inputs
sbom_file="$WORKDIR/sbom_py.json"

if [ "$INPUT_ENVIRONMENT" = "true" ]; then
  echo "Generating SBOM for environment..."
  python -m cyclonedx-py environment $GITHUB_WORKSPACE > "$sbom_file"
elif [ "$INPUT_REQUIREMENTS" = "true" ]; then
  echo "Generating SBOM for requirements..."
  cyclonedx-py requirements "$GITHUB_WORKSPACE/requirements.txt" > "$sbom_file"
elif [ "$INPUT_PIPENV" = "true" ]; then
  echo "Generating SBOM for pipenv..."
  python -m cyclonedx-py pipenv "$GITHUB_WORKSPACE" > "$sbom_file"
elif [ "$INPUT_POETRY" = "true" ]; then
  echo "Generating SBOM for poetry..."
  python -m cyclonedx-py poetry "$GITHUB_WORKSPACE" > "$sbom_file"
fi

# List files for debugging
echo "Files in SBOM directory:"
ls -l "$WORKDIR"
ls -l "$GITHUB_WORKSPACE"

# # Set the GitHub action output variable for the path of the SBOM file
# if [ -n "$sbom_file" ]; then
# #   echo "::set-output name=sbom_file_path::$sbom_file"
#   echo "sbom_file_path=$sbom_file" >> $GITHUB_OUTPUT
# else
#   echo "No SBOM file was generated."
# fi
