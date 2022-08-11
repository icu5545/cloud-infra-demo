# Requirements
- JDK 11
- Terraform
- Amazon AWS Account
- SSH
- SCP


# Environment Setup
## Java
### Ensure JAVA_HOME is set to a JDK 11 installation
The application is intended to be built using Java 11. Please, ensure the `JAVA_HOME` environment variable is set appropriately prior to building or running the application locally.


## Terraform
### Ensure the Terraform CLI application is installed
Please refer to the Terraform documentation for instructions on downloading and installing and configuring the Terraform executable.


## Amazon AWS
### Ensure AWS is accessible via the command line
The terraform installation script requires the ability to login to the Amazon AWS service. This is currently accomplished by logging into the AWS server via the AWS CLI application.

```shell
aws configure
```


### Security Role Gotcha
Need to discuss how to create the Security Role that kept causing problems...


## SSH Key
An SSH Key Pair is necessary to deploy the application to AWS. The public key is also used during infrastructure deployment.

For the purposes of this application, it is expected that the public certificate and private key files exist in the root directory, alongside the `buildAndDeploy.bat` script. The should have the filenames `id_rsa.pub` and `id_rsa` respectively.

### SSH Key Generation
A key pair can be created using the `ssh-keygen` command. Default options are acceptable for the purposes of deploying this application.

```shell
ssh-keygen
# When prompted for a location, enter the root directory of this application application (where the buildAndDeploy.bat script exists)
```



# Application build and deployment
The application has been tested locally and is not intended to be modified. This ensures the central build and deployment script works as intended.

Navigate to the root directory and run the `buildAndDeploy.bat` script. This script will compile, run unit tests against, and package the application into a JAR file, configure the AWS infrastructure, deploy the application over SCP, and launch the application over SSH.

The script will not exit immediately. Using `ctrl + c` will allow breaking away from the script after the application launched without bringing the application down.

KNOWN ISSUES:
1. If any step in the process fails, the batch file will not stop execution.



# Cleanup
Navigating to the `infra\terraform` directory and executing `terraform destroy -arg-file="secret.tfvars"` will destroy the AWS infrastucture that was created during deployment.
