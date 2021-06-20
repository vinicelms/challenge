resource "aws_iam_role" "iam_eks_role_challenge" {
  name = "eks_cluster_role_challenge"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_challenge" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.iam_eks_role_challenge.name
}

resource "aws_iam_role" "iam_eks_node_group_challenge" {
  name = "eks_node_group_challenge"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "node_group_node_policy_challenge" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.iam_eks_node_group_challenge.name
}

resource "aws_iam_role_policy_attachment" "node_group_cni_policy_challenge" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.iam_eks_node_group_challenge.name
}

resource "aws_iam_role_policy_attachment" "node_group_container_registry_policy_challenge" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.iam_eks_node_group_challenge.name
}