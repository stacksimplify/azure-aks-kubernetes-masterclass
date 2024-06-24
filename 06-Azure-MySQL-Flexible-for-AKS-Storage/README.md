# User Azure Database for MySQL Flexible for AKS Workloads

## Step-01: Introduction
- What are the problems with MySQL Pod & Azure Disks? 
- How we are going to solve them using Azure Database for MySQL Flexible?

## Step-02: Create Azure Database for MySQL flexible servers
- Go to Service **Azure Database for MySQL flexible servers**
- Click on **Create** -> Flexible Server
- **Basics**
- **Project details**
  - Subscription: SUBSCRIPTION-NAME
  - Resource Group: aks-rg1
- **Server Details**
  - Server name: akswebappdb201 (This name is based on availability - in your case it might be something else)
  - Region: (US) East US
  - MySQL Version: 8.0 (default)
  - Workload type: For development or hobby projects
  - **Compute + Storage:** Leave to defaults
  - Availability Zone: No prederence
- **High availability** 
  - leave to defaults (NO HA)  
- **Authentication**     
  - Authentication method: mysql authentication only
  - Admin username: dbadmin
  - Password: Redhat1449
  - Confirm password: Redhat1449
  - Click on **Next Networking**
- **Network connectivity**
  - Connectivity method: Public access (allowed IP addresses) and Private endpoint
  - Public access: CHECKED
  - Firewall rules: 
    - Allow public access from any Azure service within Azure to this server: CHECKED
  - Private endpoint: DONT DEFINE 
  - Click on **Next Security**
- **Security**
  - Leave to defaults        
- **Tags**
  - Leave to defaults        
- **Review + Create**  
- It will take close to 15 minutes to create the database. 

## Step-03: Update Security Settings for Database
- Go to **Azure Database for MySQL flexible servers** -> **akswebappdb201**
- **Settings -> Server Parameters**
  - Change **require_secure_transport: OFF**
  - Click on **Save**
- It will take close to 5 to 10 minutes for changes to take place. 


## Step-04:  Connect to Azure MySQL Database 
### Step-04-01: Using Azure Cloud Shell
- As we enabled the setting **Allow public access from any Azure service within Azure to this server** in `Networking Tab` it does the below. 
- This option configures the firewall to allow connections from IP addresses allocated to any Azure service or asset, including connections from the subscriptions of other customers.
- Go to Azure Database for MySQL flexible servers** -> akswebappdb201 -> Settings -> **Connect**
```t
# DB Connect Command
mysql -h akswebappdb201.mysql.database.azure.com -u dbadmin -p

mysql> show schemas;
mysql> create database webappdb;
mysql> show schemas;
mysql> exit
```
### Step-04-02: Using kubectl and create usermgmt schema/db
```t
# Template
kubectl run -it --rm --image=mysql:8.0 --restart=Never mysql-client -- mysql -h <AZURE-MYSQ-DB-HOSTNAME> -u <USER_NAME> -p<PASSWORD>

# Replace Host Name of Azure MySQL Database and Username and Password
kubectl run -it --rm --image=mysql:8.0 --restart=Never mysql-client -- mysql -h akswebappdb201.mysql.database.azure.com -u dbadmin -pRedhat1449

mysql> show schemas;
mysql> create database webappdb;
mysql> show schemas;
mysql> exit
```

## Step-05: Update Kubernetes Manifests
### Step-05-01: Create Kubernetes externalName service Manifest and Deploy
- Create mysql externalName Service
- **01-MySQL-externalName-Service.yml**
```yml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: ExternalName
  externalName: akswebappdb201.mysql.database.azure.com
```

### Step-05-02: In User Management WebApp deployment file change username from `root` to 
`dbadmin`
- **02-UserMgmtWebApp-Deployment.yml**
```yml
# Change From
          - name: DB_USERNAME
            value: "root"
          - name: DB_PASSWORD
            value: "dbpassword11"               

# Change To dbadmin
            - name: DB_USERNAME
              value: "dbadmin"            
            - name: DB_PASSWORD
              value: "Redhat1449"                              
```

## Step-06: Deploy User Management WebApp and Test
```t
# Deploy all Manifests
kubectl apply -f kube-manifests/

# List Pods
kubectl get pods

# Stream pod logs to verify DB Connection is successful from SpringBoot Application
kubectl logs -f <pod-name>
```
## Step-07: Access Application
```t
# Get Public IP
kubectl get svc

# Access Application
http://<External-IP-from-get-service-output>
Username: admin101
Password: password101
```

## Step-08: Clean Up 
```t
# Delete all Objects created
kubectl delete -f kube-manifests/

# Verify current Kubernetes Objects
kubectl get all

# Delete Azure MySQL Database
- Go to Azure Database for MySQL flexible servers -> akswebappdb201 -> Delete
```
