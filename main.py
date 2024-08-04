import os
import sys
from subprocess import Popen, PIPE


def run_command(command, args, cwd):
    print(f"Running command: {command} {' '.join(args)} in {cwd}")
    process = Popen([command] + args, stdout=PIPE, stderr=PIPE, cwd=cwd)
    result, error = process.communicate()
    if process.returncode != 0:
        print(f"Error: {error.decode('utf-8').strip()}")
        sys.exit(process.returncode)
    return result.decode("utf-8").strip()


# Get environment variables
ENVIRONMENT = os.environ.get('INPUT_ENVIRONMENT') == 'true'
REQUIREMENTS = os.environ.get('INPUT_REQUIREMENTS') == 'true'
PIPENV = os.environ.get('INPUT_PIPENV') == 'true'
POETRY = os.environ.get('INPUT_POETRY') == 'true'

# Get the repository root directory from the GITHUB_WORKSPACE environment
repo_root = os.environ.get('GITHUB_WORKSPACE', '/github/workspace')
print(f"Repository root: {repo_root}")

sbom_files = []
command = "cyclonedx-py"

if ENVIRONMENT:
    output = run_command(command, ["environment"], cwd=repo_root)
    env_file = os.path.join(repo_root, "sbom_env.json")
    with open(env_file, "w+") as f:
        f.write(output)
    sbom_files.append(env_file)

if REQUIREMENTS:
    output = run_command(command, ["requirements"], cwd=repo_root)
    req_file = os.path.join(repo_root, "sbom_req.json")
    with open(req_file, "w+") as f:
        f.write(output)
    sbom_files.append(req_file)

if PIPENV:
    output = run_command(command, ["pipenv"], cwd=repo_root)
    pipenv_file = os.path.join(repo_root, "sbom_pipenv.json")
    with open(pipenv_file, "w+") as f:
        f.write(output)
    sbom_files.append(pipenv_file)

if POETRY:
    output = run_command(command, ["poetry"], cwd=repo_root)
    poetry_file = os.path.join(repo_root, "sbom_poetry.json")
    with open(poetry_file, "w+") as f:
        f.write(output)
    sbom_files.append(poetry_file)

# Write the output paths to GITHUB_ENV
with open(os.getenv('GITHUB_ENV'), 'a') as github_env:
    if sbom_files:
        github_env.write(f"SBOM_FILE_PATH={sbom_files[0]}\n")
