#!/usr/bin/env bash

run_tests() {
    module=$1
    cores=$2
    echo test,module,cores,MFLOPS>${module}_${cores}.csv
    for tst in xcl1 xdl1 xsl1 xzl1;do
	echo -n "$tst "
        echo -n $tst,$module,$cores, >>${module}_${cores}.csv
        OMP_NUM_THREADS=$cores BLAS-Tester-20160411/bin/${tst}blastst -N 100 100000 100 | grep PASS | awk '{ print $8 }' | sort -n | tail -1 >>${module}_${cores}.csv
    done
    for tst in xcl2 xdl2 xsl2 xzl2;do
	echo -n "$tst "
        OMP_NUM_THREADS=$cores BLAS-Tester-20160411/bin/${tst}blastst -F 10000 |
        awk '$1==9 && $NF=="PASS"{print $(NF-2)}' |
        echo $tst,$module,$cores,$(</dev/stdin) >>${module}_${cores}.csv
    done
    for tst in xcl3 xdl3 xsl3 xzl3;do
	echo -n "$tst "
        OMP_NUM_THREADS=$cores BLAS-Tester-20160411/bin/${tst}blastst -F 1000 |
        awk '$1==9 && $NF=="PASS"{print $(NF-2)}' |
        echo $tst,$module,$cores,$(</dev/stdin) >>${module}_${cores}.csv
    done
}

[ -f 20160411.tar.gz ] || wget -q https://github.com/xianyi/BLAS-Tester/archive/8e1f624.tar.gz -O 20160411.tar.gz

for chain in foss/2020b gobff/2020b gobff/2020.06-amd
do

echo loading $chain
module purge
module load $chain

rm -rf BLAS-Tester-20160411
mkdir BLAS-Tester-20160411 && tar -xzf 20160411.tar.gz --strip-components 1 -C BLAS-Tester-20160411 && cd BLAS-Tester-20160411
sed -i -e 's/-openmp/-qopenmp/g' Makefile.system
echo building ...
if [[ "$chain" == "gobff"* ]]
then
	make -j 4 CC="mpicc" CXX="mpicxx" FC="mpif90" NUMTHREADS=4 USE_OPENMP=1 L2SIZE=$(getconf LEVEL2_CACHE_SIZE) TEST_BLAS=$EBROOTBLIS/lib/libblis.so NO_EXTENSION=1 >/dev/null 2>&1
elif [[ "$chain" == "foss"* ]]
then
	make -j 4 CC="mpicc" CXX="mpicxx" FC="mpif90" NUMTHREADS=4 USE_OPENMP=1 L2SIZE=$(getconf LEVEL2_CACHE_SIZE) TEST_BLAS=$EBROOTOPENBLAS/lib/libopenblas.so >/dev/null 2>&1
else
	echo "Unknown toolchain"
	exit 1
fi
cd ..

export OMP_PLACES=sockets
export OMP_PROC_BIND=close

maxcores=$((`lscpu | grep On-line | cut -f3 -d-`+1))
cores=1
until [ $cores -gt $maxcores ]
do
	echo -n num_threads=$cores ...
	f=`echo $chain | sed 's/\//-/'`
	run_tests ${f} $cores
	echo
	cores=$(($cores+$cores))
done

done
