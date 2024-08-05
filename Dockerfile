FROM python:3.9-slim

# Install CycloneDX Python module
RUN pip install cyclonedx-bom

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
