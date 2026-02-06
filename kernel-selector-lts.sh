#!/bin/bash

# Author: asdo92@duck.com
# Selector for all LTS available versions

# Check LTS versions
lts_available=$(curl -s https://www.kernel.org/ |  awk -F'<strong>|</strong>' '/longterm:/ {getline; print $2}')
lts_list=""
for lts_version in ${lts_available} ; do
  lts_list="${lts_list} ${lts_version} Longterm"
done

# Check dialog
check_dialog=$(which dialog)
if [ -z "${check_dialog}" ] ; then
  sudo apt install dialog -y
fi

# Run dialog with options
mkdir -p ~/kernel_build
touch ~/kernel_build/kernelver.txt
selected=$(dialog --menu "Select LTS kernel version for build" 15 45 50 ${lts_list} 3>&1 1>&2 2>&3)
if [ -z "${selected}" ] ; then
  rm -rf ~/kernel_build/kernelver.txt
  exit 0
else
  echo "${selected}" > ~/kernel_build/kernelver.txt
fi
