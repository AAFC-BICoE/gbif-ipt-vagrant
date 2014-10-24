# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#Provisioning script
$script = <<SCRIPT
sudo apt-get -y update
sudo apt-get -y  install wget
sudo apt-get -y install tomcat7
sudo apt-get -y --fix-missing install tomcat7
sudo wget http://repository.gbif.org/content/groups/gbif/org/gbif/ipt/2.1.1/ipt-2.1.1.war
sudo mv ipt-2.1.1.war /var/lib/tomcat7/webapps
sudo service tomcat7 restart
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/debian-7.4"

  # Create a forwarded port mapping which allows access to the Tomcat port
  # within the machine from a port on the host machine. 
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "data", "/vagrant_data", create: true

  # Run provisioning script
  config.vm.provision "shell", inline: $script

end
