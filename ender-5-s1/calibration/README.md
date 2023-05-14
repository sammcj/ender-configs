# Calibration

See the dated subdirectories for calibration information.

Latest at time of looking at this readme:

[2023-05-09](2023-05-09/)

![X](2023-05-09/resonances_x_20230509_170556-2023-05-09.png)
![Y](2023-05-09/resonances_y_20230509_170812-2023-05-09.png)

To avoid too much smoothing with 'mzv', suggested max_accel <= 13200 mm/sec^2
Recommended shaper is mzv @ 67.0 Hz

To avoid too much smoothing with 'mzv', suggested max_accel <= 6500 mm/sec^2
Recommended shaper is mzv @ 47.0 Hz

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

### Horizontal Expansion / Shrinkage

#### 2023-03-20

[YACS2mini](https://www.thingiverse.com/thing:5332053)

- X=79.8
- Y=39.9

- S=(78.8-39.9)2.5=97.25% - shrinkage %
  - Take inverse of this one and scale models by this amount
  - PrusaSlicer: Advanced Settings -> Scale -> XY Size Compensation
  - Cura: Horizontal Expansion
- E=(97.25-(1.25*79.8))/2=-1.25mm - horizontal expansion mm
  - Use this number directly in slicer

- Length AC = 112.6
- Length BD = 112.7
- Length AD = 79.8
