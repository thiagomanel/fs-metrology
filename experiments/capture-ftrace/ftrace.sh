#!/bin/sh

pids=$@

_enter() {
    echo "syscalls:sys_enter_$1"
}

_exit() {
    echo "syscalls:sys_exit_$1"
}

enter_exit() {
    echo "$(_enter $1) $(_exit $1)"
}

evts="$(enter_exit open)\
      $(enter_exit read)\
      $(enter_exit write)\
      $(enter_exit pread64)\
      $(enter_exit pwrite64)"

filter="comm == rr || comm==rw || comm==seqr || comm==seqw"

BASEFOLDER=/sys/kernel/debug/tracing

ONOFF=$BASEFOLDER/tracing_on
EVTFILE=$BASEFOLDER/set_event
FILTERFILE=$BASEFOLDER/events/syscalls/filter
TRACE=$BASEFOLDER/trace

#~~~~setup~~~~#

## disabling ftrace
echo 0 > $ONOFF
## clear trace file
echo > $TRACE
## filter by execname
echo $filter > $FILTERFILE
## events to log
echo $evts > $EVTFILE

#~~~~running~~~~#
echo 1 > $ONOFF
echo "capture started, press [RETURN] to stop" 1>&2
read -r  _ </dev/tty

#~~~~end~~~~#

echo 0 > $ONOFF
echo   > $EVTFILE       # clear changed
echo 0 > $FILTERFILE    # configurations

#~~~~output~~~~#
echo "#begin"
cat $TRACE | grep -v ^\#    # ignore ftrace header
echo "#end"