#key
resource "aws_key_pair" "key-tf" {
        key_name = var.key_name
        public_key = var.public_key

}

#instance
resource "aws_instance" "web" {
        ami = var.ami
        instance_type = var.instance_type
        key_name = var.key_name
  
}