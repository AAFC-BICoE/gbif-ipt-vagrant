gbif-ipt-vagrant
================

Package to quickly launch a [GBIF IPT](http://www.gbif.org/ipt) instance inside a [Vagrant VM](https://www.vagrantup.com/)

1) Clone this repository: *git clone http://github.com/aafc-mbb/gbif-ipt-vagrant*

2) Modify relevant configuration in *config.yml*
  * See networking section for more information

3) Run *vagrant up* and wait for provisioning to complete

4) Navigate to *http://localhost:80/* and complete the IPT configuration
  * A subdirectory named *ipt-data* is created in the working directory and maps to */ipt_data* inside the VM.

Hypervisor Support
------------------

### VirtualBox ###

By default, vagrant uses VirtualBox.  For this hypervisor, modifications are not required.  Folders between the hypervisor and host are synced using VirtualBox's Shared Folders.  This hypervisor permits using a Windows, Linux, or Mac host.

Ensure that you have VirtualBox installed before continuing.

Inside the GIT repository you cloned, start the VM using
> vagrant up

### libvirt ###

Support for the libvirt provider allows using several underlying hypervisors through the libvirt api. KVM is the default hypervisor, which is supported using most modern Linux hosts.

Ensure that you have installed the libvirt, kvm, and all relevant system packages and are able to start a KVM Virtual Machine before using this repository.  In addition, Vagrant will NFS mount the ipt-data folder in the VM from an NFS Server running on the Host.  To support this, you must install an NFS server on your host and modify the firewall to support TCP access to the relevant ports for the NFS server.  Vagrant will automatically configure and export the appropriate shares and restart the NFS Server when it starts the VM.

The [vagrant-libvirt plugin](see https://github.com/pradels/vagrant-libvirt) is required before running *vagrant up*

Inside the GIT repository you cloned, start the VM with libvirt using
> vagrant up --provider=libvirt

Networking
----------

Two networking options are supported: *private* and *public*.  Modify *config.yml* and edit the *networking->type* parameter to switch between these two modes.  You can change this option and reload the VM using
> vagrant reload --provision

### Private networking ###

Vagrant establishes a network between the hypervisor and its VMs where traffic flow into the VM must be explicitly forwarded to the VM by defining port forwarding.  Hence, the VM's IP is not accessible from outside the VM.  This is advantageous when IPs are limited or adding DNS records is not possible, which means you are relying on an existing hostname and IP.  Nevertheless, this creates the need for port forwarding from the Host (Hypervisor) to the Guest, which causes a management overhead.  To specify the forwarded ports, modify *config.yml* and add/remove entries in *networking->private->port-forward* with a *guest-port: host-port* syntax.

### Public Networking ###

Vagrant creates a bridge interface to a logical device on the host (Hypervisor) and pass traffic through to it from the VM.  This permits assigning the VM a "public" IP and avoid the need for port forwarding.  Currently, DHCP is not supported.  Edit *config.yml* and modify the *ip*, *gateway*, *dns* parameters under *networking->public* accordingly.
