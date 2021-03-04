#!/usr/bin/env bash

echo -n "Are we in a VM? "
grep -q hypervisor /proc/cpuinfo && echo "Yes." || echo "No."

echo -n "Running on:"
grep name /proc/cpuinfo | cut -f2 -d: | head -1

echo "System has `lscpu | grep Socket | awk '{ print $2 }'` socket(s) and `lscpu | grep NUMA | head -1 | awk '{ print $3 }'` NUMA domain(s)."

echo "Cores I can run on: `grep Cpus_allowed_list /proc/self/status | awk '{ print $2 }'`"

core=`grep Cpus_allowed_list /proc/self/status | awk '{ print $2 }' | cut -f1 -d, | cut -f1 -d-`

if [ -r /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_governor ]
then
	echo "CPU $core is governed by `cat /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_governor` and is currently at `cat /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_cur_freq`Hz."
else
	echo "CPU ${core} is currently at`grep MHz /proc/cpuinfo | nl -v0 -nln | grep ^${core} | awk '{ print $5 }'`MHz"
fi

#getting memory info requires root
if [ $UID -eq 0 ]
then
	echo "System has `dmidecode -t memory | grep Channel | grep Dimm0 | wc -l` memory channels at `dmidecode -t memory | grep Speed | grep MT | head -1 | cut -f2,3 -d' '`"
	
fi

#are we in a slurm job?
if [ -n "$SLURM_JOBID" ]
then
	echo "Some slurm info:"
	echo "    Tasks per node: $SLURM_STEP_TASKS_PER_NODE"
	echo "    CPUs per node: $SLURM_JOB_CPUS_PER_NODE"
fi
