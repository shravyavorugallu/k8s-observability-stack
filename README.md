# k8s-observability-stack

Production-grade Prometheus + Grafana + Alertmanager stack for Kubernetes compute clusters, deployed via Helm. Includes custom alert rules for cluster nodes (CPU, memory, disk, NFS mounts) and Slack routing.

## Stack

| Component | Purpose |
|---|---|
| **Prometheus** | Metrics collection (30d retention, 100GB) |
| **Grafana** | Dashboards with auto-provisioning |
| **Alertmanager** | Alert routing to Slack (critical/warning channels) |
| **node_exporter** | Per-node CPU, memory, disk, NFS, process metrics |

## Deploy

```bash
# Set your Grafana password
export GRAFANA_ADMIN_PASSWORD=yourpassword

# Deploy full stack
./scripts/deploy.sh

# Access Grafana
kubectl port-forward svc/kube-prom-stack-grafana 3000:80 -n monitoring
# Open http://localhost:3000
```

## Custom alerts included

- `NodeDown` · node unreachable for >2 min · fires critical
- `NodeHighCPU` · CPU >90% for 10 min · fires warning
- `NodeMemoryPressure` · <10% memory available · fires critical
- `NodeDiskFull` · <15% disk on `/scratch`, `/home`, `/apps` · fires warning
- `NodeNFSMountMissing` · NFS filesystem not mounted · fires critical
- `SlurmExporterDown` · job scheduler metrics unavailable · fires critical

## Check health

```bash
./scripts/check-health.sh
```

## Tech
`Kubernetes` · `Helm` · `Prometheus` · `Grafana` · `Alertmanager` · `kube-prometheus-stack` · `PromQL`
