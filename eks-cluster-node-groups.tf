module "eks_cluster_nodes" {
  source = "./cluster-node-group"

  count = length(var.node_groups)

  ####################################
  #### Organization Configuration ####
  ####################################
  account_id   = var.account_id
  organization = var.organization
  project      = var.project
  region       = var.region
  environment  = var.environment

  ###################################
  #### EKS Cluster Configuration ####
  ###################################
  service_name                       = var.service_name
  eks_cluster_name                   = local.instance_name
  eks_cluster_version                = aws_eks_cluster.eks_cluster.version
  eks_cluster_endpoint               = aws_eks_cluster.eks_cluster.endpoint
  eks_cluster_ca                     = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  eks_cluster_security_group_id      = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  cross_node_group_security_group_id = aws_security_group.cross_node_group_security_group.id

  ######################################
  #### EKS Node Group Configuration ####
  ######################################
  instance_type                       = var.node_groups[count.index].instance_type
  labels                              = var.node_groups[count.index].labels
  update_default_version              = var.node_groups[count.index].update_default_version
  http_endpoint                       = var.node_groups[count.index].http_endpoint
  http_put_response_hop_limit         = var.node_groups[count.index].http_put_response_hop_limit
  scaling_config                      = var.node_groups[count.index].scaling_config
  assume_role_statements              = var.node_groups[count.index].assume_role_statements
  instance_profile_policies           = var.node_groups[count.index].instance_profile_policies
  vpc_id                              = var.node_groups[count.index].vpc_id
  subnets                             = var.node_groups[count.index].subnets
  isolate_node_group_network          = var.node_groups[count.index].isolate_node_group_network
  allowed_ingress_security_group_list = var.node_groups[count.index].allowed_ingress_security_group_list
  allowed_egress_security_group_list  = var.node_groups[count.index].allowed_egress_security_group_list
  allowed_egress_ip_list              = var.node_groups[count.index].allowed_egress_ip_list
  allowed_ingress_ip_list             = var.node_groups[count.index].allowed_ingress_ip_list

  #################################
  #### Support Department Info ####
  #################################
  support_contact         = var.support_contact
  support_department      = var.support_department
  support_department_code = var.support_department_code
}