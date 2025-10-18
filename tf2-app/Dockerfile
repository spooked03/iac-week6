FROM python:trixie

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY main.py .
COPY tf2-heavy.jpg .

# Expose port for NiceGUI
EXPOSE 8080

# Run the application
CMD ["python", "main.py"]
