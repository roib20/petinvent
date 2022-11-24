#!/bin/bash

helm install --create-namespace -n ingress ingress bitnami/nginx-ingress-controller --version 9.3.21 -f my-values.yaml
# helm install --create-namespace -n ingress ingress nginx/nginx-ingress --version 0.15.1

until kubectl get svc -n ingress | grep LoadBalancer | grep -v "pending"
do
  echo Awaiting pending LoadBalancer...
  sleep 5
done
echo -------------------------
echo LoadBalancer external IP:
kubectl -n ingress get svc ingress-nginx-ingress-controller -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
echo
echo -------------------------
