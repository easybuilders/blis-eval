Test results

OS: Ubuntu 16.04
CPU: Intel(R) Xeon(R) CPU E5-2690 v4

BLAS TEST:
```
BLAS lib | version    | toolchain     | result
blasref  | -          | GCC/10.2.0    | PASS
BLIS     | 0.8.0      | gobff/2020b   | warning xblat3d with IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
OpenBLAS | 0.3.12     | foss/2020b    | PASS
imkl     | 2017.1.132 | GCCcore/6.3.0 | warning xblat3c with IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
imkl     | 2017.1.132 | GCCcore/6.3.0 | warning xblat3z with IEEE_DENORMAL
imkl     | 2018.1.163 | GCCcore/6.4.0 | warning xblat3c with IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
imkl     | 2018.1.163 | GCCcore/6.4.0 | warning xblat3z with IEEE_DENORMAL
imkl     | 2019.1.144 | GCCcore/8.2.0 | warning xblat3c with IEEE_DENORMAL
imkl     | 2019.1.144 | GCCcore/8.2.0 | warning xblat3z with IEEE_DENORMAL
imkl     | 2019.5.281 | gomkl/2019b   | warning xblat3c with IEEE_DENORMAL
imkl     | 2019.5.281 | gomkl/2019b   | warning xblat3z with IEEE_DENORMAL
imkl     | 2020.1.217 | GCCcore/9.3.0 | warning xblat3c with IEEE_DENORMAL
imkl     | 2020.1.217 | GCCcore/9.3.0 | warning xblat3z with IEEE_DENORMAL
```

LAPACK TEST:
refblas:
```
--> ALL PRECISIONS      4186556         0       (0.000%)        0       (0.000%)
```

imkl/2020.1.217:
```
                        -->   LAPACK TESTING SUMMARY  <--
                Processing LAPACK Testing output found in the TESTING directory
SUMMARY                 nb test run     numerical error         other error  
================        ===========     =================       ================  
REAL                    1316145         0       (0.000%)        0       (0.000%)
DOUBLE PRECISION        1316967         0       (0.000%)        0       (0.000%)
COMPLEX                 768540          1       (0.000%)        0       (0.000%)
COMPLEX16               777128          0       (0.000%)        0       (0.000%)

--> ALL PRECISIONS      4178780         1       (0.000%)        0       (0.000%)
```

BLIS/0.8.0:
```
                        -->   LAPACK TESTING SUMMARY  <--
                Processing LAPACK Testing output found in the TESTING directory
SUMMARY                 nb test run     numerical error         other error  
================        ===========     =================       ================  
REAL                    1308369         1       (0.000%)        0       (0.000%)
DOUBLE PRECISION        1316967         0       (0.000%)        0       (0.000%)
COMPLEX                 776316          0       (0.000%)        0       (0.000%)
COMPLEX16               755096          4       (0.001%)        0       (0.000%)

--> ALL PRECISIONS      4156748         5       (0.000%)        0       (0.000%)
```

OpenBLAS/0.3.12:
```
                        -->   LAPACK TESTING SUMMARY  <--
                Processing LAPACK Testing output found in the TESTING directory
SUMMARY                 nb test run     numerical error         other error  
================        ===========     =================       ================  
REAL                    1308369         1       (0.000%)        0       (0.000%)
DOUBLE PRECISION        1316967         0       (0.000%)        0       (0.000%)
COMPLEX                 746004          37      (0.005%)        0       (0.000%)
COMPLEX16               763556          86      (0.011%)        0       (0.000%)

--> ALL PRECISIONS      4134896         124     (0.003%)        0       (0.000%)
```
