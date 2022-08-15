output "registry_url" {
    value = "${aws_ecrpublic_repository.repo.repository_uri}"
}
output "aws_access_key_id" {
  value = aws_iam_access_key.github.id
}
output "aws_secret_access_key" {
  value = nonsensitive(aws_iam_access_key.github.secret)
}

# -------------------------------------------------------

output "gke_cluster_name" {
  value       = google_container_cluster.test-cluster.name
  description = "GKE Cluster Name"
}

output "gke_cluster_host" {
  value       = google_container_cluster.test-cluster.endpoint
  description = "GKE Cluster Host"
}