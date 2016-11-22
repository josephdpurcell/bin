#!/bin/bash
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
fi
