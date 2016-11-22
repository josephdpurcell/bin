#!/bin/bash
BACKUP_EMAIL=josephdpurcell@gmail.com
BACKUP_DATE=`date`
BACKUP_SCRIPT=/home/joep/bin/backup-joep-laptop.sh
BACKUP_LOG=/home/joep/logs/backup-joep-laptop.log
BACKUP_LOCK=/tmp/backup-joep-laptop.lock

if [ -f $BACKUP_LOCK ]
then
    /bin/echo "Lock file exists $BACKUP_LOCK" | /usr/bin/mail -s "CRON: Backup joep-laptop ALREADY RUNNING" $BACKUP_EMAIL
    exit 1
fi

if [ ! -x $BACKUP_SCRIPT ]
then
    /bin/echo "Cannot execute $BACKUP_SCRIPT" | /usr/bin/mail -s "CRON: Backup joep-laptop FAILED" $BACKUP_EMAIL
    exit 1
fi

/usr/bin/touch $BACKUP_LOCK

/usr/bin/bash $BACKUP_SCRIPT 2>&1 > $BACKUP_LOG
if [ $? -ne 0 ]
then
    /usr/bin/rm $BACKUP_LOCK
    /bin/cat $BACKUP_LOG | /usr/bin/mail -s "CRON: Backup joep-laptop FAILED" $BACKUP_EMAIL
    exit 1
fi

/usr/bin/rm $BACKUP_LOCK
cat $BACKUP_LOG | mail -s "CRON: Backup joep-laptop FINISHED" $BACKUP_EMAIL

