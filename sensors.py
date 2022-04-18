import logging
import os
import time
import dotenv
import board

from homeassistant.homeassistant import HomeAssistant
from db.db import EnvironmentDB
from healthchecks.healthchecks import Healthchecks
from lcd.lcd import LCDDisplay
from mqtt.mqtt import MQTT

logger = logging.getLogger("Status logger")
env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
lcd_enabled = os.getenv('HAS_LCD') == 'True'


def pull_values(sensor, i):
    if sensor.data_available:
        try:
            temperature = float(format(sensor.temperature, ".2f"))
            if hasattr(sensor, 'humidity'):
                humidity = float(format(sensor.humidity, ".2f"))
            else:
                humidity = float(format(sensor.relative_humidity, ".2f"))
            if hasattr(sensor, 'CO2'):
                ppm = float(format(sensor.CO2, ".2f"))
            else:
                ppm = 0
            push_values(temperature, humidity, ppm)
            Healthchecks()
            return do_sleep(0, temperature, humidity, ppm)
        except Exception as e:
            logger.critical("Error encountered while checking values:\n{}".format(e), exc_info=True)
            Healthchecks('fail', '{}'.format(e))
            return do_sleep(i)
    return i


def push_values(temp=18.0, humid=65.0, ppm=0.0):
    MQTT(temp, humid, ppm)
    EnvironmentDB().insert(temp, humid, ppm).close()


def do_sleep(state=0, temp=18.0, humid=65.0, ppm=0.0):
    sleep_time = 15
    if state == 0:
        logger.info('Updated temperature values: {}C {}% {}ppm'.format(temp, humid, ppm))
        state = 0.5
    else:
        state = 1 if (state > 16) else state
        sleep_time = state
        logger.warning('Failed to update and push new temperature values, waiting {} seconds'.format(state))
    if lcd_enabled:
        LCDDisplay(state, temp, humid, ppm)
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
            sensor.__setattr__('data_available', True)
            i = pull_values(sensor, i)
            sensor.exit()


class TemperatureSCD:
    # Location data for pressure

    def __init__(self):
        import adafruit_scd30

        sensor = adafruit_scd30.SCD30(board.I2C())
        sensor.altitude = 255
        i = 1

        while True:
            Healthchecks('start')
            pressure = HomeAssistant().pressure
            if pressure > 0:
                sensor.ambient_pressure = pressure
            i = pull_values(sensor, i)


class TemperatureAHT:

    def __init__(self):
        import adafruit_ahtx0

        sensor = adafruit_ahtx0.AHTx0(board.I2C())
        sensor.__setattr__('data_available', True)
        i = 1

        while True:
            Healthchecks('start')
            i = pull_values(sensor, i)
