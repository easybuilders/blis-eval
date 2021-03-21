# BLAS level 3 dgemm benchmark

This JUBE script benchmarks the BLAS level 3 test. This JUBE setup is a first version without many features. Use at your own risk and report issues! This benchmark might need some modifications to run on other machines.

## Running the Benchmark

Make sure `JUBE` is installed:
```
eb JUBE-2.4.1.eb
```

To run the benchmark:

```
ssh juwels
cd to/this/folder
jube [-v] run blas3.xml
squeue -u $USER
```

## Ploting the Results

In the folder `blis/test/3/octave` run the following octave commands:

```
plot_panel_4x5(3.70,32,1, 'st','..','skx',        'MKL',0); close; clear all;
plot_panel_4x5(3.40,32,24,'1s','..','skx_jc2ic12','MKL',0); close; clear all;
plot_panel_4x5(3.40,32,48,'2s','..','skx_jc4ic12','MKL',0); close; clear all;
```

```
plot_panel_4x5(3.40,16,1, 'st','..','zen2',        'MKL',0); close; clear all;
plot_panel_4x5(2.60,16,64,'1s','..','zen2_jc4ic4jr4','MKL',0); close; clear all;
plot_panel_4x5(2.60,16,128,'2s','..','zen2_jc8ic4jr4','MKL',0); close; clear all;
```
