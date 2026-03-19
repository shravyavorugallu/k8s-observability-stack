#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=monitoring
RELEASE=kube-prom-stack

echo "==> Creating namespace ${NAMESPACE}"
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

echo "==> Adding Prometheus community Helm repo"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "==> Deploying kube-prometheus-stack"
helm upgrade --install ${RELEASE} prometheus-community/kube-prometheus-stack \
  --namespace ${NAMESPACE} \
  --values helm/values-prometheus.yaml \
  --set grafana.adminPassword="${GRAFANA_ADMIN_PASSWORD:-changeme}" \
  --wait --timeout 10m

echo "==> Applying custom alert rules"
kubectl apply -f alerts/ -n ${NAMESPACE}

echo "==> Stack deployed. Access Grafana:"
echo "    kubectl port-forward svc/${RELEASE}-grafana 3000:80 -n ${NAMESPACE}"
