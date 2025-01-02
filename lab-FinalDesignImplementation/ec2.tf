# resource "aws_launch_template" "frontend_lt" {
#   name_prefix   = "frontend-lt-"
#   image_id      = var.frontend_ami
#   instance_type = var.instance_type
#   key_name      = var.key_name
#
# #   user_data = base64encode(<<-EOF
# #     #!/bin/bash
# #     sudo apt update -y
# #     sudo apt install -y git nodejs npm
# #     git clone https://github.com/satnaing/e-commerce.git /home/ubuntu/e-commerce
# #     cd /home/ubuntu/e-commerce
# #     npm install
# #     npm run dev &
# #   EOF
# #   )
#
#   tags = {
#     Name = "frontend-instance"
#   }
# }

resource "aws_iam_instance_profile" "backend_instance_profile" {
  name = "backend-instance-profile"
  role = aws_iam_role.backend_ec2_role.name
}

resource "aws_launch_template" "backend_lt" {
  name_prefix   = "backend-lt-"
  image_id      = var.backend_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.backend_instance_profile.name
  }

#   user_data = base64encode(<<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install jq -y
#     sudo apt install -y python3-pip python3-dev libpq-dev awscli
#
#     # Fetch secrets from AWS Secrets Manager
#     SECRETS=$(aws secretsmanager get-secret-value --secret-id ecommerce-db-secrets --query "SecretString" --output text)
#     DB_USER=$(echo $SECRETS | jq -r '.username')
#     DB_PASSWORD=$(echo $SECRETS | jq -r '.password')
#
#     # Export the secrets as environment variables
#     echo "export DB_USER=$DB_USER" >> /etc/environment
#     echo "export DB_PASSWORD=$DB_PASSWORD" >> /etc/environment
#
#     # Set up the Django application
#     git clone https://github.com/juniemariam/Cloud-Final-ECommerceWebsite.git /home/ubuntu/django-app
#     cd /home/ubuntu/django-app
#     pip3 install -r requirements.txt
#     python3 manage.py migrate
#     python3 manage.py runserver 0.0.0.0:8000 &
#   EOF
#   )

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e  # Exit immediately if a command exits with a non-zero status
    sudo apt update -y

    # Install dependencies
    sudo apt install -y jq python3-pip python3-dev libpq-dev curl software-properties-common

    # Install AWS CLI (explicitly download and install if not available via apt)
    if ! command -v aws &> /dev/null; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        sudo apt install unzip
        unzip awscliv2.zip
        sudo ./aws/install
    fi

    # Fetch secrets from AWS Secrets Manager
    INSTANCE_PROFILE=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/)
    if [ -z "$INSTANCE_PROFILE" ]; then
        echo "IAM Role not attached to EC2. Secrets fetching will fail."
        exit 1
    fi

    SECRETS=$(aws secretsmanager get-secret-value --secret-id ecommerce-db-secrets --query "SecretString" --output text || true)
    if [ -z "$SECRETS" ]; then
        echo "Failed to retrieve secrets from AWS Secrets Manager."
        exit 1
    fi
    DB_USER=$(echo $SECRETS | jq -r '.username')
    DB_PASSWORD=$(echo $SECRETS | jq -r '.password')

    # Export the secrets as environment variables
    echo "export DB_USER=$DB_USER" | sudo tee -a /etc/environment
    echo "export DB_PASSWORD=$DB_PASSWORD" | sudo tee -a /etc/environment
    source /etc/environment

    # Install and set up the Django application
    git clone https://github.com/juniemariam/Cloud-Final-ECommerceWebsite.git /home/ubuntu/django-app
    cd /home/ubuntu/django-app
    sudo apt update
    sudo apt install python3.12-venv -y

    python3 -m venv ~/django-env
    source ~/django-env/bin/activate

    pip3 install -r requirements.txt

    SECRET_KEY=$(python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
    echo "export SECRET_KEY=$SECRET_KEY" | sudo tee -a /etc/environment
    source /etc/environment

    # Run database migrations and start the server
    python3 manage.py migrate
    nohup python3 manage.py runserver 0.0.0.0:8000 &
  EOF
  )


  tags = {
    Name = "backend-instance"
  }
}

# resource "aws_autoscaling_group" "frontend_asg" {
#   launch_template {
#     id      = aws_launch_template.frontend_lt.id
#     version = "$Latest"
#   }
#   min_size           = 2
#   max_size           = 5
#   desired_capacity   = 2
#   vpc_zone_identifier = [aws_subnet.public_subnet.id]
#
#   tag {
#       key                 = "Name"
#       value               = "frontend-asg"
#       propagate_at_launch = true
#     }
# }

resource "aws_autoscaling_group" "backend_asg" {
  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }
  min_size           = 2
  max_size           = 5
  desired_capacity   = 2
  vpc_zone_identifier = [aws_subnet.public_subnet.id]

  tag{
      key                 = "Name"
      value               = "backend-asg"
      propagate_at_launch = true
    }
  # Attach Auto Scaling group to the backend target group
  target_group_arns = [aws_lb_target_group.backend_tg.arn]
}
