#!/bin/bash


mkdir ~/research2 2> /dev/null
sudo find /home -type f -perm 777 >> ~/research2/sys_info.txt
ps aux --sort %mem | awk {'print $1,$2,$3,$4,$11'} | head >> ~/research2/sys_info.txt 
