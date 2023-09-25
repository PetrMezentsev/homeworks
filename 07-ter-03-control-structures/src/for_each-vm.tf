data "yandex_compute_image" "vm_2_2" {
  family = var.vm_family
}

resource "yandex_compute_instance" "dz_2_2" {
  depends_on = [yandex_compute_instance.web]
    for_each = {
    for vm in var.vm_resource_list : 
    vm.vm_name => vm
    }
  name        = each.value.vm_name
  platform_id = var.vm_platform
  
  resources {
    cores         = each.value.cpu
    memory        = each.value.mem
    core_fraction = each.value.frac
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
  }

  metadata = {
    ssh-keys              = local.ssh_key    
    serial-port-enable    = local.serial_port    
  }
} 


variable "vm_resource_list" {
    type = list (object({
        vm_name         = string
        cpu             = number
        mem             = number
        hdd             = number
        frac            = number
    }))
    default  = [{
        vm_name         = "main"
        cpu             = 4
        mem             = 4
        hdd             = 5 
        frac            = 20
        },
        {
        vm_name         = "replica"
        cpu             = 2
        mem             = 1
        hdd             = 1
        frac            = 5    
        }]
}