#!/bin/sh
display_msg(){
	
	echo "###############################################################################"
	echo "### $@ Successfully started RTEMS Dev box at $(date +'%Y%m%d_%H%M') ###"
	echo "###############################################################################"
	return 0;
}
echo "###############################################################################"
echo "### STARTING Vagrant RTEMS Dev box at $(date +'%Y%m%d_%H%M') ###"
echo "###############################################################################"
cd /home/scsadmin/rtems/rtems-vagrant-master
vagrant up && display_msg "vagrant UP"
vagrant ssh
