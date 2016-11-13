#!/bin/bash
/root/bin/mdstat-reporter.sh | tee /var/log/mdstat-custom.log
scp /var/log/mdstat-custom.log joep@josephdpurcell.com:logs/mdstat-custom.log
mv /var/log/mdstat-custom.log /var/log/mdstat-custom.log.1
