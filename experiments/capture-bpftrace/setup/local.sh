#!/bin/bash

env=$1
source $env

#get the code
rm -rf $WORKLOADGEN_BASEDIR/fs-microbench
#I was using an old linux box that failed to curl and wget from github because was using an outdated openssl
git clone https://github.com/thiagomanel/fs-microbench.git $WORKLOADGEN_BASEDIR/fs-microbench

#compile the code
make -C $WORKLOADGEN_BASEDIR/fs-microbench/src/

#bpftrace dependencies
##p/ ubuntu 16:
sudo apt-add-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main'

##install bpftrace dependencies
sudo apt-get update
sudo apt-get install -y apt-utils
sudo apt-get install -y bison cmake flex g++ git libelf-dev zlib1g-dev libfl-dev systemtap-sdt-dev
sudo apt-get install -y llvm-7-dev llvm-7-runtime libclang-7-dev clang-7

##install bcc-tools
echo "deb [trusted=yes] https://repo.iovisor.org/apt/xenial xenial-nightly main" | sudo tee /etc/apt/sources.list.d/iovisor.list
sudo apt-get update
sudo apt-get install -y bcc-tools	# or the new package name: bpfcc-tools

#p/ ubuntu 16 (fixes some broken includes, see https://github.com/iovisor/bpftrace/issues/507): 
sudo cp /usr/include/bcc/BPF.h  /usr/include/bcc/BPF.h.copy
sudo sed -i "s/#include \"linux\/bpf.h\"/#include \"bcc\/compat\/linux\/bpf.h\"/g" /usr/include/bcc/BPF.h
sudo cp /usr/include/bcc/bcc_syms.h /usr/include/bcc/bcc_syms.h.copy
sudo sed -i "s/#include \"linux\/bpf.h\"/#include \"bcc\/compat\/linux\/bpf.h\"/g" /usr/include/bcc/bcc_syms.h
sudo cp /usr/include/bcc/libbpf.h /usr/include/bcc/libbpf.h.copy
sudo sed -i "s/#include \"linux\/bpf.h\"/#include \"bcc\/compat\/linux\/bpf.h\"/g" /usr/include/bcc/libbpf.h

#get bpftrace code
rm -rf $WORKLOADGEN_BASEDIR/bpftrace

git clone https://github.com/iovisor/bpftrace $WORKLOADGEN_BASEDIR/bpftrace

#build bpftrace
mkdir $WORKLOADGEN_BASEDIR/bpftrace/build && cd $WORKLOADGEN_BASEDIR/bpftrace/build && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..  && make -j5 && make install

#configure the tests
#TODO: do we really need it or just drop values at run?
