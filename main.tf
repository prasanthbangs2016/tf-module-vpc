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
  #adding igw to subnets bcz public subnets should hv then we call public subnet
 #igw_id    = aws_internet_gateway.igw.id
#  route_tables  = aws_route_table.route-tables.*.id

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-${var.env}-igw"
  }
}

#creating route table

resource "aws_route_table" "route-tables" {
  #how many route tables(ans"3") hence for each
  for_each = var.subnets
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Roboshop-${each.value["name"]}-rt"
  }
}

output "out" {
  value = module.subnets["public"].out[*].id
}

#creating rout table , taking subnets and adding route table to subnets

resource "aws_route" "public" {
  route_table_id            = aws_route_table.route-tables["public"].id
  destination_cidr_block    = "0.0.0.0/0"
  #going through igw hence gateway_id
  gateway_id = aws_internet_gateway.igw.id
}

#resource "aws_route" "public" {
#  route_table_id            = aws_route_table.route-tables["public"].id
#  destination_cidr_block    = "0.0.0.0/0"
#  #going through igw hence gateway_id
#  gateway_id = aws_internet_gateway.igw.id
#}

#resource "aws_route" "public" {
#  route_table_id            = aws_route_table.route-tables["public"].id
#  destination_cidr_block    = "0.0.0.0/0"
#  #going through igw hence gateway_id
#  gateway_id = aws_internet_gateway.igw.id
#}



