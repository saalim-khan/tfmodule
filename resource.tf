provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
module "mywebserver" {
  source = "./Desktop/modules/webserver"
  key = file("${path.module}/id_rsa.pub")
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
}
output mypublicIp {
  value = module.webserver.publicIP
}