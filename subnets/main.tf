# resource "aws_subnet" "main" {
#   #subnet creation loop if it is it creates 1 if its 2 it create 2
#   count = length(var.subnets)
#   #vpc_id     = aws_vpc.main.id
#   vpc_id      = var.vpc_id
#   #cidr_block = "10.0.1.0/24"
#   cidr_block = var.subnets[count.index]
#   availability_zone = var.AZ[count.index]


#   tags = {
#     Name = "${var.name}-subnet"
#   }
# }
#creating subnets using local module
resource "aws_subnet" "main" {
  #for_each         = var.subnets
  #if the list is coming as 2 values it will create 2 subnets or if it is 1 it will create 1 subnet
  count             = length(var.subnets)
  vpc_id            = var.vpc_id
  #cidr_block       = each.value["subnet_cidr"]
  cidr_block        = var.subnets[count.index]
  #or with function as below
  #cidr_block        = element(var.subnets[count.index])
  availability_zone = var.AZ[count.index]
  #count.index is to bring list of values avail in AZ map


  tags = {
    Name = "roboshop-${var.name}-subnet-${element(var.AZ, count.index)}"
  }
}



#see the value of subnet
#output "out" {
#  value = aws_subnet.main
#
#}

#output "out" {
#  value = aws_subnet.main
#}
output "out" {
  value = aws_subnet.main
}

