#!/bin/bash
SYNC_LOG=/home/joep/logs/sync-drupal-8.2.x.log
/home/joep/bin/sync-drupal-8.2.x.sh 2>&1 > $SYNC_LOG

grep "Everything up-to-date" $SYNC_LOG 2>&1 > /dev/null
if [ $? -eq 0 ]
then
    /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: Drupal 8.2.x Sync NO CHANGE" josephdpurcell@gmail.com
else
    /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: Drupal 8.2.x Sync CHANGED" josephdpurcell@gmail.com
fi
