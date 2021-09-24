Performance testing on Zen2, following https://github.com/flame/blis/blob/master/docs/Performance.md#zen2

## Zen2

### Zen2 experiment details

* Location: https://docs.computecanada.ca/wiki/B%C3%A9luga/en
* Processor model: AMD Epyc 7502 (Zen2 "Rome")
* Core topology: two sockets, 4 Core Complex Dies (CCDs) per socket, 2 Core Complexes (CCX) per CCD, 4 cores per CCX, 64 cores total
* SMT status: disabled
* Max clock rate: 2.5GHz (base, documented); 3.35GHz boost (single-core, documented)
* Max vector register length: 256 bits (AVX2)
* Max FMA vector IPC: 2
  * Alternatively, FMA vector IPC is 4 when vectors are limited to 128 bits each.
* Peak performance:
  * single-core: 53.6 GFLOPS (double-precision), 107.2 GFLOPS (single-precision)
  * multicore (estimated): 40 GFLOPS/core (double-precision), 80 GFLOPS/core (single-precision)
* Operating system: CentOS 7.9.2009 + Gentoo Prefix (May 2020)
* Page size: 4096 bytes
* Compiler: gcc 10.3.0
* Results gathered: 23 September 2021
* Implementations tested:
  * BLIS 52f29f739 (0.8.1+) and AMD BLIS 3.0.1
    * configured with `./configure -t openmp auto` (single- and multithreaded)
    * sub-configuration exercised: `zen2`
    * Single-threaded (1 core) execution requested via no change in environment variables
    * Multithreaded (32 core) execution requested via `export BLIS_JC_NT=2 BLIS_IC_NT=4 BLIS_JR_NT=4`
    * Multithreaded (64 core) execution requested via `export BLIS_JC_NT=4 BLIS_IC_NT=4 BLIS_JR_NT=4`
  * OpenBLAS 0.3.17
    * compiled with `make -j 8 libs netlib shared DYNAMIC_ARCH=1 DYNAMIC_LIST="HASWELL ZEN SKYLAKEX" NUM_THREADS=64 BINARY='64'  CC='gcc'  FC='gfortran'  MAKE_NB_JOBS='-1'  USE_OPENMP='1'  USE_THREAD='1'  CFLAGS='-O2 -ftree-vectorize -march=core-avx2 -fno-math-errno'`
    * Single-threaded (1 core) execution requested via `export OMP_NUM_THREADS=1`
    * Multithreaded (32 core) execution requested via `export OMP_NUM_THREADS=32`
    * Multithreaded (64 core) execution requested via `export OMP_NUM_THREADS=64`
  * MKL 2021 update 2
    * Single-threaded (1 core) execution requested via `export MKL_NUM_THREADS=1`
    * Multithreaded (32 core) execution requested via `export MKL_NUM_THREADS=32`
    * Multithreaded (64 core) execution requested via `export MKL_NUM_THREADS=64`
* Affinity:
  * Thread affinity was specified manually via `GOMP_CPU_AFFINITY="0-63"`. 
  * Single-threaded and 64 core executables were run through `numactl --interleave=all`; single socket through `numactl --cpubind=0 --membind=0` to force execution on the first socket only.
* Frequency throttling (via `cpupower`):
  * Driver: acpi-cpufreq
  * Governor: performance
  * Hardware limits (steps): 1.5GHz, 2.2GHz, 2.5GHz
  * Adjusted minimum: 1.5GHz
* Comments:
  * MKL performs poorly except for DGEMM, though much better than in https://github.com/flame/blis/blob/master/docs/Performance.md#zen2
  * AMD-BLIS performs very similar to BLIS except for single-threaded `*trsm` (`m,n,k<1000`) and all-threaded `zherk`. Is that due to recent changes in BLIS?

### Zen2 results

#### png (inline) black=BLIS, green=AMD BLIS, red=OpenBLAS, blue=MKL

* **Zen2 single-threaded**
![l3_perf_blg8599_nt1](https://user-images.githubusercontent.com/10634630/134680439-1eac2207-fcfa-4ae2-96a8-3f04329a2d72.png)
* **Zen2 multithreaded (32 cores)**
![l3_perf_blg8599_jc2ic4jr4_nt32](https://user-images.githubusercontent.com/10634630/134680443-faaf10e4-98e2-4332-8026-f0ebfc725653.png)
* **Zen2 multithreaded (64 cores)**
![l3_perf_blg8599_jc4ic4jr4_nt64](https://user-images.githubusercontent.com/10634630/134680442-44b889ca-6d9b-4dcc-b5a1-7dfade205af4.png)
