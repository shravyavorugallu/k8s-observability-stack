#!/usr/bin/env bash
# Quick health check for the observability stack
set -euo pipefail
NS=monitoring

echo "=== Prometheus ==="
kubectl get pods -n $NS -l app.kubernetes.io/name=prometheus

echo "=== Alertmanager ==="
kubectl get pods -n $NS -l app.kubernetes.io/name=alertmanager

echo "=== Grafana ==="
kubectl get pods -n $NS -l app.kubernetes.io/name=grafana

echo "=== Active alerts ==="
kubectl exec -n $NS deploy/kube-prom-stack-kube-prome-prometheus -- \
  wget -qO- http://localhost:9090/api/v1/alerts | python3 -m json.tool | grep -A3 '"state": "firing"' || echo "No firing alerts"
