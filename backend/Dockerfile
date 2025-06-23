# Use official Python image
FROM python:3.10-slim

# Set work directory inside container
WORKDIR /app

# Copy requirements first and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the application
COPY app/ ./app/

# Set working dir for uvicorn
WORKDIR /app/app

# Expose port
EXPOSE 80

# Run the FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
