#!/bin/bash
# This file should contain the series of steps that are required to execute 
# the experiment. Any non-zero exit code will be interpreted as a failure
# by the 'popper check' command.
set -e

# add commands here:

#force deleting any previous results
rm -rf results/baseline_output

mkdir -p results/baseline_output

env_fullpath=$(realpath environment.conf)

#invoke the exp
tool="baseline"
for wld in seqr rr
do
    for i in `seq 1 10`
    do
	echo "run sample" $i
	../utils/bin/coordinator --env $env_fullpath -w $wld --nforeground 1 --nbackground 0 --trace_tool $tool --bsize 4096
    done
done

exit 0
