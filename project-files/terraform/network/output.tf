output "vpc_challenge_id" {
    value = aws_vpc.vpc_challenge.id
    description = "VPC id from challenge VPC in us-east-2 region"
}

output "subnets_challenge_ids" {
    value = {
        "application_a" = aws_subnet.application_subnet_challenge_a.id
        "application_b" = aws_subnet.application_subnet_challenge_b.id
        "application_c" = aws_subnet.application_subnet_challenge_c.id
        "public_a" = aws_subnet.public_subnet_challenge_a.id
        "public_b" = aws_subnet.public_subnet_challenge_b.id
        "public_c" = aws_subnet.public_subnet_challenge_c.id
    }
    description = "Subnet ids from challenge VPC in us-east-2 region"
}