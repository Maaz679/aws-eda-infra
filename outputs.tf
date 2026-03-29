output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "compute_instance_id" {
  description = "ID of the EDA compute node"
  value       = aws_instance.compute.id
}

output "compute_public_ip" {
  description = "Public IP address of the compute node"
  value       = aws_instance.compute.public_ip
}

output "s3_bucket_name" {
  description = "Name of the artifacts S3 bucket"
  value       = aws_s3_bucket.artifacts.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}
