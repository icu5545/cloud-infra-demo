output "registry_url" {
    value = "${aws_ecrpublic_repository.repo.repository_uri}"
}
output "github_key" {
  value = aws_iam_access_key.github.id
}
output "github_secret" {
  value = nonsensitive(aws_iam_access_key.github.secret)
}