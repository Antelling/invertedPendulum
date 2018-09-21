import time
pin = 21
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(pin, GPIO.OUT)
p = GPIO.PWM(pin, 50)
p.start(6)

time.sleep(10)

p.stop()  # stop the PWM output
GPIO.cleanup()  # when your program exits, tidy up after yourself