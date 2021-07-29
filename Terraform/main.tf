provider "aws" {
  region          = var.region
}

resource "aws_instance" "stage" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.aws_security_group]
  user_data       = file("servers_data.sh")
  count           = var.count_stage
  tags = {
    Name          = "Stage-${count.index + 1}"
  }
}

resource "aws_instance" "prod" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.aws_security_group]
  user_data       = file("servers_data.sh")
  count           = var.count_prod
  tags = {
    Name          = "Prod-${count.index + 1}"
  }
}

output "stage_tags" {
  value           = aws_instance.stage.*.tags
}
output "stage-ip"   {
  value           = aws_instance.stage.*.public_ip
} 
output "prod_tags"  {
  value           = aws_instance.prod.*.tags
}
output "prod-ip"    {  
  value           = aws_instance.prod.*.public_ip
}
