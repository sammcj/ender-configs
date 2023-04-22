# CAN bus

- Good tutorial: <https://maz0r.github.io/klipper_canbus/>

## Klipper

- <https://www.klipper3d.org/CANBUS.html>

## Armbian

/etc/network/interfaces:

```plain
auto can0
iface can0 can static
bitrate 1000000
up ifconfig $IFACE txqueuelen 1024
```

## Notes

### EBB36

- ID: 44bd831d1781
- Firmware: Canboot (stock), then Klipper (stock)

### U2C

- Serial: 203739645542
- Firmware: Canboot (stock), then BTT firmware fork of candleLight_fw
  - Tried other forks which loaded - but didn't detect the EBB36

### BIGTREETECH

11 / 11

1. Every device on CANBus generates a canbus_uuid based on the MCU's UID,
to find each microcontroller device ID, make sure the hardware is powered on
and wired correctly, then run:
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
1. If an uninitialized CAN device is detected, the above command will report the
device's canbus_uuid:
Found canbus_uuid=0e0d81e4210c
1. If Klipper is already running and connected to this device, the canbus_uuid will
not be reported, which is normal.

## EBB36

- <https://github.com/bigtreetech/EBB/blob/master/README.md>
- <https://github.com/candle-usb/candleLight_fw/pull/126>
- <https://github.com/bigtreetech/EBB/blob/master/EBB%20CAN%20V1.1%20(STM32G0B1)/sample-bigtreetech-ebb-canbus-v1.2.cfg>

Good tutorial: <https://maz0r.github.io/klipper_canbus/toolhead/ebb36-42_v1.1.html>

> "V1.2 compared with v1.1: only the IO of hotend is changed from PA2 to PB13"

```dmesg
[Tue Apr 18 08:32:22 2023] usb 1-1.1: new full-speed USB device number 4 using ehci-platform
[Tue Apr 18 08:32:22 2023] usb 1-1.1: New USB device found, idVendor=1d50, idProduct=614e, bcdDevice= 1.00
[Tue Apr 18 08:32:22 2023] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[Tue Apr 18 08:32:22 2023] usb 1-1.1: Product: stm32g0b1xx
[Tue Apr 18 08:32:22 2023] usb 1-1.1: Manufacturer: Klipper
[Tue Apr 18 08:32:22 2023] usb 1-1.1: SerialNumber: 2B0007000C50425539393020
[Tue Apr 18 08:32:22 2023] cdc_acm 1-1.1:1.0: ttyACM1: USB ACM device
[Tue Apr 18 08:32:30 2023] usb 1-1.1: USB disconnect, device number 4
[Tue Apr 18 08:32:35 2023] usb 1-1.1: new full-speed USB device number 5 using ehci-platform
[Tue Apr 18 08:32:35 2023] usb 1-1.1: New USB device found, idVendor=1d50, idProduct=614e, bcdDevice= 1.00
[Tue Apr 18 08:32:35 2023] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[Tue Apr 18 08:32:35 2023] usb 1-1.1: Product: stm32g0b1xx
[Tue Apr 18 08:32:35 2023] usb 1-1.1: Manufacturer: Klipper
[Tue Apr 18 08:32:35 2023] usb 1-1.1: SerialNumber: 2B0007000C50425539393020
[Tue Apr 18 08:32:35 2023] cdc_acm 1-1.1:1.0: ttyACM1: USB ACM device
```

```dfu-util -l
Found DFU: [0483:df11] ver=0200, devnum=8, cfg=1, intf=0, path="1-1.1", alt=2, name="@Internal Flash   /0x08000000/64*02Kg", serial="203739645542"
Found DFU: [0483:df11] ver=0200, devnum=8, cfg=1, intf=0, path="1-1.1", alt=1, name="@Internal Flash   /0x08000000/64*02Kg", serial="203739645542"
Found DFU: [0483:df11] ver=0200, devnum=8, cfg=1, intf=0, path="1-1.1", alt=0, name="@Internal Flash   /0x08000000/64*02Kg", serial="203739645542"
```

<!-- dfu-util -D canboot.bin -S "2B0007000C50425539393020", -a 0 -s 0x08000000:leave -->
```shell
dfu-util -l
dfu-util -a 0 -D canboot.bin --dfuse-address 0x08000000:force:mass-erase:leave -d 0483:df11
```

or fail-safe method if device is blank:

- Disconnect the USB connector from the CANtact, short the BOOT pins, then reconnect the USB connector. The device should enumerate as "STM32 BOOTLOADER".
- Invoke dfu-util manually with: sudo dfu-util --dfuse-address -d 0483:df11 -c 1 -i 0 -a 0 -s 0x08000000 -D CORRECT_FIRWARE.bin where CORRECT_FIRWARE is the name of the desired .bin.
- Disconnect the USB connector, un-short the BOOT pins, and reconnect.

## U2C

- <https://github.com/bigtreetech/U2C>
- <https://raw.githubusercontent.com/bigtreetech/U2C/master/BIGTREETECH%20U2C%20V1.0%26V1.1%20User%20Manual.pdf>
- Good tutorial: <https://maz0r.github.io/klipper_canbus/controller/u2c.html>

```dmesg
[Tue Apr 18 08:07:19 2023] usb 1-1.1: new full-speed USB device number 3 using ehci-platform
[Tue Apr 18 08:07:19 2023] usb 1-1.1: New USB device found, idVendor=1d50, idProduct=606f, bcdDevice= 0.00
[Tue Apr 18 08:07:19 2023] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[Tue Apr 18 08:07:19 2023] usb 1-1.1: Product: candleLight USB to CAN adapter
[Tue Apr 18 08:07:19 2023] usb 1-1.1: Manufacturer: bytewerk
[Tue Apr 18 08:07:19 2023] usb 1-1.1: SerialNumber: 004400205841500C20373233
[Tue Apr 18 08:07:20 2023] CAN device driver interface
[Tue Apr 18 08:07:20 2023] gs_usb 1-1.1:1.0: Configuring for 1 interfaces
[Tue Apr 18 08:07:20 2023] usbcore: registered new interface driver gs_usb
```

```lsusb
Bus 001 Device 003: ID 1d50:606f OpenMoko, Inc. Geschwister Schneider CAN adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1d50 OpenMoko, Inc.
  idProduct          0x606f Geschwister Schneider CAN adapter
  bcdDevice            0.00
  iManufacturer           1 bytewerk
  iProduct                2 candleLight USB to CAN adapter
  iSerial                 3 004400205841500C20373233
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0032
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          4 fw_9209055_2022-06-20+
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              150mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       254 Application Specific Interface
      bInterfaceSubClass      1 Device Firmware Update
      bInterfaceProtocol      1
      iInterface            224 candleLight firmware upgrade interface
      Device Firmware Upgrade Interface Descriptor:
        bLength                             9
        bDescriptorType                    33
        bmAttributes                       11
          Will Detach
          Manifestation Intolerant
          Upload Supported
          Download Supported
        wDetachTimeout                    255 milliseconds
        wTransferSize                    2048 bytes
        bcdDFUVersion                   1.1a
can't get device qualifier: Resource temporarily unavailable
can't get debug descriptor: Resource temporarily unavailable
Device Status:     0x0000
  (Bus Powered)
```
