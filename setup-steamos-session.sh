#!/bin/bash
set -e

# Create steam user
useradd -m -u 1000 -G wheel,input,video,audio,render -s /bin/bash steam
echo "steam:steam" | chpasswd

# Autostart Steam Big Picture
mkdir -p /home/steam/.config/autostart
cat <<'EOF' > /home/steam/.config/autostart/steam-bigpicture.desktop
[Desktop Entry]
Type=Application
Name=Steam Big Picture
Exec=/usr/bin/steam -bigpicture
Icon=steam
Categories=Game;
X-KDE-autostart-phase=2
EOF

# Auto-login into gamescope session via SDDM
mkdir -p /etc/sddm.conf.d
cat <<'EOF' > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=steam
Session=gamescope-session
EOF

chown -R steam:steam /home/steam
