#!/bin/bash

#get the code
wget https://github.com/thiagomanel/fs-microbench/archive/master.zip

#copy-it to the correct place
rm -rf /tmp/fs-microbench-master
cp fs-microbench-master.zip /tmp/
unzip /tmp/fs-microbench-master.zip

#compile the code
cd /tmp/fs-microbench-master/src/
make
cd -

#configure the tests
#TODO: do we really need it or just drop values at run
