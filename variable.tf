#Region
variable "region" {
  type    = string
  default = "us-east-1"
}

#ECS Cluster
variable "cluster_name" {
  type    = string
  default = "terraform-cluster"
}

#ECS NAME

#Task Name
variable "task_defination_name" {
  type        = string
  default     = "nginx-task"
  description = "A name for the service"
}

#Docker Port Number
variable "container_port" {
  type    = number
  default = 80
}
#Docker Images Name
variable "image_url" {
  type    = string
  default = "nginx"
}
variable "desired_count" {
  default = 2

}


#Load Balancer Name
variable "load_balancer_name" {
  type    = string
  default = "ecsalb"
}


#Mention Here Uploaded Certificate ARN
variable "alb_tls_cert_arn" {
  default = "arn:aws:acm:us-east-1:111836646603:certificate/ce8a3352-aee1-4cef-b842-04e54d775eed"
}

#S3 Bucket name
variable "artifacts_bucket_name" {
  default = "soumen-artifacts-codebuild"
}

#ECR Repo Name
variable "aws_account_id" {
  default = 111836646603
}

#CodeBuild

variable "IMAGE_REPO_NAME" {
  default = "nodeapp"
}

variable "repo_name" {
  default = "clickoncloud-terraform/ecs-node-codepipeline"
}
variable "branch_name" {
  default = "main"  
}

variable "Github-Connection" {
  default = "arn:aws:codestar-connections:us-east-1:111836646603:connection/7ee728d6-2fce-4330-9945-f98460182e6f"
}