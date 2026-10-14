#!/bin/sh

# This system is configured to use Fcitx 5 + Mozc.
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Make the variables available to D-Bus/systemd user services as well.
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    dbus-update-activation-environment --systemd \
        GTK_IM_MODULE QT_IM_MODULE XMODIFIERS
fi

# Stop an old IBus session so it cannot conflict with Fcitx 5.
if command -v ibus >/dev/null 2>&1; then
    ibus exit >/dev/null 2>&1 || true
fi

# Prefer the Fcitx 5 package from the active NixOS generation.
fcitx5_bin=/run/current-system/sw/bin/fcitx5
if [ ! -x "$fcitx5_bin" ]; then
    fcitx5_bin=$(command -v fcitx5) || {
        echo "fcitx5 is not installed" >&2
        exit 1
    }
fi

# Replace any stale Fcitx 5 process and run in the background.
exec "$fcitx5_bin" --replace -d
