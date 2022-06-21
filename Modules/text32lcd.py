from microbit import *
from microbit import spi
from micropython import const

class KitronikText32():
    FUNCTION_SET1_CMD = const(0x38)
    FUNCTION_SET2_CMD = const(0x3C)
    DISPLAY_ON = const(0x0C)
    CLEAR_DISPLAY = const(0x01)
    LCD_LINE1 = const(0x80)
    LCD_LINE2 = const(0xC0)
    LCD_LINE_LENGTH = const(16)
    BLANK_SPACE = const(0x20)

    def __init__(self):
        pin14.write_digital(0)
        spi.init(baudrate=230000, bits=8, mode=0, sclk=pin13, mosi=pin15, miso=pin12)
        pin14.write_digital(1)
        sleep(1000)
        buf = bytes([self.FUNCTION_SET1_CMD, self.DISPLAY_ON, self.CLEAR_DISPLAY, 0x06])
        spi.write(buf)

    def displayString(self, lcdLineAddr, text):
        lengthOfText = len(text)
        if lengthOfText < 16:
            text = text + (' ' * (16 - lengthOfText))
        elif lengthOfText > 16:
            text = text[:16]
        buf = bytes([self.FUNCTION_SET1_CMD, lcdLineAddr])
        spi.write(buf)
        buf = bytes([self.FUNCTION_SET2_CMD, 0x8F])
        spi.write(buf)
        buf = bytes(map(ord,text))
        spi.write(buf)

    def displayString1(self, text):
        self.displayString(self.LCD_LINE1, text)

    def displayString2(self, text):
        self.displayString(self.LCD_LINE2, text)

    def clear(self):
        self.displayString1('')
        self.displayString2('')
