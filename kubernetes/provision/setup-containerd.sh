#!/bin/sh
set -e

CONTAINERD_VERSION=${CONTAINERD_VERSION:-"1.5.7"}
RUNC_VERSION=${RUNC_VERSION:-"1.0.2"}

echo " -> installing containerd ${CONTAINERD_VERSION}"
curl -sSL https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz -o /tmp/containerd.tar.gz
curl -sSL https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64 -o /usr/local/bin/runc
chmod +x /usr/local/bin/runc

tar zxf /tmp/containerd.tar.gz -C /usr/local

cat <<EOF>/etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=infinity
# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable containerd
systemctl start containerd
