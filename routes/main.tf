resource "aws_route_table" "route-tables" {
  vpc_id         = var.vpc_id
  tags = {
    Name         = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "assoc" {
  count = length(var.subnet_ids[var.name].subnet_ids)
  subnet_id = element(tomap(var.subnet_ids[var.name].out[*].id), count.index )
  route_table_id = aws_route_table.route-tables.id
}

#  #attaching route tables to public subnets
#  resource "aws_route_table_association" "assoc" {
#    count      = length(module.subnets["public"].out[*].id)
#    subnet_id      = element(module.subnets["public"].out[*].id, count.index)
#    route_table_id = aws_route_table.route-tables["public"].id
#  }