#!/bin/bash

#get the code
rm -rf /tmp/fs-microbench
#I was using an old linux box that failed to curl and wget from github because was using an outdated openssl
git clone https://github.com/thiagomanel/fs-microbench.git /tmp/fs-microbench

#compile the code
make -C /tmp/fs-microbench/src/

#configure the tests
#TODO: do we really need it or just drop values at run?
