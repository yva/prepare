#!/usr/bin/env bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

# DUMMY 
# https://jamielinux.com/docs/libvirt-networking-handbook/appendix/dummy-interface-on-debian.html

if ! lsmod | grep dummy; then
 sudo modprobe dummy
fi

if ! ip link show dummy0 | grep inet 1>&2 2>/dev/null; then 
  sudo ip link add dummy0 type dummy
  sudo ip addr add 169.254.1.1/24 dev dummy0
  sudo ip link set dev dummy0 up
else 
  echo "if.create done nothing: dummy0 exist!"
fi