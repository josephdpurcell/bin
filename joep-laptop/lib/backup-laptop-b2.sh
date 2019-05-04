#!/bin/bash
# Setup:
# sudo apt-get install build-essential -y
# sudo apt-get install python3-dev python3-pip -y
# sudo pip3 install --upgrade b2
# b2 authorize-account "applicationKeyID" "applicationKey"
#
B2='/usr/local/bin/b2'
echo "Started b2 backup on "$(date)
# Note: .marks is excluded only because of its symlinks
# Note: .platform is excluded to avoid symlink recursion
# Note: .lastpass is excluded to avoid symlinks
#b2 sync --excludeRegex '^(.config|.local|.marks|vendor|.cache|VirtualBox VMs|.mozilla)' ~/ b2://josephdpurcell-joep-laptop-dbs/home
$B2 sync --threads 32 --excludeAllSymlinks --excludeDirRegex '^(.*\.platform|.lastpass|.config|Downloads|.local|.marks|vendor|.cache|VirtualBox VMs|.mozilla)' ~/ b2://josephdpurcell-joep-laptop-dbs/home
echo "Completed b2 backup on "$(date)
