# Don't try to run this as a script or it will all be over very quickly
# it won't do any harm though.
# these are all the elements you need to control PWM on 'normal' GPIO ports
# with RPi.GPIO - requires RPi.GPIO 0.5.2a or higher
import time
pin = 14

import RPi.GPIO as GPIO  # always needed with RPi.GPIO

GPIO.setmode(GPIO.BCM)  # choose BCM or BOARD numbering schemes. I use BCM

GPIO.setup(pin, GPIO.OUT)  # set GPIO 25 as an output. You can use any GPIO port

p = GPIO.PWM(pin, 50)  # create an object p for PWM on port 25 at 50 Hertz
# you can have more than one of these, but they need
# different names for each port
# e.g. p1, p2, motor, servo1 etc.

p.start(6)  # start the PWM on 50 percent duty cycle
# duty cycle value can be 0.0 to 100.0%, floats are OK


duty = 6
for _ in range(40):
    p.ChangeDutyCycle(duty)
    time.sleep(.2)
    duty += .05

p.stop()  # stop the PWM output
GPIO.cleanup()  # when your program exits, tidy up after yourself