provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "my_instance" {
  ami           = "ami-0e2c8caa4b6378d8c" # Use the appropriate AMI ID
  instance_type = "t2.micro"
  key_name      = "terraform-demo"
  tags = {
    Name = "EC2-InstancebyHCLCode"
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = ["subnet-0004c2fde1da3c5fe"] # Replace with your subnet ID
  #launch_configuration = aws_launch_configuration.lc.id
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

}

resource "aws_launch_template" "lt" {
  image_id      = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  key_name      = "terraform-demo"
}

resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0bd8c84ae0f183064", "subnet-05fdb49be3ea17608"]
}

resource "aws_route53_record" "dns" {
  zone_id = "Z063593739KEFWPFVAZCE" # Replace with your Route 53 hosted zone ID
  name    = "sravya1.com"
  type    = "A"

  alias {
    name                   = aws_lb.my_lb.dns_name
    zone_id                = aws_lb.my_lb.zone_id
    evaluate_target_health = false
  }
}