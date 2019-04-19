#!/bin/sh
set -e
# See https://www.loganmarchione.com/2017/07/backblaze-b2-backup-setup/
# See https://loganmarchione.com/2015/12/brief-introduction-gpg/#Generate_a_key_pair
# See https://blog.xmatthias.com/duplicity_getting_started/
# See https://www.backblaze.com/blog/backing-linux-backblaze-b2-duplicity-restic/
#
# STEP 1. Install duplicity
#
# $ sudo add-apt-repository ppa:duplicity-team/ppa
# $ sudo apt-get update
# $ sudo apt-get --only-upgrade install duplicity
# 
# $ duplicity --version 
# duplicity 0.7.13.1
#
# STEP 2. Install B2
#
# $ sudo pip install b2
#
# NOTE: the account ID is the token ID, not the account id
# $ b2 authorize-account "applicationKeyID" "applicationKey"
#
# STEP 3. Generate keys
#
# While backing up, the public key of the encryption key pair is used to
# encrypt the data, while the private key of the signing key pair will be used to
# ensure the integrity of the backup.
#
# 1. Generate your signing key, with a revoke, and export it:
#
# $ gpg --gen-key
# $ gpg --gen-revoke --output=9F444799-revocation.asc 9F444799
# $ mv 9F444799-revocation.asc ~/.gnupg/
# $ gpg --export --armor 9F444799 > ~/.gnupg/9F444799-public.key
# $ gpg --export-secret-key 9F444799 > ~/.gnupg/9F444799-private.key
#
# 2. Generate your encryption key, with a revoke, and export it:
#
# $ gpg --gen-key
# $ gpg --gen-revoke --output=522E59F6-revocation.asc 522E59F6
# $ mv 522E59F6-revocation.asc ~/.gnupg/
# $ gpg --export --armor 522E59F6 > ~/.gnupg/522E59F6-public.key
# $ gpg --export-secret-key 522E59F6 > ~/.gnupg/522E59F6-private.key
#
# NOTE: to import one:
# $ gpg --import BC2FD7E2-public.key
# $ gpg --import BC2FD7E2-private.key
#
# 3. Publish the public key to keybase (optional)
#
# $ curl -O https://prerelease.keybase.io/keybase_amd64.deb
# $ sudo dpkg -i keybase_amd64.deb
# $ keybase login
# $ keybase pgp select
#
# 4. Sign your key
#
# $ gpg -u 9F444799 --sign-key duplicity_enc
#
# 5. Take note of your long keys:
#
# $ gpg --list-keys --keyid-format long 
#
# STEP 4. Test local backups
#
# $ mkdir backup-test
# $ cd backup-test
# $ mkdir backup{1..10}
# $ touch backup{1..10}/file{1..5}
# 
# $ duplicity full --encrypt-key E76638D937CD1B32 --sign-key F14E0DE0DA860108 /home/joep/backup-test file:///tmp/backup
# Local and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 12:28:29 2018
# GnuPG passphrase: 
# GnuPG passphrase for signing key: 
# --------------[ Backup Statistics ]--------------
# StartTime 1540402457.00 (Wed Oct 24 12:34:16 2018)
# EndTime 1540402457.06 (Wed Oct 24 12:34:17 2018)
# ElapsedTime 0.06 (0.06 seconds)
# SourceFiles 61
# SourceFileSize 45056 (44.0 KB)
# NewFiles 61
# NewFileSize 45056 (44.0 KB)
# DeletedFiles 0
# ChangedFiles 0
# ChangedFileSize 0 (0 bytes)
# ChangedDeltaSize 0 (0 bytes)
# DeltaEntries 61
# RawDeltaSize 0 (0 bytes)
# TotalDestinationSizeChange 1974 (1.93 KB)
# Errors 0
# -------------------------------------------------
#
# $ duplicity verify --compare-data --encrypt-key E76638D937CD1B32 --sign-key F14E0DE0DA860108 file:///tmp/backup /home/joep/backup-test
# Local and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 12:34:05 2018
# GnuPG passphrase: 
# Verify complete: 61 files compared, 0 differences found.
#
# $ echo "asdf" >> /home/joep/backup-test/backup2/file2
#
# $ duplicity verify --compare-data --encrypt-key E76638D937CD1B32 --sign-key F14E0DE0DA860108 file:///tmp/backup /home/joep/backup-test
# Local and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 12:34:05 2018
# GnuPG passphrase: 
# Difference found: File backup2/file2 has mtime Wed Oct 24 12:37:04 2018, expected Wed Oct 24 12:20:04 2018
# Verify complete: 61 files compared, 1 difference found.
#
# $ duplicity incr --encrypt-key E76638D937CD1B32 --sign-key F14E0DE0DA860108 /home/joep/backup-test file:///tmp/backup
# Local and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 12:34:05 2018
# GnuPG passphrase: 
# GnuPG passphrase for signing key: 
# --------------[ Backup Statistics ]--------------
# StartTime 1540402722.85 (Wed Oct 24 12:38:42 2018)
# EndTime 1540402722.87 (Wed Oct 24 12:38:42 2018)
# ElapsedTime 0.01 (0.01 seconds)
# SourceFiles 61
# SourceFileSize 45061 (44.0 KB)
# NewFiles 0
# NewFileSize 0 (0 bytes)
# DeletedFiles 0
# ChangedFiles 1
# ChangedFileSize 5 (5 bytes)
# ChangedDeltaSize 0 (0 bytes)
# DeltaEntries 1
# RawDeltaSize 12 (12 bytes)
# TotalDestinationSizeChange 1339 (1.31 KB)
# Errors 0
# -------------------------------------------------
#
# $ duplicity restore --encrypt-key E76638D937CD1B32 --sign-key F14E0DE0DA860108 file:///tmp/backup /tmp/backup-test-new
# Local and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 12:34:05 2018
# GnuPG passphrase: 
# 
# $ cat /tmp/backup-test-new/backup2/file2 
# asdf
#
# STEP 5. Test remote backups
#
# $ mkdir backup-test
# $ cd backup-test
# $ mkdir backup{1..10}
# $ touch backup{1..10}/file{1..5}
# 
# $ duplicity --sign-key F14E0DE0DA860108 --encrypt-key E76638D937CD1B32 /home/joep/backup-test b2://00211291c971d070000000002:K0027FktAF3yaWn208i7fCXWBilbQSg@josephdpurcell-joep-laptop-dbs
# Local and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 13:31:35 2018
# GnuPG passphrase: 
# GnuPG passphrase for signing key: 
# --------------[ Backup Statistics ]--------------
# StartTime 1540406012.30 (Wed Oct 24 13:33:32 2018)
# EndTime 1540406012.33 (Wed Oct 24 13:33:32 2018)
# ElapsedTime 0.03 (0.03 seconds)
# SourceFiles 61
# SourceFileSize 45061 (44.0 KB)
# NewFiles 0
# NewFileSize 0 (0 bytes)
# DeletedFiles 0
# ChangedFiles 0
# ChangedFileSize 0 (0 bytes)
# ChangedDeltaSize 0 (0 bytes)
# DeltaEntries 0
# RawDeltaSize 0 (0 bytes)
# TotalDestinationSizeChange 1245 (1.22 KB)
# Errors 0
# -------------------------------------------------
#
# $ duplicity verify --encrypt-key E76638D937CD1B32 b2://00211291c971d070000000002:K0027FktAF3yaWn208i7fCXWBilbQSg@josephdpurcell-joep-laptop-dbs /home/joep/backup-testLocal and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 13:31:35 2018
# GnuPG passphrase: 
# Verify complete: 62 files compared, 0 differences found.
#
# $ echo "hahahaha" >> /home/joep/backup-test/backup2/file
#
# $ duplicity incr --sign-key F14E0DE0DA860108 --encrypt-key E76638D937CD1B32 /home/joep/backup-test b2://00211291c971d070000000002:K0027FktAF3yaWn208i7fCXWBilbQSg@josephdpurcell-joep-laptop-dbsLocal and Remote metadata are synchronized, no sync needed.
# Last full backup date: Wed Oct 24 13:31:35 2018
# GnuPG passphrase: 
# GnuPG passphrase for signing key: 
# --------------[ Backup Statistics ]--------------
# StartTime 1540406990.56 (Wed Oct 24 13:49:50 2018)
# EndTime 1540406990.58 (Wed Oct 24 13:49:50 2018)
# ElapsedTime 0.01 (0.01 seconds)
# SourceFiles 61
# SourceFileSize 45080 (44.0 KB)
# NewFiles 0
# NewFileSize 0 (0 bytes)
# DeletedFiles 0
# ChangedFiles 1
# ChangedFileSize 19 (19 bytes)
# ChangedDeltaSize 0 (0 bytes)
# DeltaEntries 1
# RawDeltaSize 26 (26 bytes)
# TotalDestinationSizeChange 1341 (1.31 KB)
# Errors 0
# -------------------------------------------------
#
# $ duplicity restore  --sign-key F14E0DE0DA860108 --encrypt-key E76638D937CD1B32 b2://00211291c971d070000000002:K0027FktAF3yaWn208i7fCXWBilbQSg@josephdpurcell-joep-laptop-dbs/home/joep/backups /tmp/josephdpurcell-joep-laptop-dbs
# Synchronizing remote metadata to local cache...
# GnuPG passphrase: 
# Copying duplicity-inc.20181025T125944Z.to.20181025T130243Z.manifest.gpg to local cache.
# Copying duplicity-new-signatures.20181025T125944Z.to.20181025T130243Z.sigtar.gpg to local cache.
# Last full backup date: Wed Oct 24 15:25:48 2018
# 
# $ cat /tmp/josephdpurcell-joep-laptop-dbs/backup3/file3
# hahahaha
#
# =================================================================================
#
# Usage of this script:
#
# Create this file: $XDG_CONFIG_HOME/backup-laptop-duplicity.sh with these values:
# B2_ACCOUNT="applicationKeyID"
# B2_KEY="applicationKey"
#
# # GPG key (last 8 characters) of the public fingerprint.
# ENC_KEY="E76638D937CD1B32"
# SGN_KEY="F14E0DE0DA860108"
#
# PASSPHRASE="passphrase for ENC_KEY"
# SIGN_PASSPHRASE="passphrase for SGN_KEY"
#

# Backblaze B2 configuration variables
B2_BUCKET="josephdpurcell-joep-laptop-dbs"
B2_DIR="joep-laptop-2018-dbs"

# Include overrides
if [ -f "$XDG_CONFIG_HOME/backup-laptop-duplicity.sh" ]
then
    source $XDG_CONFIG_HOME/backup-laptop-duplicity.sh
fi

# Do you want encryption? 1=yes, 0=no
B2_ENC=0

# Local directory to backup
LOCAL_DIR="/home/joep"

if [ $B2_ENC -eq 0 ]
then

# Remove files older than 90 days
echo "Remove old files"
# Note: this assumes you are not setting lifecycle in backblaze
#duplicity \
# --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
# remove-older-than 90D --force \
# b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Perform the backup, make a full backup if it's been over 30 days
echo "Begin backup"
duplicity -v8 \
 --full-if-older-than 30D \
 --progress \
  --exclude-regexp ".PhpStorm2017*" \
  --exclude-regexp ".cache" \
  --exclude-regexp "vendor" \
 ${LOCAL_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Cleanup failures
echo "Cleanup failures"
duplicity \
 cleanup --force \
 b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Example of how to verify:
# duplicity verify \
# --encrypt-key $ENC_KEY
# b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR} ${LOCAL_DIR}

# Show collection-status
echo "Get collection status"
duplicity collection-status -v8 \
  b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Example of how to restore:
# duplicity restore \
# --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
# b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR} ${LOCAL_DIR}

else

# Remove files older than 90 days
echo "Remove old files"
# Note: this assumes you are not setting lifecycle in backblaze
#duplicity \
# --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
# remove-older-than 90D --force \
# b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Perform the backup, make a full backup if it's been over 30 days
echo "Begin backup"
duplicity \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY -v8 \
 --full-if-older-than 30D \
 --progress \
 ${LOCAL_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Cleanup failures
echo "Cleanup failures"
duplicity \
 cleanup --force \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
 b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Example of how to verify:
# duplicity verify \
# --encrypt-key $ENC_KEY
# b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR} ${LOCAL_DIR}

# Show collection-status
echo "Get collection status"
duplicity collection-status -v8 \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
  b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Example of how to restore:
# duplicity restore \
# --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
# b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR} ${LOCAL_DIR}

fi

# Unset variables
unset B2_ACCOUNT
unset B2_KEY
unset ENC_KEY
unset SGN_KEY
unset PASSPHRASE
unset SIGN_PASSPHRASE
