#!/bin/bash

env=$1
source $env

#get the code
rm -rf $WORKLOADGEN_BASEDIR/fs-microbench
#I was using an old linux box that failed to curl and wget from github because was using an outdated openssl
git clone https://github.com/thiagomanel/fs-microbench.git $WORKLOADGEN_BASEDIR/fs-microbench
#compile the code
make -C $WORKLOADGEN_BASEDIR/fs-microbench/src/

# install from repository
sudo apt-get update
sudo apt-get install -y linux-tools-common linux-tools-$(uname -r)

#configure the tests
#TODO: do we really need it or just drop values at run?
