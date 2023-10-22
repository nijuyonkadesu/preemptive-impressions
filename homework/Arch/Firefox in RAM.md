steps:  
```bash
systemctl enable firefox-profile\@cbf8hh56.default-release.service  
systemctl start --user firefox-profile\@cbf8hh56.default-release.service  
systemctl status firefox-profile\@cbf8hh56.default-release.service  
```
  
profiles in:  
```
/home/guts/.local/bin/firefox-sync.sh cbf8hh56.default-release  
/home/guts/.config/systemd/user/firefox-profile@.service
```
