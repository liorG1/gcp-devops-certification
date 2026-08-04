output "website_bucket_name" {
  value       = module.website_bucket.bucket_name
  description = "Name of the created GCS Bucket"
}

output "website_bucket_url" {
  value       = module.website_bucket.bucket_url
  description = "URL of the created GCS Bucket"
}
