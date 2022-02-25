resource "random_pet" "node_group" {
  prefix = var.eks_cluster_name
  keepers = {
    organization = var.organization
    project      = var.project
    environment  = var.environment
    service_name = var.service_name
    cluster_name = var.eks_cluster_name
    vpc_id       = var.vpc_id
    subnet_ids   = jsonencode(var.subnets)
  }
  lifecycle {
    create_before_destroy = true
  }
}
locals {
  resource_tags = merge(
    # Standard Tags
    {
      service          = var.service_name,
      organization     = var.organization,
      project          = var.project,
      environment      = var.environment,
      department       = var.support_department,
      contact          = var.support_contact,
      terraform        = "true",
      terraform-module = "terraform-aws-eks"
    },
    # EKS Node Group specific tags
    {
      cluster = var.eks_cluster_name
    },
    # Extra special tags
    var.tags
  )
  ### TODO: Come up with a nicer way to store these kinds of constants
  region_abbrs = {
    "us-east-1"      = "use1",  # US East (N. Virginia)
    "us-east-2"      = "use2",  # US East (Ohio)
    "us-west-1"      = "usw1",  # US West (N. California)
    "us-west-2"      = "usw2",  # US West (Oregon)
    "af-south-1"     = "afs1",  # Africa (Cape Town)
    "ap-east-1"      = "ape1",  # Asia Pacific (Hong Kong)
    "ap-south-1"     = "aps1",  # Asia Pacific (Mumbai)
    "ap-northeast-3" = "apne3", # Asia Pacific (Osaka-Local)
    "ap-northeast-2" = "apne2", # Asia Pacific (Seoul)
    "ap-northeast-1" = "apne1", # Asia Pacific (Tokyo)
    "ap-southeast-1" = "apse1", # Asia Pacific (Singapore)
    "ap-southeast-2" = "apse2", # Asia Pacific (Sydney)
    "ca-central-1"   = "cac1",  # Canada (Central)
    "cn-north-1"     = "cnn1",  # China (Beijing)
    "cn-northwest-1" = "cnnw1", # China (Ningxia)
    "eu-central-1"   = "euc1",  # Europe (Frankfurt)
    "eu-west-1"      = "euw1",  # Europe (Ireland)
    "eu-west-2"      = "euw2",  # Europe (London)
    "eu-south-1"     = "eus1",  # Europe (Milan)
    "eu-west-3"      = "euw3",  # Europe (Paris)
    "eu-north-1"     = "eun1",  # Europe (Stockholm)
    "me-south-1"     = "mes1",  # Middle East (Bahrain)
    "sa-east-1"      = "sae1",  # South America (São Paulo)
    "us-gov-east-1"  = "usge1", # AWS GovCloud (US-East)
    "us-gov-west-1"  = "usgw1"  # AWS GovCloud (US)
  }
}