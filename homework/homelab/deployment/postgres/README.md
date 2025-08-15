# Start:

TODO: update the commands from watgbridge readme

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

**prerequisite:** installing rclone. check bootstrap file and configure rclone.
whitelist just one command to be passwordless sudo.

```sh
sudo visudo -f /etc/sudoers.d/postgres-backup
# Add the following line
shichika ALL=(ALL) NOPASSWD: /usr/bin/podman exec -e POSTGRES_PASSWORD=* systemd-portable-postgres *
```

```sh
# TODO: add the files
sudo cp portable-postgres.container /etc/containers/systemd/

cp pg-backup.sh $HOME/.local/bin/pg-backup.sh
chmod +x $HOME/.local/bin/pg-backup.sh
sudo cp pg-backup.service /etc/systemd/system/
sudo cp pg-backup.timer /etc/systemd/system/

sudo systemctl daemon-reload

# Enabling timer unit is alone enough
sudo systemctl enable pg-backup.timer
sudo systemctl start pg-backup.timer

# to fire once:
sudo systemctl start pg-backup.service
```

# Restore

---

# TODO: Rootless + autostart

```sh
# Add user to necessary groups
sudo usermod -aG containers shichika

# Configure subuid/subgid for rootless containers
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 shichika

# Enable lingering so user services can run without login
sudo loginctl enable-linger shichika

```
