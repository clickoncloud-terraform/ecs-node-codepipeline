#####################
# ECS Cluster Create
#####################

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}
#======================================
#cloudwatch Log Group
resource "aws_cloudwatch_log_group" "yada" {
  name = "ecs-fargate-log"
}

#ECS Task Defination
#==================================================
resource "aws_ecs_task_definition" "definition" {
  family                   = var.task_defination_name
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.task_defination_name}",
    "image": "${var.image_url}:latest",
    "essential": true,
    "cpu" : 256,
    "memory" : 1024,
    "portMappings": [   
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port}
      }
    ],    
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "nginx-task-group",  
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "streaming"
      }
    },
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "ecs-fargate-log",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs"
          }
        }
    }
  
]
DEFINITION
}

#=============================================================

#ECS Service Create

resource "aws_ecs_service" "ecs_service" {
  #depends_on                         = [aws_lb.public]
  name                               = var.task_defination_name
  cluster                            = aws_ecs_cluster.cluster.id
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "0"
  desired_count                      = var.desired_count
  network_configuration {
    subnets          = ["${data.aws_subnet.selected1.id}"]
    security_groups  = ["${data.aws_security_groups.single.ids[0]}"]
    assign_public_ip = true
  }
  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.definition.family}:${max(aws_ecs_task_definition.definition.revision, aws_ecs_task_definition.definition.revision)}"


  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = var.task_defination_name
    container_port   = var.container_port
  }
}