
# public alb and its rules
resource "aws_security_group" "public_alb_sg" {
  name        = "public-alb-sg"
  description = "Public ALB security group"
  vpc_id      = var.vpc_id
}
resource "aws_security_group_rule" "inbound_from_internet" {
  type              = "ingress"
  from_port         = var.frontend_port
  to_port           = var.frontend_port
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.public_alb_sg.id
}

# frontend containers sg and its rules
resource "aws_security_group" "frontend_sg" {
  description = "security group for the frontend"
  vpc_id      = var.vpc_id
  name        = "frontend-sg"
}

resource "aws_security_group_rule" "inbound_from_public_alb" {
  type                     = "ingress"
  from_port                = var.frontend_port
  to_port                  = var.frontend_port
  security_group_id        = aws_security_group.frontend_sg.id
  source_security_group_id = aws_security_group.public_alb_sg.id
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "outbound_to_internal" {
  type                     = "egress"
  from_port                = var.frontend_port
  to_port                  = var.frontend_port
  security_group_id        = aws_security_group.frontend_sg.id
  source_security_group_id = aws_security_group.internal_alb_sg.id
  protocol                 = "tcp"
}

# internal alb sg and its rules
resource "aws_security_group" "internal_alb_sg" {
  name        = "internal-alb-sg"
  description = "Internal ALB security group"
  vpc_id      = var.vpc_id
}
resource "aws_security_group_rule" "frontend_sg_to_internal_alb" {
  type                     = "ingress"
  from_port                = var.frontend_port
  to_port                  = var.frontend_port
  security_group_id        = aws_security_group.internal_alb_sg.id
  source_security_group_id = aws_security_group.frontend_sg.id
  protocol                 = "tcp"
}

# backend containers sg and its rules
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "backend security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "internal_alb_to_backend" {
  type                     = "ingress"
  from_port                = var.backend_port
  to_port                  = var.backend_port
  security_group_id        = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.internal_alb_sg.id
  protocol                 = "tcp"
}

# resource "aws_security_group_rule" "outbound_revoked" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = []
#   security_group_id = aws_security_group.backend_sg.id
#   protocol          = "-1"
# }

resource "aws_security_group" "jenkins-ec2" {
  name = "jenkins-ec2-sg"
  description = "jenkins sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ssh" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  security_group_id        = aws_security_group.jenkins-ec2.id
  cidr_blocks = ["0.0.0.0/0"]
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "jenkins" {
  type                     = "ingress"
  from_port                = var.jenkins_port
  to_port                  = var.jenkins_port
  security_group_id        = aws_security_group.jenkins-ec2.id
  cidr_blocks = ["0.0.0.0/0"]
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "outbound" {
  type = "egress"
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-ec2.id
  from_port = 0
  to_port = 0
}

# # ########
# ingress {
#         description = "HTTP from the interenet"
#         from_port = var.frontend_port
#         to_port = var.frontend_port
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         description = "Allow outbound"
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#         from_port = 0
#         to_port = 0
#     }

#     tags = {
#         Name = "public-alb-sg-${var.environment}"
#     }

# ingress {
#     description     = "Traffic from public ALB"
#     from_port       = var.frontend_port
#     to_port         = var.frontend_port
#     protocol        = "tcp"
#     security_groups = [aws_security_group.public_alb_sg.id]
#   }

#   egress {
#     description     = "Traffic to internal ALB"
#     from_port       = var.frontend_port
#     to_port         = var.frontend_port
#     protocol        = "tcp"
#     security_groups = [aws_security_group.internal_alb_sg.id]
#   }

#   tags = {
#     Name        = "frontend-sg-${var.environment}"
#     Environment = var.environment
#   }
#   ###

#   ingress {
#         description = "request only from frontend containers"
#         from_port = var.frontend_port
#         to_port = var.frontend_port
#         protocol = "tcp"
#         security_groups = [aws_security_group.frontend_sg.id]
#     }

#     egress {
#         description = "Allow outbound"
#         protocol = "tcp"
#         security_groups = [aws_security_group.backend_sg.id]
#         from_port = var.backend_port
#         to_port = var.backend_port
#     }

#     tags = {
#         Name = "internal-alb-sg-${var.environment}"
#     }
# ####
#     ingress {
#         description = "traffic from the internal alb"
#         from_port = var.backend_port
#         to_port = var.backend_port
#         protocol = "tcp"
#         security_groups = [aws_security_group.internal_alb_sg.id]
#     }

#     egress {
#         description = "Allow outbound"
#         protocol = "-1"
#         cidr_blocks = []
#         from_port = 0
#         to_port = 0
#     }

#     tags = {
#         Name = "backend-sg-${var.environment}"
#     }