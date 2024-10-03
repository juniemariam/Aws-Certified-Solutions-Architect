 resource "aws_volume_attachment" "ebs_att" {
   device_name = "/dev/sdf"
   volume_id   = aws_ebs_volume.example.id # Id of ebs volume
   instance_id = aws_instance.app_server.id # Id of instance we want to attach the ebs volume to
 }


 resource "aws_ebs_volume" "example" {
   availability_zone = "us-west-1c"
   size              = 1
 }
