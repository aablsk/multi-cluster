# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Cloud Foundation Toolkit GKE module requires cluster-specific kubernetes provider
provider "kubernetes" {
  alias                  = "gke_az1"
  host                   = "https://${module.gke_az1.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_az1.ca_certificate)
}

# AZ1 standard cluster
module "gke_az1" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"

  project_id              = var.project_id
  name                    = local.cluster_name_az1
  regional                = false
  zones                   = [var.az1]
  network                 = local.network_name
  subnetwork              = local.network[local.cluster_name_az1].subnet_name
  ip_range_pods           = local.network[local.cluster_name_az1].ip_range_pods
  ip_range_services       = local.network[local.cluster_name_az1].ip_range_services
  enable_private_nodes    = true
  enable_private_endpoint = false

  master_ipv4_cidr_block          = local.cidr_az1_control_plane
  release_channel                 = "RAPID"
  horizontal_pod_autoscaling      = true
  create_service_account          = true

  enable_shielded_nodes         = true
  node_pools = [
    {
      name                      = "default-node-pool-${local.cluster_name_az1}"
      machine_type              = "e2-medium"
      node_locations            = var.az1
      node_count                = 3
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      auto_repair               = true
      auto_upgrade              = true
      enable_secure_boot        = true
    },
  ]

  providers = {
    kubernetes = kubernetes.gke_az1
  }

  depends_on = [
    module.enabled_google_apis,
    module.network,
  ]
}

# gke_az1 GKE workload GSA
resource "google_service_account" "gke_workload_gke_az1" {
  account_id = "gke-workload-gke-az1"
}

# binding gke_az1 GKE workload GSA to KSA
resource "google_service_account_iam_member" "gke_workload_gke_az1_identity" {
  service_account_id = google_service_account.gke_workload_gke_az1.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[hello/default]"
  depends_on = [
    module.gke_az1
  ]
}

# REQUIRED FOR MCS
# create fleet membership for development GKE cluster
resource "google_gke_hub_membership" "gke_az1" {
  count = var.enable_mcs == true ? 1 : 0 # create this resource only if mcs is enabled

  provider      = google-beta
  project       = var.project_id
  membership_id = "${local.cluster_name_az1}-membership"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke_az1.cluster_id}"
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/${module.gke_az1.cluster_id}"
  }
}
