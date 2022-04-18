import os

import dotenv
import paho.mqtt.publish as publish

env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)


class MQTT:

    def __init__(self, temp=100.0, humid=65.0, ppm=0.0):
        if 60 > float(temp) > 10:  # 60/10 is a reasonable upper treshold
            auth = {"username": os.getenv("MQTT_USER"), "password": os.getenv("MQTT_PASS")}
            publish.multiple([
                {"topic": "Home/temp/{}".format(os.uname().nodename), "payload": temp},
                {"topic": "Home/humid/{}".format(os.uname().nodename), "payload": humid},
                {"topic": "Home/ppm/{}".format(os.uname().nodename), "payload": ppm},
            ],
                hostname=os.getenv('MQTT_HOST'),
                auth=auth
            )
