provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "minimal_ec2" {
  ami           = "ami-0c02fb55956c7d316"  
  instance_type = "t2.micro"              

  # Add a security group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Key pair for SSH access
  key_name = aws_key_pair.my_key.key_name

  tags = {
    Name = "EC2-Instance"
  }
}

# Create a Key Pair for SSH access
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.minimal_ec2.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.minimal_ec2.id
}
