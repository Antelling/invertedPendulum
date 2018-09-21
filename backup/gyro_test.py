import time
from math import atan2
from numpy import mean

# region initiate gyro

from mpu6050 import mpu6050

sensor = mpu6050(0x68)

sensor.set_accel_range(sensor.ACCEL_RANGE_2G)
sensor.set_gyro_range(sensor.GYRO_RANGE_250DEG)


def accel():
    data = sensor.get_accel_data(True)
    data = [data["x"], data["y"], data["z"]]
    return data


def get_data():
    return accel()[1:2]


values = []

while True:
    try:
        pos = accel()
        radians = atan2(-1 * pos[1], -1 * pos[0])
        print(radians)
        values.append(radians)
    except KeyboardInterrupt:
        print(mean(values))
        exit()
