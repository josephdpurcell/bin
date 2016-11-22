#!/bin/bash
BACKUP_EMAIL=josephdpurcell@gmail.com
BACKUP_DATE=`date`
BACKUP_SCRIPT=/home/joep/bin/backup-joep-laptop.sh
BACKUP_LOG=/home/joep/logs/backup-joep-laptop.log

if [ ! -x $BACKUP_SCRIPT ]
then
    /bin/echo "Cannot execute $BACKUP_SCRIPT" | /usr/bin/mail -s "CRON: Backup joep-laptop FAILED" $BACKUP_EMAIL
    exit 1
fi

/usr/bin/bash $BACKUP_SCRIPT 2>&1 > $BACKUP_LOG
if [ $? -ne 0 ]
then
    /bin/cat $BACKUP_LOG | /usr/bin/mail -s "CRON: Backup joep-laptop FAILED" $BACKUP_EMAIL
    exit 1
fi

cat $BACKUP_LOG | mail -s "CRON: Backup joep-laptop FINISHED" $BACKUP_EMAIL

