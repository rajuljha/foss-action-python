import os
from subprocess import Popen, PIPE

print(os.environ)
ENVIRONMENT = os.environ.get('INPUT_ENVIRONMENT')
REQUIREMENTS = os.environ.get('INPUT_REQUIREMENTS')
PIPENV = os.environ.get('INPUT_PIPENV')
POETRY = os.environ.get('INPUT_POETRY')
GITHUB_ENV = os.getenv('GITHUB_ENV')

if (not ENVIRONMENT) or (not REQUIREMENTS) or (not PIPENV) or (not POETRY):
    ENVIRONMENT = True

command = "cyclonedx-py"

if ENVIRONMENT:
    process = Popen([f"{command}", "environment"], stdout=PIPE)
    result = process.communicate()[0]
    sbom_file = "sbom_env.json"
    with open(f"{sbom_file}", "w+") as f:
        f.write(result.decode("utf-8").strip())

if REQUIREMENTS:
    process = Popen([f"{command}", "requirements"], stdout=PIPE)
    result = process.communicate()[0]
    sbom_file = "sbom_req.json"
    with open(f"{sbom_file}", "w+") as f:
        f.write(result.decode("utf-8").strip())

if PIPENV:
    process = Popen([f"{command}", "pipenv"], stdout=PIPE)
    result = process.communicate()[0]
    sbom_file = "sbom_pipenv.json"
    with open(f"{sbom_file}", "w+") as f:
        f.write(result.decode("utf-8").strip())

if POETRY:
    process = Popen([f"{command}", "poetry"], stdout=PIPE)
    result = process.communicate()[0]
    sbom_file = "sbom_pipenv.json"
    with open(f"{sbom_file}", "w+") as f:
        f.write(result.decode("utf-8").strip())

with open(GITHUB_ENV, 'a') as github_env:
    github_env.write(f"SBOM_FILE_PATH={sbom_file}")
