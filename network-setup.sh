local gateway=$2
local dns=$3

#####################
# NEW VM
#####################
if [ ! -f /etc/network/if-up.d/custom-network-config ]; then

env

cat >/etc/network/if-up.d/custom-network-config <<EOL
#!/bin/bash
if [ "\$IFACE" != "eth1" ]; then
exit 0
fi
#ifconfig eth1 down
#ifconfig eth1 ${ip} up
route del default
route add default gw ${gateway}

EOL

cat >/etc/resolv.conf <<EOL
nameserver ${dns}
EOL

chmod +x /etc/network/if-up.d/custom-network-config
/etc/init.d/networking restart


#####################
# EXISTING VM
#####################
else

/etc/init.d/networking restart

fi
