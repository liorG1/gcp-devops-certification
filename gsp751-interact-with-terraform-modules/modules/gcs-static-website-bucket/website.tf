resource "google_storage_bucket" "bucket" {
  name                        = var.name
  project                     = var.project_id
  location                    = var.location
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
