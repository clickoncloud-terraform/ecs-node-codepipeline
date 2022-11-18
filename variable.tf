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
  type        = number
  default     = 80
}
#Docker Images Name
variable "image_url" {
  type        = string
  default     = "nginx"
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

variable "artifacts_bucket_name" {
  default = "soumen-artifacts-codebuild"
}

#Github branch
variable "nodejs_project_repository_branch" {
  default     = "main"
}

variable "nodejs_project_repository_name" {
  default     = "nodeapp"
}


#ECR Repo Name
variable "docker_repo_name" {
  default = "nodeapp"
  
}