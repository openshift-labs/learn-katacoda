#!/bin/sh -e

case $PROVISIONER in
    cloudinit)
        yum -y install dracut-modules-growroot || true
        ;;
esac

yum -y clean all

rm -rf /tmp/* /root/anaconda-ks.cfg /root/install.log /root/install.log.syslog /etc/udev/rules.d/70-persistent-net.rules /var/lib/systemd/random-seed /var/lib/random-seed || true
dd bs=1M if=/dev/zero of=/var/tmp/zeros || :
rm -f /etc/ssh/ssh_host* /var/tmp/zeros

fstrim -v /
