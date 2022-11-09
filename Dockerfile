# syntax=docker/dockerfile:1
ARG PYTHON_TAG=alpine
FROM python:${PYTHON_TAG} AS build
WORKDIR /src

# use python venv
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY flask_app/requirements.txt requirements.txt
# install pip requirments
RUN apk -U upgrade --no-cache && \
    apk add --no-cache --virtual .build-deps libpq-dev build-base && \
    python3 -m venv $VIRTUAL_ENV && \
    python3 -m ensurepip --upgrade && \
    python3 -m pip install --upgrade pip setuptools wheel --no-cache-dir && \
    python3 -m pip install -r requirements.txt --no-cache-dir && \
    apk --purge del .build-deps


FROM python:${PYTHON_TAG} AS run
WORKDIR /app

# use python venv (same as build venv)
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY --from=build /venv /venv

# copy source code
COPY /flask_app /app

# create directory for mounting configs
RUN mkdir -p /config

# install required Alpine packages
RUN apk -U upgrade --no-cache && \
    apk add --no-cache postgresql-libs wget

# Gunicorn entrypoint
COPY entrypoint.sh entrypoint.sh
EXPOSE 5000/tcp
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
