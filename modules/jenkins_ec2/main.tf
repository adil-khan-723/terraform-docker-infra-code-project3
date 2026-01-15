resource "aws_instance" "this" {
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_group_ids
    iam_instance_profile   = var.instance_profile_name
    ami = var.ami_id

    associate_public_ip_address = true

    user_data = var.user_data

    tags = {
        Name        = "jenkins-${var.environment}"
        Environment = var.environment
    }
}