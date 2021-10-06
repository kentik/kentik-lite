# Provisioning Kubernetes
The following is a quick start guide for creating a single Kubernetes node for development
and test purposes.  For production setups, please refer to the
[official docs](https://kubernetes.io/docs/setup/production-environment/#production-cluster-setup).

# Requirements
The following guide assumes an Ubuntu base operating system.  It has been tested on Ubuntu 20.04
and 21.04.

# Deployment
Assuming a fresh Ubuntu install, you should be able to clone this repository and run the `setup.sh`
script in the [kubernetes](/kubernetes/provision/) directory.  That will install the base packages,
containerd, and kubernetes.  It will also deploy and configure the node as a single kubernetes
master ready for workloads.  For details on each stage, see the corresponding sections below.

# Containerd
The chosen runtime environment for the node is [containerd](https://github.com/containerd/containerd).
The `setup-containerd.sh` script will download the package and configure systemd to run the daemon.

# Kubernetes
The `setup-k8s.sh` script will configure the package manager, download, and install the latest Kubernetes
release.  It will also use `kubeadm` to deploy as well as taint the node to allow execution on the instance.

# Cloud Init User Data
As a convenience, you can use the following in most cloud providers as `user-data` when launching an instance
to have perform the install automatically:

```
#!/bin/sh
apt-get update && apt-get install -y curl unzip
curl -sSL https://github.com/kentik/kentik-lite/archive/refs/heads/main.zip -o /tmp/kentiklabs.zip

cd /root && unzip -d kentiklabs /tmp/kentiklabs.zip
cd setup/*/kubernetes/provision

./setup.sh
```

Once finished, you can use `KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kentiklabs get service/grafana-ext` to get the `NodePort`
for the `grafana-ext` service.  You can then access the instance via the IP and port using the username
and password: `admin` / `labs`.
