#creating route table

resource "aws_route_table" "route-tables" {
  #how many route tables(ans"3") hence for each
  vpc_id = var.vpc_id

  tags = {
    Name = "Roboshop-${var.name}-rt"
  }
}