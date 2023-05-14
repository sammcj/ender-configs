# Ender 5 S1

My Documentation, Configuration, Scripts and notes for the Ender 5 S1 3d Printer.

# Sam's Ender 5 S1 Setup

- [Ender 5 S1](#ender-5-s1)
- [Sam's Ender 5 S1 Setup](#sams-ender-5-s1-setup)
  - [Hardware](#hardware)
  - [Firmware](#firmware)

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

## Firmware

See [klipper](../klipper/) for config files.

- BTT Octopus v1.1 Controller
  - STM32F446
  - 32KiB bootloader
  - 12MHz clock
  - baud: 1000000
- BTT EBB36
  - STM32G0B1
  - 8Kb bootloader
  - CAN bus on PB0/PB1
  - baud: 1000000
- BTT U2C
  - STM32F042
  - 8Kb bootloader
  - CAN bus on PA11/PA12
  - baud: 1000000
