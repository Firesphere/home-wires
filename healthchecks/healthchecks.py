import logging
import os

import dotenv
import requests

env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
logger = logging.getLogger("Status logger")


class Healthchecks:

    def __init__(self, method=''):
        if len(method) > 0 and method[:1] != '/':
            method = '/{}'.format(method)
        url = '{}/{}{}'.format(os.getenv('HEALTHPING'), os.getenv('HC'), method)
        try:
            requests.get(url)
        except:
            logger.warning('Could not execute healthcheck', exc_info=True)
