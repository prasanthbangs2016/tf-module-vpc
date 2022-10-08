#creating route table  without routes and association of subnets

resource "aws_route_table" "route-tables" {
  #how many route tables(ans"3") hence for each
  vpc_id = var.vpc_id

  tags = {
    Name = "Roboshop-${var.name}-rt"
  }
}

#resource "aws_route_table_association" "assoc" {
#  count = length(module.subnets["public"].out[*].id)
#  subnet_id      = element(module.subnets["public"].out[*].id, count.index )
#  route_table_id = aws_route_table.route-tables["public"].id
#}