terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.85.0"
    }
  }
}

provider "google" {
  project = "raghupothula"
  region = "us-central1"
  zone = "us-central1-a"
}