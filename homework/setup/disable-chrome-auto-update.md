# Chrome

```sh
sudo mkdir -p /etc/opt/chrome/policies/managed
sudo nvim /etc/opt/chrome/policies/managed/disable-updates.json

```

and paste:

```json
{
  "AutoUpdateCheckPeriodMinutes": 0,
  "DisableAutoUpdateChecksCheckboxValue": true,
  "UpdatePolicy": {
    "google-chrome": 0
  }
}
```

# Brave

```sh
sudo mkdir -p /etc/brave/policies/managed
sudo nvim /etc/brave/policies/managed/disable-updates.json
```

and paste:

```json
{
  "AutoUpdateCheckPeriodMinutes": 0,
  "DisableAutoUpdateChecksCheckboxValue": true,
  "UpdatePolicy": {
    "brave": 0
  }
}
```
