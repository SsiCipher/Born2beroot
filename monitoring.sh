#!/bin/sh

# Architecture
arch=$(uname -a)

# CPU
cpu=$(nproc)
vcpu=$(grep -c processor /proc/cpuinfo)

# RAM
ram_used=$(free --mega | grep Mem | xargs | cut -d " " -f 3)
ram_total=$(free --mega | grep Mem | xargs | cut -d " " -f 2)
ram_usage=$(free --mega | awk 'NR==2 {printf("%.2f%%", $3*100/$2)}')

#Disk
disk_used=$(df -H --total | grep total | xargs | cut -d " " -f 3 | tr -d "[A-Za-z]")
disk_total=$(df -H --total | grep total | xargs | cut -d " " -f 2 | tr -d "[A-Za-z]")
disk_percentage=$(df -H --total | grep total | xargs | cut -d " " -f 5)

# CPU Load
cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3 + $5}')

# Last Boot
last_boot=$(uptime -s | awk '{printf("%s %s", $1, substr($2, 0, 5))}')

# LVM
lvm_active=$(cat /etc/fstab | grep -c /dev/mapper)

# TCP Conns
tcp_conn=$(ss -t | grep -c ESTAB)

# USERS
logged_users=$(who | wc -l)

# IP
ip_address=$(hostname -I | xargs)

# MAC
mac_address=$(ip link | grep link/ether | xargs | cut -d " " -f 2)

# SUDO
sudo_cmds=$(grep -c COMMAND /var/log/sudo/sudo.log)

wall "
	#Architecture: $arch
	#CPU physical: $cpu
	#vCPU: $vcpu
	#Memory Usage: $ram_used/${ram_total}MB ($ram_usage)
	#Disk Usage: $disk_used/${disk_total}Gb ($disk_percentage)
	#CPU load: $cpu_load
	#Last boot: $last_boot
	#LVM use: $(if [ $lvm_active -gt 0 ]; then echo "yes"; else echo "no"; fi)
	#Connexions TCP: $tcp_conn ESTABLISHED
	#User log: $logged_users
	#Network: IP $ip_address ($mac_address)
	#Sudo: $sudo_cmds cmd
"
