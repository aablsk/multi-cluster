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

variable "organization_id" {
    type = string
    description = "Organization ID (numerical) where projects will be created"
}

variable "project_id" {
    type = string
    description = "Project ID where the resources will be deployed"
}

variable "shared_vpc_project_id" {
    type = string
    description = "Project ID where the Shared VPC resides"
}

variable "region" {
    type = string
    description = "Region where regional resources will be deployed (e.g. europe-west1)"
}

variable "enable_mcs" {
    type = bool
    description = "Enable Multi-Cluster Services"
}

variable "enable_mcg" {
    type = bool
    description = "Enable Multi-Cluster Gateway"
}

# AZ1
variable "region_az1" {
    type = string
    description = "Region where cluster AZ1 resources will be deployed"
}

variable "cidr_az1_primary_address_range" {
    type = string
    description = "Primary address range for cluster in AZ1"
}

variable "cidr_az1_control_plane" {
    type = string
    description = "Address range for control plane of cluster in AZ1"
}

variable "cidr_az1_secondary_range_services" {
    type = string
    description = "Address range for services of cluster in AZ1"
}

variable "cidr_az1_secondary_range_pods" {
    type = string
    description = "Address range for pods of cluster in AZ1"
}

# AZ2
variable "region_az2" {
    type = string
    description = "Region where cluster AZ2 resources will be deployed"
}

variable "cidr_az2_primary_address_range" {
    type = string
    description = "Primary address range for cluster in AZ2"
}

variable "cidr_az2_control_plane" {
    type = string
    description = "Address range for control plane of cluster in AZ2"
}


variable "cidr_az2_secondary_range_services" {
    type = string
    description = "Address range for services of cluster in AZ2"
}

variable "cidr_az2_secondary_range_pods" {
    type = string
    description = "Address range for pods of cluster in AZ2"
}