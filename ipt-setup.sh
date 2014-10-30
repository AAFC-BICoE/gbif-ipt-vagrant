echo Updating repository
sudo apt-get -y update

echo Installing required dependencies
sudo apt-get -q -y install wget tomcat7 apache2
sudo apt-get -q -y --fix-missing install tomcat7

echo Modifying tomcat and apache settings
sudo update-rc.d tomcat7 defaults
sudo update-rc.d apache2 defaults

sudo a2enmod proxy proxy_ajp proxy_http

cat >/etc/apache2/conf.d/ipt.conf <<EOL
<VirtualHost *:80>
	ServerName localhost
	ServerAlias `hostname -f` www.`hostname -f`
	ProxyPass / ajp://localhost:8009/
</VirtualHost>
EOL

# Remove the existing root context
sudo rm -rf /var/lib/tomcat7/webapps/ROOT

# Enable the AJP connect in tomcat
sudo perl -000 -pi.old -e 's#<!--\s+?(<Connector port="8009".+?>)\s+?-->#$1#' /etc/tomcat7/server.xml

echo Downloading IPT
sudo wget -nv http://repository.gbif.org/content/groups/gbif/org/gbif/ipt/2.1.1/ipt-2.1.1.war

echo Installing IPT war in Tomcat
sudo mv ipt-2.1.1.war /var/lib/tomcat7/webapps/ROOT.war

sudo service tomcat7 restart
sudo service apache2 restart
