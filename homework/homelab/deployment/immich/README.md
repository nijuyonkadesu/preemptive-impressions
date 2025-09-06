# Immich with iGPU Setup
[Immich Docker Compose Steps](https://immich.app/docs/install/docker-compose) 

```sh
wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env

lspci | grep VGA
ls /dev/dri

sudo apt install mesa-va-drivers vainfo
vainfo

sudo usermod -aG video,render $USER
newgrp render

LIBVA_DRIVER_NAME=radeonsi vainfo --display drm

# Check for vaapi in the list
ffmpeg -hwaccels

# follow this: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository, and run: 
sudo apt update
sudo apt install docker-compose-plugin

podman compose up -d
```

## Backups

TODO: A 3-2-1 backup strategy is recommended to protect your data. You should keep copies of your uploaded photos/videos as well as the Immich database for a comprehensive backup solution.

TODO: https://www.backblaze.com/blog/the-3-2-1-backup-strategy/
TODO: follow - https://immich.app/docs/administration/backup-and-restore/#asset-types-and-storage-locations
