import time
from datetime import datetime

import adafruit_character_lcd.character_lcd as characterlcd
import board
import digitalio
import vcgencmd

messages = {
    "tempmsg": "Temperature:\n{}\337C",
    "humidmsg": "Humidity:\n{}%",
    "ppmmsg": "CO2 PPM:\n{}ppm",
    "vcgmsg": "CPU Temperature:\n{}\337C",
}
waitmsg = "Please hold\nretrying in {}s"


class LCDDisplay:

    def __init__(self, state, temp=100, humid=100, ppm=0):
        lcd_rs = digitalio.DigitalInOut(board.D26)
        lcd_en = digitalio.DigitalInOut(board.D19)
        lcd_d7 = digitalio.DigitalInOut(board.D27)
        lcd_d6 = digitalio.DigitalInOut(board.D22)
        lcd_d5 = digitalio.DigitalInOut(board.D24)
        lcd_d4 = digitalio.DigitalInOut(board.D25)
        lcd_columns = 16
        lcd_rows = 2

        lcd = characterlcd.Character_LCD_Mono(
            lcd_rs,
            lcd_en,
            lcd_d4,
            lcd_d5,
            lcd_d6,
            lcd_d7,
            lcd_columns,
            lcd_rows
        )
        lcd.clear()
        lcd.message = "{}\n{}".format(
            datetime.now().strftime("%B %d, %Y"),
            datetime.now().strftime("%H:%M:%S")
        )
        self.lcd = lcd
        if state < 1:
            self.show_values(temp, humid, ppm)
        else:
            self.countdown(state)

    def show_values(self, temp, humid, ppm=0):
        self.lcd.clear()
        self.lcd.message = messages['tempmsg'].format(temp)
        time.sleep(3)
        self.lcd.clear()
        self.lcd.message = messages['humidmsg'].format(humid)
        time.sleep(3)
        if ppm > 0:
            self.lcd.clear()
            self.lcd.message = messages['ppmmsg'].format(ppm)
            time.sleep(3)
        self.lcd.clear()
        cputemp = vcgencmd.Vcgencmd().measure_temp()
        self.lcd.message = messages['vcgmsg'].format(cputemp)
        time.sleep(3)
        self.lcd.clear()
        self.lcd.message = datetime.now().strftime("%B %d, %Y")
        tmp = time.time() + 5
        while tmp > time.time():
            self.lcd.message = "{}\n{}".format(
                datetime.now().strftime("%B %d, %Y"),
                datetime.now().strftime("%T")
            )

    def countdown(self, i):
        self.lcd.clear()
        while i >= 0:
            self.lcd.message = waitmsg.format(i)
            i = i - 1
            time.sleep(1)
