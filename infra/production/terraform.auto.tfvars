vpc = {
  "cidr_block" = "10.15.0.0/16"
}
alb_subnets = [
  {
    "name" : "public-1a",
    "cidr_block" = "10.15.1.0/24",
    "az"         = "ap-northeast-1a"
  },
  {
    "name" : "public-1c",
    "cidr_block" = "10.15.2.0/24",
    "az"         = "ap-northeast-1c"
  },
]
private_subnets = [
  {
    "name" : "private-1a",
    "cidr_block" = "10.15.3.0/24",
    "az"         = "ap-northeast-1a"
  },
  {
    "name" : "private-1c",
    "cidr_block" = "10.15.4.0/24",
    "az"         = "ap-northeast-1c"
  },
]
vpc_endpoint = {
  "interface" : [
    # NOTE: シークレットストアに接続する場合はそのエンドポイントも必要
    "com.amazonaws.ap-northeast-1.ecr.dkr",
    "com.amazonaws.ap-northeast-1.ecr.api",
    "com.amazonaws.ap-northeast-1.logs",
    # ECS Exec用のVPCエンドポイント
    "com.amazonaws.ap-northeast-1.ecs-agent",
    "com.amazonaws.ap-northeast-1.ecs-telemetry",
    "com.amazonaws.ap-northeast-1.ecs"
  ],
  "gateway" : [
    "com.amazonaws.ap-northeast-1.s3"
  ]
}
