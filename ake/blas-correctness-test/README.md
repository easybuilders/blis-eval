BLIS seem to not be 100% IEEE 754 compliant.

Initial BLAS testing returns:
```
./xblat3d < dblat3.in
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
```

(This is mostly my personal opinion)
A BLAS library should preferably never signal underflow/denormals it should handle them correctly instead.
One could consieve of two variants of the BLAS, one fully IEEE754 version that properly handles underflow/denormals, and one that doesn't (which would then for most cases run a bit faster)

For the record, OpenBLAS does not trigger this.

Testing procedure:
```
pwd=this.dir
git clone https://github.com/Reference-LAPACK/lapack.git
cd lapack
patch -p1 < BLAS_TESTING_noopt.patch
cp $pwd/make.inc .

ml gobff/2020b

cd BLAS/TESTING

# In a perfect world there should be no
# "Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL" output durig this phase.
make run
```

Check *.out, it should only say PASS(ED)
