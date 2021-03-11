#!/bin/bash

# Use a CL argument to specify the toolchain

toolchain="foss"

if [ "$1" == "gobff" ]
then
    toolchain="gobff"
fi

run_tests() {
    module=$1
    cores=$2
    echo test,module,cores,MFLOPS>${module}_${cores}.csv
    for tst in xcl1 xcl2 xcl3 xdl1 xdl2 xdl3 xsl1 xsl2 xsl3 xzl1 xzl2 xzl3;do
        OMP_NUM_THREADS=$cores BLAS-Tester-20160411-$toolchain/bin/${tst}blastst |
        awk '$1==9 && $NF=="PASS"{print $(NF-2)}' |
        echo $tst,$module,$cores,$(</dev/stdin) >>${module}_${cores}.csv
    done
}

module purge
module load 2020
module load $toolchain/2020b

export OMP_PLACES=sockets
export OMP_PROC_BIND=close

run_tests $toolchain-2020b 4
run_tests $toolchain-2020b 24

lscpu > lscpu
