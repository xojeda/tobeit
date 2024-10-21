## Once we've completed successfully the installation.

# Create a new namespace to host resources for this test.
kubectl create namespace tobeit

# Set to be it as default namespace since we will be working in this namespace.
kubectl config set-context --current --namespace=tobeit

# We will configure grafana to use a Persistent Volume to prevent data loss if the pod is restarted.
# In the repository we have grafana-pv.yaml and grafana-pvc.yaml to create the persisten volume and the claim.

# Create the directory for te Persistent Volume on the host.
sudo mkdir -p /mnt/data/grafana

# Apply the psersitent volume.
kubectl apply -f grafana-pv.yaml

# Apply the PVC.
kubectl apply -f grafana-pvc.yaml

# Apply the grafana and service yaml to deploy a grafana pod and a service to route the traffic to grafana pod.
kubectl apply -f grafana.yaml

## For this exercise we will expose this grafana deployment to the internet to be able to perform checks.
# We will install nignx package on debian 12 to server as reverse proxy and route internet access reaching port 30120 to our minikube network in order to access grafana portal from the internet.

# Installing pre requisites
sudo apt install curl gnupg2 ca-certificates lsb-release

# Adding nginx repository key.
curl https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

# Nginx repository.
echo "deb http://nginx.org/packages/debian/ $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list

# Update packages
sudo apt update

# Install nginx.
sudo apt install nginx

# Check that the compiled niginx version allows the usage of stream block, some versions of nginx have this feature in the nginx-full package, not the case for debian 12.
nginx -V 2>&1 | grep -- '--with-stream'

# Add stream configuration to the end of the nginx config file.
echo "
stream {
    server {
        listen 31020;
        proxy_pass 192.168.49.2:31020;   
    }
}" >> /etc/nginx/nignx.conf

# Check nginx configuration.
sudo nginx -t

# Desired output.
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

# Restart nignx service and check status.
sudo systemctl restart nginx && sudo systemctl status nginx

# Now we have our grafana container published to the internet and with a persistent volume to persist the configurations.