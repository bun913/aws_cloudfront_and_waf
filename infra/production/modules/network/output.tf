output "alb_subnet_ids" {
  value = [
    for sb in aws_subnet.alb : sb.id
  ]
}

output "private_subnet_ids" {
  value = [
    for sb in aws_subnet.private : sb.id
  ]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_route_table_id" {
  value = aws_route_table.alb.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
