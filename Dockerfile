FROM --platform=linux/amd64 python:3.12-slim

ENV SQLALCHEMY_DATABASE_URI=sqlite:///:memory:

# Install OS dependencies
RUN apt-get update && \
    apt-get install -y postgresql-client libpq-dev libcurl4-openssl-dev libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry

# Use system Python for poetry (so gunicorn is visible)
RUN poetry config virtualenvs.create false

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml .

# Install dependencies via Poetry (includes gunicorn)
RUN poetry install --no-root

# Copy the application code
COPY bin bin
COPY todo todo

# Entrypoint
ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["serve"]