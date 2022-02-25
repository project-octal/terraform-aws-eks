# terraform-aws-eks
Terraform module for deploying appropriately configured and secured AWS EKS clusters

## Defining an EKS cluster
```hcl-terraform
module "eks" {
  source  = "app.terraform.io/example-module"
  version = "0.0.X"

  #####################
  # EKS Configuration #
  #####################
  k8s_version                         = "1.20.7"
  log_retention_in_days               = 400
  allow_http                          = false
  allowed_ingress_security_group_list = []
  allowed_ingress_ip_list             = [
    {
      description = "Allow all networks to communicate with the API server."
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = [
        "0.0.0.0/0", # Everywhere
      ]
    }
  ]
  node_groups = []

  #########################
  # Network Configuration #
  #########################
  vpc_id          = data.terraform_remote_state.remote_state.outputs.vpc_id
  cluster_subnets = data.terraform_remote_state.remote_state.outputs.vpc_private_subnets

  ######################################
  # Organization Account Configuration #
  ######################################
  account_name = data.terraform_remote_state.remote_state.outputs.account_name
  account_id   = data.terraform_remote_state.remote_state.outputs.account_id
  region       = data.terraform_remote_state.remote_state.outputs.region
  environment  = data.terraform_remote_state.remote_state.outputs.environment
  organization = data.terraform_remote_state.remote_state.outputs.organization
  project      = data.terraform_remote_state.remote_state.outputs.project

  ##################################
  # Support Department Information #
  ##################################
  support_contact         = data.terraform_remote_state.remote_state.outputs.support_contact
  support_department      = data.terraform_remote_state.remote_state.outputs.support_department
  support_department_code = data.terraform_remote_state.remote_state.outputs.support_department_code

  #########################
  # Logging Configuration #
  #########################
  access_log_bucket    = data.terraform_remote_state.remote_state.outputs.access_log_bucket_name
}
```
## Defining EKS cluster node groups
```hcl-terraform
node_groups = [
  {
    labels                      = {},
    user_data                   = "",
    image_id                    = "",
    instance_type               = "t3.medium",
    update_default_version      = true,
    http_endpoint               = "enabled",
    http_put_response_hop_limit = 2,
    scaling_config = {
      desired_size = 2,
      min_size     = 1,
      max_size     = 4
    },
    instance_profile_policies           = {},
    assume_role_statements              = {},
    vpc_id                              = "vpc-01234567890abcdef",
    subnets                             = ["subnet-01234567890abcdef"],
    isolate_node_group_network          = false,
    allowed_ingress_security_group_list = [],
    allowed_egress_security_group_list = [],
    allowed_ingress_ip_list             = [],
    allowed_egress_ip_list = [
      {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow these hosts to talk to whomever they please"
      }
    ]
  }
]
```