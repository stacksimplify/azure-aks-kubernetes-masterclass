# Terraform - AKS Cluster

## Step-00: Pre-requisite Note
- Please do this exercise only from Azure Cloud Shell
- I have seen multiple issues with local desktop compatability issues terraform, azure-cli and python.

## Step-01: Introduction

## Step-02: Install VS Code Extension
- https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform

## Step-03: Terraform - Authenticate via Azure service principal
- **Contributor Role**

```
# List Subscriptions
az account list --output table

# Create Azure Service Principal 
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription_id>"

# Replace Subscription Id
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/82808767-144c-4c66-a320-b30791668b0a"
```

- **Output**
```json
{
  "appId": "7f8d687c-c360-4c5c-93d9-12e88e8b9651",
  "displayName": "azure-cli-2020-08-14-10-07-12",
  "name": "http://azure-cli-2020-08-14-10-07-12",
  "password": "9BXkQvVx.7VidBpOwz0L01EyZdT.-e6Zop",
  "tenant": "c81f465b-99f9-42d3-a169-8082d61c677a"
}
```
- **Login**
```
# Template
az login --service-principal -u <service_principal_name> -p "<service_principal_password>" --tenant "<service_principal_tenant>"

# Replace Values
az login --service-principal -u http://azure-cli-2020-08-14-10-07-12 -p "9BXkQvVx.7VidBpOwz0L01EyZdT.-e6Zop" --tenant "c81f465b-99f9-42d3-a169-8082d61c677a"
```

## Step-04: Create SSH Key
```
echo $HOME
mkdir $HOME/aks-ssh
ssh-keygen -m PEM -t rsa -b 4096 -f $HOME/aks-ssh/id_rsa
ls $HOME/aks-ssh
```

## Step-05: Create Terraform files and Review them
- main.tf
- k8s.tf
- variables.tf
- output.tf


## Step-06: Terraform Backend Setup: Create tfstate Storage Container
```
# Make a Note of Cloud Shell Storage Account Name
- Cloud Shell Storage Account Name: csg100320003f4363d9

# Cloud Shell Storage Account Access Key
Key1: /6Edyyngp105nbFUQnK4AJNb0C177YVENlnysLkjQuz6csD2cO3UzP1CN7nWUoD5i4bEHrs9Rb4dUlqhvrOZew==

# Create a Container in Azure Cloud Shell Storage Account
az storage container create -n tfstate --account-name <YourAzureStorageAccountName> --account-key <YourAzureStorageAccountKey>

# Replace Values
az storage container create -n tfstate --account-name csg100320003f4363d9 --account-key "/6Edyyngp105nbFUQnK4AJNb0C177YVENlnysLkjQuz6csD2cO3UzP1CN7nWUoD5i4bEHrs9Rb4dUlqhvrOZew=="

# View Container
Go to Storage Accounts -> Cloud Shell Storage Account csg100320003f4363d9 -> Storage Explorer
Click on BLOB CONTAINERS
We should see a container with name "tfstate"
```

## Step-07: Create Kubernetes Cluster - Initialize Terraform
```
# Template
terraform init -backend-config="storage_account_name=<YourAzureStorageAccountName>" -backend-config="container_name=tfstate" -backend-config="access_key=<YourStorageAccountAccessKey>" -backend-config="key=codelab.microsoft.tfstate"

# Replace Values
terraform init -backend-config="storage_account_name=csg100320003f4363d9" -backend-config="container_name=tfstate" -backend-config="access_key=/6Edyyngp105nbFUQnK4AJNb0C177YVENlnysLkjQuz6csD2cO3UzP1CN7nWUoD5i4bEHrs9Rb4dUlqhvrOZew==" -backend-config="key=codelab.microsoft.tfstate"
```

## Step-08: Export Service Principal 
```
# Template
export TF_VAR_client_id=<service-principal-appid>
export TF_VAR_client_secret=<service-principal-password>

# Replace Values
export TF_VAR_client_id="7f8d687c-c360-4c5c-93d9-12e88e8b9651"
export TF_VAR_client_secret="9BXkQvVx.7VidBpOwz0L01EyZdT.-e6Zop"

```

## Step-08: Run Terraform plan
```
terraform plan -out out.plan
```

## Step-09: Run terraform apply
```
terraform apply out.plan

```
## Step-10: Verify Cluster
```
```


## Step-11: Run terraform destroy to Clean-Up
```
terraform destroy

```

## References
- Configure Terraform: https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell
- Azure AKS Terraform: https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
- Azure CLI - Create Service Principal: https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest
- Terraform AKS: https://learn.hashicorp.com/tutorials/terraform/aks?in=terraform/kubernetes