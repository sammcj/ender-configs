#!/usr/bin/env bash

mkdir -p /root/backups/apt{,/lists}
dpkg --get-selections > /root/backups/apt/Package.list
sudo cp -R /etc/apt/sources.list* /root/backups/apt/lists/

# To Restore:
# cp -R /root/backups/apt/lists/sources.list* /etc/apt/
# apt-get update
# apt-get install dselect
# dselect update
# dpkg --set-selections < /root/backups/apt/Package.list
# apt-get dselect-upgrade -y
