#!/bin/bash
LOCKFILE="$XDG_CACHE_HOME/backup-laptop.lock"

if [ ! -f "$LOCKFILE" ]
then
  echo "Lock file not found, creating it at $LOCKFILE"
  touch $LOCKFILE
# Older than 24 hrs
elif test "`find "$LOCKFILE" -mmin +1440`"
then
  echo "Lock file older than 24 hrs, updating"
  touch $LOCKFILE
else
  echo "Lock file is too recent, exiting."
  exit 0
fi

echo "Running backup"
bash "$HOME/bin/joep-laptop/lib/backup-laptop-b2.sh"
