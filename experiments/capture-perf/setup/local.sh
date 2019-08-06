#!/bin/bash

env=$1
source $env

# install from repository
sudo apt-get update
sudo apt-get install -y linux-tools-common linux-tools-$(uname -r)

#configure the tests
#TODO: do we really need it or just drop values at run?
