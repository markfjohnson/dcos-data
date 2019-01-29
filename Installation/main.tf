provider "aws" {
  region = "us-west-2"
}

module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.1"
  availability_zones = ["us-west-2a","us-west-2b","us-west-2c"]
#  availability_zones = ["us-west-2a"]
  cluster_name       = "mjohnsons-hdmk-demo"
  num_masters        = "1"
  num_private_agents = "6"
  num_public_agents  = "1"
  bootstrap_instance_type = "t2.medium"
#  public_agents_instance_type = "m4.xlarge"
#  private_agents_instance_type = "m4.2xlarge"
#  masters_instance_type = "m4.xlarge"
  public_agents_instance_type = "c4.xlarge"
  private_agents_instance_type = "c4.4xlarge"
  masters_instance_type = "m4.xlarge"
  dcos_version = "1.12.1"
  dcos_instance_os    = "centos_7.5"

#  dcos_variant = "open"
  dcos_variant              = "ee"
  dcos_license_key_contents = "${file("./license.txt")}"
  admin_ips=["0.0.0.0/0"]
  ssh_public_key_file = "~/.ssh/mke-workshop.pub"

#  admin_ips           = ["${data.http.whatismyip.body}/32"]
   dcos_resolvers      = "\n   - 169.254.169.253"
  public_agents_additional_ports = ["6090","9092", "9094", "6443", "6444","6445","6446","6447","6448","6449", "30001"]

  dcos_install_mode = "${var.dcos_install_mode}"

  providers = {
    aws = "aws"
  }
}






variable "dcos_install_mode" {
  description = "specifies which type of command to execute. Options: install or upgrade"
  default     = "install"
}

data "http" "whatismyip" {
  url = "http://whatismyip.akamai.com/"
}

output "masters-ips" {
  value = "${module.dcos.masters-ips}"
}

output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}
