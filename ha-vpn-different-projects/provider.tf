terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.31.1"
    }
  }
}

provider "google" {
  project = "raghupothula"
  region = "us-central1"
  zone = "us-central1-a"
}