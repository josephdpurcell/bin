#!/bin/bash
GIT_REPO=$1
GIT_BRANCH=$2
GIT_DIR="/home/joep/src/github.com/josephdpurcell/$GIT_REPO/"

if [ -z $GIT_BRANCH ]
then
    echo "Usage: sync-git-repo.sh [REPO] [BRANCH]"
    echo "Example: sync-git-repo.sh drupal-8.1.x 8.1.x"
    exit 1
fi

if [ ! -d $GIT_DIR ]
then
    echo "Could not find directory $GIT_DIR"
    exit 1
fi

echo "Starting $GIT_REPO:$GIT_BRANCH sync"

/bin/date

cd $GIT_DIR

# @todo check for an upstream remote

/usr/bin/git fetch upstream "$GIT_BRANCH" 2>&1
if [ $? -ne 0 ]
then
    exit 1
fi

/usr/bin/git pull --rebase upstream "$GIT_BRANCH" 2>&1
if [ $? -ne 0 ]
then
    exit 1
fi

/usr/bin/git push -f origin "$GIT_BRANCH" 2>&1
if [ $? -ne 0 ]
then
    exit 1
fi
