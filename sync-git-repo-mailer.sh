#!/bin/bash
GIT_REPO=$1
GIT_BRANCH=$2
GIT_DIR="/home/joep/src/github.com/josephdpurcell/$GIT_REPO/"
SYNC_LOG="/home/joep/logs/sync-"$GIT_BRANCH".log"
SYNC_LOCK="/tmp/sync-"$GIT_REPO"-git-repo.lock"

if [ -z $GIT_BRANCH ]
then
    echo "Usage: sync-git-repo-mailer.sh [REPO] [BRANCH]"
    echo "Example: sync-git-repo-mailer.sh drupal-8.1.x 8.1.x"
    exit 1
fi

if [ ! -d $GIT_DIR ]
then
    echo "Could not find directory $GIT_DIR"
    exit 1
fi

/home/joep/bin/sync-git-repo.sh $GIT_REPO $GIT_BRANCH 2>&1 > $SYNC_LOG
if [ $? -ne 0 ]
then
    /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: $GIT_REPO:$GIT_BRANCH Sync FAILED" josephdpurcell@gmail.com
    exit 1
fi

grep "Everything up-to-date" $SYNC_LOG 2>&1 > /dev/null
if [ $? -ne 0 ]
then
    /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: $GIT_REPO:$GIT_BRANCH Sync CHANGED" josephdpurcell@gmail.com
#else
#    /bin/cat $SYNC_LOG | /usr/bin/mail -s "CRON: $GIT_REPO:$GIT_BRANCH Sync NO CHANGE" josephdpurcell@gmail.com
fi
