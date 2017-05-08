#!/bin/bash
# File: 	setup-rtems.sh
# Author: 	Hassan.Karim@bison.howard.edu
# Purpose:	Standardize Pre installation steps for RTEMS
# Date:		2017-05-08
# Note:	since this script is normally done at box initialization, sudo not required

echo "## $0: changing the timezone from $TZ now it is $(date) ###"
export TZ=America/New_York
echo $TZ | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
echo "## $0: timezone changed to $TZ now it is $(date) ###"

set -e

BUILD_BRANCH=master
TOOLS_BRANCH=master
RTEMS_BRANCH=master

DEBIAN_FRONTEND=noninteractive
echo "## $0: updating the base OS at $(date) ###"
apt-get update
echo "## $0: install prerequisite dependancies at $(date) ###"
apt-get install -y git
apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev pax

echo "## $0: downloading sourcebuilder at $(date) ###"
git clone -b "${BUILD_BRANCH}" https://github.com/RTEMS/rtems-source-builder.git 
echo "## $0: downloading rtems-tools at $(date) ###"
git clone -b "${TOOLS_BRANCH}" https://github.com/RTEMS/rtems-tools.git
echo "## $0: downloading rtems $(date) ###"
git clone -b "${RTEMS_BRANCH}" https://github.com/RTEMS/rtems.git
echo "## $0: downloading rtems examples $(date) ###"
git clone -b "${RTEMS_BRANCH}" https://github.com/RTEMS/examples-v2.git

echo "## Setting Permissions to vagrant ##"
chown -R vagrant:vagrant *

# sb-check returns 0 on failed check (but without fatal error), so work around
isok=$(./rtems-source-builder/source-builder/sb-check | grep -c "Environment is ok")
if [[ $? != 0 ]]; then
    echo "sb-check failed. exiting"
    exit 1
fi
