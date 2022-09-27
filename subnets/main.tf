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

resource "aws_subnet" "main" {
  count             = length(var.subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.subnets[count.index]
  availability_zone = var.AZ[count.index]


  tags = {
    Name = "${var.name}-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-igw"
  }
}


output "subnets" {
  value = aws_subnet.main
}

output "subnet_ids" {
  value = [for s in aws_subnet.main : s.id]
}

