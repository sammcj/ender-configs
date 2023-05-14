# Sam's Ender 5 S1 Setup

My Documentation, Configuration, Scripts and notes for the Ender 5 S1 3d Printer.

- [Sam's Ender 5 S1 Setup](#sams-ender-5-s1-setup)
  - [Klipper Config](#klipper-config)
  - [Hardware](#hardware)
  - [Firmware](#firmware)

## Klipper Config

See [klipper](../klipper/) for config files.

## Hardware

- Ender 5 S1
- Creality Sprite Extruder
- BTT Octopus Controller
- BTT EBB36 CAN bus tool
  - ADXL345 USB accelerometers
- BTT U2C USB CAN bus
- Mellow NF Smart Hotend
  - 60W heating element
  - PT1000 sensor
- MP1584 DC-DC Buck Converter
  - 24v to 12v (3A max)
  - Used for the hotend fan (Nocuta 40x40x20mm 12v)
- Dual 5015 parts cooling

## Firmware

See [klipper](../klipper/) for config files.

- BTT Octopus v1.1 Controller
  - STM32F446
  - 32KiB bootloader
  - 12MHz clock
  - baud: 1000000
- BTT EBB36
  - Canboot
  - Klipper
    - STM32G0B1
    - 8Kb bootloader
    - CAN bus on PB0/PB1
    - baud: 1000000
- BTT U2C
  - Canboot
  - Klipper
    - STM32F042
    - 8Kb bootloader
    - CAN bus on PA11/PA12
    - baud: 1000000
