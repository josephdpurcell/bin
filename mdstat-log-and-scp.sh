#!/bin/bash
/home/joep/bin/mdstat-reporter.sh 2>&1 | tee /home/joep/logs/mdstat-custom.log
scp /home/joep/logs/mdstat-custom.log joep@josephdpurcell.com:logs/mdstat-custom.log
mv /home/joep/logs/mdstat-custom.log /home/joep/logs/mdstat-custom.log.1
