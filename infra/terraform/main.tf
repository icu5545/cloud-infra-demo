terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_elastic_beanstalk_application" "default" {
  name = var.app_name
  description = "Cloud infrastructure demo deployment"
}

resource "aws_elastic_beanstalk_environment" "default" {
  name                = format("%s-%s", var.app_name, "env")
  application         = aws_elastic_beanstalk_application.default.name
  solution_stack_name = var.solution_stack_name
  tier                = var.tier

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 1
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = format("%s-%s", var.app_name, "deployer-key")
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = format("%s-%s", var.app_name, "deployer-key")
  public_key = var.deployer_public_key
}



data "aws_instance" "ec2_instance" {
  filter {
    name = "tag:elasticbeanstalk:environment-id"
    values = [ "${aws_elastic_beanstalk_environment.default.id}" ]
  }
  filter {
    name = "instance-state-name"
    values = [ "running" ]
  }
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${sort(data.aws_instance.ec2_instance.vpc_security_group_ids)[0]}"
}