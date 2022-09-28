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
#creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

#using this elastic ip internet will be shared to nat
resource "aws_eip" "ngw" {
  vpc = true

}
#creating nat gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = module.subnets["public"].out[0].id

  tags = {
    Name = "gw NAT"
  }

}


#creating table
resource "aws_route_table" "route_table" {
  for_each = var.subnets
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${each.value["name"]}-rt"
  }
}

#prints all route tables public,apps,db
# output "out" {
#   value = aws_route_table.route_table
  
# }

#print route table id
#output "out" {
#  value = aws_route_table.route_table["public"].id
#
#}

#attaching routes to route table
resource "aws_route" "public" {
    #since it is a list hence so
    route_table_id          = aws_route_table.route_table["public"].id
    destination_cidr_block  = "0.0.0.0/0"
    #it should go through internet gateway
    gateway_id              = aws_internet_gateway.igw.id
 
}
#attaching route tables to public subnets
resource "aws_route_table_association" "public" {
  count      = length(module.subnets["public"].out[*].id)
  subnet_id      = element(module.subnets["public"].out[*].id, count.index)
  route_table_id = aws_route_table.route_table["public"].id
}

resource "aws_route_table_association" "apps" {
  count      = length(module.subnets["apps"].out[*].id)
  subnet_id      = element(module.subnets["apps"].out[*].id, count.index)
  route_table_id = aws_route_table.route_table["apps"].id
}

resource "aws_route_table_association" "db" {
  count      = length(module.subnets["db"].out[*].id)
  subnet_id      = element(module.subnets["db"].out[*].id, count.index)
  route_table_id = aws_route_table.route_table["db"].id
}


resource "aws_route" "apps" {
  #since it is a list hence so
  route_table_id          = aws_route_table.route_table["apps"].id
  destination_cidr_block  = "0.0.0.0/0"
  #it should go through internet gateway
  nat_gateway_id              = aws_nat_gateway.ngw.id

}

resource "aws_route" "db" {
  #since it is a list hence so
  route_table_id          = aws_route_table.route_table["db"].id
  destination_cidr_block  = "0.0.0.0/0"
  #it should go through internet gateway
  nat_gateway_id              = aws_nat_gateway.ngw.id

}

resource "aws_vpc_peering_connection" "peering-to-default-vpc" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc_id
  auto_accept   = true

}

#adding route tables to peering connection
resource "aws_route" "peering" {
  for_each = var.subnets
  route_table_id          = aws_route_table.route_table["${each.value["name"]}"].id
  destination_cidr_block  = "0.0.0.0/0"
  #it should go through internet gateway
  vpc_peering_connection_id        = aws_vpc_peering_connection.peering-to-default-vpc.id

}




# resource "aws_route" "private-apps" {
#     for_each                = var.subnets
#     route_table_id          = aws_route_table.route_table["apps"].id
#     destination_cidr_block  = "0.0.0.0/0"
#     gateway_id              = aws_internet_gateway.igw.id
#
# }
#
#
#
# resource "aws_route" "private-db" {
#     for_each                = var.subnets
#     route_table_id          = aws_route_table.route_table["db"].id
#     destination_cidr_block  = "0.0.0.0/0"
#     gateway_id              = aws_internet_gateway.igw.id
#
# }





# output "out" {
#     value = aws_route_table.route_table["public"].id
  
# }

# output "out" {
#     value = module.subnets
#
# }

output "out" {
  value = module.subnets["public"].out[*].id

}



