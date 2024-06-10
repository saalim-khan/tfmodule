terraform module

Up to this point, we've been configuring Terraform by editing Terraform configurations directly. As our infrastructure grows, this practice has a few key problems: a lack of organization, a lack of reusability, and difficulties in management for teams.

Modules in Terraform are self-contained packages of Terraform configurations that are managed as a group. Modules are used to create reusable components, improve organization, and to treat pieces of infrastructure as a black box.

A module is a container for multiple resources that are used together. Modules can be used to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture, rather than directly in terms of physical objects.

The .tf files in your working directory when you run terraform plan or terraform apply together form the root module. That module may call other modules and connect them together by passing output values from one to input values of another.




<Module structure>



Re-usable modules are defined using all of the same configuration language concepts we use in root modules. Most commonly, modules use:

Input variables to accept values from the calling module.
Output values to return results to the calling module, which it can then use to populate arguments elsewhere.
Resources to define one or more infrastructure objects that the module will manage.
To define a module, create a new directory for it and place one or more .tf files inside just as you would do for a root module. Terraform can load modules either from local relative paths or from remote repositories; if a module will be re-used by lots of configurations you may wish to place it in its own version control repository.

Modules can also call other modules using a module block, but we recommend keeping the module tree relatively flat and using module composition as an alternative to a deeply-nested tree of modules, because this makes the individual modules easier to re-use in different combinations.

When to write a module
In principle, any combination of resources and other constructs can be factored out into a module, but over-using modules can make your overall Terraform configuration harder to understand and maintain, so we recommend moderation.

A good module should raise the level of abstraction by describing a new concept in your architecture that is constructed from resource types offered by providers.

Now let's create a module and use them. create a modules/webserver folder in your current working directory.

Now create a file /modules/webserver/resource.tf with below content.

# key
resource "aws_key_pair" "key-tf" {
  key_name   = var.key_name
  public_key = var.key
}
# instance
resource "aws_instance" "web" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
}
Create a file /modules/webserver/variables.tf with below content.

variable "instance_type" {
  type = string
}
variable "image_id" {
    type = string
}
variable "key" {
    type = string
}
variable "key_name" {
  type= string
}
Create a file /modules/webserver/output.tf with the below content.

output publicIP {
    value = aws_instance.web.public_ip
}
now use this module, let's create a file in your current directory.

create variable.tf with the below content.

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "image_id" {
    type = string
}

variable "key_name"{
  type = string
}
create a file named resource.tf with the below content.

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
module "mywebserver" {
  source = "./modules/webserver"
  key = file("${path.module}/id_rsa.pub")
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
}
output mypublicIp {
  value = module.mywebserver.publicIP
}
create a file named terraform.tfvars with the below contents

instance_type = "t2.micro"
image_id   = "ami-01b996646377b6619"
key_name= "mykey"


now let's run terraform init, and terraform apply and check instance is created in your AWS account.