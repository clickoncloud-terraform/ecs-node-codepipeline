#VPC
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc"]
  }
}
# output "EXISTING-VPC-ID" {
#   value = data.aws_vpc.selected.id
# }

#availability_zones
data "aws_availability_zones" "available" {
  state = "available"
}

# output "output_availability_zones" {
#     value = data.aws_availability_zones.available.names
# }


#Subnet1
data "aws_subnet" "selected1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

# output "Public-1-Subnet-ID" {
#   value = data.aws_subnet.selected1.id
# }

#Subnet2
data "aws_subnet" "selected2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

# output "Public-2-Subnet-ID" {
#   value = data.aws_subnet.selected2.id
# }

#Fetching Security Group ID

data "aws_security_groups" "single" {
  filter {
    name   = "group-name"
    values = ["*Allow-All*"]
  }
}

# output "EXISTING-Security-Group-ID" {
#   value = data.aws_security_groups.single.ids[0]
# }