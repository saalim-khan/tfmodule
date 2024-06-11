#output
output "public_key" {
        value = aws_instance.web.public_ip 
}