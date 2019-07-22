avr-gcc -g -Os -mmcu=atmega32 -c led.c
avr-gcc -g -mmcu=atmega32 -o led.elf led.o
avr-objcopy -j .text -j .data -O ihex led.elf led.hex
avr-size --format=avr --mcu=atmega32 led.elf 
rm led.elf led.o
avrdude -c usbtiny -p atmega328p -U flash:w:led.hex -F
