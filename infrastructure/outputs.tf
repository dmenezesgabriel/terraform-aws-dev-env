output "my_ip" {
  value = data.http.myip
}

output "dev_ip" {
  value = aws_instance.dev_node.public_ip
}
