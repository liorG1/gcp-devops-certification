output "bucket_url" {
  value       = google_storage_bucket.bucket.url
  description = "The base URL of the bucket"
}

output "bucket_name" {
  value       = google_storage_bucket.bucket.name
  description = "The name of the bucket"
}
