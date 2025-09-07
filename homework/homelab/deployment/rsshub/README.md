# Steps

Use RSSHUB's private endpoint with [ReadYou RSS Reader](https://t.me/ReadYouApp). I use this to track github repos (PR, issues, releases).

[RSSHUB deploy guide](https://docs.rsshub.app/deploy/) 

```sh
podman compose up -d
```

# Auto update

1. TODO: check and use https://github.com/containrrr/watchtower
2. manual update `podman compose pull` and `podman compose up -d`
