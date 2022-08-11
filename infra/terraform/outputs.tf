output "public_uri" {
    description = "Publicly accessible Web access"
    value = "${aws_elastic_beanstalk_environment.default.cname}"
}

output "ec2_ssh" {
    description = "EC2 SSH access URL"
    value = "${data.aws_instance.ec2_instance.public_dns}"
}

output "ec2_instance" {
    value = "${data.aws_instance.ec2_instance.*}"
}