#!/bin/bash
echo "Starting Drupal 7.x sync"
date
cd /home/joep/src/github.com/josephdpurcell/drupal-7.x/ 2>&1
git fetch drupal 7.x 2>&1
git pull --rebase drupal 7.x 2>&1
git push -f origin 7.x 2>&1
