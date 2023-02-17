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

locals {
  cluster_name_az1 = "gke-az1"
  cluster_name_az2 = "gke-az2"

  network_name     = "gcp-network-shared" # VPC containing resources will be given this name

  cluster_names    = toset([local.cluster_name_az1, local.cluster_name_az2]) # used to create network configuration below
  network = { for name in local.cluster_names : name =>
    {
      subnet_name             = "${name}-gke-subnet"
      master_auth_subnet_name = "${name}-gke-master-auth-subnet"
      ip_range_pods           = "${name}-ip-range-pods"
      ip_range_services       = "${name}-ip-range-svc"
  } }

}
