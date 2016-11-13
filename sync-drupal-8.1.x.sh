#!/bin/bash
echo "Starting Drupal 8.2.x sync"
date
cd /home/joep/src/github.com/josephdpurcell/drupal-8.1.x/ 2>&1
git fetch drupal 8.1.x 2>&1
git pull --rebase drupal 8.1.x 2>&1
git push origin -f 8.1.x 2>&1
