resource "yandex_vpc_network" "network-clopro02" {
  name = "network-clopro02"
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.zone
  network_id = yandex_vpc_network.network-clopro02.id
}