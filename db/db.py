import logging
import os

import dotenv
import mysql.connector

env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
logger = logging.getLogger("Status logger")


class EnvironmentDB:
    has_ppm = False
    query = "INSERT INTO {} (temp, humidity, ppm) VALUES ({}, {}, {})"
    create = "CREATE TABLE IF NOT EXISTS {} " \
             "(" \
             "id int NOT NULL AUTO_INCREMENT PRIMARY KEY, " \
             "created DATETIME DEFAULT CURRENT_TIMESTAMP, " \
             "temp DECIMAL(8,3), " \
             "humidity DECIMAL(5,2), " \
             "ppm DECIMAL(6,2)" \
             ")"

    def __init__(self):
        try:
            self.connection = mysql.connector.connect(
                host=os.getenv('MYSQL_HOST'),
                user=os.getenv('MYSQL_USER'),
                password=os.getenv('MYSQL_PASS'),
                database=os.getenv('MYSQL_DATA')
            )
        except Exception as e:
            logger.critical("Could not set up a database connection!\n{}".format(e))

    def check_table(self):
        self.connection.cursor().execute(
            self.create.format(os.uname().nodename)
        )
        return self

    def insert(self, temp=100.0, humidity=65.0, ppm=0.0):
        if temp < 50:
            self.connection.cursor().execute(
                self.query.format(
                    os.uname().nodename,
                    temp,
                    humidity,
                    ppm
                )
            )
        return self

    def close(self):
        self.connection.commit()
        self.connection.cursor().close()
        self.connection.close()