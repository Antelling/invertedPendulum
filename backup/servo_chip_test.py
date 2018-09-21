import Adafruit_PCA9685
import time

# Uncomment to enable debug output.
#import logging
#logging.basicConfig(level=logging.DEBUG)

# Initialise the PCA9685 using the default address (0x40).

pwm = Adafruit_PCA9685.PCA9685()
pwm.set_pwm_freq(60)
def set(f):
    pwm.set_pwm(0, 0, f)
    pwm.set_pwm(1, 0, f)


# Configure min and max servo pulse lengths
servo_min = 130  # Min pulse length out of 4096
servo_max = 170  # Max pulse length out of 4096

# Helper function to make setting a servo pulse width simpler.
def set_servo_pulse(channel, pulse):
    pulse_length = 1000000    # 1,000,000 us per second
    pulse_length //= 60       # 60 Hz
    print('{0}us per period'.format(pulse_length))
    pulse_length //= 4096     # 12 bits of resolution
    print('{0}us per bit'.format(pulse_length))
    pulse *= 1000
    pulse //= pulse_length
    pwm.set_pwm(channel, 0, pulse)

# Set frequency to 60hz, good for servos.
pwm.set_pwm_freq(60)

pwm.set_pwm(0, 0, 380)