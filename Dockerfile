# Use AMD64 architecture explicitly
FROM --platform=linux/amd64 python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies for pdfminer and numpy/scikit-learn
RUN apt-get update && \
    apt-get install -y gcc build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Download the sentence-transformers model during build
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2').save('./models/all-MiniLM-L6-v2')"

# Copy the application code
COPY app/ .

# Create input and output directories (for Docker volume mounts)
RUN mkdir -p /app/input /app/output

# Set the entrypoint to process PDFs from /app/input to /app/output
ENTRYPOINT ["python", "main.py", "--input_dir", "/app/input", "--output_dir", "/app/output", "--model_dir", "/app/models/all-MiniLM-L6-v2"] 