#!/bin/bash
# File: 	sparc-build-rtems.sh
Author:		Hassan.Karim @ Howard University
Purpose:	This shell script uses the RTEMS source-builder to remotely build rtems
Prerequisite: This script expects the RTEMS repositories to have already been installed
# This script attempts to build RTEMS 4.12 for sparc/BSP=erc32 and i386/BSP=pc386
#  section of the project.

RTEMS_VERSION="4.12"
RTEMS_TARGET="sparc i386"
RTEMS_BSP="erc32 pc386" # BSP should match the RTEMS_TARGET
export PREFIX=$HOME/rtems/${RTEMS_VERSION}
export PATH=$PREFIX/bin:$PATH
export LOGFILE=$0.$(date +'%Y%m%d_%H%M').log
export RT_CONFIG=$HOME/rtems

hashline="###################################################################"
echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: starting source builder for ${RTEMS_VERSION}/rtems-${RTEMS_TARGET}" | tee -a $LOGFILE
echo "## RTEMS_VERSION: $RTEMS_VERSION" | tee -a $LOGFILE
echo "## RTEMS_TARGET: $RTEMS_TARGET" | tee -a $LOGFILE
echo "## RTEMS_BSP: $RTEMS_BSP" | tee -a $LOGFILE
echo "## PREFIX: $PREFIX" | tee -a $LOGFILE
echo "## PATH: $PATH" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE

cd rtems-source-builder/rtems/
../source-builder/sb-set-builder \
  --log=sb-set-builder.$DATE.log \
  --prefix="${PREFIX}" \
  "${RTEMS_VERSION}/rtems-${RTEMS_TARGET}"

echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Finished source builder for ${RTEMS_VERSION}/rtems-${RTEMS_TARGET}" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE


echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Starting BOOTSTRAP " | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE
cd $RT_CONFIG
./bootstrap

echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Finished BOOTSTRAP" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE

echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Starting Configure in rtems-build " | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE
cd ..; if[ ! -d rtems-build ] && mkdir rtems-build; cd rtems-build
../rtems/configure \
	--enable-tests=samples \
	--target=${RTEMS_TARGET}-rtems${RTEMS_VERSION} \
	--enable-rtemsbsp=${RTEMS_BSP} \
	--prefix=${PREFIX}/${RTEMS_TARGET}

echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Finished configure for ${RTEMS_VERSION}/rtems-${RTEMS_TARGET}" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE

DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Starting make -j6 all" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE

make -j8 -l3 all

echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Finished make -j6 all" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE
echo "## $0: $DATE: Starting make -j6 install" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE
make -j4 install

echo $hashline | tee -a $LOGFILE
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Finished make -j6 all" | tee -a $LOGFILE
echo $hashline | tee -a $LOGFILE

DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: Updating the ENV PATH in .bashrc" | tee -a $LOGFILE
echo "export PATH=${PREFIX}/bin:$PATH" >> ~/.bashrc
echo "export RTEMS_MAKEFILE_PATH=${PREFIX}/${RTEMS_TARGET}/${RTEMS_TARGET}-rtems${RTEMS_VERSION}/${RTEMS_BSP}" >> ~/.bashrc
source ~/.bashrc
DATE=`date +'%Y%m%d_%H%M'`
echo "## $0: $DATE: COMPLETED" | tee -a $LOGFILE
