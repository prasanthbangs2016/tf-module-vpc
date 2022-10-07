resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name  = "Roboshop-${var.env}"
  }
}


module "subnets" {
  #iterating subnets
  for_each = var.subnets
  source = "./subnets"
  #creating name for subnets(app/db/public)
  name  = each.value["name"]
  #passing all the subnets
  subnets = each.value["subnet_cidr"]
  vpc_id   = aws_vpc.main.id
  AZ       = var.AZ
  #false is default value
  ngw       = try(each.value["ngw"], false)
  igw       = try(each.value["igw"], false)
  env = var.env

}



