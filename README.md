# Requirements
- CLI Tools
  - Terraform
- Accounts
  - Amazon AWS
  - Google Cloud
  - Github


# Deployment overview
Steps for deployment:
1. [Account Setup](#account-setup)
1. [Environment Setup](#local-environment-setup)
1. [Infrastructure Deployment](#infrastructure-deployment)
1. [GitHub Configuration](#github-automated-deployment-configuration)
1. [Build and Deploy](#build-and-deploy-the-application)
1. [Cleanup](#cleanup)


# Account Setup
## Amazon AWS
A valid Amazon AWS account is required.

Amazon AWS is the platform on which the built application image will be hosted.

### Create Administrative User Account
A user account is necessary to access AWS via Terraform.

The following instructions will result in a user with full administrative privileges against the AWS account and should be used as an example. Further limiting permissions is recommended depending on the intended usage of the user.

1. Login to AWS as the account administrator
2. Navigate to Services > Security, Identity, & Compliance > IAM
3. Navigate to Access management > Users
4. Click the `Add users` button
5. Configure the user information:
  1. Set the user name to an appropriate value
  2. Set the `Select AWS Credential Type` field value to `Access key - Programmatic access`
6. Click the `Next: Permissions` button
7. Select the `Attach existing policies directly` box
8. Select the `AdministratorAccess` policy
9. Click the `Next: Tags` button
10. Click the `Next: Review` button
11. Click the `Create user` button
12. Note the `Access key ID` value and store it in a secure location. See [Environment Variables](#environment-variables).
13. Click the `Show` link in the `Secret access key` column
14. Note the `Secret access key` value and store it in a secure location. See [Environment Variables](#environment-variables).

## Google Cloud
A valid Google Cloud account is required.

Google Cloud will host the Kubernetes cluster upon which the application is run and made available.

### Create a Project
The default project can be used. Take note of the `Project Number` and `Project ID` values for the target project.

#### Identifying the Project Number and Project ID
1. Navigate to `Cloud overview` > `Dashboard`
2. Ensure the appropriate project is selected by using the context bar across the top of the screen
3. Look in the `Project info` section of the page for the `Project number` and `Project ID` values

### Enable APIs
#### Compute Engine API
1. Navigate to `APIs & Services` > `Enabled APIs & services`
2. Click the `ENABLE APIS & SERVICES` button
3. Search for and select the `Compute Engine API`
4. If `Enable` is a button on the resultant page, click the `Enable` button
  - If `Manage` is a button on the resultant page, the API is already enabled

#### Kubernetes Engine API
1. Navigate to `APIs & Services` > `Enabled APIs & services`
2. Click the `ENABLE APIS & SERVICES` button
3. Search for and select the `Kubernetes Engine API`
4. If `Enable` is a button on the resultant page, click the `Enable` button
  - If `Manage` is a button on the resultant page, the API is already enabled


### Obtain the Service Account Key
The service account key is used to create Google Cloud resources.

1. Navigate to `IAM & Admin` > `Service Accounts`
2. Open the context-menu icon (three vertical dots under the `Actions` column) for the row of the default Compute Engine Service Account
  - This can be identified by the name format: `<project-number>-compute@developer.gserviceaccount.com`
3. Select `Manage Keys`
4. Click `ADD KEY` > `Create new key`
5. Select `JSON` as the key type
6. Click `Create`
7. When prompted, save key file to the root folder of this project with the name `gke-credential.json`


## Github
A valid GitHub account is required.

GitHub will be the platform on which the codebase is stored and automated deployment executed.

A GitHub repository must be created and configured as the target repository for this codebase in order to use these automated features.

# Local Environment Setup
## Environment variables
The following environment variables are used during deployment and should be configured as described:

| Variable Name | Description |
|---------------|-------------|
| AWS_ACCESS_KEY_ID | The Access Key ID for the AWS administrative user used to create AWS resources. |
| AWS_SECRET_ACCESS_KEY | The Secret Access Key (password) for the AWS administrative user corresponding with the AWS_ACCESS_KEY_ID environment variable |

## Terraform deployment values
Update the following variables in the `infra/terraform/terraform.tfvars` file:

- gke_project_number
  - Set this value to match the [target Project Number](#Identifying-the-Project-Number-and-Project-ID)
- gke_project_id
  - Set this value to match the [target Project ID](#Identifying-the-Project-Number-and-Project-ID)
- gke_region
  - Configure this to match the target deployment region in GKE
  - Defaults to `us-east1`
- gke_cluster_name
  - Set this to the name of the cluster to be created or updated.
  - Defaults to `test-cluster`

# Infrastructure Deployment
## Terraform Initialization
In order to generate the deployment, the Terraform implementation must be initialized against the Terraform configuration in this code base.

1. Navigate to `infra/terraform`
2. Execute `terraform init`

## Terraform Deployment
The following commands will result in automatically generating the application deployment infrastructure with no chance for review. Review the Terraform documentation for instructions regarding reviewing and applying changes.

1. Navigate to `infra/terraform`
2. Execute `terraform apply -auto-approve`

## Retain Output Data
Once complete, Terraform will provide necessary information about the generated AWS and Google cloud environments.

Note the following values and store them in a secure location:

| Output Key | Description / Usage |
|------------|---------------------|
| registry_url | The URL of the AWS image repository to which the built image should be stored once built. |
| aws_access_key_id | The Access Key ID value representing the generated service account to be used when pushing the built application image to the AWS image repository. |
| aws_secret_acccess_key | The Secret Access Key value representing the password for the generated service account to be used when pushing the built application image to the AWS image repository.<br/><span style="color:red">NOTE: This is a sensitive value!</span> |
| gke_cluster_name | The name of the GKE cluster generated in the Google Cloud environment. This should match value of the `gke_cluster_name` variable if defined in the `terraform.tfvars` file. |
| gke_cluster_host | The hostname of the GKE cluster for use when deploying the application. |

# GitHub Automated Deployment Configuration
GitHub's GitHub Actions are leveraged to automate application builds and deployment. In order to leverage this functionality, modifications must be made to the local GitHub Workflow definition file and the GitHub repository's stored "Action" secrets.

## GitHub Workflow File
The GitHub workflow configuration file located at `.github/workflows/ci.yml` must be updated with the appropriate AWS region, AWS image registry URL, and Google Cloud cluster name. Note that the Google Cloud location must be set to `us-east1` due to current limitations of the Google Cloud platform.

| Pseudo YAML Key | Value |
| -------- | ---------------------- |
| jobs.Build-And-Push-Image.steps."Configure AWS Credentials".with.aws-region | AWS Region |
| jobs.Build-And-Push-Image.steps."Login to Public ECR".with.registry | Hostname from the Terraform output `registry_url` value |
| jobs.Build-And-Push-Image.steps."Build and Push".with.tags | Terraform output `registry_url` value with an appended image tag.<br/>E.g. public.ecr.aws/abcdefgh/cloud-infra-demo:latest |
| jobs.Build-And-Push-Image.steps."Get Credentials".with.cluster_name | Terraform output `gke_cluster_name` value |

Once modified with the appropriate values, save the file.

## GitHub Action Secrets
Prior to pushing to the GitHub repository, the following secret values must be configured:

| Action Secret Key Name | Value |
| -------- | ---------------------- |
| AWS_ACCESS_KEY_ID | Terraform output `aws_access_key_id` value |
| AWS_SECRET_ACCESS_KEY | Terraform output `aws_secret_acccess_key` value |
| GKE_SA_KEY | Base64-encoded GKE Service Account file |
| GKE_PROJECT_ID | The Google Cloud Project ID | 

For each of the above key names and values:

1. Login to Github and navigate to the target repository
2. Navigate to Settings > Security > Secrets > Actions
3. Click the `New repository secret` button
4. Enter the secret name and value
5. Click `Add secret`


# Build and Deploy the Application
Simply push the codebase to the GitHub repository.


# Cleanup
Navigating to the `infra\terraform` directory and executing `terraform destroy -arg-file="secret.tfvars"` will destroy the AWS infrastucture that was created during deployment.

