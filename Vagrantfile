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
    config.vm.network "public_network", ip: netconf['ip'], dev: netconf['bridge'], id: "network"
    config.vm.provision :shell, :id => "network", :path => "network-setup.sh", :args => '%s %s' % [ netconf['gateway'], netconf['dns'] ]
  else
    netconf = conf['vm']['networking']['private']
    netconf['port-forward'].each do |guest_port, host_port|
      config.vm.network :forwarded_port, guest: guest_port, host: host_port, host_ip: '*'
    end
  end

  conf['vm']['shared-folders'].each do |folder|
    folder_owner = folder.has_key?('owner') ? folder['owner'] : 'vagrant'
    folder_group = folder.has_key?('group') ? folder['group'] : 'vagrant'

    unless File.directory?( folder['host-path'] )
      FileUtils.mkdir_p( folder['host-path'] )
    end

    config.vm.synced_folder folder['host-path'], folder['guest-path'], owner: folder_owner, group: folder_group
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

  config.vm.provider "openstack" do |provider, override|
    os = conf['vm']['provider']['openstack']

    if os['enabled'] == true
      require 'vagrant-openstack-plugin'

      override.vm.box = os['box']
      override.vm.box_url = os['box-url']
      
      # Networking is Openstack's job - disable persistent networking configuration
      override.vm.provision :shell, :id => 'network', :path => nil, :inline => ""
      override.vm.provision :shell, :path => "openstack-provision.sh"

      override.ssh.private_key_path = os['ssh-key-path']
      provider.server_name	= os['vm-name']
      provider.endpoint		= os['identity-auth-url']
      provider.keypair_name	= os['keypair-name']
      provider.username		= os['username']
      provider.api_key		= os['api-key']
      provider.tenant_name	= os['project-name']
      provider.flavor		= os['flavor']
      provider.image		= os['image']
      provider.ssh_username 	= os['ssh-username']
      provider.network		= false

      unless os['floating-ip'].nil?
        provider.floating_ip	= os['floating-ip'] == 'auto' ? :auto : os['floating-ip']
        provider.address_id	= :floating_ip
      end

      conf['vm']['shared-folders'].each do |folder|
        folder_owner = folder.has_key?('owner') ? folder['owner'] : os['ssh-username']
        folder_group = folder.has_key?('group') ? folder['group'] : os['ssh-username']

        override.vm.provision :shell, :id => folder['guest-path'], :inline => 'echo "Changing owner and mode of shared folders"; chown -R %s.%s %s; chmod -R g+rwx %s' % [ folder_owner, folder_group, folder['guest-path'], folder['guest-path'] ]
      end
    end
  end

  # Run provisioning script
  config.vm.provision "shell", path: "ipt-setup.sh", privileged: false
end
