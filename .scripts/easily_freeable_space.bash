#!/bin/bash

du -hs ~/.local/share/Trash/files
sudo du -hs /tmp /var/tmp /var/cache

echo -e "\nRemovable (disabled) snaps:"
snap list --all | awk '/disabled/{print $1" --revision "$3}' | xargs -rn3 echo sudo snap remove

echo ""
journalctl --disk-usage
echo "Clear systemd journal to keep only last 2 days:"
echo "sudo journalctl --vacuum-time=2d"
