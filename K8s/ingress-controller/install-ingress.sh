#! /bin/sh

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm uninstall ingress-nginx --namespace ingress-nginx
helm uninstall cert-manager --namespace default
helm uninstall external-dns --namespace default

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
--namespace ingress-nginx --create-namespace \
--set controller.ingressClassResource.default=true \
--set controller.metrics.enabled=true

kubectl get services --namespace ingress-nginx

helm upgrade --install cert-manager jetstack/cert-manager \
--version v1.10.0 \
--namespace default \
--set installCRDs=true

kubectl get services --namespace ingress-nginx

/bin/sh ./secret.sh

kubectl apply -f clusterissuer-staging.yaml
kubectl apply -f certificate-staging.yaml

helm install external-dns bitnami/external-dns \
--version 6.11.3 \
--namespace default \
--set provider=cloudflare \
--set cloudflare.secretName=cloudflare-secret \
--set cloudflare.proxied=true

exit 0
