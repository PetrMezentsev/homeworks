terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

module "vpc_dev" {
  source           = "./vpc"
  network_name     = "my-network"
  zone             = "ru-central1-a"
  v4_cidr_block    = "10.0.0.0/24"
}

output "network_id" {
  value = module.vpc_dev.network_id
}

output "subnet_id" {
  value = module.vpc_dev.subnet_id
}

module "test-vm" {
  //depends_on = [module.vpc]
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = module.vpc_dev.network_id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [module.vpc_dev.subnet_id]
  instance_name   = "web"
  instance_count  = 2
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      serial-port-enable = 1
  }

}