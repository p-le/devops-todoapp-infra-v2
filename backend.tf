terraform {
  backend "gcs" {
    bucket = "asia-northeast1-devops-demo"
    prefix = "state"
  }
}
