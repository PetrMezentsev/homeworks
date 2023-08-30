variable "vm_web_family" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
}

variable "vm_web_platform" {
  type = string
  default = "standard-v1"
}

variable "vm_db_family" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_db_name" {
  type = string
  default = "netology-develop-platform-db"
}

variable "vm_db_platform" {
  type = string
  default = "standard-v1"
}

variable "locals_interpolation_1st_item_mentor" {
  default = "netology"
}

variable "locals_interpolation_2nd_item_class" {
  default = "develop"
}

variable "locals_interpolation_3rd_item_platform" {
  default = "platform"
}

variable "locals_interpolation_4th_item_web" {
    default = "web"  
}

variable "locals_interpolation_4th_item_db" {
    default = "db"  
}