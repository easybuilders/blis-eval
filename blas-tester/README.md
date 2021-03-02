## Building blas-tester with gobff

```bash
module load gobff/2020b

wget https://github.com/xianyi/BLAS-Tester/archive/8e1f624.tar.gz -O 20160411.tar.gz
mkdir BLAS-Tester-20160411 && tar -xzvf BLAS-Tester-20160411.tar.gz --strip-components 1 -C BLAS-Tester-20160411 && cd BLAS-Tester-20160411
sed -i -e 's/-openmp/-qopenmp/g' Makefile.system
make -j 4 CC="mpicc" CXX="mpicxx" FC="mpif90" NUMTHREADS=4 USE_OPENMP=1 L2SIZE=$(getconf LEVEL2_CACHE_SIZE) TEST_BLAS=$EBROOTBLIS/lib/libblis.so NO_EXTENSION=1
```

## Building blas-tester with foss for comparison

```bash
module load foss/2020b

mkdir BLAS-Tester-20160411 && tar -xzvf /apps/brussel/sources/b/BLAS-Tester/BLAS-Tester-20160411.tar.gz --strip-components 1 -C BLAS-Tester-20160411 && cd BLAS-Tester-20160411
sed -i -e 's/-openmp/-qopenmp/g' Makefile.system
make -j 4 CC="mpicc" CXX="mpicxx" FC="mpif90" NUMTHREADS=4 USE_OPENMP=1 L2SIZE=$(getconf LEVEL2_CACHE_SIZE) TEST_BLAS=$EBROOTOPENBLAS/lib/libopenblas.so
```

## Running the tests

```bash
run_tests() {
    module=$1
    cores=$2
    echo test,module,cores,MFLOPS>${module}_${cores}.csv
    for tst in xcl1 xcl2 xcl3 xdl1 xdl2 xdl3 xsl1 xsl2 xsl3 xzl1 xzl2 xzl3;do
        OMP_NUM_THREADS=$cores BLASBuildTest/BLAS-Tester-20160411/bin/${tst}blastst |
        awk '$1==9 && $NF=="PASS"{print $(NF-2)}' |
        echo $tst,$module,$cores,$(</dev/stdin) >>${module}_${cores}.csv
    done
}

module load gobff/2020b

export OMP_PLACES=sockets
export OMP_PROC_BIND=close

run_tests gobff-2020b 4
run_tests gobff-2020b 40
```

## Correctness test

all tests pass with both `foss/2020b` and `gobff/2020b`
