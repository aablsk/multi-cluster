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

variable "project_id" {
    type = string
    description = "Project ID where the resources will be deployed"
}

variable "region" {
    type = string
    description = "Region where regional resources will be deployed (e.g. europe-west1)"
}

variable "az1" {
    type = string
    description = "Zone where cluster AZ1 resources will be deployed"
}

variable "az2" {
    type = string
    description = "Zone where cluster AZ2 resources will be deployed"
}

variable "enable_mcs" {
    type = bool
    description = "Enable Multi-Cluster Services"
}

variable "enable_mci" {
    type = bool
    description = "Enable Multi-Cluster Ingress & Multi-Cluster Gateway"
}