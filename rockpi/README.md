# Rock Pi 4 SE

Used as Klipper host

## Armbian

```shell
temp=$(mktemp)
curl -L --output radxa.deb "https://github.com/radxa-pkg/radxa-archive-keyring/releases/latest/download/radxa-archive-keyring_$(curl -L https://github.com/radxa-pkg/radxa-archive-keyring/releases/latest/download/VERSION)_all.deb"
sudo dpkg -i radxa.deb
rm -f radxa.deb
source /etc/os-release
sudo tee /etc/apt/sources.list.d/radxa.list <<< "deb [signed-by=/usr/share/keyrings/radxa-archive-keyring.gpg] https://radxa-repo.github.io/bullseye/ ${VERSION_CODENAME} main"
sudo apt update

apt install -y setserial irqtop borgmatic borgbackup firmware-brcm80211 hwinfo jq lshw usbutils v4l-utils zstd libzstd1 python3-zstd socat fzf aria2 nullmailer build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev gpiod virtualenv python3-dev python3-libgpiod liblmdb-d wget uvcdynctrl

systemctl disable bluetooth.service vnstat.service console-getty.service wpa_supplicant.service
systemctl enable nullmailer
systemctl disable sysstat

usermod -a -G tty octo
usermod -a -G dialout octo

touch "${HOME}/.hushlogin"
```

### Optional

Packages from <https://github.com/sammcj/packages/tree/main/debian/rockpi>

```shell
# node
curl -fsSL https://fnm.vercel.app/install | bash
fnm install v18 && fnm default v18
```

Other things to automate / document:

- rsyslog
- logrotate
- cron

### Nullmailer

```plain
smtp.fastmail.com smtp --port=587 --starttls --user=user@fastmail.com --pass=password
```

### GPIO things

`gpiodetect`

#### MRAA

<https://wiki.radxa.com/Mraa#Install_example:_Install_Mraa_on_ROCK_Pi_4B_Debian11_armhf_system>

```shell
apt-get install git build-essential swig4.0 python-dev cmake libnode-dev python3-dev pkg-config tree libc6 libjson-c5 libjson-c-dev libgtest-dev libgcc1 libstdc++6 python python2.7 libpython2.7 python3.9 libpython3.9 libgtest-dev pkg-config cmake-data

git clone -b master https://github.com/radxa/mraa.git --depth=1
```

Lost the rest of the steps to the sands of time.

## Klipper

Restore printer_data from backup.

Follow <https://github.com/th33xitus/kiauh> install:

- Mainsail
- Klipper
-

- Stock controller: STM32F401 (stm32f401xc), 64K bootloader, USB
- BTT Octopus:

## ADXL345

![](images/adxl345-rockpi4.png)

- GND: 20 - [Grey -> Brown]
- VCC: 17 - [Purple -> Red]
- CS:  24 - [Orange]
- SDO: 21 - [Yellow]
- SDA: 19 - [Green]
- SCL: 23 - [Blue]

```plain
cat /boot/armbianEnv.txt
verbosity=1
bootlogo=false
overlay_prefix=rockchip
fdtfile=rockchip/rk3399-rock-pi-4b.dtb
rootdev=UUID=f2269554-755d-4013-9484-7c7525b6dbba
rootfstype=ext4
overlays=pcie-gen2 spi-spidev
param_spidev_spi_bus=1
usbstoragequirks=0x2537:0x1066:u,0x2537:0x1068:u
```

```shell
sysctl -w kernel.sched_rt_runtime_us=-1
echo "kernel.sched_rt_runtime_us = -1" | sudo tee /etc/sysctl.d/10-disable-rt-group-limit.conf

su - octo
~/klippy-env/bin/pip install numpy

cd ~/klipper

cd ~/klipper
make menuconfig
# select linux process
sudo systemctl stop klipper
make flash

sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service

## Timelapse

```shell
cd ~/
git clone https://github.com/mainsail-crew/moonraker-timelapse.git --depth=1
cd ~/moonraker-timelapse
make install

```

Follow <https://www.klipper3d.org/RPi_microcontroller.html> to install the rpi mcu on the rockpi.

## Wifi Fix

Note: Don't bother if you're not using wifi!

Because Broadcom is terrible

```shell
git checkout --depth=1 https://github.com/radxa/rkwifibt.git
cp -a ./rkwifibt/firmware/broadcom/AP6256/wifi/ /lib/firmware/brcm/
```

Create `/etc/initramfs-tools/hooks/fix_brcm_missing_firmware.sh` with:

```shell
#!/bin/sh -e
# Copy missing firmware files for brcmfmac driver
PREREQ=""
prereqs () { echo "${PREREQ}"; }
case "${1}" in prereqs) prereqs; exit 0 ;; esac ;
. /usr/share/initramfs-tools/hook-functions
echo "Copying missing firmware files for brcmfmac..."

cp /lib/firmware/brcm/fw_bcm43456c5_ag_apsta.bin ${DESTDIR}/lib/firmware/brcm/
cp /lib/firmware/brcm/fw_bcm43456c5_ag.bin ${DESTDIR}/lib/firmware/brcm/
cp /lib/firmware/brcm/fw_bcm43456c5_ag_mfg.bin ${DESTDIR}/lib/firmware/brcm/
cp /lib/firmware/brcm/fw_bcm43456c5_ag_p2p.bin ${DESTDIR}/lib/firmware/brcm/
```

Reboot.

## Calibration

Following <https://makershop.co/how-to-calibrate-esteps-ender-3/>

Measured 3 lengths of 100mm from the extruder:

(95.5+96.2+96.4)/3=96.033mm

- Calculated extrusion multiplier: `1.04`

Current E Step: 93

- Calculated new E Step value: `96.7`

Store E Steps per mm.

Repeat:

Measured 3 lengths of 100mm from the extruder:

(100.5+101.8+101.5)/3=101.266mm

- Calculated extrusion multiplier: `0.99`

Current E Step: 96.7

- Calculated new E Step value: `95.7` (stock extruder)

Do flow rate test such as <https://www.thingiverse.com/thing:4810337>

### Titan Direct Drive Extruder Calibration

- E Steps: `405.9`

## Klipper

```shell
apt install -y virtualenv python3-dev python3-libgpiod liblmdb-dev libffi-dev build-essential libncurses-dev libncurses-dev libncurses-dev stm32flash libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0-0 pkg-config libstdc++-arm-none-eabi-newlib nginx python-setuptools python3-setuptools npm pwmset python3-pip gpiod
```

```shell
su - octo

git clone https://github.com/th33xitus/kiauh.git --depth=1

./kiauh/kiauh.sh
```

### Webcam

NOTE: Now using kiauh's provided webcam plugin rather than ustreamer directly.

Webcam Settings

- Stream URL: `http://rockpi/webcam/?action=stream`
- Snapshot URL: `http://rockpi/snapshot`
- Path to FFMPEG: `/usr/bin/ffmpeg`

## Backups

- Whole OS: Borgmatic for Borg backup to local network + Borgbase
- Local versioning: linux-timemachine of /home/octo

```shell
su - octo
mkdir /home/octo/timemachine
chmod 0700 /home/octo/timemachine
git clone https://github.com/cytopia/linux-timemachine.git --depth=1
cd linux-timemachine
sudo make install
sudo echo "0 9 * * * /usr/local/bin/timemachine -v /home/octo/printer_data/config /home/octo/timemachine" >> /var/spool/cron/crontabs/octo
timemachine -v /home/octo/printer_data/config /home/octo/timemachine
tree -aL 1 /home/octo/timemachine
```
