variable "subnet_id" {}
variable "security_group_id" {}
variable "target_group_arn" {}

resource "aws_instance" "openproject" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = "t3.medium"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user

              sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose

              mkdir -p /home/ec2-user/openproject
              cat <<EOL > /home/ec2-user/openproject/docker-compose.yml
              version: "3"
              services:
                openproject:
                  image: openproject/community:latest
                  ports:
                    - "80:8080"
                  environment:
                    - SECRET_KEY_BASE=verysecretkey
                  volumes:
                    - openproject_data:/var/openproject

              volumes:
                openproject_data:
              EOL

              cd /home/ec2-user/openproject
              sudo docker-compose up -d
              EOF

  tags = {
    Name = "openproject-ec2"
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.openproject.id
  port             = 80
}
