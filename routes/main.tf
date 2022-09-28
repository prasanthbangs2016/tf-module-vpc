#creating route table
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-rt"
  }
}

# # # #attaching route tables to public subnets
resource "aws_route_table_association" "public" {
  #first public,apps,db
  #since values are hence having tomap function 
  #count      = length(tomap(var.subnet_ids.ids[var.name].out[*].id))
  count      = length(var.subnet_ids[var.name].subnet_ids)
  subnet_id      = element(var.subnet_ids[var.name].subnet_ids, count.index)
  route_table_id = aws_route_table.route_table.id
}

#writing into a file
resource "local_file" "foo" {
    #var.subnet_ids is object with 3 attributes(values coming as map but it is expecting to have string)
    #content  = var.subnet_ids
    # var.name is "apps-private"

    #content  = var.subnet_ids["${var.name}"]
    #converting map to string
    content = replace(replace(jsonencode(var.subnet_ids), "\"", ""), ":", "=")
    filename = "/tmp/out"
}