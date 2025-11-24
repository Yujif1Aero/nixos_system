# Initial setting
```bash
ls /etc/nixos/
configuration.nix hardware-configuration.nix
```
```bash
cp /etc/nixos/* .
```
# nixos_system
sudo nixos-rebuild switch --flake .#myNixOS

## check tailscale
sudo tailscale status

## Japanese
```bash
ibus-daemon -drx
```
put home dir `fcitx5.sh` and `setxkbmap_us.sh`
## Xsession
put home dir `.xsession`

# nixos_system
sudo nixos-rebuild switch --flake .#myNixOS
