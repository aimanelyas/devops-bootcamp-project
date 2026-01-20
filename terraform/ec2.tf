#Instance for Web Server
  resource "aws_instance" "web_server" {
    ami                    = "ami-00d8fc944fb171e29"  # ubuntu 24.04 in ap-southeast-1
    instance_type          = "t3.micro"
    subnet_id              = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.public_sg.id]
    associate_public_ip_address = true
    private_ip = "10.0.0.5"
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    key_name = aws_key_pair.ansible.key_name
    tags = {
      Name = "Web Server"
    }
  }

#Instance for Ansible Controller
  resource "aws_instance" "ansible_controller" {
    ami                    = "ami-00d8fc944fb171e29"  # ubuntu 24.04 in ap-southeast-1
    instance_type          = "t3.micro"
    subnet_id              = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.private_sg.id]
    associate_public_ip_address = false
    private_ip = "10.0.0.135"
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    key_name = aws_key_pair.ansible.key_name

#below code is to copy ansible-key.pem to ansible server using user data
    user_data_replace_on_change = true
    user_data = <<-EOF
                #!/bin/bash

                #wait 2 minutes for ssm-user to be created
                sleep 120

                # create ssh folder
                mkdir -p /home/ubuntu/.ssh
                chmod 700 /home/ubuntu/.ssh

                # add private key to ssh folder
                cat > /home/ubuntu/.ssh/ansible-key.pem << 'PRIVKEY'
                ${tls_private_key.ssh_key.private_key_pem}
                PRIVKEY

                chmod 600 /home/ubuntu/.ssh/ansible-key.pem
                chown ubuntu:ubuntu /home/ubuntu/.ssh -R
                
            
                # For ssm-user
                mkdir -p /home/ssm-user/.ssh
                cp /home/ubuntu/.ssh/ansible-key.pem /home/ssm-user/.ssh/
                chown ssm-user:ssm-user /home/ssm-user/.ssh/ansible-key.pem
                chmod 600 /home/ssm-user/.ssh/ansible-key.pem
                chown ssm-user:ssm-user /home/ssm-user/.ssh -R

                apt update && apt upgrade -y
                apt install -y ansible
                EOF
# run sudo chown ssm-user:ssm-user /home/ssm-user/.ssh/ansible-key.pem in ansible server after creation to fix permission issue

    tags = {
      Name = "ansible-controller"
    }
  }

#Instance for Monitoring Server
  resource "aws_instance" "monitoring_server" {
    ami                    = "ami-00d8fc944fb171e29"  # ubuntu 24.04 in ap-southeast-1
    instance_type          = "t3.micro"
    subnet_id              = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.private_sg.id]
    associate_public_ip_address = false
    private_ip = "10.0.0.136"
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    key_name = aws_key_pair.ansible.key_name
    tags = {
      Name = "monitoring"
    }
  }
