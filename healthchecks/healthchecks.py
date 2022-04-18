import logging
import os

import dotenv
import requests

env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
logger = logging.getLogger("Status logger")


class Healthchecks:

    def __init__(self, method='', data=''):
        if len(method) > 0 and method[:1] != '/':
            method = '/{}'.format(method)
        url = '{}/{}{}'.format(os.getenv('HEALTHPING'), os.getenv('HC'), method)
        try:
            if len(data) > 0:
                requests.post(url, data=data, timeout=5)
            else:
                requests.get(url, timeout=2)
        except requests.RequestException as e:
            logger.warning('Could not execute healthcheck:\n{}'.format(e), exc_info=True)
