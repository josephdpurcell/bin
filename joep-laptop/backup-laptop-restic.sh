#!/bin/sh
set -e
# See https://help.backblaze.com/hc/en-us/articles/115002880514-How-to-configure-Backblaze-B2-with-Restic-on-Linux
# See https://jpmens.net/2017/08/22/my-backup-software-of-choice-restic/
# See https://www.digitalocean.com/community/tutorials/how-to-back-up-data-to-an-object-storage-service-with-the-restic-backup-client
# 
# $ restic -r b2:josephdpurcell-joep-laptop init
# created restic repository 1d9df30f94 at b2:josephdpurcell-joep-laptop
# 
# Please note that knowledge of your password is required to access
# the repository. Losing your password means that your data is
# irrecoverably lost.
# 
# $ time restic -r b2:josephdpurcell-joep-laptop backup ~
# repository 1d9df30f opened successfully, password is correct
# created new cache in /home/joep/.cache/restic
# Save(<data/147324beec>) returned error, retrying after 405.164841ms: Close: b2_get_upload_url: 403: Cannot upload files, storage cap exceeded. See the Caps & Alerts page to increase your cap.
# Save(<data/88245596aa>) returned error, retrying after 421.099256ms: Close: b2_get_upload_url: 403: Cannot upload files, storage cap exceeded. See the Caps & Alerts page to increase your cap.
# Save(<data/eef2b607e4>) returned error, retrying after 526.247809ms: Close: b2_get_upload_url: 403: Cannot upload files, storage cap exceeded. See the Caps & Alerts page to increase your cap.
# [2:02] 0.02%  251 files 63.039 MiB, total 1801545 files 292.306 GiB, 0 errors ETA 160:52:34
# [2:03] 0.02%  251 files 63.039 MiB, total 1801545 files 292.306 GiB, 0 errors ETA 162:11:42
# /home/joep/.PhpStorm2017.1/system/index/.persistent/trigram.index/values.values
# [2:04] 0.02%  251 files 63.039 MiB, total 1801545 files 292.306 GiB, 0 errors ETA 163:30:49
#   signal interrupt received, cleaning up
# 
# $ restic -r b2:josephdpurcell-joep-laptop snapshots
#
#
# $ restic -r b2:josephdpurcell-joep-laptop restore 1d9df30f -t /tmp/restic-restore 
#
# =================================================================================
#
# SETUP:
#
# Create this file: $XDG_CONFIG_HOME/backup-laptop-restic.sh with these values:
# B2_ACCOUNT="applicationKeyID"
# B2_KEY="applicationKey"
#

RESTIC_REPOSITORY="b2:josephdpurcell-joep-laptop"
RESTIC_PASSWORD_FILE="/etc/restic-passwd"

time restic --exclude-file=/home/joep/.restic-excludes -r b2:josephdpurcell-joep-laptop backup ~

