rtemsvagrant-samples
=====================

File:
        README.md
Author:
        Hassan.Karim @ Howard University
Purpose:
        This set of VAGRANTUP build scripts will download a suitable
        pre-built Ubuntu image from vagrant cloud and installl RTEMS
        development environment and operating system

Prerequisite:
On the host machine,
* install vagrant from HashiCorp -- https://www.vagrantup.com/
* install VirtualBox from Oracle -- https://www.virtualbox.org/

Contents:
        Vagrantfile, setup-rtems.sh, and sparci386-build-rtems.sh
Date:
        2017-05-08

Base Configuration:
===================
* Ubuntu Image = AMD64 "precise64"
* Network Configuration = "private_network",  type: "dhcp"
* Virtual Machine manager = "virtualbox"
* Virtual Box Name = "rtems-devbox"
* Size of Image on Disk = 40GB
* Number of Configured CPUS = 4
* Amount of Configured Memory = 4096

Usage:
======
To run the rtems-devbox, or to do the intial setup, use the same command

A. # From a command shell where the Vagrantfile resides.
========================================================================
```bash
host$ vagrant up
```

This is what happens in the background:
1. setup-rtems.sh is executed from host machine
2. setup-rtems.sh downloads the Ubuntu Precise 64-bit image.
3. setup-rtems.sh installs all of the latest ubuntu patches
4. setup-rtems.sh installs all of the RTEMS related dependancies
5. setup-rtems.sh clones the rtems git repositories

If needed, modifiy that script to adjust where to put the repositories within the devbox

B. # From the directory where the Vagrantfile resides, connect to devbox
========================================================================

```bash
host$ vagrant ssh
```

C. # Once in the devbox
========================================================================

```bash
rtems-devbox$ chmod u+x ./build-rtems.sh && ./build-rtems.sh
```
1. This logs you into the new development box. where you will find build-rtems.sh
2. The local file sparc-build-rtems.sh gets copied to rtems-devbox as build-rtems.sh
3. This will build sparc using erc32 BSP and i386 with pc386 BSP
4. This process may take several hours.

