variable "project" {
  type        = string
  description = "Three letter project key"
}

variable "stage" {
  type        = string
  description = "Stage for this ip"
}

variable "location" {
  type        = string
  description = "Azure location to use"
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group to use"
}

variable "client_id" {
  type        = string
  description = "Azure client ID to use to manage Azure resources from the cluster, like f.e. load balancers"
}

variable "client_secret" {
  type        = string
  description = "Azure client secret to use to manage Azure resources from the cluster, like f.e. load balancers"
}

variable "dns_prefix" {
  type        = string
  description = "DNS-Prefix to use. Defaults to cluster name"
  default     = "NONE"
}

variable "node_count" {
  type        = string
  description = "Number of Kubernetes cluster nodes to use"
}

variable "vm_size" {
  type        = string
  description = "Type of vm to use. Use az vm list-sizes --location <location> to list all available sizes"
}

variable "kubernetes_version" {
  type        = string
  description = "Version of kubernetes of the control plane"
}

variable "subnet_id" {
  type        = string
  description = "ID of subnet to host the nodes, pods and services in."
}

variable "node_storage" {
  type        = string
  description = "Disk size in GB"
  default     = "30"
}

variable "rbac_enabled" {
  type        = bool
  description = "Enables RBAC on the cluster. If true, rbac_managed_admin_groups have to be specified."
  default     = false
}

variable "rbac_managed_admin_groups" {
  type        = list(string)
  description = "The group IDs that have admin access to the cluster. Have to be specified if rbac_enabled is true"
  default     = []
}

variable "default_node_pool_name" {
  type        = string
  description = "Name of the default node pool"
  default     = "default"
}

variable "default_node_pool_k8s_version" {
  type        = string
  description = "Version of kubernetes for the default node pool"
}

variable "node_pools" {
  type = map(object({
    vm_size : string,
    count : number,
    os_disk_size_gb : number,
    k8s_version : string,
    node_labels : map(string),
    max_pods : number,
    mode : string,
    taints : list(string),
    availability_zones : list(number)
  }))
  default     = {}
  description = "Additional node pools to set up"

}

variable "load_balancer_sku" {
  description = "The SKU for the used Load Balancer"
  default     = "Basic"
}

variable "max_pods" {
  type        = string
  description = "Amount of pods allowed on each node (be aware that kubernetes system pods are also counted"
  default     = "30"
}

variable "availability_zones" {
  type        = list(number)
  description = "availability zones to spread the cluster nodes across, if omitted, only one avilability zone is used"
  default     = []
}

variable "sku_tier" {
  type    = string
  default = "Free"
}

variable "static_outbound_ip_count" {
  type        = number
  description = <<EOF
    On a lot of outgoing connections use this together with the maximum for outbound_ports_allocated of 64000 to not fall into network
    bottlenecks. Recommended in that case is to set the count at least +5 more than the count of kubernetes nodes.
  EOF
  validation {
    condition     = var.static_outbound_ip_count >= 1 && var.static_outbound_ip_count <= 100
    error_message = "idle_timeout has to be between 1 and 100 including."
  }
  default = 1
}

variable "outbound_ports_allocated" {
  type        = number
  description = "Pre-allocated ports (AKS default: 0)"
  validation {
    condition     = var.outbound_ports_allocated >= 0 && var.outbound_ports_allocated <= 64000
    error_message = "outbound_ports_allocated has to be between 0 and 64000 including."
  }
  default = 0
}

variable "network_policy" {
  type        = string
  description = "Network policy to use, currently only azure and callico are supported"
  default     = "azure"
}

variable "idle_timeout" {
  type        = number
  description = "Desired outbound flow idle timeout in minutes for the cluster load balancer. Must be between 4 and 120 inclusive."
  default     = 5
  validation {
    condition     = var.idle_timeout >= 4 && var.idle_timeout <= 120
    error_message = "idle_timeout has to be between 4 and 120 including."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to access the kubernetes node with"
}
