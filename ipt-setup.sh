echo Updating repository
sudo apt-get -y update

echo Installing required dependencies
sudo apt-get -q -y  install wget install tomcat7
sudo apt-get -q -y --fix-missing install tomcat7

echo Downloading IPT
sudo wget -nv http://repository.gbif.org/content/groups/gbif/org/gbif/ipt/2.1.1/ipt-2.1.1.war

echo Installing IPT war in Tomcat
sudo mv ipt-2.1.1.war /var/lib/tomcat7/webapps/ipt.war

sudo service tomcat7 restart
