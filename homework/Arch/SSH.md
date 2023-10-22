## Step 1 
sshd  
passwd  
add a single key, then remove password login (edit sshd config)

`ssh u0_a342@shell.cocooil.tech -p 8022  `
`ssh-keygen -t ed25519  `
`ssh-copy-id -i .ssh/id_ed25519.pub u0_a342@shell.cocooil.tech -p 8022  `
  
[https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/install-and-setup/tunnel-guide/local/](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/install-and-setup/tunnel-guide/local/)  
  
look at it's usecases  
[https://developers.cloudflare.com/learning-paths/modules/security/ddos-baseline/enable-waf/?learning_path=prevent-ddos-attacks](https://developers.cloudflare.com/learning-paths/modules/security/ddos-baseline/enable-waf/?learning_path=prevent-ddos-attacks)  
  
FIX #1 --------  
Create Onion tunnel