#! /bin/sh

valid_string="This API Token is valid and active"
valid_token=false

while [ ${valid_token} = false ]
do
# Ask user to enter Cloudflare API token
stty -echo
printf "Enter Cloudflare API token: "
read -r CLOUDFLARE_API_TOKEN
stty echo
printf "\n"

if curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type:application/json" |
    grep -q "$valid_string"; then
    valid_token=true
    echo "Valid Cloudflare API token"
else
    echo "Invalid Cloudflare API token.
    For getting your token, see instructions here:
    https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens"
fi
done

SECRET_NAME="cloudflare-secret"

# Install "Sealed Secrets" controller by Bitnami
# kubectl apply --filename \
#   https://github.com/bitnami-labs/sealed-secrets/releases/download/"${SEALED_SECRETS_VERSION}"/controller.yaml

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install sealed-secrets-controller bitnami/sealed-secrets \
--namespace default

# sleep "5s"

# Remove previous secret by the same name
( kubectl delete sealedsecrets.bitnami.com ${SECRET_NAME} ) > /dev/null 2>&1

CLOUDFLARE_API_TOKEN="5bMCPVBzrT-EjT8fwRPjxzzSow6JD4daElTpPjoi"

kubectl --namespace default \
  create secret \
  generic "${SECRET_NAME}" \
  --dry-run=client \
  --from-literal cloudflare_api_token="${CLOUDFLARE_API_TOKEN}" \
  --output json |
  kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=default \
      |
  tee "${SECRET_NAME}".yaml

kubectl create \
  --filename "${SECRET_NAME}".yaml

# kubectl get secret ${SECRET_NAME} \
#     --output yaml

# kubeseal --fetch-cert

exit 0
