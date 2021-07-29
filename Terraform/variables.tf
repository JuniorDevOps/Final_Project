variable "ami_id" {
  default = "ami-0767046d1677be5a0"
}
variable "region" {
  default = "eu-central-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "count_stage" {
  default = 1
}
variable "count_prod" {
  default = 1
}
variable "key_name" {
  default = "MyProdServer"
}
variable "aws_security_group" {
  default = "launch-wizard-7"
}
