FROM python:3-slim

WORKDIR /foss_action_python

# Copy only the requirements file first to leverage caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Set environment variables
ENV PYTHONPATH /foss_action_python

# Run the main script
CMD ["python", "main.py"]
