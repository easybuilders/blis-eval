#!/usr/bin/env bash

run_l1() {
	temp=`mktemp`
	echo -n "$4,$1,$3," >> ${2}.csv
	#N sizes selected arbitrary to achieve enough runtime to get no 0.00 mflops values; more indepth knowhow needed
	#(maybe based on L2SIZE) to determine proper values so that we test cpu fpu perf and not memory bandwidth limitations
	#also for any sensible arch comparison ensure that cpus run at fixed frequency and no throttling is happening
	OMP_NUM_THREADS=$4 BLAS-Tester-20160411/bin/${1}blastst -N 1000000 10000000 1000000 -R $3 > $temp
	#we expect 10 PASSed runs of each test
	[ `grep PASS $temp | wc -l` -ne 10 ] && echo "test failed!" && exit 1
	#find which column is actually MFLOPs
	mflopscol=$((`cat $temp | grep TST | tr -s ' ' | tr ' ' '\n' | nl | grep MFLOP | awk '{ print $1 }'`+1))
	#wtf ... some are shifted
	[ "$3" = "axpy" -a "$1" = "xcl1" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "axpy" -a "$1" = "xzl1" ] && mflopscol=$(($mflopscol+1))
	grep PASS $temp | tr -s ' ' | cut -d' ' -f $mflopscol | sort -n > ${temp}x
	#mflops vary wildly; does discarding slowest and fastest and averaging the rest make sense??
	( echo -n 'scale=2; ('; cat ${temp}x | tail -9 | head -8 | tr '\n' '+'; echo '0)/8' ) | bc >> ${2}.csv
	rm $temp ${temp}x 
}

run_l2() {
	temp=`mktemp`
	echo -n "$4,$1,$3," >> ${2}.csv
	OMP_NUM_THREADS=$4 BLAS-Tester-20160411/bin/${1}blastst -N 1000 10000 1000 -R $3 > $temp
	[ `grep PASS $temp | wc -l` -ne 10 ] && echo "test failed!" && exit 1
	mflopscol=$((`cat $temp | grep TST | tr -s ' ' | tr ' ' '\n' | nl | grep MFLOP | awk '{ print $1 }'`+1))
	[ "$3" = "gbmv" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "gbmv" -a "$1" = "xzl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "gemv" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "gemv" -a "$1" = "xzl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hbmv" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hbmv" -a "$1" = "xzl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hpmv" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hpmv" -a "$1" = "xzl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hemv" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hemv" -a "$1" = "xzl2" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "gerc" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "geru" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "ger2c" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "ger2u" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "hpr2" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "her2" -a "$1" = "xcl2" ] && mflopscol=$(($mflopscol+1))
	grep PASS $temp | tr -s ' ' | cut -d' ' -f $mflopscol | sort -n > ${temp}x
	( echo -n 'scale=2; ('; cat ${temp}x | tail -9 | head -8 | tr '\n' '+'; echo '0)/8' ) | bc >> ${2}.csv
	rm $temp ${temp}x
}

run_l3() {
	temp=`mktemp`
	echo -n "$4,$1,$3," >> ${2}.csv
	OMP_NUM_THREADS=$4 BLAS-Tester-20160411/bin/${1}blastst -N 100 1000 100 -R $3 > $temp
	[ `grep PASS $temp | wc -l` -ne 10 ] && echo "test failed!" && exit 1
	mflopscol=$((`cat $temp | grep TST | tr -s ' ' | tr ' ' '\n' | nl | grep MFLOP | awk '{ print $1 }'`+1))
	[ "$3" = "her2k" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "her2k" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "trmm" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "trmm" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "trsm" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "trsm" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+1))
	[ "$3" = "gemm" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "gemm" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hemm" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "hemm" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "symm" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "symm" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "syrk" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "syrk" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "syr2k" -a "$1" = "xcl3" ] && mflopscol=$(($mflopscol+2))
	[ "$3" = "syr2k" -a "$1" = "xzl3" ] && mflopscol=$(($mflopscol+2))
	grep PASS $temp | tr -s ' ' | cut -d' ' -f $mflopscol | sort -n > ${temp}x
	( echo -n 'scale=2; ('; cat ${temp}x | tail -9 | head -8 | tr '\n' '+'; echo '0)/8' ) | bc >> ${2}.csv
	rm $temp ${temp}x
}

run_tests() {
	export OMP_PLACES=sockets
	export OMP_PROC_BIND=close
	module=$1
	cores=$2
	[ -e ${module}.csv ] || echo nthreads,test,routine,MFLOPS > ${module}.csv
	tst=xcl1
	echo -n "$tst: "
	#c nrm2,amax,asum,axpy,copy,swap,dotc,dotu - these behave in sane way: no 0.00 mflops and 10 runs
	for r in nrm2 amax asum axpy copy swap dotc dotu
	do
		echo -n "$r "
		run_l1 $tst $module $r $cores
	done
	echo

	tst=xzl1
	echo -n "$tst: "
	#z nrm2,amax,asum,axpy,copy,swap,dotc,dotu
	for r in nrm2 amax asum axpy copy swap dotc dotu
	do
		echo -n "$r "
		run_l1 $tst $module $r $cores
	done
	echo

	tst=xdl1
	echo -n "$tst: "
	#d nrm2,amax,asum,axpy,copy,swap,dot,rotm
	for r in nrm2 amax asum axpy copy swap dot rotm
	do
		echo -n "$r "
		run_l1 $tst $module $r $cores
	done
	echo

	tst=xsl1
	echo -n "$tst: "
	#s nrm2,amax,asum,axpy,copy,swap,dot,rotm,dsdot,sdsdot
	for r in nrm2 amax asum axpy copy swap dot rotm dsdot sdsdot
	do
		echo -n "$r "
		run_l1 $tst $module $r $cores
	done
	echo

	tst=xcl2
	echo -n "$tst: "
	#c gbmv,gemv,hbmv,hpmv,hemv,tbmv,tpmv,trmv,tbsv,tpsv,trsv,gerc,geru,ger2c,ger2u,hpr,her,hpr2,her2
	for r in gbmv gemv hbmv hpmv hemv tbmv tpmv trmv tbsv tpsv trsv gerc geru ger2c ger2u hpr her hpr2 her2
	do
		echo -n "$r "
		run_l2 $tst $module $r $cores
	done
	echo

	tst=xzl2
	echo -n "$tst: "
	#z gbmv,gemv,hbmv,hpmv,hemv,tbmv,tpmv,trmv,tbsv,tpsv,trsv, rest fails with nomem: gerc,geru,ger2c,ger2u,hpr,her,hpr2,her2
	for r in gbmv gemv hbmv hpmv hemv tbmv tpmv trmv tbsv tpsv trsv
	do
		echo -n "$r "
		run_l2 $tst $module $r $cores
	done
	echo

	tst=xdl2
	echo -n "$tst: "
	#d gbmv,gemv,sbmv,spmv,symv,tbmv,tpmv,trmv,tbsv,tpsv,trsv,ger,ger2,spr,syr,spr2,syr2
	for r in gbmv gemv sbmv spmv symv tbmv tpmv trmv tbsv tpsv trsv ger ger2 spr syr spr2 syr2
	do
		echo -n "$r "
                run_l2 $tst $module $r $cores
        done
        echo

	tst=xsl2
	echo -n "$tst: "
	#s gbmv,gemv,sbmv,spmv,symv,tbmv,tpmv,trmv,tbsv,tpsv,trsv,ger,ger2, spr,syr,spr2,syr2
	for r in gbmv gemv sbmv spmv symv tbmv tpmv trmv tbsv tpsv trsv ger ger2 spr syr spr2 syr2
	do
		echo -n "$r "
                run_l2 $tst $module $r $cores
        done
        echo
	
	tst=xcl3
	echo -n "$tst: "
	#c gemm,hemm,herk,her2k,symm,syr2k,syrk,trmm,trsm
	for r in gemm hemm herk her2k symm syr2k syrk trmm trsm
	do
		echo -n "$r "
		run_l3 $tst $module $r $cores
	done
	echo

	tst=xzl3
	echo -n "$tst: "
	#z gemm,hemm,herk,her2k,symm,syr2k,syrk,trmm,trsm
	for r in gemm hemm herk her2k symm syr2k syrk trmm trsm
	do
		echo -n "$r "
		run_l3 $tst $module $r $cores
	done
	echo

	tst=xdl3
	echo -n "$tst: "
	#d gemm,symm,syrk,syr2k,trmm,trsm
	for r in gemm symm syrk syr2k trmm trsm
	do
		echo -n "$r "
		run_l3 $tst $module $r $cores
	done
	echo

	tst=xsl3
	echo -n "$tst: "
	#s gemm,symm,syrk,syr2k,trmm,trsm
	for r in gemm symm syrk syr2k trmm trsm
	do
		echo -n "$r "
		run_l3 $tst $module $r $cores
	done
	echo
}

#fetch if not already here
[ -f 20160411.tar.gz ] || wget -q https://github.com/xianyi/BLAS-Tester/archive/8e1f624.tar.gz -O 20160411.tar.gz

#test for these toolchains
for chain in foss/2020b gobff/2020b gobff/2020.06-amd
do
	echo loading $chain
	module purge
	module load $chain

	maxcores=$((`lscpu | grep On-line | cut -f3 -d-`+1))
	cores=1
	until [ $cores -gt $maxcores ]
	do
		echo -n "num_threads=$cores ... "

		#prepare clean copy
		rm -rf BLAS-Tester-20160411
		mkdir BLAS-Tester-20160411 && tar -xzf 20160411.tar.gz --strip-components 1 -C BLAS-Tester-20160411 && cd BLAS-Tester-20160411
		sed -i -e 's/-openmp/-qopenmp/g' Makefile.system
		echo building ...
		#link to proper blas lib
		if [[ "$chain" == "gobff"* ]]
		then
			#reports indicate that amd blis comes with separate .so for multithreaded
			if [ -e $EBROOTBLIS/lib/libblis-mt.so ]; then BLASLIB=$EBROOTBLIS/lib/libblis-mt.so; else BLASLIB=$EBROOTBLIS/lib/libblis.so; fi
		elif [[ "$chain" == "foss"* ]]
		then
			BLASLIB=$EBROOTOPENBLAS/lib/libopenblas.so
		else
			echo "Unknown toolchain"
			exit 1
		fi
		#does NUMTREADS here influence the way tests are built?
		make -j 4 CC="mpicc" CXX="mpicxx" FC="mpif90" NUMTHREADS=$cores USE_OPENMP=1 L2SIZE=$(getconf LEVEL2_CACHE_SIZE) TEST_BLAS=$BLASLIB NO_EXTENSION=1 >/dev/null 2>&1
		cd ..

		f=`echo $chain | sed 's/\//-/'`
		run_tests ${f} $cores
		echo
		cores=$(($cores+1)) #or cores+cores for more quadratic range
	done
done
