#!/bin/bash
# Setup:
# sudo apt-get install build-essential -y
# sudo apt-get install python3-pip -y
# sudo pip3 install --upgrade b2
# b2 authorize-account "applicationKeyID" "applicationKey"
#
B2='/usr/local/bin/b2'
DOW=`date "+%u"`

echo "Started b2 backup on "$(date)

$B2 sync /var/local/backups/ b2://josephdpurcell-joep-bup/backups

echo "Completed b2 backup on "$(date)

