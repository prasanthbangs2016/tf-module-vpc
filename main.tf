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
  value = aws_route_table.route-tables
}

#adding route to route table

#resource "aws_route" "public" {
#  for_each = var.subnets
#  route_table_id            = each.value[]
#  destination_cidr_block    = "10.0.1.0/22"
#  vpc_peering_connection_id = "pcx-45ff3dc1"
#  depends_on                = [aws_route_table.testing]
#}

