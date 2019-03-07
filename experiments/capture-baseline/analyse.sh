#!/bin/bash
# This file should contain the series of steps that are required to execute 
# the experiment. Any non-zero exit code will be interpreted as a failure
# by the 'popper check' command.
set -e

#TODO: we should analyse the raw data and abort if an error is found

#join raw data in a single file
bash analysis/join.sh results/data > results/capture_baseline.data



exit 0
