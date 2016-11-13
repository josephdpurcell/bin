#!/bin/bash
/home/joep/bin/mdstat-reporter.sh 2>&1 | tee /var/log/mdstat-custom.log
scp /var/log/mdstat-custom.log joep@josephdpurcell.com:logs/mdstat-custom.log
mv /var/log/mdstat-custom.log /var/log/mdstat-custom.log.1
