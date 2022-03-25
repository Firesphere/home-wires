import os

import dotenv
import requests

env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)


class Healthchecks:

    def __init__(self, method=''):
        if len(method) > 0 and method[:1] != '/':
            method = '/{}'.format(method)
        url = '{}/{}{}'.format(os.getenv('HEALTHPING'), os.getenv('HC'), method)
        requests.get(url)
