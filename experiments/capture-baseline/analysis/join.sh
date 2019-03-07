#!/bin/bash
#
# It joins output dat to ease plotting. We do not summarize results
# Usage: ./join.sh outdir > join.data

if [ $# -ne 1 ]
then
    echo "Usage:" $0 "outdir"
    exit 1
fi

outdir=$1

if [ ! -d $outdir ]
then
    echo "directory" $outdir "not found"
    exit 1
fi

#7874.seqr.2.0.4096.load.out
echo -e "tid req begin end offset trace random workload nforeground nbackground blksize nops delay"
for file in `find ${outdir} -name "*.load.out"`
do
    trace_type="baseline"
    basepath=`basename $file`
    delay="0"
    nops="5000"
    cfg=`echo $basepath | cut -d"." -f1-5 | sed 's/\./ /g'`" $nops $delay"
    grep -v debug $file | awk -v args="$trace_type $cfg" '{ printf("%s %s %s %s %s %s\n", $1, $2, $3, $4, $5, args); }'
done
