resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.zone
  network_id = yandex_vpc_network.network-1.id
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  #zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  route_table_id = yandex_vpc_route_table.private-subnet-rt.id
}


resource "yandex_vpc_route_table" "private-subnet-rt" {
  name       = "private-subnet-rt"
  network_id = yandex_vpc_network.network-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }

}