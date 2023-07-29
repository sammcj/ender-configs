#!/usr/bin/env python3
import time
import numpy as np
import matplotlib.pyplot as plt
import gpiod
from adxl345 import ADXL345



# Set up GPIO 24 as an input
chip = gpiod.Chip('gpiochip1')
line = chip.get_line(24)
line.request(consumer="my_consumer", type=gpiod.LINE_REQ_DIR_IN)

# Create an ADXL345 object
adxl = ADXL345()

# Wait for interrupt signal
while True:
    ev_line = line.event_wait(gpiod.LINE_EVENT_RISING_EDGE)
    x, y, z = adxl.get_axes()
    print(f"X: {x}, Y: {y}, Z: {z}")
    time.sleep(0.1)

