# BLAS level 3 dgemm benchmark

This JUBE script benchmarks the BLAS level 3 dgemm. This JUBE setup is a first version without many features. Use at your own risk and report issues! This benchmark might need some modifications to run on other machines.

## Running the Benchmark

Make sure `JUBE` is installed:
```
eb JUBE-2.4.1.eb
```

To run the benchmark:

```
ssh juwels
cd to/this/folder
jube [-v] run dgemm.xml
squeue -u $USER
jube continue bench_run
jube result -a bench_run

# Store the csv
jube result bench_run -o result-csv > data/$SYSTEMNAME/`date +"%Y-%m-%d"`.csv
```

