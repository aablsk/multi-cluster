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

  project_id   = var.shared_vpc_project_id
  network_name = local.network_name

  subnets = [
    {
      subnet_name           = local.network[local.cluster_name_az1].subnet_name
      subnet_ip             = var.cidr_az1_primary_address_range
      subnet_region         = var.region
      subnet_private_access = true
    },
    {
      subnet_name           = local.network[local.cluster_name_az2].subnet_name
      subnet_ip             = var.cidr_az2_primary_address_range
      subnet_region         = var.region
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    (local.network[local.cluster_name_az1].subnet_name) = [
      {
        range_name    = local.network[local.cluster_name_az1].ip_range_pods
        ip_cidr_range = var.cidr_az1_secondary_range_pods
      },
      {
        range_name    = local.network[local.cluster_name_az1].ip_range_services
        ip_cidr_range = var.cidr_az1_secondary_range_services
    }, ]
    (local.network[local.cluster_name_az2].subnet_name) = [
      {
        range_name    = local.network[local.cluster_name_az2].ip_range_pods
        ip_cidr_range = var.cidr_az2_secondary_range_pods
      },
      {
        range_name    = local.network[local.cluster_name_az2].ip_range_services
        ip_cidr_range = var.cidr_az2_secondary_range_services
    }, ]
  }

  depends_on = [
    module.enabled_google_apis,
    module.enabled_google_apis_shared_vpc
  ]
}

# A host project provides network resources to associated service projects.
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.shared_vpc_project_id
}

# A service project gains access to network resources provided by its associated host project.
resource "google_compute_shared_vpc_service_project" "service" {
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = var.project_id
}
