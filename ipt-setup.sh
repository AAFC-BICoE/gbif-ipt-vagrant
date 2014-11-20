echo Updating repository
sudo apt-get -y update

echo Installing required dependencies
sudo apt-get -q -y install wget tomcat7 apache2

echo Modifying tomcat and apache settings
sudo update-rc.d tomcat7 defaults
sudo update-rc.d apache2 defaults

sudo a2enmod proxy proxy_ajp proxy_http

sudo tee "/etc/apache2/sites-available/ipt.conf" > /dev/null <<EOL
# Forward to Tomcat port 8009 from Apache port 80
<VirtualHost *:80>
	ServerName localhost
	ServerAlias `hostname -f` www.`hostname -f`
	ProxyPass / ajp://localhost:8009/
	ProxyPassReverse / http://localhost:8080/
</VirtualHost>
EOL

# Enable IPT configuration and disable default virtual host
# Using "*" allows for variance between debian and ubuntu where ".conf" is added in Ubuntu
sudo a2ensite ipt*
sudo a2dissite 000-default* # 000-default is standard on Debian/Ubuntu

# Remove the existing root context
sudo rm -rf /var/lib/tomcat7/webapps/ROOT

# Enable the AJP connect in tomcat
sudo perl -000 -pi.old -e 's#<!--\s+?(<Connector port="8009".+?>)\s+?-->#$1#' /etc/tomcat7/server.xml

# Allows tomcat7 user to access shared folders, which get the owner and group set to vagrant by default
GROUP=$(groups | cut -f 1 -d ' ')
sudo usermod -a -G $GROUP tomcat7

echo Fetching the IPT war if it does not exist
cd /vagrant
wget -N -nv http://repository.gbif.org/content/groups/gbif/org/gbif/ipt/2.1.1/ipt-2.1.1.war

echo Installing IPT war in Tomcat
sudo -u tomcat7 cp ipt*.war /var/lib/tomcat7/webapps/ROOT.war

sudo service tomcat7 restart
sudo service apache2 restart
