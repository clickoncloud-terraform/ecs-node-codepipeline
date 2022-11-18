resource "aws_iam_role" "apps_codepipeline_role" {
  name = "apps-code-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "apps_codepipeline_role_policy" {
  name = "apps-codepipeline-role-policy"
  role = aws_iam_role.apps_codepipeline_role.id

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetRepository",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "*"
        },
        {
         "Effect":"Allow",
         "Action":[
            "kms:Decrypt"
         ],
         "Resource":[
            "*"
         ]
      }
    ],
    "Version": "2012-10-17"
}
EOF
}

#===================================================

#S3 Bucket Create
resource "aws_s3_bucket" "cicd_bucket" {
  bucket = var.artifacts_bucket_name
  //acl    = "private"
}


#============================================================


resource "aws_codepipeline" "node_app_pipeline" {
  name     = "node-app-pipeline"
  role_arn = aws_iam_role.apps_codepipeline_role.arn


  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      input_artifacts  = []
      output_artifacts = [
        "SourceArtifact",
      ]
      //run_order        = "1"
      

      configuration = {
        # "PollForSourceChanges" = "false"
        ConnectionArn    = "arn:aws:codestar-connections:us-east-1:111836646603:connection/7ee728d6-2fce-4330-9945-f98460182e6f"
        FullRepositoryId = var.repo_name
        BranchName       = var.branch_name
      }
    }

  }


  stage {
    name = "Build"

    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "SourceArtifact",
      ]
      output_artifacts = [
        "BuildArtifact",
      ]
      version = "1"
      configuration = {
        ProjectName = aws_codebuild_project.containerAppBuild.name

        "EnvironmentVariables" = jsonencode(
          [
            {
              name  = "environment"
              type  = "PLAINTEXT"
              value = "cognizant-ecs"
            },
            {
              name  = "AWS_DEFAULT_REGION"
              type  = "PLAINTEXT"
              value = var.region
            },
            {
              name  = "AWS_ACCOUNT_ID"
              type  = "PLAINTEXT"
              value = var.aws_account_id
            },
            {
              name  = "IMAGE_REPO_NAME"
              type  = "PLAINTEXT"
              value = var.IMAGE_REPO_NAME
            },
            {
              name  = "IMAGE_TAG"
              type  = "PLAINTEXT"
              value = "latest"
            },
            {
              name  = "CONTAINER_NAME"
              type  = "PLAINTEXT"
              value = var.task_defination_name
            },
          ]
        )

      }
    }
  }


  stage {
    name = "Deploy"

    action {
      name     = "Deploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "ECS"
      input_artifacts = [
        "BuildArtifact",
      ]
      output_artifacts = []
      version          = "1"
      run_order        = 1
      configuration = {
        "ClusterName" = "terraform-cluster"
        "ServiceName" = "ecs-service"
        "FileName"    = "imagedefinitions.json"
        #"DeploymentTimeout" = "15"
      }
    }
  }
}
