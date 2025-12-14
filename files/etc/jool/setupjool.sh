#!/bin/sh
ip link add jool type veth peer openwrt
ip netns add jool
ip link set dev openwrt netns jool
ip netns exec jool sh <<EOF
    sysctl -w net.ipv4.conf.all.forwarding=1
    sysctl -w net.ipv6.conf.all.forwarding=1
    sysctl -w net.ipv6.conf.openwrt.accept_ra=2
    sysctl -w net.ipv4.ip_local_port_range="32768 32999"
    ip link set dev lo up
    ip link set dev openwrt up
    ip addr add dev openwrt 192.168.164.2/24
    ip addr add dev openwrt fe80::64
    ip route add default via 192.168.164.1
    modprobe jool
    jool instance add --netfilter --pool6 64:ff9b::/96
    jool global update lowest-ipv6-mtu 1500
    jool pool4 add 192.168.164.2 33000-65535 --tcp
    jool pool4 add 192.168.164.2 33000-65535 --udp
    jool pool4 add 192.168.164.2 33000-65535 --icmp
EOF
