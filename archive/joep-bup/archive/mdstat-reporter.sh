#!/bin/bash
echo "Generating mdadm report"
/bin/date
echo ""
echo "====================================================================="
echo "cat /proc/mdstat"
echo "====================================================================="
/bin/cat /proc/mdstat 2>&1
echo ""
echo "====================================================================="
echo "mdadm -E /dev/sdb"
echo "====================================================================="
/sbin/mdadm -E /dev/sdb 2>&1
echo ""
echo "====================================================================="
echo "mdadm -E /dev/sdc"
echo "====================================================================="
/sbin/mdadm -E /dev/sdc 2>&1
echo ""
echo "====================================================================="
echo "mdadm -Ds /dev/md"
echo "====================================================================="
/sbin/mdadm -Ds /dev/md0 2>&1
echo ""
echo "Finished mdadm report"
