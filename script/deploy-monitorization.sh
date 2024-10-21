## First create and test our Python script.
## Create the docker file to build our custom python image with the required dependecies.

# Build the image.
# Set the enviroment.
eval $(minikube docker-env)
# Build the image
docker build -t python-parsejson:latest .

# Apply the parse json cron job.
kubectl apply -f parsejson.yaml

# Check that the cronjob is succesfully created.
kubectl get cronjobs

# Desired output.
NAME            SCHEDULE      TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
parsejson-job   */5 * * * *   <none>     False     0        4m21s           49m

# Check that the cronjob is creating more jobs
kubectl get jobs

# Desired output
NAME                     STATUS     COMPLETIONS   DURATION   AGE
parsejson-job-28825190   Complete   1/1           4s         10m
parsejson-job-28825195   Complete   1/1           4s         5m42s
parsejson-job-28825200   Complete   1/1           4s         42s

#Check that the containers are being created and running successfully
kubectl get pods

# Desired output
NAME                           READY   STATUS      RESTARTS   AGE
grafana-6d49b5fcf6-tt8c6       1/1     Running     0          61m
mysql-56b97d75d4-np4q4         1/1     Running     0          60m
parsejson-job-28825190-cqp8f   0/1     Completed   0          11m
parsejson-job-28825195-74w4h   0/1     Completed   0          6m1s
parsejson-job-28825200-28cch   0/1     Completed   0          61s

# Check that data is being iserted into mysql.
# And create a simple table visualization in grafana to view this data.