#!/bin/bash
mysqldump --defaults-file=/home/joep/.my.cnf --all-databases > /var/local/backups/mysql/mysql.sql
