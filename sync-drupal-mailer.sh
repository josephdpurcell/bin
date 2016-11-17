#!/bin/bash
DRUPAL_BRANCH=$1
SYNC_LOG="/home/joep/logs/sync-drupal-"$DRUPAL_BRANCH".log"
SYNC_LOCK="/tmp/sync-drupal-"$DRUPAL_BRANCH".lock"

if [ -z $DRUPAL_BRANCH ]
then
    echo "Usage: sync-drupal-mailer.sh [BRANCH]"
    echo "Example: sync-drupal-mailer.sh 8.1.x"
    exit 1
fi

/home/joep/bin/sync-drupal.sh $DRUPAL_BRANCH 2>&1 > $SYNC_LOG
if [ $? -ne 0 ]
then
    if [ -f $SYNC_LOCK ]
    then
        rm $SYNC_LOCK
    fi
    /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: Drupal $DRUPAL_BRANCH Sync FAILED" josephdpurcell@gmail.com
    exit 1
fi

grep "Everything up-to-date" $SYNC_LOG 2>&1 > /dev/null
if [ $? -eq 0 ]
then
    # Only say nothing changed once a day.
    if [ ! -f $SYNC_LOCK ]
    then
        touch $SYNC_LOCK
        /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: Drupal $DRUPAL_BRANCH Sync NO CHANGE" josephdpurcell@gmail.com
    fi
else
    if [ -f $SYNC_LOCK ]
    then
        rm $SYNC_LOCK
    fi
    /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: Drupal $DRUPAL_BRANCH Sync CHANGED" josephdpurcell@gmail.com
fi
