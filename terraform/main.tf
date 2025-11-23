provider "aws" {
  region = var.aws_region
}
# ---------------------------
#  ECR Repository
# ---------------------------
resource "aws_ecr_repository" "app_repo" {
  name = var.app_name
}

# ---------------------------
#  VPC + Subnet (simple setup)
# ---------------------------
#resource "aws_vpc" "main" {
#  cidr_block = "10.0.0.0/16"
#}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true	# To ensure to have Public DNS 
  enable_dns_hostnames = true	# To ensure to have Public DNS 
  tags = {
    Name = "sm-vpc_11"
  }
}
# Create a subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true	# To ensure to have Public ip

  tags = {
    Name = "sm-subnet_11"
  }
}

#resource "aws_subnet" "public" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = "10.0.1.0/24"
#  availability_zone = "${var.aws_region}a"
#  map_public_ip_on_launch = true
#}

#resource "aws_internet_gateway" "igw" {
#  vpc_id = aws_vpc.main.id
#}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sm-igw_11"
  }
}

# Create a route table
resource "aws_route_table" "rtable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "sm-route-table_11"
  }
}

#resource "aws_route_table" "public" {
#  vpc_id = aws_vpc.main.id
#}

#resource "aws_route" "internet_access" {
#  route_table_id         = aws_route_table.public.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id             = aws_internet_gateway.igw.id
#}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.rtable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate subnet with route table
resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rtable.id
}

#resource "aws_route_table_association" "public_assoc" {
#  subnet_id      = aws_subnet.public.id
#  route_table_id = aws_route_table.public.id
#}

# Create a security group
resource "aws_security_group" "allow_ssh" {
#  name        = "sm-sg_ssh_http_s_11" # security group name
  name   = "${var.app_name}-sg_11"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sm-sg_ssh_http_s2_11" # name of sg tag
  }
}

# ---------------------------
# Security Group
# ---------------------------
#resource "aws_security_group" "app_sg" {
#  vpc_id = aws_vpc.main.id
#  name   = "${var.app_name}-sg"

#  ingress {
#    description = "Allow HTTP"
#    from_port   = 8080
#    to_port     = 8080
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

# ---------------------------
# IAM Role (EC2 → ECR access)
# ---------------------------
#resource "aws_iam_role" "ec2_role" {
#  name = "${var.app_name}-ec2-role_11"

#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Action = "sts:AssumeRole"
#      Effect = "Allow"
#      Principal = { Service = "ec2.amazonaws.com" }
#    }]
#  })
#}

#resource "aws_iam_role_policy_attachment" "ecr_readonly" {
#  role       = aws_iam_role.ec2_role.name
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#}

#resource "aws_iam_role_policy_attachment" "ssm_managed" {
#  role       = aws_iam_role.ec2_role.name
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#}

#resource "aws_iam_instance_profile" "ec2_profile" {
#  name = "${var.app_name}-instance-profile"
#  role = aws_iam_role.ec2_role.name
#}
# ---------------------------
# EC2 instance running Docker container
# ---------------------------
#data "aws_ami" "amazon_linux" {
#  most_recent = true

#  filter {
#    name   = "name"
#    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#  }

#  owners = ["137112412989"] # Amazon
#}

#resource "aws_instance" "app_ec2" {
#  ami                    = data.aws_ami.amazon_linux.id
#  instance_type          = "t3.micro"
#  subnet_id              = aws_subnet.public.id
#  security_groups        = [aws_security_group.app_sg.id]
#  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
#  associate_public_ip_address = true

#  user_data = base64encode(templatefile("${path.module}/userdata.tpl", {
#    region      = var.aws_region
#    account_id  = var.aws_account_id
#    repo_name   = var.app_name
#    app_port    = 8080
#  }))

#  tags = {
#    Name = "${var.app_name}-ec2"
#  }
}
# ---------------------------
# Create an EC2 instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  # ---------------------------
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  # ---------------------------
  associate_public_ip_address = true  # <--- Ensures a public IP is assigned for instance. Overrides subnet setting

  #key_name      = var.key_name
  #user_data = file("sm0_update.sh")
  
#  user_data = base64encode(templatefile("${path.module}/userdata.tpl", {
#    region      = var.aws_region
#    account_id  = var.aws_account_id
#    repo_name   = var.app_name
#    app_port    = 8080
#  }))

  tags = {
#    Name = "sm-P1_tf-ec2_11"
    Name = "${var.app_name}-ec2_11"
  }
}

