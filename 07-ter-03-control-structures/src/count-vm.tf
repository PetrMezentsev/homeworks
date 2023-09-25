data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

resource "yandex_compute_instance" "web" {
  count = 2
  name        = "web-${count.index+1}"
  platform_id = var.vm_platform
  resources {
    cores         = local.cores
    memory        = local.memory
    core_fraction = local.fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = "${yandex_vpc_security_group.example.*.id}"
  }

  metadata = {
    serial-port-enable = local.serial_port
    ssh-keys           = local.ssh_key
  }
}