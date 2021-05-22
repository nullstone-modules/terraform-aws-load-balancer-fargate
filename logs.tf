module "logs_bucket" {
  source = "./logs_bucket"
  name          = var.name
  tags          = var.tags
  force_destroy = true
}
