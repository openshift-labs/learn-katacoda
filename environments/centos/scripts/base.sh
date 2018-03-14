#!/bin/bash -e

cat <<EOF > /etc/resolv.conf
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844
nameserver 8.8.8.8
nameserver 8.8.4.4
options timeout:2 attempts:1 rotate
EOF

cat <<EOF >  /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
BOOTPROTO=dhcp
NM_CONTROLLED="yes"
PERSISTENT_DHCLIENT=1
ONBOOT="yes"
TYPE=Ethernet
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=yes
NAME="eth0"
DNS1=8.8.8.8
DNS2=8.8.4.4
DNS3=2001:4860:4860::8888
DNS4=2001:4860:4860::8844
EOF

echo "GRUB_DEFAULT=1" > /etc/default/grub
echo "GRUB_TIMEOUT=0" >> /etc/default/grub
echo "GRUB_DISTRIBUTOR=\"CentOS\"" >> /etc/default/grub
echo "GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 init=/usr/lib/systemd/systemd\"" >> /etc/default/grub
echo "GRUB_CMDLINE_LINUX=\"console=tty1 console=ttyS0 init=/usr/lib/systemd/systemd\"" >> /etc/default/grub
echo "GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"" >> /etc/default/grub
echo "GRUB_TERMINAL_INPUT=\"console\"" >> /etc/default/grub
echo "GRUB_TERMINAL_OUTPUT=\"console\"" >> /etc/default/grub
echo "GRUB_TERMINAL=\"console\"" >> /etc/default/grub
echo "GRUB_SERIAL_COMMAND=\"serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1\"" >> /etc/default/grub
echo "GRUB_GFXMODE=auto" >> /etc/default/grub
echo "GRUB_GFXPAYLOAD_LINUX=keep" >> /etc/default/grub
echo "GRUB_DISABLE_RECOVERY=true" >> /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg

cat <<EOF > /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>          <options>                        <dump>  <pass>
/dev/sda1       /               ext4    defaults,relatime,errors=panic      0       1
EOF

dracut -H --force
