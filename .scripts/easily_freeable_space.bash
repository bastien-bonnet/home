#!/bin/bash

du -hs ~/.local/share/Trash/files
sudo du -hs /tmp /var/tmp /var/cache

echo -e "\nRemovable (disabled) snaps:"
snap list --all | awk '/disabled/{print $1" --revision "$3}' | xargs -rn3 echo sudo snap remove

echo ""
journalctl --disk-usage
echo "You can either :"
echo "1. Clear systemd journal to keep only last 2 days:"
echo "    sudo journalctl --vacuum-time=2d"
echo "2. Schedule journald to only keep as much data as you are interested in by"
echo "editing /etc/systemd/journald.conf and changing size or time settings:"
echo "    MaxRetentionSec=2day"
echo "    SystemMaxUse=100M"
echo "Then restart daemon with"
echo "    systemctl restart systemd-journald"
