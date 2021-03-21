#!/bin/bash

CLUSTER_NAME=$VSC_INSTITUTE_CLUSTER

if [ $# -ne 3 ]; then
    echo "ERROR: Usage: $0 <module name> <numpy function> <core counts to test>" >&2
    exit 1
fi
module=$1
numpy_function=$2
core_counts=$3

echo "module: $module"
echo "numpy function: $numpy_function"

module load $module
echo ">> $module loaded"

if [ $numpy_function == "dot" ]; then
    code1="import numpy; x = numpy.random.random((5000, 5000))"
    code2="numpy.dot(x, x.T)"
    iter_cnt=5
elif [ $numpy_function == "svd" ]; then
    code1="import numpy.linalg; x = numpy.random.random((2000, 2000))"
    code2="numpy.linalg.svd(x)"
    iter_cnt=3
else
    echo "Unknown numpy function to test: $numpy_function" >&2
    exit 2
fi

# pin threads to cores,
# cfr. https://github.com/flame/blis/blob/master/docs/Multithreading.md#specifying-thread-to-core-affinity
export OMP_PROC_BIND=close
export OMP_PLACES=cores

results_file="results_${CLUSTER_NAME}_$(echo $module | tr '/' '-')_numpy_${numpy_function}.csv"
echo -n "core_cnt" > ${results_file}
for i in $(seq 1 5); do
    echo -n ",run${i}" >> ${results_file}
done
echo >> ${results_file}

for core_count in $core_counts; do

    echo $module | egrep '\-gobff|\-goblf-|\-iibff-|\-iiblf-' > /dev/null
    if [ $? -eq 0 ]; then
        export BLIS_NUM_THREADS=$core_count
        echo ">> BLIS_NUM_THREADS=$BLIS_NUM_THREADS"
    else
        export OMP_NUM_THREADS=$core_count
        echo ">> OMP_NUM_THREADS=$OMP_NUM_THREADS"
    fi

    echo ">> Running '${code1}' '${code2}'"
    results=""
    for i in $(seq 1 ${iter_cnt}); do
        outfile="out_run${i}_${core_count}threads.txt"
        time python -m timeit -u msec -n 10 -r 10 -s "${code1}" "${code2}" > ${outfile}
        msec=$(cat ${outfile} | sed 's/.*: \(.*\) msec per loop/\1/g')
        echo $msec
        results="$results,$msec"
    done
    echo "${core_count}${results}" >> ${results_file}
done
