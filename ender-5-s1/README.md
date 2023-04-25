# Ender 5 S1

My Documentation, Configuration, Scripts and notes for the Ender 5 S1 3d Printer.

# Sam's Ender 5 S1 Setup

- [Ender 5 S1](#ender-5-s1)
- [Sam's Ender 5 S1 Setup](#sams-ender-5-s1-setup)
  - [Hardware](#hardware)
  - [Firmware](#firmware)
  - [Feedrate calibration](#feedrate-calibration)
    - [Creality Sprite (Stock)](#creality-sprite-stock)
  - [Pressure Advance](#pressure-advance)
    - [2023-03-29](#2023-03-29)
  - [Resonance Testing](#resonance-testing)
    - [2023-04-25](#2023-04-25)
    - [20-23-04-10](#20-23-04-10)
    - [2023-04-07](#2023-04-07)
  - [Skew Calibration](#skew-calibration)
    - [2023-04-7](#2023-04-7)
    - [2023-03-23](#2023-03-23)
  - [Notes / Links](#notes--links)
    - [Controller board](#controller-board)

## Hardware

- Ender 5 S1
- Creality Sprite Extruder
- Mellow NF Smart Hotend
  - 60W heating element
  - PT1000 sensor
- 2x KUSBA ADXL345 USB accelerometers

## Firmware

- Klipper

## Feedrate calibration

### Creality Sprite (Stock)

- The large heatsink used on the 2023 Ender 5 S1 is exactly the same as on the 2022 Ender 3 V2 Neo with one exception - it comes with a bi-metal heatbreak.

## Pressure Advance

### 2023-03-29

- 0.6mm nozzle
- 0.44mm layer height

Corners look best about 8.4mm

> pressure_advance = <start> + <measured_height> * <factor>

PA = 0 + 8.4 * 0.005 == 0.042

## Resonance Testing

```plain
MEASURE_AXES_NOISE # (0~100 and < 1000)
TEST_RESONANCES AXIS=X
MEASURE_AXES_NOISE # (0~100 and < 1000)
TEST_RESONANCES AXIS=Y
mkdir -p ~/calibration/$(date +%Y%m%d)
cd  ~/calibration/$(date +%Y%m%d)
cp /tmp/resonances_*$(date +%Y%m%d)* ~/calibration/$(date +%Y%m%d)

~/klipper/scripts/calibrate_shaper.py resonances_x*.csv -o resonances_x_$(date +%Y%m%d).png
~/klipper/scripts/calibrate_shaper.py resonances_y*.csv -o resonances_y_$(date +%Y%m%d).png
```

### 2023-04-25

![](calibration/2023-04-25/resonances_x_20230425.png)
![](calibration/2023-04-25/resonances_y_20230425.png)

- Replaced hot end cabling and board with BTT EBB36 CAN bus.
- Replaced squash ball feed with printed flexi-feet (TBC if this is better during printing).

- X: Recommended shaper is mzv @ 75.0 Hz
- Y: Recommended shaper is mzv @ 41.6 Hz

```plain
Fitted shaper 'zv' frequency = 78.8 Hz (vibrations = 6.3%, smoothing ~= 0.031)
To avoid too much smoothing with 'zv', suggested max_accel <= 24200 mm/sec^2
Fitted shaper 'mzv' frequency = 75.0 Hz (vibrations = 1.2%, smoothing ~= 0.038)
To avoid too much smoothing with 'mzv', suggested max_accel <= 16600 mm/sec^2
Fitted shaper 'ei' frequency = 68.6 Hz (vibrations = 0.0%, smoothing ~= 0.068)
To avoid too much smoothing with 'ei', suggested max_accel <= 8800 mm/sec^2
Fitted shaper '2hump_ei' frequency = 83.6 Hz (vibrations = 0.0%, smoothing ~= 0.077)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 7800 mm/sec^2
Fitted shaper '3hump_ei' frequency = 105.0 Hz (vibrations = 0.0%, smoothing ~= 0.074)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 8100 mm/sec^2
Recommended shaper is mzv @ 75.0 Hz
```

```plain
Fitted shaper 'zv' frequency = 60.6 Hz (vibrations = 19.6%, smoothing ~= 0.049)
To avoid too much smoothing with 'zv', suggested max_accel <= 14300 mm/sec^2
Fitted shaper 'mzv' frequency = 41.6 Hz (vibrations = 1.3%, smoothing ~= 0.118)
To avoid too much smoothing with 'mzv', suggested max_accel <= 5100 mm/sec^2
Fitted shaper 'ei' frequency = 55.8 Hz (vibrations = 1.7%, smoothing ~= 0.103)
To avoid too much smoothing with 'ei', suggested max_accel <= 5800 mm/sec^2
Fitted shaper '2hump_ei' frequency = 60.8 Hz (vibrations = 0.0%, smoothing ~= 0.146)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 4100 mm/sec^2
Fitted shaper '3hump_ei' frequency = 74.4 Hz (vibrations = 0.0%, smoothing ~= 0.148)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 4100 mm/sec^2
Recommended shaper is mzv @ 41.6 Hz
```

### 20-23-04-10

- No major changes

-[](calibration/2023-04-10/resonances_x_20230410.png)
-[](calibration/2023-04-10/resonances_y_20230410.png)

- X: Recommended shaper is mzv @ 63.2 Hz, suggested max_accel <= 11800 mm/sec^2
- Y: Recommended shaper is mzv @ 50.2 Hz, suggested max_accel <= 7400 mm/sec^2

```plain
Fitted shaper 'zv' frequency = 66.0 Hz (vibrations = 1.6%, smoothing ~= 0.042)
To avoid too much smoothing with 'zv', suggested max_accel <= 17000 mm/sec^2
Fitted shaper 'mzv' frequency = 63.2 Hz (vibrations = 0.1%, smoothing ~= 0.051)
To avoid too much smoothing with 'mzv', suggested max_accel <= 11800 mm/sec^2
Fitted shaper 'ei' frequency = 73.8 Hz (vibrations = 0.0%, smoothing ~= 0.059)
To avoid too much smoothing with 'ei', suggested max_accel <= 10100 mm/sec^2
Fitted shaper '2hump_ei' frequency = 95.4 Hz (vibrations = 0.0%, smoothing ~= 0.060)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 10100 mm/sec^2
Fitted shaper '3hump_ei' frequency = 118.2 Hz (vibrations = 0.0%, smoothing ~= 0.060)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 10200 mm/sec^2
Recommended shaper is mzv @ 63.2 Hz
```

```plain
Fitted shaper 'zv' frequency = 53.4 Hz (vibrations = 7.1%, smoothing ~= 0.060)
To avoid too much smoothing with 'zv', suggested max_accel <= 11100 mm/sec^2
Fitted shaper 'mzv' frequency = 50.2 Hz (vibrations = 0.9%, smoothing ~= 0.081)
To avoid too much smoothing with 'mzv', suggested max_accel <= 7400 mm/sec^2
Fitted shaper 'ei' frequency = 58.8 Hz (vibrations = 0.0%, smoothing ~= 0.093)
To avoid too much smoothing with 'ei', suggested max_accel <= 6400 mm/sec^2
Fitted shaper '2hump_ei' frequency = 73.4 Hz (vibrations = 0.0%, smoothing ~= 0.100)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 6000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 88.4 Hz (vibrations = 0.0%, smoothing ~= 0.105)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 5700 mm/sec^2
Recommended shaper is mzv @ 50.2 Hz
```

### 2023-04-07

- Reassembled X gantry, replaced worn wheels, fixed belt alignment

![](calibration/2023-04-07/resonances_x_20230407.png)
![](calibration/2023-04-07/resonances_y_20230407.png)

- X: Recommended shaper is zv @ 66.8 Hz, suggested max_accel <= 11400 mm/sec^2
- Y: Recommended shaper is ei @ 56.2 Hz, suggested max_accel <= 5900 mm/sec^2

```plain
Fitted shaper 'zv' frequency = 66.8 Hz (vibrations = 1.5%, smoothing ~= 0.041)
To avoid too much smoothing with 'zv', suggested max_accel <= 17400 mm/sec^2
Fitted shaper 'mzv' frequency = 64.0 Hz (vibrations = 0.1%, smoothing ~= 0.050)
To avoid too much smoothing with 'mzv', suggested max_accel <= 12100 mm/sec^2
Fitted shaper 'ei' frequency = 75.2 Hz (vibrations = 0.0%, smoothing ~= 0.057)
To avoid too much smoothing with 'ei', suggested max_accel <= 10500 mm/sec^2
Fitted shaper '2hump_ei' frequency = 97.2 Hz (vibrations = 0.0%, smoothing ~= 0.058)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 10500 mm/sec^2
Fitted shaper '3hump_ei' frequency = 120.6 Hz (vibrations = 0.0%, smoothing ~= 0.058)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 10600 mm/sec^2
Recommended shaper is zv @ 66.8 Hz
```

```plain
Fitted shaper 'zv' frequency = 54.2 Hz (vibrations = 9.5%, smoothing ~= 0.059)
To avoid too much smoothing with 'zv', suggested max_accel <= 11400 mm/sec^2
Fitted shaper 'mzv' frequency = 49.8 Hz (vibrations = 1.8%, smoothing ~= 0.082)
To avoid too much smoothing with 'mzv', suggested max_accel <= 7300 mm/sec^2
Fitted shaper 'ei' frequency = 56.2 Hz (vibrations = 0.0%, smoothing ~= 0.102)
To avoid too much smoothing with 'ei', suggested max_accel <= 5900 mm/sec^2
Fitted shaper '2hump_ei' frequency = 71.2 Hz (vibrations = 0.0%, smoothing ~= 0.106)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 5600 mm/sec^2
Fitted shaper '3hump_ei' frequency = 87.0 Hz (vibrations = 0.0%, smoothing ~= 0.108)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 5500 mm/sec^2
Recommended shaper is ei @ 56.2 Hz
```

## Skew Calibration

<https://www.klipper3d.org/Skew_Correction.html>

### 2023-04-7

[YACS2](https://www.thingiverse.com/thing:5332053)

S=(X-Y)*2
E=(S-X)/2

Before:

AC=142.1
BD=140.7
AD=100.1

`SET_SKEW XY=142.1,140.7,100.1`

After:

AC=141.7
BD=141.5
AD=100.2

### 2023-03-23

[YACS2mini](https://www.thingiverse.com/thing:5332053)

- X=79.8
- Y=39.9

- S=(78.8-39.9)2.5=97.25% - shrinkage %
  - Take inverse of this one and scale models by this amount
  - PrusaSlicer: Advanced Settings -> Scale -> XY Size Compensation
  - Cura: Horizontal Expansion
- E=(97.25-(1.25*79.8))/2=-1.25mm - horizontal expansion mm
  - Use this number directly in slicer

Length AC = 112.6
Length BD = 112.7
Length AD = 79.8

> Step 1: Measure diagonals AC, BD and AD of each cube side.
> For the XY plane, measure he diagonals when looking at the Z face.
> For the XZ plane, measure he diagonals when looking at the X face.
> For the YZ plane, measure he diagonals when looking at the Y face.
>
> Step 2: In configuration.h there are 3 options mentioned:
>
>      insert the lengths of diagonals for XY, XZ and YZ planes directly in configuration.h and Marlin will calculate the skew >      factors (parameters XY_DIAG_AC, XY_DIAG_BD, XY_SIDE_AD, XZ_DIAG_AC, XZ_DIAG_BD, YZ_DIAG_AC, YZ_DIAG_BD, YZ_SIDE_AD)
>      calculate the skew factors for the 3 planes by hand and insert the values in configuration.h (parameters XY_SKEW_FACTOR, >      XZ_SKEW_FACTOR, YZ_SKEW_FACTOR)
>      calculate the skew factors for the 3 planes by hand and activate SKEW_CORRECTION_GCODE. This way, the skew factors can be >      set via M852 g-code command via serial interface.

XY AC 38.2
XY BD 38.2
XY AD 30

XZ AC 38.4
XZ BD 38.2
XZ AD 30

YZ AC 38.2
YZ BD 38.2
YZ AD 30

SET_SKEW XY=38.2,38.2,30 XZ=38.4,38.2,30 YZ=38.2,38.2,30

## Notes / Links

### Controller board

**Note: The Sprite Extruder / Pro kits have different breakout boards to the Ender 5 S1!**

Below contains notes/reference only.

- Sprite Extruder (Pro) pinout: <https://manuals.plus/creality/sprite-extruder-pro-kit-manual>

Likely an updated version of the board found on the Ender 3 S1, but using the STM32F401RE instead of the STM32F401CC as found in the Ender-3 S1/Ender-3S1 Pro V2.4.S1 Silent MotherBoard
