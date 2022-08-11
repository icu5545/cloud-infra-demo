setlocal 
cd app
call mvnw package
cd ..\
cd infra\terraform
call terraform init
call terraform plan -out tfplan -var-file="secret.tfvars"
call terraform apply -auto-approve "tfplan"
for /F %%A IN ('terraform output ec2_ssh') do ( 
    set SSH_HOST=%%A
)
cd ..\..\
call scp -o StrictHostKeyChecking=no -i "id_rsa" -C app\target\cloud-infra-demo-*.jar ec2-user@%SSH_HOST%:/home/ec2-user/app.jar
call ssh -o StrictHostKeyChecking=no -i "id_rsa" ec2-user@%SSH_HOST% java -jar /home/ec2-user/app.jar