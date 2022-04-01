resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.prefix}-ecs-task-execution"
  assume_role_policy = file("${path.module}/iam/ecs_assume_policy.json")
}

# タスク実行ロールは管理ポリシーを利用
data "aws_iam_policy" "ecs_task" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# CloudWatchLogの権限もタスク実行ロールに与える
data "aws_iam_policy" "cloudwatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "ecs_task_exec" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task.arn
}
resource "aws_iam_role_policy_attachment" "ecs_task_exec_logs" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.cloudwatch.arn
}

# ECS Exec用にタスクロールを作成する(コンテナへデバッグできるように)
resource "aws_iam_role" "ecs_task" {
  name               = "${var.prefix}-ecs-task"
  assume_role_policy = file("${path.module}/iam/ecs_assume_policy.json")
}
resource "aws_iam_role_policy" "ecs_exec" {
  name = "${var.prefix}-ecs-task"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
