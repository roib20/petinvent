#! /bin/sh

helm repo add nginx-stable https://helm.nginx.com/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm uninstall nginx-ingress--namespace nginx-ingress
helm uninstall cert-manager --namespace default
helm uninstall external-dns --namespace default

helm upgrade --install nginx-ingress nginx-stable/nginx-ingress \
--namespace nginx-ingress --create-namespace \
--set controller.enableCustomResources=true \
--set controller.enableCertManager=true \
--set controller.enableExternalDNS=true \
--set controller.setAsDefaultIngress=true

kubectl get services --namespace nginx-ingress

helm upgrade --install cert-manager jetstack/cert-manager \
--version v1.10.0 \
--namespace default \
--set installCRDs=true

kubectl get services --namespace nginx-ingress

/bin/sh ./secret.sh

kubectl apply -f clusterissuer-staging.yaml
kubectl apply -f certificate.yaml

helm install external-dns bitnami/external-dns \
--version 6.11.3 \
--namespace default \
--set provider=cloudflare \
--set cloudflare.secretName=cloudflare-secret \
--set cloudflare.proxied=true

exit 0
