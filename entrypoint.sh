#!/bin/sh

#python3 -m flask run --host=0.0.0.0
python3 -m gunicorn --bind 0.0.0.0:5000 --workers 4 --access-logfile=- wsgi:app
