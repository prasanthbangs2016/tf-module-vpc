resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    tags = {
        Name = "${var.env}-vpc"
    }
  
}

module "subnets" {
    for_each = var.subnets
    source = "./subnets"
    name    = each.value["name"]
    subnets = each.value["subnet_cidr"]
    vpc_id  = aws_vpc.main.id
    AZ      = var.AZ
    #if ngw/igw is there it will pick else it will not pick
    ngw     = try(each.value["ngw"], false)
    igw     = try(each.value["ngw"], false)
    env     = var.env
    #sending internet gateway public subnet
    #igw_id  = aws_internet_gateway.igw.id
    #route_table = aws_route_table.route_table
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}


resource "aws_route_table" "route_table" {
  for_each = var.subnets
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${each.value["name"]}-rt"
  }
}

resource "aws_route_table" "public" {
    for_each = var.subnets
    #route_table_id      
    vpc_id = aws_vpc.main.id
    tags = {
        Name    = "${each.value["name"]}-rt"
    }
}


output "out" {
    value = aws_route_table.route_table["public"].id
  
}