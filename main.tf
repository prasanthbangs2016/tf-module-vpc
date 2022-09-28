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

#creating public route table,and attaching to subnets
resource "aws_route" "public" {
    route_table_id          = aws_route_table.route_table["public"].id
    destination_cidr_block  = "0.0.0.0/0" 
    gateway_id              = aws_internet_gateway.igw.id
 
}


# resource "aws_route" "private-apps" {
#     for_each                = var.subnets
#     route_table_id          = aws_route_table.route_table["public"].id
#     destination_cidr_block  = "0.0.0.0/0" 
#     gateway_id              = aws_internet_gateway.igw.id
 
# }



# resource "aws_route" "private-db" {
#     for_each                = var.subnets
#     route_table_id          = aws_route_table.route_table["public"].id
#     destination_cidr_block  = "0.0.0.0/0" 
#     gateway_id              = aws_internet_gateway.igw.id
 
# }





# output "out" {
#     value = aws_route_table.route_table["public"].id
  
# }

output "out" {
    value = module.subnets
  
}


