#creating route table  without routes and association of subnets

resource "aws_route_table" "route-tables" {
  #how many route tables(ans"3") hence for each
  vpc_id = var.vpc_id

  tags = {
    Name = "Roboshop-${var.name}-rt"
  }
}

#route tables association to subnets (public/apps/db)
resource "aws_route_table_association" "assoc" {
  #getting list of subnets with name(public,apps,db)
  count = length(var.subnet_ids[var.name].out[*].id)
  subnet_id      = element(var.subnet_ids[var.name].out[*].id, count.index )
  route_table_id = aws_route_table.route-tables.id
}

#write logic content to output file
resource "local_file" "foo" {
  #content  = length(var.subnet_ids["${var.name}"].out[*].id)
  content  = length(var.subnet_ids[var.name].out[*].id)
  filename = "/tmp/out"
}

#creating route for public subnets
resource "aws_route" "public" {
  #if var.name =public =1
  count                    = var.igw  ? 1 : 0
  route_table_id            = aws_route_table.route-tables.id
  destination_cidr_block    = "0.0.0.0/0"
  #going through igw hence gateway_id
  gateway_id = var.gateway_id
}

#creating route for private subnets(apps and db)
resource "aws_route" "private" {
  #if var.name =public =1
  #count                    = var.ngw == "public" ? 1 : 0
  count                    = var.ngw ? 1 : 0
  route_table_id            = aws_route_table.route-tables.id
  destination_cidr_block    = "0.0.0.0/0"
  #going through igw hence gateway_id
  nat_gateway_id = var.nat_gateway_id
}

resource "aws_route" "peering-route" {
  #getting and adding 3 route tables
  route_table_id            = aws_route_table.route-tables.id
  destination_cidr_block    = var.default_vpc_cidr
  #going through igw hence nat gateway_id
  vpc_peering_connection_id = var.vpc_peering_connection_id

}


