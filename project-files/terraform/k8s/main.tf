provider "aws" {
    region = "us-east-2"
}

# Utilizando DATA: foi apenas para facilitar a gestão
# para que não fosse utilizado um Remote State (S3), por considerar
# a melhor forma de gerir os recursos de forma descentralizada,
# assíncrona e com baixo custo
data "aws_vpc" "vpc_challenge_data" {
  cidr_block = "12.0.0.0/16"
}

data "aws_subnet_ids" "subnet_ids_challenge_data" {
  vpc_id = data.aws_vpc.vpc_challenge_data.id
  filter {
    name = "tag:Name"
    values = [
      "application_subnet_challenge_a",
      "application_subnet_challenge_b",
      "application_subnet_challenge_c"
    ]
  }
}

data "aws_subnet" "subnet_id_challenge_data" {
  for_each = data.aws_subnet_ids.subnet_ids_challenge_data.ids
  id = each.value
}

resource "aws_eks_cluster" "eks_cluster_challenge" {
  name = "eks_challenge"
  role_arn = aws_iam_role.iam_eks_role_challenge.arn

  vpc_config {
    subnet_ids = [for s in data.aws_subnet.subnet_id_challenge_data : s.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_challenge
  ]
}

resource "aws_eks_node_group" "node_group_challenge" {
  cluster_name = aws_eks_cluster.eks_cluster_challenge.name
  node_group_name = "node_group_challenge"
  node_role_arn = aws_iam_role.iam_eks_node_group_challenge.arn
  subnet_ids = [for s in data.aws_subnet.subnet_id_challenge_data : s.id]

  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_node_policy_challenge,
    aws_iam_role_policy_attachment.node_group_cni_policy_challenge,
    aws_iam_role_policy_attachment.node_group_container_registry_policy_challenge
  ]
}