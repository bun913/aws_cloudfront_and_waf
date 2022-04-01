resource "aws_lb" "app" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ingress_all.id]
  subnets            = var.alb_subnets

  # テストようなので保護機能を有効にしない
  enable_deletion_protection = false

  # テスト用なのでアクセスログは吐き出さない
  /* access_logs { */
  /*   bucket  = aws_s3_bucket.lb_logs.bucket */
  /*   prefix  = "test-lb" */
  /*   enabled = true */
  /* } */
}

resource "aws_lb_listener" "http_blue" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = merge({ "Name" : "${var.prefix}-blue" }, var.tags)
  # BGデプロイで動的にtgを入れ替えるため変更を無視
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_lb_listener" "https_blue" {
  load_balancer_arn = aws_lb.app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_blue.arn
  }
}

resource "aws_lb_target_group" "app_blue" {
  name                 = "${var.prefix}-tg-blue"
  deregistration_delay = 60
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  health_check {
    healthy_threshold   = 2
    interval            = 30
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}
