#!/bin/sh

filter="comm==rr||comm==rw||comm==seqr||comm==seqw"

_enter() {
    echo "syscalls:sys_enter_$1"
}

_exit() {
    echo "syscalls:sys_exit_$1"
}

enter_exit() {
    echo "$(_enter $1),$(_exit $1)"
}

evts="$(enter_exit open),$(enter_exit read),$(enter_exit write),$(enter_exit pread64),$(enter_exit pwrite64)"

# save and show when done
OUTPUT_FILE="perf.out"

ctrl_c() {
    perf script -i perf.data > OUTPUT_FILE
    echo "#begin"
    cat OUTPUT_FILE
    echo "end"
    rm OUTPUT_FILE
}

# run
trap ctrl_c INT
echo "capture started, press [^C] to stop" 1>&2
echo "perf record -e $evts --filter $filter"
# perf record -e $evts --filter $filter


