#!/bin/bash
echo "Started daily mysql backup on "$(date)
DOM=$(date '+%d')
mysqldump --defaults-file=/home/joep/.my.cnf --all-databases > /var/local/backups/mysql/day-$DOM-mysql.sql.gz
ls -lha /var/local/backups/mysql/day-*
echo "Completed daily mysql backup on "$(date)
