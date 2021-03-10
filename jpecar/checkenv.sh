#!/usr/bin/env bash

echo -n "Are we in a VM? "
grep -q hypervisor /proc/cpuinfo && echo "Yes." || echo "No."

echo -n "Running on:"
grep name /proc/cpuinfo | cut -f2 -d: | head -1

echo "System has `lscpu | grep Socket | awk '{ print $2 }'` socket(s) and `lscpu | grep NUMA | head -1 | awk '{ print $3 }'` NUMA domain(s)."

corelist=`grep Cpus_allowed_list /proc/self/status | awk '{ print $2 }'`
cores=` echo $corelist | tr ',' '\n' | while read n; do if [[ "$n" == *'-'* ]]; then echo $n | tr '-' ' ' | xargs seq; else echo $n; fi; done | tr '\n' ' '`

echo "CPUs I can run on: ${corelist}"

for core in $cores 
do
	if [ -f /sys/devices/system/cpu/cpu${core}/topology/core_id ]
	then
		[ "`cat /sys/devices/system/cpu/cpu${core}/topology/core_id`" -eq ${core} ] && type="core" || type="thread"
		numa=`ls -d /sys/devices/system/cpu/cpu${core}/node* | cut -d'/' -f7 | sed s/node//`
		if [ -r /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_governor ]
		then
			echo "CPU ${core} (${type} in numa $numa) is governed by `cat /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_governor` and is currently at `cat /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_cur_freq`Hz."
		else
			echo "CPU ${core} (${type} in numa $numa) is currently at `grep MHz /proc/cpuinfo | nl -v0 -nln | grep ^${core} | awk '{ print $5 }'` MHz"
		fi
	fi
done

#getting memory info requires root
if [ $UID -eq 0 ]
then
	echo "System has `dmidecode -t memory | grep Channel | grep Dimm0 | wc -l` memory channels at `dmidecode -t memory | grep Speed | grep MT | head -1 | cut -f2,3 -d' '`"
fi
#also /sys/firmware/dmi/entries/17-*/ are all only root readable ...

#are we in a slurm job?
if [ -n "$SLURM_JOBID" ]
then
	echo "Some slurm info:"
	echo "    Tasks per node: $SLURM_STEP_TASKS_PER_NODE"
	echo "    CPUs per node: $SLURM_JOB_CPUS_PER_NODE"
	#add more interesting ones ...
fi

#print some interesting vars
env | egrep 'OMP|BLIS|MKL'


