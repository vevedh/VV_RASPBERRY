#!/bin/sh
IPT=/sbin/iptables
LOCAL_IFACE=eth0
INET_IFACE=ppp0
INET_ADDRESS=$1
#INET_ADDRESS=`ifconfig | grep  "ppp0" -A 1 |grep inet|awk -F"adr:" '{ print $2 }'|awk -F" " '{ print $1 }'`

# Flush ALL
$IPT -F
$IPT -F -t nat
$IPT -F -t mangle
$IPT -X
$IPT -X -t nat
$IPT -X -t mangle


# Flush the tables
$IPT -F INPUT
$IPT -F OUTPUT
$IPT -F FORWARD

$IPT -t nat -P PREROUTING ACCEPT
$IPT -t nat -P POSTROUTING ACCEPT
$IPT -t nat -P OUTPUT ACCEPT

# Allow forwarding packets:
$IPT -A FORWARD -p ALL -i $LOCAL_IFACE -j ACCEPT
$IPT -A FORWARD -i $INET_IFACE -m state --state ESTABLISHED,RELATED -j ACCEPT

# Packet masquerading
$IPT -t nat -A POSTROUTING -o $INET_IFACE -j SNAT --to-source $INET_ADDRESS
