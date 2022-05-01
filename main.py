#!/usr/bin/python3

import logging
import os

import dotenv

import sensors

env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
logger = logging.getLogger("Status logger")
logger.setLevel(logging.INFO)
handler = logging.FileHandler('/home/pi/temphumid.log')
formatter = logging.Formatter('%(asctime)s : %(levelname)s : %(name)s : %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.info("Start recording temperature/humidity")


def main():
    sensortype = os.getenv('SENSORTYPE')
    if sensortype == 'DHT22':
        sensors.TemperatureDHT()
    elif sensortype == 'AHTx0':
        sensors.TemperatureAHT()
    elif sensortype == 'SCD30':
        sensors.TemperatureSCD()
    else:
        logger.critical("Sensor not recognised. Exiting")
        exit(255)


if __name__ == '__main__':
    main()
