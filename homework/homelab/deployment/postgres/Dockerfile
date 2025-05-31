# Stage 1: Build extensions
FROM postgres:17 AS builder

USER root

# Install build dependencies + PostgreSQL headers
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    jq \
    pkg-config \
    libssl-dev \
    zlib1g-dev \
    libreadline-dev \
    clang \
    llvm \
    ca-certificates \
    libclang-dev \
    rustc \
    cargo \
    postgresql-server-dev-17 \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Copy and run scripts
COPY build_pgvectorscale.sh /tmp/build_pgvectorscale.sh
COPY build_wal2json.sh /tmp/build_wal2json.sh

RUN chmod +x /tmp/build_pgvectorscale.sh /tmp/build_wal2json.sh && \
    /tmp/build_pgvectorscale.sh && \
    /tmp/build_wal2json.sh

# Stage 2: Runtime
FROM postgres:17

USER root

# Copy extensions from builder
COPY --from=builder /usr/lib/postgresql/17/lib/wal2json.so /usr/lib/postgresql/17/lib/
COPY --from=builder /usr/lib/postgresql/17/lib/*vectorscale* /usr/lib/postgresql/17/lib/
COPY --from=builder /usr/share/postgresql/17/extension/*vectorscale* /usr/share/postgresql/17/extension/

USER postgres
WORKDIR /var/lib/postgresql
