# Use a slim Python image
FROM python:3-slim

# Install CycloneDX Python tool
RUN pip install cyclonedx-bom

# Set the working directory to the root of the action
WORKDIR /action

# Copy the action code
COPY . .

# Make sure the script is executable
RUN chmod +x /action/main.py

# Set environment variables
ENV PYTHONPATH /action

# Run the main script
CMD ["python", "/action/main.py"]
