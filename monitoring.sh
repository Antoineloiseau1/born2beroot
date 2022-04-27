#!/bin/bash

#Display system informations:
sys_info=$(uname -a)

#Display number of physical CPUs:
ncpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)

#Display count of vCPUs:
nvcpu=$(grep "processor" /proc/cpuinfo | wc -l)

#Display RAM Memory Available:
ram_value=$(free -m | awk '$1 == "Mem:" {print $3"/"$2}')
ram_ratio=$(free -m | awk '$1 == "Mem:" {printf ("(%.2f%%)\n", $3/$2*100)}')

#Display Memory available on disks:
mem_available=$(df -Bg | grep "^/dev/" | grep -v "/dev/sda1/" | awk '{tot_a += $4} END {print tot_a}')
mem_used=$(df -m | grep "^/dev/" | grep -v "/dev/sda1" | awk ' {tot_u += $3} END {print tot_u}')
mem_pourcent=$(df | grep "^/dev/" | grep -v "/dev/sda1" | awk '{tot_a += $4} {tot_u += $3} END {printf("%d\n", tot_u/tot_a*100)}')

#Display CPUs load:
cpu_load=$(top -bn1 | grep "^%Cpu(s)" | awk ' {print $2} ')

#Display last boot:
boot=$(who -b | awk ' {print $3" "$4}')

#Check if LVM is on:
is_lvm=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [ $is_lvm -lt  0 ];
	then echo no;
	else echo yes; fi)

#How many connections
tcp=$(netstat | grep "tcp" | wc -l)

#Print all monitor:
wall  "
        #Architecture: $sys_info
        #CPU physical: $ncpu
        #vCPU: $nvcpu
        #Memory Usage: ${ram_value}Mb $ram_ratio
	#Disk Usage: $mem_used/${mem_available}Gb ($mem_pourcent%)
	#CPU load: $cpu_load%
	#Last boot: $boot EDT
	#LVM use: $lvm
	#Connections TCP: $tcp ESTABLISHED"