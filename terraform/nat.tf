#Define External IP 
resource "aws_eip" "custom-eip-nat" {
  vpc = true
}

resource "aws_nat_gateway" "custom-nat-gw" {
  allocation_id = aws_eip.custom-eip-nat.id
  subnet_id     = aws_subnet.subnet-public-1.id
  depends_on    = [aws_internet_gateway.custom-gw]
}

resource "aws_route_table" "routingtable-private" {
  vpc_id = aws_vpc.customvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom-nat-gw.id
  }

  tags = {
    Name = "routingtable-private"
  }
}

# route associations private
resource "aws_route_table_association" "custom-private-1-a" {
  subnet_id      = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.routingtable-private.id
}
resource "aws_route_table_association" "custom-private-2-b" {
  subnet_id      = aws_subnet.subnet-private-2.id
  route_table_id = aws_route_table.routingtable-private.id
}
