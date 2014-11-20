echo Applying OpenStack specific configuration
rm /dev/random
mknod /dev/random c 1 9

service tomcat7 restart
