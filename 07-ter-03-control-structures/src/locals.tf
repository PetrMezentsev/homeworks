locals {
  cores = "2"
  memory = "1"
  fraction = "5"
}

locals {
    serial_port = "1"
    ssh_key = "ubuntu:${var.vms_ssh_root_key}"
}