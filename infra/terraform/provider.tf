provider "aws" {
  region = "${var.aws_region}"
}

provider "google" {
  region = "${var.gke_region}"
  project = "${var.gke_project_id}"
  credentials = "${var.gke_credential}"
}