# Start:

```sh
docker run -d \
  --name postgres \
  -e POSTGRES_USER=user\
  -e POSTGRES_PASSWORD=password\
  -e POSTGRES_DB=db \
  -p 5432:5432 \
  -c wal_level=logical \
  -c max_wal_senders=10 \
  -c max_replication_slots=10 \
  -c log_statement=all \
  -v ~/.local/share/pg:/var/lib/postgresql/data \
  postgres
```

# Exec

```sh
docker exec -it postgres psql -U fine -d db
```

# Backup

# Restore
