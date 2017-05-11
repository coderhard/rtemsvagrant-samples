#!/bin/bash
# File:         sparci386--build-rtems.sh
Author:         Hassan.Karim @ Howard University
Purpose:        This shell script uses the RTEMS source-builder to remotely build rtems
Prerequisite: This script expects the RTEMS repositories to have already been installed
# This script attempts to build RTEMS 4.12 for sparc/BSP=erc32 and i386/BSP=pc386
#  section of the project.

RTEMS_VERSION="4.12"
RTEMS_TARGET="sparc i386"
RTEMS_BSP="erc32 pc386" # BSP should match the RTEMS_TARGET
export PREFIX=$HOME/rtems/${RTEMS_VERSION}
export PATH=$PREFIX/bin:$PATH
bashrc="$HOME/.bashrc"
# Base directory is where RTEMS cloned repositories reside.
# Here, we assume the following directories exist:
# $BASEDIR/rtems-source-builder
# $BASEDIR/rtems-tools  -- will be retrieved by source-builder
# $BASEDIR/rtems                -- will be retrieved by source-builder
# $BASEDIR/examples-v2
export BASEDIR=$(pwd)
export RT_CONFIG_DIR=$BASEDIR/rtems
export LOGFILE=$BASEDIR/$0.$(date +'%Y%m%d_%H%M').log
export hashline="###################################################################"

logthis(){
        echo $hashline | tee -a $LOGFILE
        DATE=`date +'%Y%m%d_%H%M'`
        echo "## $0: $DATE: $@" | tee -a $LOGFILE
        echo $hashline | tee -a $LOGFILE
}

for target in ${RTEMS_TARGET}; do
        logthis "Starting RTEMS source builder for ${RTEMS_VERSION}/rtems-${RTEMS_TARGET}"
        echo "## RTEMS_VERSION: $RTEMS_VERSION" | tee -a $LOGFILE
        echo "## RTEMS_TARGET: $RTEMS_TARGET" | tee -a $LOGFILE
        echo "## RTEMS_BSP: $RTEMS_BSP" | tee -a $LOGFILE
        echo "## PREFIX: $PREFIX" | tee -a $LOGFILE
        echo "## PATH: $PATH" | tee -a $LOGFILE
        echo $hashline | tee -a $LOGFILE

        #cd $BASEDIR/rtems-source-builder/rtems/
        #../source-builder/sb-set-builder \
        #--log=sb-set-builder.$DATE.log \
        #--prefix="${PREFIX}" \
        #"${RTEMS_VERSION}/rtems-${target}"

        logthis "Finished source builder for ${RTEMS_VERSION}/rtems-${RTEMS_TARGET}"
done

logthis "Starting BOOTSTRAP "
cd $RT_CONFIG_DIR
#./bootstrap

logthis "Finished BOOTSTRAP"
logthis "Starting Configure in rtems-build "

cd $BASEDIR; # Now we are in the base directory where installation begain
[ ! -d rtems-build ] && mkdir rtems-build;
cd rtems-build
for target in ${RTEMS_TARGET}; do
        if [ $target == "sparc" ]; then
                RTEMS_BSP="erc32"
                logthis "Starting configure for ${RTEMS_VERSION}/rtems-${target} "
                #$RT_CONFIG_DIR/configure \
                        #--enable-tests=samples \
                        #--target=${target}-rtems${RTEMS_VERSION} \
                        #--enable-rtemsbsp=${RTEMS_BSP} \
                        #--prefix=${PREFIX}/${RTEMS_TARGET}
        elif [ $target == "i386" ]; then
                RTEMS_BSP="pc386"
                logthis "Starting configure for ${RTEMS_VERSION}/rtems-${target} "
                #$RT_CONFIG_DIR/configure \
                        #--enable-tests=samples \
                        #--target=${target}-rtems${RTEMS_VERSION} \
                        #--enable-rtemsbsp=${RTEMS_BSP} \
                        #--prefix=${PREFIX}/${RTEMS_TARGET}
        else
                RTEMS_BSP="none"
                logthis "Starting configure for ${RTEMS_VERSION}/rtems-${target} "
                #$RT_CONFIG_DIR/configure \
                        #--enable-tests=samples \
                        #--target=${target}-rtems${RTEMS_VERSION} \
                        #--prefix=${PREFIX}/${RTEMS_TARGET}
        fi


        logthis "Finished configure for ${RTEMS_VERSION}/rtems-${target}"
        logthis "Starting make for ${RTEMS_VERSION}/rtems-${target}"

        #make -j4 -l3

        logthis "Finished make for ${RTEMS_VERSION}/rtems-${target}"
        logthis "Starting make tests ; make install for ${RTEMS_VERSION}/rtems-${target}"

        #make -j4 tests
        #make -j4 install

        logthis "Finished make tests & make install for ${RTEMS_VERSION}/rtems-${target}"
        logthis "Updating the ENV vars in $bashrc"
        if [ $RTEMS_BSP != "none" ]; then
          mkfileinpath=$(grep $RTEMS_BSP $bashrc )
          if [ -z $mkfileinpath ]; then
  newpath="${PREFIX}/${target}/${target}-rtems${RTEMS_VERSION}/${RTEMS_BSP}"
                oldpath="$(grep RTEMS_MAKEFILE_PATH $bashrc | cut -f2 -d= )"
                if [ -z $oldpath ] ; then
                        newmkline="RTEMS_MAKEFILE_PATH=$newpath"
                else
                        newmkline="RTEMS_MAKEFILE_PATH=$oldpath:$newpath"
                fi
                sed '/RTEMS_MAKEFILE_PATH/d' $bashrc > $bashrc.1
                echo "$newmkline">> $bashrc.1
                mv $bashrc.1 $bashrc
                #echo "export RTEMS_MAKEFILE_PATH=$newpath:$oldpath">> $bashrc
          fi
        else
          mkfileinpath=$(grep ${PREFIX}/${target} $bashrc )
          if [ -z $mkfileinpath ]; then
                newpath="${PREFIX}/${target}/${target}-rtems${RTEMS_VERSION}"
                oldpath="$(grep RTEMS_MAKEFILE_PATH $bashrc | cut -f2 -d= )"
                if [ -z $oldpath ] ; then
                        newmkline="RTEMS_MAKEFILE_PATH=$newpath"
                else
                        newmkline="RTEMS_MAKEFILE_PATH=$oldpath:$newpath"
                fi
                sed '/RTEMS_MAKEFILE_PATH/d' $bashrc > $bashrc.1
                echo "$newmkline">> $bashrc.1
                mv $bashrc.1 $bashrc
                #oldpath="$(grep RTEMS_MAKEFILE_PATH $bashrc | cut -f2 -d= )"
                #echo "export RTEMS_MAKEFILE_PATH=$newpath:$oldpath">> $bashrc
          fi
        fi
done


cd $BASEDIR; # Now we are in the base directory where installation begain
inpath=$(egrep "PATH" $bashrc | grep -v "_PATH")
if [ ! -z $inpath ]; then
  # is prefix in the path
  inpath=$( grep PATH=${PREFIX} $bashrc )
  if [ -z $inpath ]; then
         echo "export PATH=${PREFIX}/bin:$PATH" >> $bashrc
  fi
else
         echo "export PATH=${PREFIX}/bin:$PATH" >> $bashrc
fi

source $bashrc
logthis "making examples from examples-v2"
cd $BASEDIR/examples-v2
#make -j4

cd $BASEDIR
logthis "COMPLETED making examples"
logthis "COMPLETED $0"
