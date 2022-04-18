import os
import dotenv
import HTTPBearerAuth.requests as auth
import logging
import requests


logger = logging.getLogger("Status logger")
env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
openweathermap = "states/sensor.openweathermap_pressure"
url = '{}{}'.format(os.getenv('HASSURL'), openweathermap)
creds = auth.HTTPBearerAuth(os.getenv('HASS'))


class HomeAssistant:
    pressure = 0

    def get_pressure(self):
        try:
            weather = requests.get(url, auth=creds)
            result = weather.json()
            self.pressure = int(result['state'])
        except requests.RequestException as e:
            logger.info('Could not retrieve weather data from HASS:\n'.format(e))
            self.pressure = 0

        return self
