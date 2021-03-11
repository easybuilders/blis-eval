#!/bin/bash

# Use a CL argument to specify the toolchain

toolchain="foss"

if [ "$1" == "gobff" ]
then
    toolchain="gobff"
fi

module purge
module load 2020
module load $toolchain/2020b

if [ "$toolchain" == "foss" ]
then
    test_blas="${EBROOTOPENBLAS}/lib/libopenblas.so"
else
    test_blas="${EBROOTBLIS}/lib/libblis.so NO_EXTENSION=1"
fi

dir_name="BLAS-Tester-20160411-$toolchain"

rm -rf $dir_name

wget https://github.com/xianyi/BLAS-Tester/archive/8e1f624.tar.gz -O 20160411.tar.gz
mkdir -p $dir_name && tar -xzvf 20160411.tar.gz --strip-components 1 -C $dir_name && cd $dir_name
sed -i -e 's/-openmp/-qopenmp/g' Makefile.system
make -j 4 CC="mpicc" CXX="mpicxx" FC="mpif90" NUMTHREADS=4 USE_OPENMP=1 L2SIZE=$(getconf LEVEL2_CACHE_SIZE) TEST_BLAS=$test_blas
