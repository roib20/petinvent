#! /bin/sh

helm upgrade --install --upgrade petbuddy petbuddy/. -f myvalues.yaml -f existingsecret.yaml

exit 0
