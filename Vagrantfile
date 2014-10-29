require 'yaml'
require 'fileutils'

debug = false

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

current_dir = File.dirname(__FILE__)

#Load all configuration from a single yaml file
conf = YAML.load_file("#{current_dir}/config.yml")

if debug
  puts "VM Configuration"
  puts conf['vm']
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = conf['vm']['box-default']
  config.vm.hostname = conf['vm']['hostname']

  if conf['vm']['networking']['type'] == 'public'
    netconf = conf['vm']['networking']['public']
    # Set a static IP for the VM
    config.vm.network "public_network", ip: netconf['ip'], dev: netconf['bridge']
    config.vm.provision "shell" do |script|
      script.path = "network-setup.sh"
      script.args = '%s %s' % [ netconf['gateway'], netconf['dns'] ]
    end
  else
    netconf = conf['vm']['networking']['private']
    netconf['port-forward'].each do |guest_port, host_port|
      config.vm.network :forwarded_port, guest: guest_port, host: host_port, host_ip: '*'
    end
  end

  conf['vm']['shared-folders'].each do |folder|
    unless File.directory?( folder['host-path'] )
      FileUtils.mkdir_p( folder['host-path'])
    end
    config.vm.synced_folder folder['host-path'], folder['guest-path']
  end

  config.vm.provider "virtualbox" do |provider, override|
    provider.gui = true
    provider.cpus = conf['vm']['cpus']
    provider.memory = conf['vm']['memory']
  end

  config.vm.provider "libvirt" do |provider, override|
    override.vm.box = conf['vm']['provider']['libvirt']['box']

    provider.cpus = conf['vm']['cpus']
    provider.memory = conf['vm']['memory']

    # Share using rsync.  libvirt doesn't support virtualbox shared folders.  NFS is an option
    # NOTE: you must enable the nfs-server on the host and the firewall is not blocking connections
    override.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_udp: "false"

    conf['vm']['shared-folders'].each do |folder|
      override.vm.synced_folder folder['host-path'], folder['guest-path'], type: "nfs", nfs_udp: "false"
    end
  end

  # Run provisioning script
  config.vm.provision "shell", path: "ipt-setup.sh"
end
