# Kentik Convis Demo
This repo contains supporting scripts for Convis visualization.



# Windows Setup
Make sure Virtualization Technology is enabled in BIOS and Virtual Machine Platform and Windows Subsystem for Linux is enabled in Turn Windows features on and off to make it work. Then reboot your system.

Note: To make it work you need to have Windows 10 version 1903 or higher

### Install WSL2
Open the windows powershell administrator mode and run `wsl -l -o` and you will get the name of all the available distros

Now type `wsl --install` to install WSL and reboot your system

Note: If you already have WSL installed then type `wsl --set-default-version 2` to convert it to WSL2. And by default WSL uses the ubuntu distro which we will be using in this demo

### Install Distro
After restart open Microsoft Store and then download and install Ubuntu.
Then open it from the start menu after installation and a Ubuntu terminal will pop up saying `Installing, this may take a few seconds`. Wait until the installation is done and it may take a bit of time.

Then in windows powershell administrator mode type `wsl --status`

Then it should show:
```
Default Distribution: Ubuntu
Default Version: 2
```

WSL2 is now installed in your system

### Install Docker Desktop
Download docker desktop from [here](https://docs.docker.com/desktop/windows/install/) and set it up on your local system

Now in Docker Desktop go to `Setting > General > Use the WSL 2 based engine` and `Resources > WSL Integration > Enable integration with my default WSL distro` and check the boxes if unchecked

### Enable Kubernetes
In Docker Desktop go to `Kubernetes > Enable Kubernetes` and enable kubernetes


Now `cd` into `kubernetes` in the cloned repo and follow on from [Deployment](#Deployment)



# Demo
To run the demo, use the following.  In the examples we use a VM to ensure we have a kernel with proper functionality.  If
you are running on an existing Kubernetes cluster, skip to [Deployment](#Deployment)

# Lima VM
[Lima](https://github.com/lima-vm/lima) is an application for managing Linux VMs.  Ensure you have it installed before proceeding.

Start the VM:

You can use the defaults or adjust the yaml before launching.  It is recommended to have at least 4G of ram to run the demo.

```bash
limactl start ./lima/labs.yaml
```

To monitor the provisioning process use the following:

```bash
tail -f $HOME/.lima/labs/serial.log
```

You should see the instance booting and being configured.  Once you see the following the instance should be ready to use:

```bash
[  OK  ] Finished Execute cloud user/final scripts.
```

If the above is successful, you should have a fully working Kubernetes development environment ready.

Enter the VM and test that everything is running properly:

```bash
limactl shell labs
```

Test that Kubernetes is ready:

```bash
kubectl get nodes
```

This should return something like the following:

```bash
NAME        STATUS     ROLES                  AGE   VERSION
lima-labs   Ready      control-plane,master   59s   v1.22.2
```
Note: ensure that the status is `Ready` before continuing.

# Deployment
To deploy the Kentik Convis stack, run the following:

```bash
kubectl apply -f stack/
```

This will create several Kubernetes resources:

```
namespace/kentik unchanged
configmap/grafana-dashboard-kentik unchanged
namespace/kentiklabs unchanged
configmap/prometheus-config unchanged
configmap/prometheus-rules created
configmap/grafana-dashboard-config created
configmap/grafana-datasource created
clusterrole.rbac.authorization.k8s.io/kentiklabs-api-role created
clusterrolebinding.rbac.authorization.k8s.io/kentiklabs-rolebinding created
deployment.apps/prometheus created
deployment.apps/grafana created
deployment.apps/geoip created
daemonset.apps/convis created
service/grafana created
service/prometheus created
service/geoip created
```

To check the status of the deployment:

```bash
kubectl -n kentiklabs get pods
```

Once all pods are in the `Running` status, continue:

```
NAME                          READY   STATUS    RESTARTS   AGE
convis-6k5xh                  1/1     Running   0          3m29s
geoip-5b88cc4fc9-29nl5        1/1     Running   0          2s
grafana-8c6f5cf8-nzszg        1/1     Running   0          3m29s
prometheus-774ddbb698-2nx5q   2/2     Running   0          3m29s
```

# Test Data
In order to populate the graphs with some real data, we can launch some example apps:

```bash
kubectl apply -f apps/tor/tor.yaml
```

# Grafana
Once all pods are in the `Running` status we can use `port-forward` to expose the service:

```bash
kubectl -n kentiklabs port-forward service/grafana 8080:3000
```

You should now be able to open http://localhost:8080 and see Grafana.  The default username and password is `admin` / `labs`.

