resource "yandex_lb_target_group" "web-lamp" {
  name      = "lamp-target-group"
  region_id = "ru-central1"

  dynamic "target" {
    for_each = [
      for s in yandex_compute_instance_group.web-lamp.instances : {
        address   = s.network_interface.0.ip_address
        subnet_id = s.network_interface.0.subnet_id
      }
    ]

    content {
      subnet_id = target.value.subnet_id
      address   = target.value.address
    }
  }
}

resource "yandex_lb_network_load_balancer" "web-lamp" {
  name  = "network-lb"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.web-lamp.id}"
    healthcheck {
      name = "test-lamp"
      http_options {
        port = 80
      }
    }
  }
}