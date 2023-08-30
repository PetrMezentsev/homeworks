# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные: идентификаторы облака, токен доступа. Благодаря .gitignore этот файл не попадёт в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
##### Ответ:
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/3c9089ca-bc48-4ae8-8094-0e96799b2142)  

3. Сгенерируйте или используйте свой текущий ssh-ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
##### Ответ:
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/d781aa5c-4f33-4964-9506-a5f3146b89e1)
  

4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
##### Ответ:
Ошибка заключается в том, что платформа `standart-v4` не найдена  

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/da66e664-d2b1-44dc-a574-f1e2430b5193)  

Поправил в `main.tf` платформу на `standard-v1`, согласно перечню платформ из документации (https://cloud.yandex.com/en/docs/compute/concepts/vm-platforms)

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/2154a7f9-d1ab-47b1-9e00-2ac3295a251c)

Следующая ошибка о допустимом количестве ядер. Должно быть `2` либо `4`

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/78222b17-ef7b-4ff6-a3bf-ee65df997696)  

Поправил в `main.tf` параметр `cores = 2`. Ресурсы создались  

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/ae9716de-51e0-49f8-b9f8-9277c1e959c7)





5. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ. Ответ в документации Yandex Cloud.
##### Ответ:
Параметр `preemptible = true` полезен для экономии средств, так как виртуальные машины с этим параметром доступны по более низкой цене в сравнении с обычными. Такие машины можно применять, если не требуется обеспечение отказоустойчивости. С этим параметром прерываемые виртуальные машины могут быть принудительно остановлены в течение 24 часов с момента запуска. Когда такая машина понадобится, её можно снова запустить.  
Параметр `core_fraction=5` устанавливает ограничение для нашей виртуальной машины в 5% производительности процессора. Данный параметр позволит сэкономить средства и использовать только требуемую мощность устройств. Значение этого параметра для платформы `standard-v1` может быть 5%, 20%, 100%

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/e41b1ccb-9727-4012-8c90-e7813e859a08)



В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ;
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/c97317bc-995e-4ec5-9964-d6f88a1b76d3)


- скриншот успешного подключения к консоли ВМ через ssh. К OS ubuntu необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address";  

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/3d480bef-f08b-459a-9ec4-45f210cdc38e)

- ответы на вопросы.


### Задание 2

1. Изучите файлы проекта.
2. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/ef6c0115-d117-4652-afce-e3f413bc362e)

2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf.   
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/a643d429-563d-4d28-8b64-9cc2dc8d271c)

3. Проверьте terraform plan. Изменений быть не должно.   
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/02fa0ec1-cd54-41fc-90b8-2fc7a1d72075)



### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.  
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').
3. Примените изменения.
##### Ответ:  
Две машины в интерфейсе yc  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/1b4fc1d1-d6bb-4c5d-a075-e8d41d40d801)




### Задание 4

1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.

2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/11bb9892-eef7-4cd5-a175-6c74d297afb5)



### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
```terraform
locals {
  vm_web_from_locals = "${var.locals_interpolation_1st_item_mentor}-${var.locals_interpolation_2nd_item_class}-${var.locals_interpolation_3rd_item_platform}-${var.locals_interpolation_4th_item_web}"
  vm_db_from_locals  = "${var.locals_interpolation_1st_item_mentor}-${var.locals_interpolation_2nd_item_class}-${var.locals_interpolation_3rd_item_platform}-${var.locals_interpolation_4th_item_db}"
}
```
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local-переменные.  
```terraform
resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_from_locals

...

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_from_locals
```
3. Примените изменения.  
```terraform
root@LE3:/home/user/terraform/ter-homeworks/02# terraform apply
...
Enter a value: yes

yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 2s [id=enpnfg532r3ea6c11ibl]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_subnet.develop: Creation complete after 1s [id=e9bl575mvlhsdi98idsj]
yandex_compute_instance.platform_db: Creating...
yandex_compute_instance.platform: Creating...
yandex_compute_instance.platform: Still creating... [10s elapsed]
yandex_compute_instance.platform_db: Still creating... [10s elapsed]
yandex_compute_instance.platform: Still creating... [20s elapsed]
yandex_compute_instance.platform_db: Still creating... [20s elapsed]
yandex_compute_instance.platform_db: Still creating... [30s elapsed]
yandex_compute_instance.platform: Still creating... [30s elapsed]
yandex_compute_instance.platform: Creation complete after 39s [id=fhm0tacrbscedos0uspv]
yandex_compute_instance.platform_db: Creation complete after 39s [id=fhmtuvus8nsrr0vbridu]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

external_ip_addr_db = "netology-develop-platform-db = 158.160.112.121"
external_ip_addr_web = "netology-develop-platform-web = 158.160.34.215"
```


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources". В качестве продвинутой практики попробуйте создать одну map-переменную **vms_resources** и уже внутри неё конфиги обеих ВМ — вложенный map.
2. Также поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.  
Создал `locals` для 1 и 2 пункта:
```terraform
locals {
    vm_web_resources = {cores = "2", memory = "1", fraction = "5"}
    vm_db_resources = {cores = "2", memory = "2", fraction = "20"}
    serial_port = "1"
    ssh_key = "ubuntu:${var.vms_ssh_root_key}"
}
```
Заменил вручную прописанные ресурсы с количеством ядер, памяти, процента использования CPU, serial-port и ssh-key в `main.tf` на переменные из `locals.tf`  

3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan. Изменений быть не должно.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/934cbbfe-0e9d-4512-a463-9fde7a525900)


------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.  
```bash
> local.test_list[1]
"staging"
```
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).  
```bash
> length(local.test_list)
3
```
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
```bash
> local.test_map.admin
"John
```
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.
```bash
root@LE3:/home/user/terraform/ter-homeworks/02# terraform output admin
"John is admin for production server based on OS ubuntu-20-04 with 10 vcpu, 40 ram and 4 virtual disks"
```

В качестве решения предоставьте необходимые команды и их вывод.

------



