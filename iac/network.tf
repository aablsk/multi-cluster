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

# explicit setup of VPC & subnets for GKE resources
module "network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.0.1, < 5.0.0"

  project_id   = var.project_id
  network_name = local.network_name

  subnets = [
    {
      subnet_name           = local.network[local.cluster_name_az1].subnet_name
      subnet_ip             = local.cidr_az1_primary_address_range
      subnet_region         = var.region
      subnet_private_access = true
    },
    {
      subnet_name           = local.network[local.cluster_name_az2].subnet_name
      subnet_ip             = local.cidr_az2_primary_address_range
      subnet_region         = var.region
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    (local.network[local.cluster_name_az1].subnet_name) = [
      {
        range_name    = local.network[local.cluster_name_az1].ip_range_pods
        ip_cidr_range = local.cidr_az1_secondary_range_pods
      },
      {
        range_name    = local.network[local.cluster_name_az1].ip_range_services
        ip_cidr_range = local.cidr_az1_secondary_range_services
    }, ]
    (local.network[local.cluster_name_az2].subnet_name) = [
      {
        range_name    = local.network[local.cluster_name_az2].ip_range_pods
        ip_cidr_range = local.cidr_az2_secondary_range_pods
      },
      {
        range_name    = local.network[local.cluster_name_az2].ip_range_services
        ip_cidr_range = local.cidr_az2_secondary_range_services
    }, ]
  }

  depends_on = [
    module.enabled_google_apis
  ]
}

# REQUIRED for INTERNAL Multi-Cluster Gateway
resource "google_compute_subnetwork" "subnet-with-logging" {
  count = var.enable_mci == true ? 1 : 0 # create this resource only if mci is enabled
  name          = "proxy-only-subnet"
  ip_cidr_range = "10.170.144.0/23"
  region        = var.region
  network       = module.network.network_id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}