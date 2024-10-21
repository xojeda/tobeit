## In this script file we will resume the installation steps for minikube.
# We will be using an debian 12 aws ec2 instance deplolyed with pulumi. 
# these configuratios should serve for any debian 12 installation.


## Pre requisites.
# Once we have a debian 12 with internet access running update and upgrade repository packages.
sudo apt update && sudo apt upgrade -y

# We will be using docker contianerd so we will need to install docker pre-requisites.
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add docker GPG Key.
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add docker container with the stable release for our OS.
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package repositories again and install docker.
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable docker daemon.
sudo systemctl enable docker && sudo systemctl start docker

# Ethier log out and login or run:
newgrp docker
# To change the current group ID in order to use docker.

#Check that docker is successfully installed getting the version.
docker --version

## Minikube installation.

# Download Minikube.
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Install minikube.
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify Minikube installation.
minikube version

## Kubectl installation.

# Download kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make kubectl executable.
chmod +x ./kubectl

# Move Kubectl to the system path to be recognized as a command.
sudo mv ./kubectl /usr/local/bin/kubectl

# Check the version to verify that kubectl is installed.
kubectl version --client

## Start Minikube.

# Start minikube with docker driver.
# Setting verbose level to 7 to check for possible errors.
minikube start --driver=docker -v=7

# Verify the minikube status.
minikube status

# The desired output is.
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

# Check containers runnting.
kubectl get pods -A

# Desired Output.
NAMESPACE     NAME                               READY   STATUS    RESTARTS      AGE
kube-system   coredns-6f6b679f8f-fbzs7           1/1     Running   0             100s
kube-system   etcd-minikube                      1/1     Running   0             105s
kube-system   kube-apiserver-minikube            1/1     Running   0             105s
kube-system   kube-controller-manager-minikube   1/1     Running   0             105s
kube-system   kube-proxy-9lzzz                   1/1     Running   0             100s
kube-system   kube-scheduler-minikube            1/1     Running   0             105s
kube-system   storage-provisioner                1/1     Running   1 (70s ago)   104s