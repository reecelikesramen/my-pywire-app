FROM python:3.12-slim
WORKDIR /app

# Install build dependencies (Rust parser needs cc, client build needs node/pnpm), git, and uv
RUN apt-get update && apt-get install -y --no-install-recommends build-essential git curl && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs && corepack enable pnpm
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev

# Copy application code
COPY . .

EXPOSE 8000
CMD ["uv", "run", "pywire", "run", "--host", "0.0.0.0", "--port", "8000", "--workers", "5"]
