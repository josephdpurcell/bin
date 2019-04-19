#!/bin/bash
echo "Started weekly mysql backup on "$(date)
WOY=$(date '+%V')
mysqldump --defaults-file=/home/joep/.my.cnf --all-databases | gzip -c > /var/local/backups/mysql/week-$WOY-mysql.sql.gz
ls -lha /var/local/backups/mysql/week-*
echo "Completed weekly mysql backup on "$(date)
