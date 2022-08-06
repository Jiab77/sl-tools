# sl-tools

Some tools made when [Linden Lab](https://en.wikipedia.org/wiki/Linden_Lab) / [Second Life](https://secondlife.com) blocked my IP for "security reasons" :rofl:

## Context

They blocked my IP after the publication of this [research](https://gist.github.com/Jiab77/6c38f6566d68784f4591b60c0269a8f0) and probably for having made the [sl-friends](https://github.com/Jiab77/sl-friends) project :sweat_smile:.

> __*They have unblocked my IP few months later without telling me why...*__

So, these scripts can be used by those who also got their IP blocked and still willing to go to the virtual world without being blocked anymore.

## Requirements

* [sl-novpn.sh](sl-novpn.sh): none
* [sl-proxy-ssh.sh](sl-proxy-ssh.sh):
  * `proxychains` installed on your machine
  * A VPS with `ssh` installed
* [sl-proxy-tor.sh](sl-proxy-tor.sh):
  * `proxychains` and `tor` installed on your machine
* [sl-vpn.sh](sl-vpn.sh):
  * `protonvpn-cli` installed on your machine

> The VPN [script](sl-vpn.sh) has been made for using [Proton VPN](https://protonvpn.com/) as provider but you should be able to use any other ones by updating the [config](sl.template.conf) file and the [script](sl-vpn.sh) itself for the commands to pass to the VPN provider binary.

## Configuration

Copy the file [sl.template.conf](sl.template.conf) to `sl.conf` and add the missing informations.

Example config:

```bash
# main
CLIENT_DIR="$HOME/firestorm"
CLIENT_BIN="./firestorm"

# tor / ssh proxy
SSH_USER="[REDACTED]"
SSH_HOST="[REDACTED].linode.com"
TUNNEL_PORT=9050
KILL_EXISTING_TUNNEL=true
PROXYCHAINS_BIN="proxychains4"

# vpn
VPN_BIN="protonvpn-cli"
```

## Author

[Jiab77](https://twitter.com/jiab77)
