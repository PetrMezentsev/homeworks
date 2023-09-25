resource "yandex_compute_disk" "disks" {
    count = 3
    name = "disk-${count.index}"
    type = "network-hdd"
    size = 1
    zone = var.default_zone
}

data "yandex_compute_image" "ubuntu_dz_3_2" {
    family = var.vm_family
}
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  depends_on = [yandex_compute_instance.web]
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
  
  dynamic secondary_disk {
    for_each = yandex_compute_disk.disks.*.id 
        content {
            disk_id = secondary_disk.value
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable    = local.serial_port
    ssh-keys              = local.ssh_key
  }

}

