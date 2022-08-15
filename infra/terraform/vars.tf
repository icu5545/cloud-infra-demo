variable "aws_region" {
    default = "us-east-1"
}

# -------------------------------------------------------

variable "gke_credential" {
    default = "../../gke-credential.json"
}

variable "gke_region" {
    default = "us-east1"
}

variable "gke_project_number" {
    type = string
}

variable "gke_project_id" {
    type = string
}

variable "gke_cluster_name" {
    default = "test-cluster"
}