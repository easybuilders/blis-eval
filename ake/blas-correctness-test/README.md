Testing procedure:

```
git clone https://github.com/akesandgren/lapack.git
cd lapack
git checkout blis-test
cp make.inc.blis-test make.inc

ml gobff/2020b

cd BLAS/TESTING

# In a perfect world there should be no
# "Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL" output durig this phase.
make run
```

Check *.out, it should only say PASS(ED)


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


Testing using LAPACK
```
make lib
make lapack_testing > test.out 2>&1
tail -n 11 test.out
```
Ideal result is (from using refblas):
```
                        -->   LAPACK TESTING SUMMARY  <--
                Processing LAPACK Testing output found in the TESTING directory
SUMMARY                 nb test run     numerical error         other error
================        ===========     =================       ================
REAL                    1316145         0       (0.000%)        0       (0.000%)
DOUBLE PRECISION        1316967         0       (0.000%)        0       (0.000%)
COMPLEX                 776316          0       (0.000%)        0       (0.000%)
COMPLEX16               777128          0       (0.000%)        0       (0.000%)

--> ALL PRECISIONS      4186556         0       (0.000%)        0       (0.000%)

```
