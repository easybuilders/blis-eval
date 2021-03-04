## `gobff/2020b`

Install (with EasyBuild v4.3.3 or newer):

```shell
eb CP2K-7.1-gobff-2020b.eb --robot
```

Test summary on VUB-HPC Hydra Skylake (Intel(R) Xeon(R) Gold 6148 CPU @ 2.40GHz):

```
--------------------------------- Summary --------------------------------
Number of FAILED  tests 81
Number of WRONG   tests 7
Number of CORRECT tests 3173
Number of NEW     tests 8
Total number of   tests 3269
--------------------------------------------------------------------------
Number of LEAKING tests 0
Number of memory  leaks 0
--------------------------------------------------------------------------
```

Reference summary for CP2K-7.1-foss-2020b.eb:

```
--------------------------------- Summary --------------------------------
Number of FAILED  tests 5
Number of WRONG   tests 7
Number of CORRECT tests 3250
Number of NEW     tests 8
Total number of   tests 3270
--------------------------------------------------------------------------
Number of LEAKING tests 0
Number of memory  leaks 0
--------------------------------------------------------------------------
```

### things tested without success:
'lowopt': True
'optarch': 'mavx2'

