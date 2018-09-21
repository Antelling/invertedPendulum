from numpy import median
from math import acos, atan2
from mpu6050 import mpu6050
import RPi.GPIO as GPIO

# region initiate servos

import pigpio
pi = pigpio.pi()
zeropoint = 1522
current_speed = zeropoint

# endregion

# region initiate gyro

sensor = mpu6050(0x68)

sensor.set_accel_range(sensor.ACCEL_RANGE_2G)
sensor.set_gyro_range(sensor.GYRO_RANGE_250DEG)


def accel():
    data = sensor.get_accel_data(True)
    data = [data["x"], data["y"]]
    return data

#the gyroscope is twisted a little
balance_offset = 0.176765396

# endregion

# region controller

class PIDController(object):
    def __init__(self, p=-.001, i=0.0, d=-1.0, ts=.01):
        self.p = p
        self.i = i
        self.d = d

        self.ts = ts

        self.error = 0

    def step(self, prev_pos, current_pos):
        # since the center is 0, 0, we can just add the position to accumulated error
        self.error += current_pos * self.ts

        # p term
        x_p_adjustment = self.p * current_pos

        # i term
        x_i_adjustment = self.i * self.error

        # p term
        x_d_adjustment = self.d * ((current_pos - prev_pos) / self.ts)

        return x_p_adjustment + x_i_adjustment + x_d_adjustment

s = 10
p = 5
d = 0
m = True
controller = PIDController(p, 0, d)


# endregion controller

# region feedback loop

def sign(x):
    return -1 if x < 0 else 1


pos = accel()
radians = acos(median([-1, -pos[0], 1])) * -sign(pos[1]) - balance_offset
prev_pos = radians

try:
    while True:
        pos = accel()

        if m: #we can use both x and y to get radians, or just y
            current_radians = atan2(-1 * pos[1], -1 * pos[0]) - balance_offset
        else:
            current_radians = acos(median([-1, -pos[0], 1])) * -sign(pos[1]) - balance_offset

        #position can only change so fast
        difference = radians - current_radians
        if abs(difference) > s:
            difference = s * sign(difference)
        radians -= difference

        #now we plug this position into our PID controller, which gives a response value
        adjust = controller.step(prev_pos, radians)
        print("controller response is: " + str(adjust))

        #we use this response as acceleration
        current_speed += adjust
        current_speed = median([1420, current_speed, 1630])

        prev_pos = radians

        pi.set_servo_pulsewidth(18, current_speed)

except KeyboardInterrupt:
    pi.set_servo_pulsewidth(18, zeropoint)

# endregion
