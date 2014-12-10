gbif-ipt-vagrant
================

## Description

Package to quickly launch a [GBIF IPT](http://www.gbif.org/ipt) instance inside a [Vagrant VM](https://www.vagrantup.com/).

## Step by Step Instructions

Step) Description: *execute command in the terminal*

1) Clone this repository: *git clone http://github.com/aafc-mbb/gbif-ipt-vagrant*

2) Change directory into the cloned repository: *cd gbif-ipt-vagrant*

3) Copy the *config.yml.sample* to *config.yml* and modify it accordingly
  * See networking section for more information on private vs public networking (VirtualBox and libvirt providers only)
  * See the hypervisor support section for more information

4) Install vagrant:
  * Debian/Ubuntu: *sudo apt-get install vagrant*
  * RHEL/CentOS: Download vagrant from https://www.vagrantup.com/downloads.html

5) Initialize the VM and wait for provisioning to complete: *vagrant up*
  * To use the libvirt or OpenStack provider, see the Hypervisor Support section.  Defaults to VirtualBox.

6) Navigate to IPT in a web browser
  * libvirt and VirtualBox providers
    * vm->networking->type in config.yml is set to:
      * Private (default): Navigate to http://*hypervisor-hostname*:4567 where *hypervisor-hostname* is the name of the machine hosting the VM. You can determine this by typing *hostname -f* on the command line.
      * Public:  Navigate to http://*hostname* or http://*ip* where *hostname* and *ip* are replaced by values from config.yml
  * OpenStack provider
    * vm->provider->openstack->floating-ip is set to auto (default) or an address: Navigate to http://*floating-ip* where *floating-ip* is displayed on vagrant-up and/or in openstack.
    * vm->provider->openstack->floating-ip is not set (empty string): Navigate to http://*internal-ip* where *internal-ip* is displayed on vagrant-up and/or in openstack.

7) Complete the IPT configuration
  * By default, a subdirectory named *ipt_data* is created in the working directory and maps to */ipt_data* inside the VM.  Use */ipt_data* when the IPT configuration prompts for a data folder.
  * In the IPT configuration, the Base URL should be set to the URL used to navigate to IPT (see step 6).

## Hypervisor Support

### VirtualBox (default)

For this hypervisor, modifications are not required.  Folders between the hypervisor and host are synced using VirtualBox's Shared Folders.  This hypervisor permits using a Windows, Linux, or Mac host.

Ensure that you have VirtualBox installed before continuing.

Inside the GIT repository you cloned, start the VM using
> vagrant up

### libvirt

Support for the libvirt provider allows using several underlying hypervisors through the libvirt api. KVM is the default hypervisor, which is supported using most modern Linux hosts.

Ensure that you have installed the libvirt, kvm, and all relevant system packages and are able to start a KVM Virtual Machine before using this repository.  In addition, Vagrant will NFS mount the ipt-data folder in the VM from an NFS Server running on the Host.  To support this, you must install an NFS server on your host and modify the firewall to support TCP access to the relevant ports for the NFS server.  Vagrant will automatically configure and export the appropriate shares and restart the NFS Server when it starts the VM.

The [vagrant-libvirt plugin](https://github.com/pradels/vagrant-libvirt) is required before issuing a vagrant up command.

Inside the GIT repository you cloned, start the VM with libvirt using
> vagrant up --provider=libvirt

### OpenStack

The [vagrant-openstack-plugin](https://github.com/cloudbau/vagrant-openstack-plugin) is required before issuing a vagrant up command.  This plugin is only compatible with Vagrant 1.4+ and can be installed using:
> vagrant plugin install vagrant-openstack-plugin

In addition, a dummy box must be installed as it is required for Vagrant to function:
> vagrant box add dummy https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box

Generate a private/public key pair to use for SSHing into the VM and register it in Openstack and your workstation.  See [Openstack's documentation](http://docs.openstack.org/user-guide/content/Launching_Instances_using_Dashboard.html) for more information.

#### Configuration

The openstack provider requires some configuration in *config.yml* under the vm->provider->openstack section.  

*NOTE: This provider ignores the vm->networking section config.yml completely!*

See the following for a brief explanation of the options.

      enabled: true | false - Set to 'true' if you want to use the openstack provider (vagrant-openstack-plugin required)
      box: dummy - Name of the empty box to user. This is a limitation of Vagrant.
      vm-name: 'IPT' - Name of the instance that you will see in OpenStack
      box-url: https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box - Place holder
      username: admin - OpenStack identity/authentication username
      api-key: admin - OpenStack identity/authentication password.
      flavor: m1.small - Name of VM flavor to use. m1.small, m1.medium, etc are default flavours in openstack. They control the VM's cpu, mem, and storage paremeters.
      project-name: admin | - The project name to use. Leave empty to use the default project for your account.
      image: Ubuntu 14.04 Trusty - The base image to use (must be available in OpenStack).  This Vagrantfile is based on and tested on Debian 6 and Ubuntu 14.04 only.
      identity-auth-url: http://openstack-test.biodiversity.agr.gc.ca:5000/v2.0/tokens - URL to identity service appended by "/tokens"
      ssh-username: ubuntu - The username used to SSH into the VM, which is typically defined in the image (default is ubuntu for Ubuntu cloud images)
      ssh-key-path: ~/.ssh/cloud.key - Location of the SSH private key on disk. You must generate a private/public key pair abd unoirt the public key to openstack.
      keypair-name: iyad - Name of the private/public key pair defined in OpenStack.  You must generate a private/public key pair and import the public key to openstack.
      floating-ip: 192.168.0.100 | auto | - Provide a floating-ip address, or set to 'auto', or leave it empty. This will be the IP used to access the VM.  If left empty, the nova network IP will be used.

#### Starting VM

Insite the GIT repository you cloned, start the VM with OpenStack using
> vagrant up --provider=openstack

#### Limitations

* Not all openstack functionality is integrated into this Vagrantfile.  Adding additional functionality through the config.yml should be relateively simple.
* The openstack provider does not "share" folders (e.g. /ipt_data) but rather rsyncs their content from provisioner to the VM.  Hence, the data lives in the VM and is lost when the VM is terminated!

### AWS

The [vagrant-aws](https://github.com/mitchellh/vagrant-aws) plugin is required before issuing a vagrant up command.  This plugin is only compatible with Vagrant 1.2+ and can be installed using:
> vagrant plugin install vagrant-aws

In addition, a dummy box must be installed as it is required for Vagrant to function:
> vagrant box add ubuntu_aws vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box

Generate a private/public key pair to use for SSHing into the VM and register it in AWS and your workstation.  See [Amazon's keypair documentation]http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) for more information.

#### Configuration

The AWS provider requires some configuration in *config.yml* under the vm->provider->aws section.  

*NOTE: This provider ignores the vm->networking section config.yml completely!*

See the following for a brief explanation of the options.

i     vm-name: 'IPT' - Identifier to assign to VM
      box: ubuntu_aws - A dummy box that Vagrant requires for backwards compatibility
      box-url: https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box - The path for the dummy box
      access-key-id:  ABCDEFGHIJKLMNOP - AWS access id
      secret-access-key: ABCDEFHIJKLMNOPQRSTUVWXYZ1234567890 - AWS secret key
      keypair-name: example-keypair - SSH keypair name in AWS (ensure it is in your default region)
      ssh-key-path: ~/.ssh/example-keypair.pem - Private key path on your disk
      ssh-username: ubuntu - Username to ssh with (set in the image)
      instance-type: t2.micro - The instance type defines the CPU, Mem, and Storage for the VM 
      image: ami-8827efe0 - Amazon Machine Image identifier
      elastic-ip: - Provide an existing elastic-ip address, or set to 'auto' to assign a new one, or leave it empty

#### Starting VM

Insite the GIT repository you cloned, start the VM with AWS using
> vagrant up --provider=aws

#### Limitations

* Not all AWS functionality is integrated into this Vagrantfile.  Adding additional functionality through the config.yml should be relateively simple.
* The AWS provider does not "share" folders (e.g. /ipt_data) but rather rsyncs their content from provisioner to the VM.  Hence, the data lives in the VM and is lost when the VM is terminated!

## Networking

Two networking options are supported: *private* and *public*.  Modify *config.yml* and edit the *networking->type* parameter to switch between these two modes.  You can change this option and reload the VM using
> vagrant reload --provision

Note: The OpenStack and AWS providers ignores the networking section in config.yml completely.  If using the OpenStack or AWS provider, please skip this section.

### Private networking

Vagrant establishes a network between the hypervisor and its VMs where traffic flow into the VM must be explicitly forwarded to the VM by defining port forwarding.  Hence, the VM's IP is not accessible from outside the VM.  This is advantageous when IPs are limited or adding DNS records is not possible, which means you are relying on an existing hostname and IP.  Nevertheless, this creates the need for port forwarding from the Host (Hypervisor) to the Guest, which causes a management overhead.  To specify the forwarded ports, modify *config.yml* and add/remove entries in *networking->private->port-forward* with a *guest-port: host-port* syntax.

### Public Networking

Vagrant creates a bridge interface to a logical device on the host (Hypervisor) and pass traffic through to it from the VM.  This permits assigning the VM a "public" IP and avoid the need for port forwarding.  Currently, DHCP is not supported.  Edit *config.yml* and modify the *ip*, *gateway*, *dns* parameters under *networking->public* accordingly.


## Credits

The following contributors have dedicated the time and effort to make this possible.

Allan Jones
Agriculture & Agri-Foods Canada

Iyad Kandalaft
Agriculture & Agri-Foods Canada

If you feel that your name should be on this list, please make a pull request listing your contributions.
