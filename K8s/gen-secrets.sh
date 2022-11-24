#! /bin/sh

SEALED_SECRETS_CHART_VERSION=1.1.9

if [ "$1" ]; then
  SECRET_NAME="$1"
else
  SECRET_NAME="mysecret"
fi

if [ "$2" ]; then
  VALUES_NAME="$2"
else
  VALUES_NAME="existingsecret"
fi

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install sealed-secrets-controller bitnami/sealed-secrets --version "${SEALED_SECRETS_CHART_VERSION}" \
--namespace default

# sleep "5s"

# Remove previous secret by the same name
kubectl delete sealedsecrets.bitnami.com ${SECRET_NAME}

# Generate random passwords
PASSGEN="head /dev/urandom | tr -dc A-Za-z0-9 | head -c64"
FLASK_SECRET_KEY=$(eval "$PASSGEN")
POSTGRESQL_PASSWORD=$(eval "$PASSGEN")
POSTGRESQL_POSTGRES_PASSWORD=$(eval "$PASSGEN")
REPMGR_PASSWORD=$(eval "$PASSGEN")

kubectl --namespace default \
  create secret \
  generic "${SECRET_NAME}" \
  --dry-run=client \
  --from-literal flaskSecretKey="${FLASK_SECRET_KEY}" \
  --from-literal postgresql-password="${POSTGRESQL_PASSWORD}" \
  --from-literal postgresql-postgres-password="${POSTGRESQL_POSTGRES_PASSWORD}" \
  --from-literal repmgr-password="${REPMGR_PASSWORD}" \
  --output json |
  kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=default \
      |
  tee "${SECRET_NAME}".yaml

kubectl create \
  --filename "${SECRET_NAME}".yaml

# create myvalues.yaml file
cat >"${VALUES_NAME}".yaml <<EOF
app:
  secret:
    existingSecret: ${SECRET_NAME}

# Values for PostgreSQL child/dependency chart
postgresql-ha:
  postgresql:
    existingSecret: ${SECRET_NAME}
    username: user
    database: db
    repmgrUsername: repmgr
EOF

# kubectl get secret ${SECRET_NAME} \
#     --output yaml

# kubeseal --fetch-cert

exit 0
