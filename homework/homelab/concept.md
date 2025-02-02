# SSH

scenario: client -> ssh into -> server

1. server's pub key is copied to client's known_hosts
2. client can append it's public key into server's authorized_keys

This prevents man in the middle attack. User will be notified if unauthorized changes were made to any of these two keys.
Otherwise, user can just log into server without any messages
