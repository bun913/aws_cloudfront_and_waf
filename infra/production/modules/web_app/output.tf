output "cluster_name" {
  value = aws_ecs_cluster.web.name
}
output "service_name" {
  value = aws_ecs_service.app.name
}
output "blue_listener_arn" {
  value = aws_lb_listener.http_blue.arn
}
output "green_listener_arn" {
  value = aws_lb_listener.http_green.arn
}
output "blue_targetgroup_name" {
  value = aws_lb_target_group.app_blue.name
}
output "green_targetgroup_name" {
  value = aws_lb_target_group.app_green.name
}