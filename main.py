#!/bin/python3
import logging
import sys
import os
import requests
import dotenv
import json

env_path = os.path.join(os.path.dirname(sys.argv[0]), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
pushover_url = 'https://api.pushover.net/1/messages.json'

token = os.getenv('PUSHOVERKEY', '')
user = os.getenv('PUSHOVERUSER', '')

handler = None
logger = logging.getLogger("MotionEye push notification")
logger.setLevel(logging.INFO)
if os.getenv('ENVIRONMENT', '') == 'dev':
    handler = logging.StreamHandler(sys.stdout)
else:  # The else is to prevent errors trying to open the log file as the wrong user
    handler = logging.FileHandler('/var/log/motion_pushover.log')
formatter = logging.Formatter('%(asctime)s : %(levelname)s : %(name)s : %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
data = {
        "token": token,
        "user": user,
}


def call_pushover(data, filedata=None):
    response = requests.post(pushover_url, data=data, files=filedata)
    response_text = json.loads(response.text)
    if response_text['status'] != 1:
        logger.warning('Error sending notification')
        logger.warning('Error message: {}'.format(response.text))


def start(eventtime):
    data["message"] = "{} detected motion at {}".format(os.uname().nodename, eventtime)
    call_pushover(data)


def end(eventtime):
    data["message"] = "{} motion event ended at {}".format(os.uname().nodename, eventtime)
    call_pushover(data)


def withfile(eventtime, location):
    data["message"] = "{} motion event detected at {}. See image attached".format(os.uname().nodename, eventtime)

    attachment = {
        "attachment": open(location, "rb")
    }
    call_pushover(data, attachment)


if __name__ == '__main__':
    args = sys.argv
    time = args[2]
    if args[1] == 'start':
        start(time)
    elif args[1] == 'end':
        end(time)
    elif args[1] == 'file':
        withfile(time, args[3])
