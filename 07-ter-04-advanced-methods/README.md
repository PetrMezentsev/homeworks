# Домашнее задание к занятию «Продвинутые методы работы с Terraform»

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания ВМ с помощью remote-модуля.
2. Создайте одну ВМ, используя этот модуль. В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.
3. Добавьте в файл cloud-init.yml установку nginx.
4. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```.

##### Ответ:
![1 1](https://github.com/PetrMezentsev/homeworks/assets/124135353/51fd70a6-e141-4e87-a559-5887156b7099)
![1 2](https://github.com/PetrMezentsev/homeworks/assets/124135353/15d208cc-22db-4b0a-bf78-72e8d955aa2e)
![1 3](https://github.com/PetrMezentsev/homeworks/assets/124135353/7042d482-3202-408d-a45a-ba30f1f500da)

------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля, например: ```ru-central1-a```.
```terraform
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

variable "network_name" {
  description = "Название сети"
  type        = string
}

variable "zone" {
  description = "Зона размещения"
  type        = string
}

variable "v4_cidr_block" {
  description = "Блок IPv4-адресов"
  type        = string
}

resource "yandex_vpc_network" "network" {
  name   = var.network_name
  labels = {
    "module" = "vpc"
  }
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.network_name}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [var.v4_cidr_block]
}

output "subnet_id" {
  value = yandex_vpc_subnet.subnet.id
}

output "network_id" {
  value = yandex_vpc_network.network.id
}
```
2. Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.  
![2 2](https://github.com/PetrMezentsev/homeworks/assets/124135353/4fc4a8d6-cf23-47af-ac1e-31b542786017)

3. Модуль должен возвращать в root module с помощью output информацию о yandex_vpc_subnet. Пришлите скриншот информации из terraform console о своем модуле. Пример: > module.vpc_dev
  ![2 3](https://github.com/PetrMezentsev/homeworks/assets/124135353/eaaba5ef-4e2a-449b-a383-5f662a005e78)

4. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.
5. Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.vpc_dev.
![2 4](https://github.com/PetrMezentsev/homeworks/assets/124135353/6e2675d4-a32d-4dff-b45f-6d99209530ab)

  6. Сгенерируйте документацию к модулю с помощью terraform-docs.
```md
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.network](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Название сети | `string` | n/a | yes |
| <a name="input_v4_cidr_block"></a> [v4\_cidr\_block](#input\_v4\_cidr\_block) | Блок IPv4-адресов | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Зона размещения | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |

```
 
Пример вызова

```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```

### Задание 3
1. Выведите список ресурсов в стейте.
2. Полностью удалите из стейта модуль vpc.
3. Полностью удалите из стейта модуль vm.
4. Импортируйте всё обратно. Проверьте terraform plan. Изменений быть не должно.
Приложите список выполненных команд и скриншоты процессы.

##### Ответ:  
```bash
root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform state list
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]
module.test-vm.yandex_compute_instance.vm[1]
module.vpc_dev.yandex_vpc_network.network
module.vpc_dev.yandex_vpc_subnet.subnet
root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform state rm module.test-vm.yandex_compute_instance.vm[0]
Removed module.test-vm.yandex_compute_instance.vm[0]
Successfully removed 1 resource instance(s).
root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform state rm module.test-vm.yandex_compute_instance.vm[1]
Removed module.test-vm.yandex_compute_instance.vm[1]
Successfully removed 1 resource instance(s).
root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform state rm module.vpc_dev.yandex_vpc_network.network
Removed module.vpc_dev.yandex_vpc_network.network
Successfully removed 1 resource instance(s).
root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform state rm module.vpc_dev.yandex_vpc_subnet.subnet
Removed module.vpc_dev.yandex_vpc_subnet.subnet
Successfully removed 1 resource instance(s).
root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform state list
module.test-vm.data.yandex_compute_image.my_image
root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform import 'module.vpc_dev.yandex_vpc_network.network' enpbtodfun3jrvq3dhc1
╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
╵

module.vpc_dev.yandex_vpc_network.network: Importing from ID "enpbtodfun3jrvq3dhc1"...
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc_dev.yandex_vpc_network.network: Import prepared!
  Prepared yandex_vpc_network for import
module.vpc_dev.yandex_vpc_network.network: Refreshing state... [id=enpbtodfun3jrvq3dhc1]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd826honb8s0i1jtt6cg]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
│ 
│ (and one more similar warning elsewhere)
╵

root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform import 'module.vpc_dev.yandex_vpc_subnet.subnet' e9bdhbl00u8hs2efbfmr
╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
╵

module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc_dev.yandex_vpc_subnet.subnet: Importing from ID "e9bdhbl00u8hs2efbfmr"...
module.vpc_dev.yandex_vpc_subnet.subnet: Import prepared!
  Prepared yandex_vpc_subnet for import
module.vpc_dev.yandex_vpc_subnet.subnet: Refreshing state... [id=e9bdhbl00u8hs2efbfmr]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd826honb8s0i1jtt6cg]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
│ 
│ (and one more similar warning elsewhere)
╵

root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform import 'module.test-vm.yandex_compute_instance.vm[0]' fhmq11g100ds09598moq
╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
╵

module.test-vm.data.yandex_compute_image.my_image: Reading...
module.test-vm.data.yandex_compute_image.my_image: Read complete after 2s [id=fd826honb8s0i1jtt6cg]
module.test-vm.yandex_compute_instance.vm[0]: Importing from ID "fhmq11g100ds09598moq"...
module.test-vm.yandex_compute_instance.vm[0]: Import prepared!
  Prepared yandex_compute_instance for import
module.test-vm.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmq11g100ds09598moq]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
│ 
│ (and one more similar warning elsewhere)
╵

root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform import 'module.test-vm.yandex_compute_instance.vm[1]' fhmgd6iqdlbtvek4ptr5
╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
╵

module.test-vm.data.yandex_compute_image.my_image: Reading...
module.test-vm.data.yandex_compute_image.my_image: Read complete after 2s [id=fd826honb8s0i1jtt6cg]
module.test-vm.yandex_compute_instance.vm[1]: Importing from ID "fhmgd6iqdlbtvek4ptr5"...
module.test-vm.yandex_compute_instance.vm[1]: Import prepared!
  Prepared yandex_compute_instance for import
module.test-vm.yandex_compute_instance.vm[1]: Refreshing state... [id=fhmgd6iqdlbtvek4ptr5]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
│ 
│ (and one more similar warning elsewhere)
╵

root@LE3:/home/user/terraform/ter-homeworks/04/src# terraform plan
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc_dev.yandex_vpc_network.network: Refreshing state... [id=enpbtodfun3jrvq3dhc1]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd826honb8s0i1jtt6cg]
module.vpc_dev.yandex_vpc_subnet.subnet: Refreshing state... [id=e9bdhbl00u8hs2efbfmr]
module.test-vm.yandex_compute_instance.vm[1]: Refreshing state... [id=fhmgd6iqdlbtvek4ptr5]
module.test-vm.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmq11g100ds09598moq]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.test-vm.yandex_compute_instance.vm[0] will be updated in-place
  ~ resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
        id                        = "fhmq11g100ds09598moq"
        name                      = "develop-web-0"
        # (11 unchanged attributes hidden)

      - timeouts {}

        # (6 unchanged blocks hidden)
    }

  # module.test-vm.yandex_compute_instance.vm[1] will be updated in-place
  ~ resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
        id                        = "fhmgd6iqdlbtvek4ptr5"
        name                      = "develop-web-1"
        # (11 unchanged attributes hidden)

      - timeouts {}

        # (6 unchanged blocks hidden)
    }

Plan: 0 to add, 2 to change, 0 to destroy.
╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on .terraform/modules/test-vm/providers.tf line 2, in provider "template":
│    2:   version = "2.2.0"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
╵

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
