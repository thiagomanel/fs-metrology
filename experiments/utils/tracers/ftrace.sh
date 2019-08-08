#!/bin/bash

OUTPUT=/dev/stdout
OUTCOMM=/dev/stdout
ERRCOMM=/dev/stderr

while [ "$1" != "" ]; do
    case $1 in

        -o | --stdout)
            shift;
            OUTPUT=$1;
        ;;

        -e | --command-stderr)
            shift;
            ERRCOMM=$1;
        ;;

        -r | --redirect | --command-stdout)
            shift;
            OUTCOMM=$1;
        ;;

        *)
            COMMAND=$@;
            shift $#;
        ;;

    esac
    shift
done

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
$COMMAND > $OUTCOMM 2> $ERRCOMM
echo 0 > $ONOFF

#~~~~end~~~~#

echo   > $EVTFILE       # clear changed
echo 0 > $FILTERFILE    # configurations

#~~~~output~~~~#
echo "#begin"               > $OUTPUT
cat $TRACE | grep -v ^\#    >> $OUTPUT # ignore ftrace header
echo "#end"                 >> $OUTPUT