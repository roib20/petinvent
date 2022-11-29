from os import environ
from dotenv import load_dotenv
from dotenv import dotenv_values
from pathlib import Path
from sqlalchemy.engine.url import make_url

# env_filepath = Path.cwd().parent.joinpath(".env")
env_filepath = Path("/config/.env")


if env_filepath.is_file():
    load_dotenv(dotenv_path=env_filepath)

if "POSTGRES_DB" in environ:
    try:
        POSTGRES_USER = str(environ["POSTGRES_USER"])
        POSTGRES_PASSWORD = str(environ["POSTGRES_PASSWORD"])
        DB_HOSTNAME = str(environ["DB_HOSTNAME"])
        POSTGRES_DB = str(environ["POSTGRES_DB"])
    except KeyError:
        raise ValueError("Missing values for PostgreSQL config")

    try:
        POSTGRES_PORT = str(environ["POSTGRES_PORT"])
    except KeyError:
        POSTGRES_PORT = 5432

    # Connect String:
    # dialect+driver://username:password@host:port/dbname[?key=value&key=value...]
    SQLALCHEMY_DATABASE_URI = make_url(
        str(
            "postgresql"
            + "+"
            + "psycopg2"
            + "://"
            + POSTGRES_USER
            + ":"
            + POSTGRES_PASSWORD
            + "@"
            + DB_HOSTNAME
            + ":"
            + POSTGRES_PORT
            + "/"
            + POSTGRES_DB
        )
    )

elif "MYSQL_DATABASE" in environ:
    try:
        MYSQL_USER = str(environ["MYSQL_USER"])
        MYSQL_PASSWORD = str(environ["MYSQL_PASSWORD"])
        MYSQL_ROOT_PASSWORD = str(environ["MYSQL_ROOT_PASSWORD"])
        DB_HOSTNAME = str(environ["DB_HOSTNAME"])
        MYSQL_DATABASE = str(environ["MYSQL_DATABASE"])
    except KeyError:
        raise ValueError("Missing value/values for MySQL or MariaDB config")

    try:
        MYSQL_PORT = str(environ["POSTGRES_PORT"])
    except KeyError:
        MYSQL_PORT = str(3306)

    # Connect String:
    # dialect+driver://username:password@host:port/dbname[?key=value&key=value...]
    SQLALCHEMY_DATABASE_URI = make_url(
        str(
            "mysql"
            + "+"
            + "pymsql"
            + "://"
            + MYSQL_USER
            + ":"
            + MYSQL_PASSWORD
            + "@"
            + DB_HOSTNAME
            + ":"
            + MYSQL_PORT
            + "/"
            + MYSQL_DATABASE
            + "?"
            + "charset=utf8mb4"
        )
    )

elif "MARIADB_DATABASE" in environ:
    try:
        MARIADB_USER = str(environ["MARIADB_USER"])
        MARIADB_PASSWORD = str(environ["MARIADB_PASSWORD"])
        MARIADB_ROOT_PASSWORD = str(environ["MARIADB_ROOT_PASSWORD"])
        DB_HOSTNAME = str(environ["DB_HOSTNAME"])
        MARIADB_DATABASE = str(environ["MARIADB_DATABASE"])
    except KeyError:
        raise ValueError("Missing value/values for MariaDB config")

    try:
        MARIADB_PORT = str(environ["POSTGRES_PORT"])
    except KeyError:
        MARIADB_PORT = str(3306)

    # Connect String:
    # dialect+driver://username:password@host:port/dbname[?key=value&key=value...]
    SQLALCHEMY_DATABASE_URI = make_url(
        str(
            "mariadb"
            + "+"
            + "pymsql"
            + "://"
            + MARIADB_USER
            + ":"
            + MARIADB_PASSWORD
            + "@"
            + DB_HOSTNAME
            + ":"
            + MARIADB_PORT
            + "/"
            + MARIADB_DATABASE
            + "?"
            + "charset=utf8mb4"
        )
    )

else:
    SQLALCHEMY_DATABASE_URI = make_url(str("sqlite:///pets_db.sqlite3"))

try:
    SECRET_KEY = str(environ["SECRET_KEY"])
except KeyError:
    raise ValueError("No SECRET_KEY set for Flask application")


class Config(object):
    SQLALCHEMY_DATABASE_URI = SQLALCHEMY_DATABASE_URI
    SECRET_KEY = SECRET_KEY
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
