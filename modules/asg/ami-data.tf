data "aws_ami" "ami_server" {
    most_recent                 = true
    owners                      = [ "099720109477" ]
    filter {
      name                      = "name"
      values                    = [ "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" ]
    }
}