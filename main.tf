provider "aws" {
  region = "us-east-1"  # Cambia esta región según tu preferencia
}

# Crear un Security Group para permitir el tráfico HTTP
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2_sg"
  description = "Allow inbound HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear una instancia EC2
resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # AMI de Amazon Linux
  instance_type = "t2.micro"
  security_group = aws_security_group.ec2_sg.id
  key_name      = "your-aws-ec2-key"  # Cambia por tu clave EC2

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 80:80 your-docker-image:latest  # Cambia esta línea según tu imagen Docker
              EOF

  tags = {
    Name = "MyEC2Instance"
  }
}

# Crear un Load Balancer
resource "aws_lb" "main_lb" {
  name               = "main-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.ec2_sg.id]
  subnets           = ["subnet-xxxxxx"]  # Cambia por el ID de tu subred

  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true
}

# Crear un Target Group para el Load Balancer
resource "aws_lb_target_group" "main_target_group" {
  name     = "main-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-xxxxxx"  # Cambia por el ID de tu VPC
}

# Configurar un Listener para el Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "OK"
    }
  }
}

# Crear un Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_configuration = aws_launch_configuration.ec2_launch_config.id
  vpc_zone_identifier  = ["subnet-xxxxxx"]  # Cambia por el ID de tu subred

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }
}

# Configuración de Launch Configuration para el Auto Scaling Group
resource "aws_launch_configuration" "ec2_launch_config" {
  name          = "ec2-launch-config"
  image_id      = "ami-0c55b159cbfafe1f0"  # Cambia por el AMI de tu preferencia
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2_sg.id]
  user_data     = <<-EOF
                #!/bin/bash
                docker run -d -p 80:80 your-docker-image:latest  # Cambia por tu imagen Docker
                EOF
}

# Crear un API Gateway (opcional)
resource "aws_api_gateway_rest_api" "api" {
  name        = "user-management-api"
  description = "API Gateway for User Management Microservice"
}

resource "aws_api_gateway_resource" "user_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_method" "user_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.user_resource.id
  http_method             = aws_api_gateway_method.user_get.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = aws_lb.main_lb.dns_name
}

# Output: Dirección del Load Balancer
output "load_balancer_url" {
  value = aws_lb.main_lb.dns_name
}
