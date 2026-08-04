output "bucket_name" {
  value       = google_storage_bucket.test_bucket_for_state.name
  description = "Name of the GCS Bucket created for Terraform State"
}

output "bucket_url" {
  value       = google_storage_bucket.test_bucket_for_state.url
  description = "URL of the GCS Bucket"
}