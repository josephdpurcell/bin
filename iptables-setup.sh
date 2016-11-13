#!/bin/bash
# This is my script for setting up firewall rules. It's a work in progress and
# I'm not 100% convinced this is the best setup for me. But, it's a start.
# Also, many thanks to Digital Ocean from which I drew a few hints:
# https://www.digitalocean.com/community/articles/how-to-setup-a-basic-ip-tables-configuration-on-centos-6
# 
# I don't like the idea of anything on the machine being able to use a port
# that isn't an application port I explicitly allow. For example, I know that I
# only want mail, DNS, HTTP(S), and SSH. But, alas! I had to allow ports
# sourced from the machine (see b) and default output policy to accept (see i)
# in order to get ping and apt-get update to work. One workaround would be to
# not allow connections (see b) and set the default output policy to drop (see
# i) until I needed to update the server. But, that seems like too much hassle
# at the moment.
#
# Note: I haven't tested 80 and 443. Also, I'm not 100% sure I have the
# source and destination ports set right.

# a. completely clear iptables (removes anything that pre-existed)
iptables -F
iptables -X

# b. allow any connection that originated from this server (this should be the first rule)
# Note: this is needed for running ping and apt-get update
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# c. accept everything no matter port on the loopback interface
iptables -A INPUT -i lo -j ACCEPT

# d. drop all null packets (recon packets)
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# e. drop all empty connections (syn-flood packets)
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# f. drop all packets full of options (XMAS packets, also recon packets)
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# g. allow input on the following ports
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 1701 -j ACCEPT

# h. allow output on the following ports
# Note: with default output policy of accept we don't need these. I just list them so I know what I want.
iptables -A OUTPUT -p tcp --sport 25 -j ACCEPT
iptables -A OUTPUT -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 1701 -j ACCEPT

# i. set default policy to drop
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

