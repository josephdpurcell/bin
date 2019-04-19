#!/bin/bash
# Setup:
# sudo apt-get install build-essential -y
# sudo apt-get install python3-dev python3-pip -y
# sudo pip3 install --upgrade b2
# b2 authorize-account "applicationKeyID" "applicationKey"
#
echo "Started b2 backup on "$(date)
b2 sync /var/local/backups/ b2://josephdpurcell-joep-server/backups

b2 sync /var/www/ b2://josephdpurcell-joep-server/www

echo "Completed b2 backup on "$(date)

