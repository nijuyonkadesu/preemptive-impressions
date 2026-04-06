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
