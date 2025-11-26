terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.56.1"
    }
  }
}
provider "aws" {
  region = var.aws_region
}

# Ensure your EC2 instance has an IAM role attached with the necessary permissions
# Check that IMDS is enabled on the instance. You can verify this in the EC2 console or using AWS CLI:

# In EC2 Settings 
# aws ec2 describe-instances --instance-ids i-0bc36a327f31838fd
# IMDS defaults Info -- Manage
# Set the IMDS defaults at the account level for new instance launches in this Region.
# Instance metadata service Enabled
# Metadata version No preference
# Access to tags in metadata Enabled
# Metadata response hop limit No preference
