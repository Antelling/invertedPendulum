import time
from math import atan2, acos
from numpy import mean, median

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

def sign(x):
    return -1 if x < 0 else 1


values = []

while True:
    try:
        pos = accel()
        #time.sleep(.1)
        radians = atan2(-1 * pos[1], -1 * pos[0])
        #print(abs(pos[0]) + abs(pos[1]))
        #print(acos(median([-1, -pos[0], 1])) * -sign(pos[1]))
        print(radians)
        #print("")
        values.append(radians)
    except KeyboardInterrupt:
        print(mean(values))
        exit()
