import logging
import os
import time

import board
import dotenv

from db.db import EnvironmentDB
from healthchecks.healthchecks import Healthchecks
from lcd.lcd import LCDDisplay
from mqtt.mqtt import MQTT

logger = logging.getLogger("Status logger")
env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)

if os.getenv('HAS_LCD') == 'True':
    display = LCDDisplay()
else:
    display = None


def push_values(temp=18.0, humid=65.0, ppm=0.0):
    MQTT(temp, humid, ppm)
    EnvironmentDB().insert(temp, humid, ppm).close()


def do_sleep(state=1, temp=18.0, humid=65.0, ppm=0.0):
    sleep_time = 15
    if state >= 1:
        state = 1 if (state > 16) else state
        sleep_time = state
        logger.warning('Failed to update and push new temperature values, waiting {} seconds'.format(state))
    else:
        logger.info('Updated temperature values: {}C {}% {}ppm'.format(temp, humid, ppm))
        state = 0.5

    if display is not None:
        if state >= 1:
            display.countdown(state)
        else:
            display.show_values(temp, humid, ppm)
    else:
        time.sleep(sleep_time)

    return state * 2


class TemperatureDHT:

    def __init__(self):
        import adafruit_dht

        i = 1

        while True:
            Healthchecks('start')
            sensor = adafruit_dht.DHT22(board.D4)
            try:
                temperature = float(format(sensor.temperature, ".2f"))
                humidity = float(format(sensor.humidity, ".2f"))
                push_values(temperature, humidity)
                Healthchecks()
                i = do_sleep(0, temperature, humidity)
            except Exception as e:
                logger.critical("Error encountered while checking values:\n{}".format(e))
                Healthchecks('fail')
                i = do_sleep(i)
            sensor.exit()


class TemperatureSCD:

    def __init__(self):
        import adafruit_scd30

        sensor = adafruit_scd30.SCD30(board.I2C())

        i = 1

        while True:
            Healthchecks('start')
            try:
                if sensor.data_available:
                    temperature = float(format(sensor.temperature, ".2f"))
                    humidity = float(format(sensor.relative_humidity, ".2f"))
                    ppm = float(format(sensor.CO2, ".2f"))
                    push_values(temperature, humidity, ppm)
                    Healthchecks()
                    i = do_sleep(0, temperature, humidity)
            except Exception as e:
                logger.critical("Error encountered while checking values:\n{}".format(e))
                Healthchecks('fail')
                i = do_sleep(i)


class TemperatureAHT:

    def __init__(self):
        import adafruit_ahtx0

        sensor = adafruit_ahtx0.AHTx0(board.I2C())
        i = 1

        while True:
            Healthchecks('start')
            try:
                temperature = float(format(sensor.temperature, ".2f"))
                humidity = float(format(sensor.relative_humidity, ".2f"))
                push_values(temperature, humidity)
                Healthchecks()
                i = do_sleep(0, temperature, humidity)
            except Exception as e:
                logger.critical("Error encountered while checking values:\n{}".format(e))
                Healthchecks('fail')
                i = do_sleep(i)
