variable "app_name" {
  default = "cloud-infra-demo"
}
variable "solution_stack_name" {
  type = string
}
variable "tier" {
  type = string
  default = "WebServer"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "deployer_public_key" {
    type = string
    sensitive = true
}