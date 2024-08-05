# Use a slim Python image
FROM python:3-slim

# Install CycloneDX Python tool
RUN pip install cyclonedx-bom

# Set the working directory to the root of the action
WORKDIR /action

# Copy the action code and entrypoint script
COPY . .

# Make sure the script is executable
RUN chmod +x /action/entrypoint.sh

# Set entrypoint to the script
ENTRYPOINT ["/action/entrypoint.sh"]

# FROM python:3.9-slim

# # Install CycloneDX Python module
# RUN pip install cyclonedx-bom

# # Copy entrypoint script
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# # Set entrypoint
# ENTRYPOINT ["/entrypoint.sh"]
