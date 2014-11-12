gbif-ipt-vagrant
================

## Description

Package to quickly launch a [GBIF IPT](http://www.gbif.org/ipt) instance inside a [Vagrant VM](https://www.vagrantup.com/).

## Step by Step Instructions

Step) Description: *execute command in the terminal*

1) Clone this repository: *git clone http://github.com/aafc-mbb/gbif-ipt-vagrant*

2) Change directory into the cloned repository: *cd gbif-ipt-vagrant*

3) Modify relevant configuration in *config.yml*
  * See networking section for more information on private vs public networking
  * See the hypervisor support section for more information

4) Install vagrant:
  * Debian/Ubuntu: *sudo apt-get install vagrant*
  * RHEL/CentOS: Download vagrant from https://www.vagrantup.com/downloads.html

5) Initialize the VM and wait for provisioning to complete: *vagrant up*
  * To use the libvirt provider, see the Hypervisor Support section

6) Navigate to IPT in a web browser
  * Depending on the networking type configuration in config.yml:
    * Private (default): Navigate to http://*hypervisor-hostname*:4567 where *hypervisor-hostname* is the name of the machine hosting the VM. You can determine this by typing *hostname -f* on the command line.
    * Public:  Navigate to http://*hostname* or http://*ip* where *hostname* and *ip* are replaced by values from config.yml

7) Complete the IPT configuration
  * By default, a subdirectory named *ipt_data* is created in the working directory and maps to */ipt_data* inside the VM.  Use */ipt_data* when the IPT configuration prompts for a data folder.
  * In the IPT configuration, the Base URL should be set to the URL used to navigate to IPT.

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

## Networking

Two networking options are supported: *private* and *public*.  Modify *config.yml* and edit the *networking->type* parameter to switch between these two modes.  You can change this option and reload the VM using
> vagrant reload --provision

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
