resource "aws_instance" "my-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.main_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "Terraform-Challenge"
  }
  depends_on = [aws_internet_gateway.main_igw]
  user_data = file("${path.module}/script.sh")
}