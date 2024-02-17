resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public-subnet"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "main_public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.main_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id

}

resource "aws_route_table_association" "main_public_association" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.main_public_rt.id
}

resource "aws_security_group" "main_sg" {
  name        = "dev_sg"
  description = "Dev security group"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "main_sg_ingress_ipva4" {
  security_group_id = aws_security_group.main_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "${chomp(data.http.myip.response_body)}/32" # myip
}

resource "aws_vpc_security_group_egress_rule" "main_sg_egress_ipva4" {
  security_group_id = aws_security_group.main_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "main_auth" {
  key_name   = "ec2devkey"
  public_key = file("~/.ssh/ec2devkey.pub")
}


resource "aws_instance" "dev_node" {
  ami                    = data.aws_ami.dev_server_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.main_auth.key_name
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  subnet_id              = aws_subnet.main_public_subnet.id
  user_data              = file("templates/userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }

  provisioner "local-exec" {
    command = templatefile("templates/${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip
      user         = "ubuntu"
      identityfile = "~/.ssh/ec2devkey"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
}
