# Sam's Ender Configs

My Documentation, Configuration, Scripts and notes for my Ender 5 S1 and Ender 3 v2 Neo printers.

- [Sam's Ender Configs](#sams-ender-configs)
  - [Ender 5 S1](#ender-5-s1)
  - [Ender 3 v2 Neo](#ender-3-v2-neo)
  - [Creality Sonic Pad](#creality-sonic-pad)
  - [RockPi 4 SE](#rockpi-4-se)
    - [Connectivity](#connectivity)
    - [Formatting SD Cards](#formatting-sd-cards)
  - [Software](#software)
    - [Prusa Slicer](#prusa-slicer)
    - [Material Settings](#material-settings)
    - [GCode scripts](#gcode-scripts)
  - [Failed print recovery](#failed-print-recovery)
  - [Links](#links)
  - [Author](#author)

## Ender 5 S1

My new printer, mods are a work in progress.

- [ender-5-s1](ender-5-s1/README.md)

## Ender 3 v2 Neo

- [ender-3-v2-neo](ender-3-v2-neo/README.md)

## Creality Sonic Pad

- [creality-sonic-pad](creality-sonic-pad/README.md)

## RockPi 4 SE

Used for running Klipper, Mainsail etc...

- [rockpi](rockpi/README.md)

### Connectivity

- Klipper/Mainsail/Fluidd running on a RockPi 4 SE
- Webcam connected to RockPi with ustreamer
- Printer connected via USB
  - I did try removing the USB 5v pin as per <https://community.octoprint.org/t/put-tape-on-the-5v-pin-why-and-how/13574> but it caused the printer to not be detected, I ended up getting an adapter that removes the 5v pin cleanly.
  - udev rules for consistent USB device naming - when you reconnect a USB device it might get a different device name (e.g. `/dev/ttyUSB0` > `/dev/ttyUSB1` etc...) - this is annoying if you've configured your software such as Octoprint to use a specific device. As such you can create udev rules to ensure both the printer and any related webcams are always named consistently (e.g. `/dev/3dprinter`, `/dev/webcam` etc...) [octoprint/`99-3d-printer.rules`](octoprint/99-3d-printer.rules).

### Formatting SD Cards

Make sure you format your SD card with 4096 byte sector size or it may not flash correctly.

Format a SDCard with 4096 byte sector size in macOS

```shell
diskutil list # Find the SDCard you want to format

diskutil info disk4s1 # Get the current SDCard info, assuming the disk is disk4s1
sudo newfs_msdos -F 32 -b 4096 disk4s1 # Format the SDCard as FAT32 with a 4096 byte sector size, assuming the disk is disk4s1
```

## Software

### Prusa Slicer

- Running the [latest beta/alpha version](https://github.com/prusa3d/PrusaSlicer/releases).
- See [prusa-slicer](prusa-slicer).

Output Options

```shell
/Users/samm/bin/ArcWelder --g90-influences-extruder;
```

### Material Settings

- PLA+ (eSun, yxpolyer)
  - Extruder Temperature: 206°C
    - Initial Layer Temperature: 210°C
  - Platform Temperature: 66°C
    - Initial Layer Temperature: 73°C

### GCode scripts

- See [klipper/cfgs-macros](klipper/cfgs-macros)
- See [legacy/gcodes](legacy/gcodes) (legacy)

## Failed print recovery

I've created a GCODE template that can be used to recover/resume from a failed print.

- See [legacy/gcodes/manual-print-recovery.gcode](legacy/gcodes/manual-print-recovery.gcode) (legacy)

## Links

- <https://github.com/norpchen/ProcessGCode>

---

## Author

Sam McLeod

[smcleod.net](https://smcleod.net)
