#!/bin/sh
# File: rtdevboxconnect.sh
# Author: (c) 2017 Hassan Karim
# Date: 2017 May 11
# Purpose: Simplify connecting to the RTEMS Vagrant Samples devbox

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
cd "$rtvagsamplesdir"
display_msg "vagrant up for devbox" && vagrant up && \
display_msg "Connecting to RTEMS devbox" && vagrant ssh
display_msg "Finished RTEMS via vagrant"
