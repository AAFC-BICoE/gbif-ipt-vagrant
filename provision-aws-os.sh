echo Applying OpenStack specific configuration
rm /dev/random
mknod /dev/random c 1 9

service tomcat7 restart

cat >/etc/rc.local <<EOL
#!/bin/sh -e

rm /dev/random
mknod /dev/random c 1 9

exit 0
EOL

chmod +rx /etc/rc.local
