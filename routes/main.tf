resource "aws_route_table" "route-tables" {
  vpc_id         = var.vpc_id
  tags = {
    Name         = "${var.name}-rt"
  }
}