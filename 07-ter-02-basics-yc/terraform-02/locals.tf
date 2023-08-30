locals {
  vm_web_from_locals = "${var.locals_interpolation_1st_item_mentor}-${var.locals_interpolation_2nd_item_class}-${var.locals_interpolation_3rd_item_platform}-${var.locals_interpolation_4th_item_web}"
  vm_db_from_locals  = "${var.locals_interpolation_1st_item_mentor}-${var.locals_interpolation_2nd_item_class}-${var.locals_interpolation_3rd_item_platform}-${var.locals_interpolation_4th_item_db}"
}

locals {
    vm_web_resources = {cores = "2", memory = "1", fraction = "5"}
    vm_db_resources = {cores = "2", memory = "2", fraction = "20"}
    serial_port = "1"
    ssh_key = "ubuntu:${var.vms_ssh_root_key}"
}