#creating route table  without routes and association of subnets

resource "aws_route_table" "route-tables" {
  #how many route tables(ans"3") hence for each
  vpc_id = var.vpc_id

  tags = {
    Name = "Roboshop-${var.name}-rt"
  }
}

#resource "aws_route_table_association" "assoc" {
#  #getting list of subnets with name(public,apps,db)
#  count = length(var.subnet_ids[var.name].out[*].id)
#  subnet_id      = element(var.subnet_ids[var.name].out[*].id, count.index )
#  route_table_id = aws_route_table.route-tables.id
#}

resource "local_file" "foo" {
  content  = length(var.subnet_ids["${var.name}"].out[*].id)
  filename = "/tmp/out"
}