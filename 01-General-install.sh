#!/bin/sh

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

# Stop/disable some irrelevant services
for p in avahi-daemon.service avahi-daemon.socket cups.service cups-browsed.service wpa_supplicant.service ModemManager.service ufw.service unattended-upgrades.service apt-daily-upgrade.service apt-daily-upgrade.timer apt-daily.timer
do
   systemctl stop ${p}
   systemctl mask ${p}
done
if [ -f /etc/os-release ] ; then
   . /etc/os-release
   if [ "${NAME}" = "Linux Mint" ] ; then
      # Following services only on Linux Mint
      systemctl stop casper.service
      systemctl mask casper.service
      systemctl stop casper-md5check.service
      systemctl mask casper-md5check.service
   fi
fi

# Miscellaneous other packages
apt-get -y install build-essential wireshark conntrack conntrackd xterm curl net-tools ssh gcc-12

# Add user to sudoers file
# grep -q -e "^user" /etc/sudoers || /usr/bin/echo -e "user\tALL = NOPASSWD: ALL" >> /etc/sudoers 

# Cleanup apt-get
apt-get clean

# Fix Grub
sed -i 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/g' /etc/default/grub
update-grub
