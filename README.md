gbif-ipt-vagrant
================

Package to quickly launch a [GBIF IPT](http://www.gbif.org/ipt) instance inside a [Vagrant VM](https://www.vagrantup.com/)

1) Clone this repository to a local folder

2) Modify relevant configuration in config.yml

3) Run "vagrant up" and wait for provisioning to complete

4) Navigate to the IPT web application and complete the IPT configuration: http://localhost:80/ (see networking section to modify IP, Hostname, and port)

By default, a subdirectory named "ipt-data" is created in the working directory which maps to "/ipt_data" inside the VM.

Hypervisor Support & Information
================================

* VirtualBox
By default, vagrant uses VirtualBox.  For this hypervisor, no configuration is required.  Folders between the hypervisor and host are synced using VirtualBox's Shared Folders.  This hypervisor permits using a Windows, Linux, or Mac host.

* libvirt
Support for the libvirt provider allows using several underlying hypervisors through the libvirt api. This hypervisor supports using a Linux host.

To start a VM with libvirt, use
  vagrant up --provider=libvirt

The vagrant-libvirt plugin is required (see https://github.com/pradels/vagrant-libvirt)

Folders between the host and guest are synced using NFS.  As a result, you must install an NFS server on your host and modify the firewall to support TCP access to the relevant ports for the NFS server.  Vagrant will automatically configure and export the appropriate shares in the nfs server.


Networking
==========

Two networking options are supported: private and public.  Edit config.yml and modify the networking->type to select the appropriate option.

Private networking:
Vagrant establishes a network between the hypervisor and its VMs where traffic flow into the VM must be explicitly forwarded to the VM.  Hence, the VM's IP is not accessible from outside the VM.  This is advantageous when IPs are limited, cannot create DNS entries for the VMs, etc.  Nevertheless, this creates the need for port forwarding from the Host (Hypervisor) to the Guest, which causes a management overhead.  To specify the forwarded ports, modify config.yml and add/remove entries in [networking->private->port-forward] with a [guest-port: host-port] syntax.

Public Networking:
Vagrant bridges to a logical device on the host (Hypervisor) from the VM.  This permits assigning the VM a "public" IP and avoid the need for port forwarding.  Currently, DHCP is not supported.  You must modify the [ip], [gateway], [dns] parameters under [networking->public].
