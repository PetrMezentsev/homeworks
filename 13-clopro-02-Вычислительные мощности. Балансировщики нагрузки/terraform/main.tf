resource "yandex_iam_service_account" "sa-ig" {
  name = "sa-for-ig"
}

resource "yandex_resourcemanager_folder_iam_member" "ig-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
}

resource "yandex_compute_instance_group" "web-lamp" {
  name                = "web-lamp"
  folder_id           = var.folder_id
  service_account_id  = yandex_iam_service_account.sa-ig.id
  deletion_protection = false
  instance_template {
    platform_id = var.platform
    resources {
      cores         = 4
      memory        = 4
      core_fraction = 20
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.network-clopro02.id}"
      subnet_ids = ["${yandex_vpc_subnet.public-subnet.id}"]
      nat        = true
    }
    metadata = {
      serial-port-enable = 1
      ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzXn4HqEZWkxR/7afwjSQpJpptBdCgoin4uClO4L25Y"
      user-data = <<EOF
#!/bin/bash
cd /var/www/html
echo '<html><head><title>Picture from my bucket</title></head> <body><h1>Clopro02 task</h1><p><img src="https://storage.yandexcloud.net/mezentsev-bucket/mypicture.jpg"/></body></html>' > index.html
EOF
    }
    scheduling_policy {
      preemptible = true
    }
  }
    scale_policy {
      fixed_scale {
        size = 3
      }
    }
    allocation_policy {
      zones = ["ru-central1-a"]
    }
    deploy_policy {
      max_unavailable = 2
      max_creating    = 1
      max_expansion   = 1
      max_deleting    = 1
    }
    health_check {
      timeout  = "10"
      interval = "20"
      http_options {
        path = "/"
        port = 80
      }
    }
  }