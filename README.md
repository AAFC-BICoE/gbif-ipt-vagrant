gbif-ipt-vagrant
================

Package to quickly launch a [GBIF IPT](http://www.gbif.org/ipt) instance inside a [vagrant VM](https://www.vagrantup.com/)

1) cd to an empty working directory 

2) Copy Vagrantfile into it 

3) vagrant init 

4) vagrant up

When the installation is complete, the IPT will be available at http://hostname:8080/ipt-2.2.1/

A subdirectory named "data" is created in the working directory which is mapped to "/vagrant_data" inside the VM.
You can use this as the storage directory for your IPT data.
