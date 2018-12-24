#!/bin/sh

# Add new chain for REDSOCKS and let all traffic pre-routing to pass RED
iptables -t nat -N RED
iptables -t nat -A PREROUTING -j RED

# Ignore LANs and some other reserved addresses.
iptables -t nat -A RED -d 0.0.0.0/8 -j RETURN
iptables -t nat -A RED -d 10.0.0.0/8 -j RETURN
iptables -t nat -A RED -d 127.0.0.0/8 -j RETURN
iptables -t nat -A RED -d 169.254.0.0/16 -j RETURN
iptables -t nat -A RED -d 172.16.0.0/12 -j RETURN
iptables -t nat -A RED -d 192.168.0.0/16 -j RETURN
iptables -t nat -A RED -d 224.0.0.0/4 -j RETURN
iptables -t nat -A RED -d 240.0.0.0/4 -j RETURN

# Redirect all other TCP traffic to REDSOCKS
iptables -t nat -A RED -p tcp -j REDIRECT --to-ports 12345

# Seems unused. Remove later.
#iptables -P FORWARD ACCEPT # default filter table?
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# ===== DNSCrypt =====
# It listens on TCP 65053 and UDP 65053
# Verify if DNSCrypt works: nslookup google.com localhost:65053
#iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-destination $(nvram get lan_ipaddr):65053
#iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-destination $(nvram get lan_ipaddr):65053
#iptables -A PREROUTING -p udp --dport 53 -j REDIRECT --to-destination $(nvram get lan_ipaddr):65053
#iptables -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-destination $(nvram get lan_ipaddr):65053

iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 65053
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 65053

