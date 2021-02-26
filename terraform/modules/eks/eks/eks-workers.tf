# Setup data source to get amazon-provided AMI for EKS nodes
data "aws_ami" "eks-workers" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
  }
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}
locals {
  eks-workers-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${local.cluster_name}'
USERDATA
}

# resource "aws_launch_configuration" "eks_launch_config" {
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.workers.name
#   image_id                    = data.aws_ami.eks-workers.id
#   instance_type               = var.instance_type
#   name_prefix                 = "${var.app_id}-${local.app_env}-lc-"
#   security_groups             = ["${var.sg-worker}"]
#   user_data_base64            = base64encode(local.eks-workers-userdata)
#   # key_name                    = "${var.keypair-name}"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_launch_template" "eks_launch_template" {
  name_prefix            = "${var.app_id}-${local.app_env}-template-"
  image_id               = data.aws_ami.eks-workers.id
  instance_type          = var.instance_types[0]
  vpc_security_group_ids = ["${var.sg-worker}"]
  user_data              = base64encode(local.eks-workers-userdata)
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.node_disk_space
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.workers.name
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-asg" {
  desired_capacity = var.asg_desired
  #launch_configuration = aws_launch_configuration.eks_launch_config.id
  max_size            = var.asg_max
  min_size            = var.asg_min
  name                = "${var.app_id}-${local.app_env}-asg"
  vpc_zone_identifier = var.private_subnets

  mixed_instances_policy {
    instances_distribution {
      spot_allocation_strategy                 = "lowest-price"
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.above_base_capacity
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_launch_template.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }
  lifecycle {
    ignore_changes        = [desired_capacity, min_size, max_size]
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.app_id}-${local.app_env}-eks-worker-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${local.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = var.project
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
