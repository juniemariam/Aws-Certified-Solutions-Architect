 resource "aws_launch_template" "example" {
   name_prefix   = "example"
   image_id      = aws_instance.app_server.ami # Image our ec2 instance will use 
   instance_type = aws_instance.app_server.instance_type # Size of image
   vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
   user_data     = filebase64("${path.module}/install_apache.sh") # script we want the ec2 instances to run on startup
 }

 resource "aws_autoscaling_group" "example" {
   availability_zones = ["us-west-1c"] # Which availability zones to spread the ec2 instances in.
   desired_capacity   = 2 # Desired number of ec2 instances in the group
   max_size           = 2 # Maximum number of ec2 instances in the group
   min_size           = 1 # Minimum number of ec2 instances in the group
 
   load_balancers = [aws_elb.example.name]
   launch_template {
     id      = aws_launch_template.example.id
     version = "$Latest"
   }
 }

# Create a new load balancer
 resource "aws_elb" "example" {
   
   name               = "example-elb"
   availability_zones = ["us-west-1a"]

   health_check {
     healthy_threshold   = 3 # How many times the health check needs to succeed to be considered healthy
     unhealthy_threshold = 5 # How times the healthcheck needs to fail to mark the instance unhealthy and stop serving it traffic
     timeout             = 5 # how long to wait for the instance to respond to the health check in seconds
     target              = "HTTP:80/index.html" # What protocol, port, and path to test
     interval            = 30 # how often instances are probed in seconds
   }
  
   listener {
     instance_port     = 80 # What port the instances are listening on
     instance_protocol = "HTTP" # What protocol the instances are using to serve traffic
     lb_port           = 80 # What port the load balancer is listening on
     lb_protocol       = "HTTP" # What protocol the load balancer is using to serve traffic
   }
 }
