gateway=$1
dns=$2

if [ ! -f /etc/network/if-up.d/custom-network-config ]; then

# Make changes immediate
sudo ip route del default
sudo ip route add default via ${gateway}

# Make changes permanent in the VM
cat >/etc/network/if-up.d/custom-network-config <<EOL
#!/bin/bash

ip route del default
ip route add default via ${gateway}

EOL

cat >/etc/resolv.conf <<EOL
nameserver ${dns}
EOL

chmod +x /etc/network/if-up.d/custom-network-config

fi
