#!/bin/sh

arch=$(uname -a)
cpu=$(cat /proc/cpuinfo | grep -c processor)
vcpu=$(cat /proc/cpuinfo | grep -c physical\ id)
ram_used=$(free --mega | grep Mem | xargs | cut -d " " -f 3)
ram_total=$(free --mega | grep Mem | xargs | cut -d " " -f 2)
disk_used=$(df -H --total | grep total | xargs | cut -d " " -f 3 | tr -d "[A-Za-z]")
disk_total=$(df -H --total | grep total | xargs | cut -d " " -f 2 | tr -d "[A-Za-z]")
disk_percentage=$(df -H --total | grep total | xargs | cut -d " " -f 5)
cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
last_boot_date=$(who | xargs | cut -d " " -f 3)
last_boot_time=$(who | xargs | cut -d " " -f 4)
lvm_active=$(cat /etc/fstab | grep -c /dev/mapper)
tcp_conn=$(cat /proc/net/sockstat | grep TCP | cut -d " " -f 3)
logged_users=$(who | wc -l)
ip_address=$(hostname -I | xargs)
mac_address=$(ip link | grep link/ether | xargs | cut -d " " -f 2)
sudo_cmds=$(cat /var/log/auth.log | grep -c sudo)

wall "
	#Architecture: $arch
	#CPU physical: $cpu
	#vCPU: $vcpu
	#Memory Usage: $ram_used/${ram_total}MB ($(($ram_used * 100 / $ram_total))%)
	#Disk Usage: $disk_used/${disk_total}Gb ($disk_percentage)
	#CPU load: $cpu_load
	#Last boot: $last_boot_date $last_boot_time
	#LVM use: $(if [ $lvm_active -gt 0 ]; then echo "yes"; else echo "no"; fi)
	#Connexions TCP: $tcp_conn ESTABLISHED
	#User log: $logged_users
	#Network: IP $ip_address ($mac_address)
	#Sudo: $sudo_cmds cmd
"
