from os import environ
from dotenv import load_dotenv
from dotenv import dotenv_values
from pathlib import Path

# env_filepath = Path.cwd().parent.joinpath(".env")
env_filepath = Path("/config/.env")


if env_filepath.is_file():
    load_dotenv(dotenv_path=env_filepath)

try:
    POSTGRES_USER = str(environ["POSTGRES_USER"])
    POSTGRES_PASSWORD = str(environ["POSTGRES_PASSWORD"])
    DB_HOSTNAME = str(environ["DB_HOSTNAME"])
    POSTGRES_DB = str(environ["POSTGRES_DB"])
    POSTGRES_PORT = str(environ["POSTGRES_PORT"])
except KeyError:
    raise ValueError("No database config set for Flask application")
try:
    SECRET_KEY = str(environ["FLASK_SECRET_KEY"])
except KeyError:
    raise ValueError("No SECRET_KEY set for Flask application")


class Config(object):
    # Connect String:
    # postgresql+psycopg2://user:password@host:port/dbname[?key=value&key=value...]
    SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://" + POSTGRES_USER + ":" + POSTGRES_PASSWORD + "@" \
                              + DB_HOSTNAME + ":" + POSTGRES_PORT + "/" + POSTGRES_DB

    SECRET_KEY = str(environ["SECRET_KEY"])
    DEBUG = False
    TESTING = False
    SESSION_COOKIE_SECURE = True


class ProductionConfig(Config):
    pass


class DevelopmentConfig(Config):
    DEBUG = True
    SESSION_COOKIE_SECURE = False


class TestingConfig(Config):
    TESTING = True
    SESSION_COOKIE_SECURE = False
