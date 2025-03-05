# Initial settiong
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