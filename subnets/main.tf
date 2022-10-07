resource "aws_subnet" "main" {
  #for_each = var.subnets
  #iterating if list comes of 2 values it creates 2 or if it comes of  value it creates 1 or etc
  count     = length(var.subnets)
  vpc_id     = var.vpc_id
  #cidr_block = each.value["subnet_cidr"] #this is for for each
  #it brings all the subnets cidr
  cidr_block = element(var.subnets, count.index)
  #passing AZ
  availability_zone = var.AZ[count.index]

  tags = {
    Name = "Roboshop-${var.name}-${element(var.AZ, count.index)}"
  }
}

output "out" {
  value = aws_subnet.main
}


