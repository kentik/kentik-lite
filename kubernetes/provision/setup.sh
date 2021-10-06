#!/bin/sh
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# check for ubuntu
grep UBUNTU /etc/os-release > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERR: provisioning currently only works on Ubuntu"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "ERR: must be run as root"
   exit 1
fi
# exit on future errors
set -e

# k8s prereqs
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# base packages
apt-get update && apt-get install -y curl

# containerd
$SCRIPT_DIR/setup-containerd.sh

# k8s
$SCRIPT_DIR/setup-k8s.sh
