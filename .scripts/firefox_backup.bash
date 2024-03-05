#!/bin/bash


if [ -z "$1" ]; then
    echo "No profile name supplied"
    exit 1
fi

set -eux

# To find the value, in Firefox go to about:support → look for the line Profile Directory.
PROFILE_NAME="$1"
FIREFOX_PROFILE_DIRECTORY="$HOME/snap/firefox/common/.mozilla/firefox/$PROFILE_NAME"
FIREFOX_SESSION_BACKUP_FOLDER="$FIREFOX_PROFILE_DIRECTORY/sessionstore-backups"
BACKUP_FOLDER="$HOME/Shelf/Sauvegarde/Firefox"
NOW="$(date -Iseconds)"
BACKUP_FOLDER_FOR_TODAY="$BACKUP_FOLDER/ff-bck-$NOW"

rsync -vihurlt $FIREFOX_SESSION_BACKUP_FOLDER $BACKUP_FOLDER_FOR_TODAY
find "$BACKUP_FOLDER" -maxdepth 1 -mtime +7 -execdir gio trash {} +

