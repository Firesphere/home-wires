import logging
import os

import dotenv
import mysql.connector

env_path = os.path.join(os.getcwd(), '.env')
dotenv.load_dotenv(dotenv_path=env_path)
logger = logging.getLogger("Status logger")


class EnvironmentDB:
    has_ppm = False
    insert_query = "INSERT INTO {} (temp, humidity, ppm) VALUES (%s, %s, %s)"
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
            self.cursor = self.connection.cursor(prepared=True)
        except Exception as e:
            logger.critical("Could not set up a database connection!\n{}".format(e), exc_info=True)

    def check_table(self):
        if self.connection:
            self.cursor.execute(
                self.create.format(os.uname().nodename)
            )
        return self

    def insert(self, temp=100.0, humidity=65.0, ppm=0.0):
        if self.connection:
            if temp < 50:
                query = self.insert_query.format(os.uname().nodename)
                self.cursor.execute(query, (temp, humidity, ppm))
        return self

    def close(self):
        if self.connection:
            self.connection.commit()
            self.cursor.close()
            self.connection.close()
