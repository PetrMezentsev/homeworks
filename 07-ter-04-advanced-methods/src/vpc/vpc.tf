terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

variable "network_name" {
  description = "Название сети"
  type        = string
}

variable "zone" {
  description = "Зона размещения"
  type        = string
}

variable "v4_cidr_block" {
  description = "Блок IPv4-адресов"
  type        = string
}

resource "yandex_vpc_network" "network" {
  name   = var.network_name
  labels = {
    "module" = "vpc"
  }
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.network_name}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [var.v4_cidr_block]
}

output "subnet_id" {
  value = yandex_vpc_subnet.subnet.id
}

output "network_id" {
  value = yandex_vpc_network.network.id
}