require 'yaml'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

current_dir = File.dirname(__FILE__)

#Load all configuration from a single yaml file
conf = YAML.load_file("#{current_dir}/config.yml")

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

  config.vm.provider "virtualbox" do |v|
    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = conf['vm']['libvirt']['box']

    v.gui = true
    config.vm.synced_folder ".", "/vagrant"
  end

  config.vm.provider "libvirt" do |v|
    config.vm.box = conf['vm']['libvirt']['box']
    config.vm.synced_folder ".", "/vagrant", type: "p9"
  end

  v.customize ["modifyvm", :id, '--cpus', conf['vm']['cpus']]
  v.customize ["modifyvm", :id, "--memory", conf['vm']['memory']]

  # Set a static IP for the VM
  config.vm.network "public_network", ip: conf['vm']['ip']

  # Run provisioning script
  config.vm.provision "shell", inline: $script
end
