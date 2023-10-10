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
