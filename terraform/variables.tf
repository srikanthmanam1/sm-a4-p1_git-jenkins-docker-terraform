variable "aws_region" {
  default = "us-east-2"
}

/*variable "aws_account_id" {
  description = "Your AWS account ID"
}
*/
variable "app_name" {
  #default = "sample-ci-cd-app"
  default = "sm-devops-app1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.large"
//  default     = "t2.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04"
  default     = "ami-0c5ddb3560e768732" # Ubuntu 22.04 (us-east-2)
}

