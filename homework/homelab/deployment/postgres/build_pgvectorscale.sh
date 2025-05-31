#!/bin/bash

set -euxo pipefail

# Ensure Rust is initialized
source "$HOME/.cargo/env"

# Clone the repo
cd /tmp
git clone --branch main https://github.com/timescale/pgvectorscale
cd pgvectorscale/pgvectorscale

# Install cargo-pgrx using the same version as `pgrx` from Cargo.toml
PGRX_VERSION=$(cargo metadata --format-version 1 | jq -r '.packages[] | select(.name == "pgrx") | .version')
cargo install --locked cargo-pgrx --version "$PGRX_VERSION"

# Initialize pgrx for PG17
cargo pgrx init --pg17 /usr/lib/postgresql/17/bin/pg_config

# Build & install pgvectorscale
cargo pgrx install --release

# check tailscale/pgvectorscale for further docs / instructions
