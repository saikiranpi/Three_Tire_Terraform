provider "aws" {
  region = "us-east-1"
}
# create a VPC
resource "aws_vpc" "three-tier-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}
# check the az
data "aws_availability_zones" "myazs" {
}
# create the igw, nat-gw and eip
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three-tier-vpc.id
}
# create 1 public and 2 private subnets
resource "aws_subnet" "pb_sn" {
  count                   = var.pb_sn_count
  vpc_id                  = aws_vpc.three-tier-vpc.id
  cidr_block              = "10.0.${10 + count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.myazs.names[count.index]
}
# create the rt
resource "aws_route_table" "pb_rt" {
  vpc_id = aws_vpc.three-tier-vpc.id

}
resource "aws_route" "def_public_route" {
  route_table_id         = aws_route_table.pb_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

}
resource "aws_route_table_association" "pb_rt_asc" {
  count          = var.pb_sn_count
  route_table_id = aws_route_table.pb_rt.id
  subnet_id      = aws_subnet.pb_sn.*.id[count.index]
}

resource "aws_eip" "eip" {
  
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pb_sn[0].id

}

resource "aws_subnet" "app_pr_sn" {
  count                   = var.app_pr_sn_count
  vpc_id                  = aws_vpc.three-tier-vpc.id
  availability_zone       = data.aws_availability_zones.myazs.names[count.index]
  cidr_block              = "10.0.${20 + count.index}.0/24"
  map_public_ip_on_launch = false

}

resource "aws_route_table" "app_pr_rt" {
  vpc_id = aws_vpc.three-tier-vpc.id
}
resource "aws_route" "def_pr_route" {
  route_table_id         = aws_route_table.app_pr_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id

}

resource "aws_route_table_association" "app_pr_rt_asc" {
  count          = var.app_pr_sn_count
  route_table_id = aws_route_table.app_pr_rt.id
  subnet_id      = aws_subnet.app_pr_sn.*.id[count.index]
}

resource "aws_subnet" "db_pr_sn" {
  count                   = var.db_pr_sn_count
  vpc_id                  = aws_vpc.three-tier-vpc.id
  cidr_block              = "10.0.${30 + count.index}.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.myazs.names[count.index]
}

resource "aws_route_table" "db_pr_sn_rt" {
  vpc_id = aws_vpc.three-tier-vpc.id
}
resource "aws_route" "def_db_route" {
  route_table_id         = aws_route_table.db_pr_sn_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "db_pr_sn_asc" {
  count          = var.db_pr_sn_count
  route_table_id = aws_route_table.db_pr_sn_rt.id
  subnet_id      = aws_subnet.db_pr_sn.*.id[count.index]
}

# Web-tier lb sg
resource "aws_security_group" "web_lb_sg" {
  name   = "web_lb_sg"
  vpc_id = aws_vpc.three-tier-vpc.id
  egress {
    protocol    = "-1"
    to_port     = 0
    from_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    to_port     = 80
    from_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    to_port     = 22
    from_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# web-tier sg
resource "aws_security_group" "web_sg" {
  name = "web_sg"
  egress {
    protocol    = "-1"
    to_port     = 0
    from_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_lb_sg.id]
  }
  ingress {
    to_port         = 22
    from_port       = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_lb_sg.id]
  }
}

#app-tier lb sg
resource "aws_security_group" "app_lb_sg" {
  vpc_id = aws_vpc.three-tier-vpc.id
  name   = "app_lb_sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_lb_sg.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_lb_sg.id]
  }

}
#app-tier sg
resource "aws_security_group" "app_sg" {
  name   = "app_sg"
  vpc_id = aws_vpc.three-tier-vpc.id
  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.app_lb_sg.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.app_lb_sg.id]
  }
}

resource "aws_security_group" "db_sg" {
  name   = "db_sg"
  vpc_id = aws_vpc.three-tier-vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port         = 3306
    from_port       = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
}

# create the db subnet group2
resource "aws_db_subnet_group" "db_sn_group" {
  name       = "db_sn_group"
  subnet_ids = [aws_subnet.db_pr_sn[0].id,aws_subnet.db_pr_sn[1].id]
}