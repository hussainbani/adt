# Use a minimal base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set a non-root user
RUN mkdir -p /home/appuser
RUN groupadd -r appuser && useradd -r -d /home/appuser -g appuser appuser
# Create and set a non-root user
# RUN mkdir -p /home/appuser
# RUN adduser -D appuser

# Set the working directory
WORKDIR /app
RUN chown -R appuser:appuser /app /home/appuser


# Copy only necessary files (requirements.txt and the application code)
COPY adjustapi /app


# Install dependencies (as a separate step to leverage Docker cache)
RUN pip install --upgrade pip --progress-bar off&& \
    pip install  -r /app/requirements.txt --progress-bar off

USER appuser

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:create_app()"]