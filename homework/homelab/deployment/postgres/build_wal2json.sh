#!/bin/bash
set -euxo pipefail

# Build wal2json
cd /tmp
git clone https://github.com/eulerto/wal2json.git
cd wal2json
make PG_CONFIG=/usr/lib/postgresql/17/bin/pg_config
make install PG_CONFIG=/usr/lib/postgresql/17/bin/pg_config
