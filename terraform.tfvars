region               = "us-east-1"
cluster_name         = "cognizant-cluster"
task_defination_name = "apache-task"
container_port       = "80"
image_url            = "httpd" #or nginx
desired_count        = 1

load_balancer_name = "ecsalb"

#staging.aspinfotech.co.in
alb_tls_cert_arn = "arn:aws:acm:us-east-1:111836646603:certificate/ce8a3352-aee1-4cef-b842-04e54d775eed"
