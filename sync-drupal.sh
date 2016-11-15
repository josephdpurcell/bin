#!/bin/bash
DRUPAL_BRANCH=$1
DRUPAL_DIR="/home/joep/src/github.com/josephdpurcell/drupal-$DRUPAL_BRANCH/"

if [ -z $DRUPAL_BRANCH ]
then
    echo "Usage: sync-drupal.sh [BRANCH]"
    echo "Example: sync-drupal.sh 8.1.x"
    exit 1
fi

if [ ! -d $DRUPAL_DIR ]
then
    echo "Could not find directory $DRUPAL_DIR"
    exit 1
fi

echo "Starting $DRUPAL sync"

/bin/date

cd $DRUPAL_DIR

/usr/bin/git fetch drupal "$DRUPAL_BRANCH" 2>&1
if [ $? -ne 0 ]
then
    exit 1
fi

/usr/bin/git pull --rebase drupal "$DRUPAL_BRANCH" 2>&1
if [ $? -ne 0 ]
then
    exit 1
fi

/usr/bin/git push -f origin "$DRUPAL_BRANCH" 2>&1
if [ $? -ne 0 ]
then
    exit 1
fi
