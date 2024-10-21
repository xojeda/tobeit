# Once we've deployed the grafana app.
# We will deploy a mysql database to store all the metrics recovered by our sniffer.

# First create a persistent volume for the mysql instance.
# Create the mysql data directory in the host.
sudo mkdir -p /mnt/data/mysql

# Create the persistent volume claim.
kubectl apply -f mysql-pv.yaml

# Create the persistent volume claim.
kubectl apply -f mysql-pvc.yaml

# Create the mysql deployment and service.
kubectl apply -f mysql.yaml

# Once the service and the deployment are on check that there is no issues with the pod.
kubcetl get logs <pod>

kubectl describe <pod>

# Since we've configured the service as node port to be able to access mysql from the host we can test the access with.

# To get the minikube ip.
minikube ip

nc -v <minikube ip> <port>

# Desired output.

(UNKNOWN) [192.168.49.2] 30006 (?) open

# We can now connect to the mysql instance and change the root password.

## Configure user to store the data acquired.

# Accessing mysql with a client in a pod or in the node.
CREATE USER 'monitor'@'%' IDENTIFIED BY 'Your pass.';

GRANT SELECT ON tobeit.* to 'monitor'@'%';
GRANT INSERT ON tobeit.* to 'monitor'@'%';

FLUSH PRIVILEGES;

# Create table to store data.
create table monitor_data (name varchar(255), step_name varchar(255), step_status varchar(255), curr_time varchar(255));

# Create the datasource in grafana and test the connection.