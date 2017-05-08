# rtemsvagrant-samples
RTEMS Vagrant scripts with logging and samples build

rtemsvagrant-samples
=====================
File: 		README.md

Author:		Hassan.Karim @ Howard University

Purpose:	This set of VAGRANTUP build scripts will download a suitable 
		pre-built Ubuntu image from vagrant cloud and installl RTEMS 
		development environment and operating system

Prerequisite: 	On the host machine, 
		install vagrant from HashiCorp -- https://www.vagrantup.com/
		install VirtualBox from Oracle -- https://www.virtualbox.org/

Contents:	Vagrantfile, setup-rtems.sh, and sparc-build-rtems.sh

Date:		2017-05-08

Usage:
======
To run the rtems-devbox, or to do the intial setup, use the same command

A. # From a command Shell where vagrant is installed and where the 
	Vagrantfile resides. (Windows or Unix)
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

Modifiy that script to adjust where to put the repository within the devbox

B. # From the directory where the Vagrantfile resides launch ssh
========================================================================

```bash
host$ vagrant ssh
```

This logs you into the new development box. where you will find build-rtems.sh

```bash
rtems-devbox$ ./build-rtems.sh
```

Note... the local file sparc-build-rtems.sh gets copied to RTEMS=devbox as build-rtems.sh
This will build sparc using erc32 BSP and i386 with pc386 BSP

