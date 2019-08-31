#!/bin/bash
echo "Started daily mysql backup on "$(date)
DOW=$(date '+%u')
mysqldump --defaults-file=/home/joep/.my.cnf --all-databases | gzip -c > /var/local/backups/mysql/day-$DOW-mysql.sql.gz
ls -lha /var/local/backups/mysql/day-*
echo "Completed daily mysql backup on "$(date)
