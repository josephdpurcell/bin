#!/bin/bash
# My Laptop Backup Script
#
# Configuration:
#   1. Change $BUP_DEST_ROOT to the drive/folder you want to have mirror your laptop.
#   2. Change $BUP_SRC_DIRS to all the paths to backup (use full paths).
#   3. Optionally, remove the mount/umount commands, see AUTO MOUNTING.
#
# Example Configuration:
#   If $BUP_DEST_ROOT is '/mnt/bup' and $BUP_SRC_DIRS has '/home/joep' and
#   '/etc', running this script will backup those directories to
#   /mnt/bup/home/joep and /mnt/bup/etc, respectively.
#
# AUTO MOUNTING configuration:
#   This script will manually mount the $BUP_DISK when the script is executed,
#   and unmount it when it is done. This is useful if you have a docking
#   station with the disk connected and you may undock your laptop at any time.
#   (Undocking while backup is in progress is... not ideal.)
#
#   To use this functionality:
#       1. Add a line simlar to the following to /etc/fstab:
#
#           UUID=aed1f4eb-fc29-4266-8a55-cf745235c3ff /run/media/joep/joep-laptop-bup ext4  noauto,defaults,user 0 0
#
#       2. Edit the $BUP_DISK to be the path that is mounted.
#
#

BUP_DISK='/run/media/joep/joep-laptop-bup'
BUP_DEST_ROOT='/run/media/joep/joep-laptop-bup/joep-laptop'
BUP_SRC_DIRS=(
    # General content directories.
    '/home/joep/Desktop'
    '/home/joep/Documents'
    '/home/joep/Downloads'
    '/home/joep/Music'
    '/home/joep/Pictures'
    '/home/joep/Videos'
    '/home/joep/Videos'

    # Dot files.
    '/home/joep/.bash_includes'
    '/home/joep/.bashrc'
    '/home/joep/.ctags'
    '/home/joep/.gitconfig'
    '/home/joep/.inputrc'
    '/home/joep/.marks'
    '/home/joep/.profile'
    '/home/joep/.purple'
    '/home/joep/.purple-proxy'
    '/home/joep/.ssh'
    '/home/joep/.vim'
    '/home/joep/.vimrc'
    '/home/joep/phpmd_drupal.xml'
    '/home/joep/phpmd_ruleset.xml'

    # All Git repos and sites.
    '/home/joep/src'

    # Any notes.
    /home/joep/*.txt

    # Virtual machines.
    '/home/joep/VirtualBox VMs'
    '/home/joep/.vagrant.d'

    # DBridge dev.
    '/home/joep/drupal-vm'
    '/home/joep/www'

    # Not sure what this is.
    '/home/joep/bup'

    # Backup system configuration.
    '/etc'
)

mount $BUP_DISK

if [ -d $BUP_DEST_ROOT ]
then
    for ((i = 0; i < ${#BUP_SRC_DIRS[@]}; i++))
    do
        BUP_SRC="${BUP_SRC_DIRS[$i]}"
        BUP_DEST_DIR=`dirname "$BUP_SRC"`
        echo "====================================================================="
        echo "Backing up $BUP_SRC"
        rsync -av "$BUP_SRC" "$BUP_DEST_ROOT$BUP_DEST_DIR" 2>&1
        echo ""
    done
else
    echo "Backup directory does not exist! This is a critical error you should investigate."
fi

umount $BUP_DISK
