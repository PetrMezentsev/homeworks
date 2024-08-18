resource "yandex_compute_instance" "vm-1" {
  name        = var.vm1_name
  platform_id = var.platform
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public-subnet.id
    nat        = true
    ip_address = "192.168.10.254"
  }

  metadata = var.ssh
}


resource "yandex_compute_instance" "vm-2" {
  name        = var.vm2_name
  platform_id = var.platform
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }


  boot_disk {
    initialize_params {
      image_id    = "fd80qjt4v3h9ukucg1di"
      description = "ubuntu-2004-lts"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet.id
    nat       = true
  }

  metadata = var.ssh
}

resource "yandex_compute_instance" "vm-3" {
  name        = var.vm3_name
  platform_id = var.platform
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd80qjt4v3h9ukucg1di"
      description = "ubuntu-2004-lts"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet.id
    nat       = false
  }


  metadata = var.ssh

}