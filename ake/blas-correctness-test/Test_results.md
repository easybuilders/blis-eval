Test results

OS: Ubuntu 16.04
CPU: Intel(R) Xeon(R) CPU E5-2690 v4

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