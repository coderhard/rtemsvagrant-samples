#!/bin/sh
# File: hkrt.dev.sh
# Author: (C) Hassan Karim 2017
# Date: 2017 May 11
# Purpose: Sample script to start either of two different RTEMS dev images

# Set this as needed
AdvBOX=/home/scsadmin/rtems/rtemsvagrant-master

display_msg(){
  echo "#################################################################"
  echo "### $@ at $(date +'%Y%m%d_%H%M') ###"
  echo "#################################################################"
}

if [ ! -f ./Vagrantfile ] ; then
        echo "Enter the path of the directory where Vagrantfile resides"
        read rtvagsamplesdir
else
        rtvagsamplesdir=$(pwd)
fi

if [ ! -d "$rtvagsamplesdir" ]; then
        display_msg "Exiting directory $@ does not exist"
        exit 2;
fi

display_msg "STARTING RTEMS via vagrant"
echo "Devbox or AdvOS-box"
read boxtype
if [ $boxtype == 'a' ]; then
        cd "$AdvBOX"
        display_msg "vagrant os AdvOS box" && vagrant up
        display_msg "Connecting to AdvOS box" && vagrant ssh
elif [ $boxtype == 'd' ]; then
        cd "$rtvagsamplesdir"
        display_msg "vagrant up for RTEMS devbox" && vagrant up
        display_msg "Connecting to RTEMS devbox" && vagrant ssh
else
        echo " must choose a for AdvOS box | d for devbox "
fi
display_msg "Finished RTEMS via vagrant"
