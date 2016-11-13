#!/bin/bash
MDSTAT_LOG=/home/joep/logs/mdstat-custom.log
MDSTAT_LOG_BAK=/home/joep/logs/mdstat-custom.log.1
MDSTAT_EMAIL=josephdpurcell@gmail.com
MDSTAT_DATE=`date`

# If the log file is not found, there was an error reporting.
if [ ! -f $MDSTAT_LOG ]
then
    echo -e "Failure on: $MDSTAT_DATE\nMissing log file" | mail -s "CRON: mdstat FAILURE" $MDSTAT_EMAIL
    exit 1
fi

# If a drive is recovering, we will see recovering.
grep "State : .*recovering" $MDSTAT_LOG > /dev/null
if [ $? -eq 0 ]
then
    MDADM_IS_RECOVERING=1
else
    MDADM_IS_RECOVERING=0
fi

# If a drive failed, we won't see AA.
grep "State : .*degraded" $MDSTAT_LOG > /dev/null
if [ $? -eq 0 ]
then
    MDADM_IS_FAILED=1
else
    MDADM_IS_FAILED=0
fi

if [ $MDADM_IS_RECOVERING -eq 1 ]
then
    cat $MDSTAT_LOG | mail -s "CRON: mdstat RECOVERING" $MDSTAT_EMAIL
elif [ $MDADM_IS_FAILED -eq 1 ]
then
    cat $MDSTAT_LOG | mail -s "CRON: mdstat FAILURE" $MDSTAT_EMAIL
else
    cat $MDSTAT_LOG | mail -s "CRON: mdstat NORMAL" $MDSTAT_EMAIL
fi

# Ensure the bup server is still sending us fresh logs.
mv $MDSTAT_LOG $MDSTAT_LOG_BAK

