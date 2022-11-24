#! /bin/sh

/bin/sh ./values/gen-secrets.sh

helm upgrade --install --upgrade petinvent ./charts/petinvent/. \
-f ./values/my-petinvent-values.yaml \
-f ./values/existingsecret.yaml

exit 0
