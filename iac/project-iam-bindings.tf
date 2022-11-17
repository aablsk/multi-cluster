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

# authoritative project-iam-bindings to increase reproducibility
module "project-iam-bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.project_id]
  mode     = "authoritative"

  bindings = {
    "roles/cloudtrace.agent" = [
        "serviceAccount:${google_service_account.gke_workload_gke_az1.email}",
        "serviceAccount:${module.gke_az1.service_account}",
        "serviceAccount:${google_service_account.gke_workload_gke_az2.email}",
        "serviceAccount:${module.gke_az2.service_account}",
    ],
    "roles/monitoring.metricWriter" = [
        "serviceAccount:${google_service_account.gke_workload_gke_az1.email}",
        "serviceAccount:${module.gke_az1.service_account}",
        "serviceAccount:${google_service_account.gke_workload_gke_az2.email}",
        "serviceAccount:${module.gke_az2.service_account}",
    ],
    "roles/logging.logWriter" = [
        "serviceAccount:${google_service_account.gke_workload_gke_az1.email}",
        "serviceAccount:${module.gke_az1.service_account}",
        "serviceAccount:${google_service_account.gke_workload_gke_az2.email}",
        "serviceAccount:${module.gke_az2.service_account}",
    ],
    # REQUIRED FOR MCS
    "roles/compute.networkViewer" = [
        "serviceAccount:${var.project_id}.svc.id.goog[gke-mcs/gke-mcs-importer]"
    ]
    # REQUIRED FOR MCI
    "roles/container.admin" = [
      "serviceAccount:service-${data.google_project.project.number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com"
    ]
  }
}
